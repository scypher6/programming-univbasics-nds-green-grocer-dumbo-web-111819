require "pry"

def find_item_by_name_in_collection(name, collection)
  #binding.pry
  # Implement me first!
  collection.each do |hash|
    return hash if hash[:item] == name
  end
    nil
end


#Finds all dups in an AoH and returns a H
def find_dups(cart)
  cart.group_by {|e| e}.select { |k, v| v.size > 1}.map {|k, v| [k.values[0], v.size] }.to_h
end

#find_item_by_name_in_collection("bread", cart)

def consolidate_cart(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.
  count = 1
  #get cart with unique values
  u_cart = cart.uniq {|e| e[:item] }
  #get all duplicates
  dups = find_dups(cart)
  #Add correct count
  i = 0     #index for dups array
  u_cart.size.times do |index|
    if (!dups.empty? && (dups.keys[i] == u_cart[index][:item]))   #duplicate found
        u_cart[index][:count] = dups.values[i]
        i += 1
    else
        u_cart[index][:count] = count
    end  
  end
  u_cart
end


def apply_coupons(cart, coupons)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  index = 0
  newCart = []
  while (index < coupons.size)
    #look for coupon match in the cart
    item_found = find_item_by_name_in_collection(coupons[index][:item], cart)
    discounted_item = "#{coupons[index][:item]} W/COUPON"
    item_w_coupon = find_item_by_name_in_collection(discounted_item, cart)
    
    if (item_found && item_found[:count] >= coupons[index][:num])
        if (item_w_coupon)
            item_w_coupon[:count] += coupons[:index][:num]
            item_found[:count] -= coupons[index][:num]
        else
            item_w_coupon = {
              :item => discounted_item,
              :price => coupons[index][:cost]/coupons[index][:num],
              :clearance => item_found[:clearance],
              :count => coupons[index][:num]
            }
            cart << item_w_coupon
            item_found[:count] -= coupons[index][:num]
        end  
    end
    index += 1
  end #WHILE
  cart
end

def apply_clearance(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  index = 0
  while (index < cart.size)
    if (cart[index][:clearance]) 
        cart[index][:price] = (cart[index][:price] - (cart[index][:price] * 0.2)).round(2)
    end
    index += 1
  end
  cart  
end

def checkout(cart, coupons)
  # Consult README for inputs and outputs
  #
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers
  
  consolidated = consolidate_cart(cart)
  couponed = apply_coupons(consolidated, coupons)
  checkout_cart = apply_clearance(couponed)

  total = 0
  index = 0

  while (index < checkout_cart.size)
    total += checkout_cart[index][:price] * checkout_cart[index][:count]
    index += 1
  end
  if (total > 100)
      total -= (total * 0.1)
  end
  total
end
