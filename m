Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335061B0E20
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 16:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgDTORy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 10:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728355AbgDTORy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 10:17:54 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B055C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 07:17:53 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id d17so12349433wrg.11
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 07:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GMi3jWIK7dtaKhPbBDeKH6BTuOKWiGLwzGDvuocqyOY=;
        b=XYszIr0hmn0SsL7pMNnKtivKEP1eyvHvU252QvFGAHeGso5sqXS42+y8Atjd08WNp2
         Jd7tuNRqrWLVkBRc6M4dilmSIVYVRgPrCJFlq/kIjknPOzyXFTUXGvToCphXTYPSlqnA
         +xE8aEHAM81A++cYyXVRMRAqOZfrCCaRz6QfIty6NMhTe4T4UsWqVrCdwcAplope7cdr
         GEzYzh3u9fiMmubZm0EA9voCRDPpTgdm47UCPhdSRvogO5V+0biWq6Ys/0jrqiXwFEvu
         NYDmgG5WPudNn1rCN7/1kbyRwTp856KrcejUrMYwtzO4khxWDjqGW588twOJsNm2wN3t
         P2QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GMi3jWIK7dtaKhPbBDeKH6BTuOKWiGLwzGDvuocqyOY=;
        b=nsqMuQe99IB+AXEIVk55a7mL5BFiBcnMP0NDJXn2KuugjBjLO2PpEnYSrcijQKlmj/
         uh4E+tXtu5ZG/Rtc3POreY47bo3UUyaw7ICmtvs3GDAmFe136V5PZi49xgKV1DJ56yVH
         VyVuYbI0DVEljZRD66fHX8mXmTBF8oSXYIcebKHpzJtUv5QSFWlOv9dC0ZmAcVc72lAZ
         ixD4yftQHJeMvqMiDVlJaNyD0lrw1in1TUsVguz6FTsKxbem7kAAgLhiA2Z1l4S8hQFR
         yxgGKWazh0wdH+Li7+fJ2qIUqL8+JzjuZLNvyMafPk3xa9gQMYJt+XnD0mH7VtCsmzaL
         6FWA==
X-Gm-Message-State: AGi0PubAFCUWbmpF31CuXBlSdxxq1EEkT6N/5UDx29bb9fIOwdYII9ZA
        YNJWkM6GDI1NDicx0bAvn6jZDg==
X-Google-Smtp-Source: APiQypKzrhHPUD9aHJ3hmZp0/ZgDnDoCA6ubDPVnU3qpCBTRnS1Uhogiu1QmjutmwtD6GQY4umypQw==
X-Received: by 2002:adf:e58e:: with SMTP id l14mr15938569wrm.186.1587392272356;
        Mon, 20 Apr 2020 07:17:52 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id z18sm1304719wrw.41.2020.04.20.07.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 07:17:51 -0700 (PDT)
Date:   Mon, 20 Apr 2020 16:17:50 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Maor Gottlieb <maorg@mellanox.com>
Cc:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, leonro@mellanox.com, saeedm@mellanox.com,
        jiri@mellanox.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, alexr@mellanox.com
Subject: Re: [PATCH V2 mlx5-next 02/10] bonding: Rename slave_arr to
 usable_slaves
Message-ID: <20200420141750.GL6581@nanopsycho.orion>
References: <20200420075426.31462-1-maorg@mellanox.com>
 <20200420075426.31462-3-maorg@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420075426.31462-3-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 20, 2020 at 09:54:18AM CEST, maorg@mellanox.com wrote:
>This patch renames slave_arr to usable_slaves, since we will
>have two arrays, one for the usable slaves and the other to all
>slaves. In addition, exports the bond_skip_slave logic to function.

I the patch description, you should tell the codebase what to do. You
should not talk about "this patch".

>
>Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
>---
> drivers/net/bonding/bond_alb.c  |  4 +-
> drivers/net/bonding/bond_main.c | 85 +++++++++++++++++----------------
> include/net/bonding.h           |  2 +-
> 3 files changed, 48 insertions(+), 43 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
>index c81698550e5a..7bb49b049dcc 100644
>--- a/drivers/net/bonding/bond_alb.c
>+++ b/drivers/net/bonding/bond_alb.c
>@@ -1360,7 +1360,7 @@ netdev_tx_t bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
> 				struct bond_up_slave *slaves;
> 				unsigned int count;
> 
>-				slaves = rcu_dereference(bond->slave_arr);
>+				slaves = rcu_dereference(bond->usable_slaves);
> 				count = slaves ? READ_ONCE(slaves->count) : 0;
> 				if (likely(count))
> 					tx_slave = slaves->arr[hash_index %
>@@ -1494,7 +1494,7 @@ netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
> 			struct bond_up_slave *slaves;
> 			unsigned int count;
> 
>-			slaves = rcu_dereference(bond->slave_arr);
>+			slaves = rcu_dereference(bond->usable_slaves);
> 			count = slaves ? READ_ONCE(slaves->count) : 0;
> 			if (likely(count))
> 				tx_slave = slaves->arr[bond_xmit_hash(bond, skb) %
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index 2e70e43c5df5..2cb41d480ae2 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -4087,6 +4087,29 @@ static void bond_slave_arr_handler(struct work_struct *work)
> 	bond_slave_arr_work_rearm(bond, 1);
> }
> 
>+static void bond_skip_slave(struct bond_up_slave *slaves,
>+			    struct slave *skipslave)
>+{
>+	int idx;
>+
>+	/* Rare situation where caller has asked to skip a specific
>+	 * slave but allocation failed (most likely!). BTW this is
>+	 * only possible when the call is initiated from
>+	 * __bond_release_one(). In this situation; overwrite the
>+	 * skipslave entry in the array with the last entry from the
>+	 * array to avoid a situation where the xmit path may choose
>+	 * this to-be-skipped slave to send a packet out.
>+	 */
>+	for (idx = 0; slaves && idx < slaves->count; idx++) {
>+		if (skipslave == slaves->arr[idx]) {
>+			slaves->arr[idx] =
>+				slaves->arr[slaves->count - 1];
>+			slaves->count--;
>+			break;
>+		}
>+	}

Do this move in a separate patch. Is not related to the rename.


>+}
>+
> /* Build the usable slaves array in control path for modes that use xmit-hash
>  * to determine the slave interface -
>  * (a) BOND_MODE_8023AD
>@@ -4097,9 +4120,9 @@ static void bond_slave_arr_handler(struct work_struct *work)
>  */
> int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
> {
>+	struct bond_up_slave *usable_slaves, *old_usable_slaves;
> 	struct slave *slave;
> 	struct list_head *iter;
>-	struct bond_up_slave *new_arr, *old_arr;
> 	int agg_id = 0;
> 	int ret = 0;
> 
>@@ -4107,11 +4130,10 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
> 	WARN_ON(lockdep_is_held(&bond->mode_lock));
> #endif
> 
>-	new_arr = kzalloc(offsetof(struct bond_up_slave, arr[bond->slave_cnt]),
>-			  GFP_KERNEL);
>-	if (!new_arr) {
>+	usable_slaves = kzalloc(struct_size(usable_slaves, arr,
>+					    bond->slave_cnt), GFP_KERNEL);
>+	if (!usable_slaves) {
> 		ret = -ENOMEM;
>-		pr_err("Failed to build slave-array.\n");
> 		goto out;
> 	}
> 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
>@@ -4119,14 +4141,14 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
> 
> 		if (bond_3ad_get_active_agg_info(bond, &ad_info)) {
> 			pr_debug("bond_3ad_get_active_agg_info failed\n");
>-			kfree_rcu(new_arr, rcu);
>+			kfree_rcu(usable_slaves, rcu);
> 			/* No active aggragator means it's not safe to use
> 			 * the previous array.
> 			 */
>-			old_arr = rtnl_dereference(bond->slave_arr);
>-			if (old_arr) {
>-				RCU_INIT_POINTER(bond->slave_arr, NULL);
>-				kfree_rcu(old_arr, rcu);
>+			old_usable_slaves = rtnl_dereference(bond->usable_slaves);
>+			if (old_usable_slaves) {
>+				RCU_INIT_POINTER(bond->usable_slaves, NULL);
>+				kfree_rcu(old_usable_slaves, rcu);
> 			}
> 			goto out;
> 		}
>@@ -4146,37 +4168,20 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
> 			continue;
> 
> 		slave_dbg(bond->dev, slave->dev, "Adding slave to tx hash array[%d]\n",
>-			  new_arr->count);
>+			  usable_slaves->count);
> 
>-		new_arr->arr[new_arr->count++] = slave;
>+		usable_slaves->arr[usable_slaves->count++] = slave;
> 	}
> 
>-	old_arr = rtnl_dereference(bond->slave_arr);
>-	rcu_assign_pointer(bond->slave_arr, new_arr);
>-	if (old_arr)
>-		kfree_rcu(old_arr, rcu);
>+	old_usable_slaves = rtnl_dereference(bond->usable_slaves);
>+	rcu_assign_pointer(bond->usable_slaves, usable_slaves);
>+	if (old_usable_slaves)
>+		kfree_rcu(old_usable_slaves, rcu);
> out:
>-	if (ret != 0 && skipslave) {
>-		int idx;
>-
>-		/* Rare situation where caller has asked to skip a specific
>-		 * slave but allocation failed (most likely!). BTW this is
>-		 * only possible when the call is initiated from
>-		 * __bond_release_one(). In this situation; overwrite the
>-		 * skipslave entry in the array with the last entry from the
>-		 * array to avoid a situation where the xmit path may choose
>-		 * this to-be-skipped slave to send a packet out.
>-		 */
>-		old_arr = rtnl_dereference(bond->slave_arr);
>-		for (idx = 0; old_arr != NULL && idx < old_arr->count; idx++) {
>-			if (skipslave == old_arr->arr[idx]) {
>-				old_arr->arr[idx] =
>-				    old_arr->arr[old_arr->count-1];
>-				old_arr->count--;
>-				break;
>-			}
>-		}
>-	}
>+	if (ret != 0 && skipslave)
>+		bond_skip_slave(rtnl_dereference(bond->usable_slaves),
>+				skipslave);
>+
> 	return ret;
> }
> 
>@@ -4192,7 +4197,7 @@ static netdev_tx_t bond_3ad_xor_xmit(struct sk_buff *skb,
> 	struct bond_up_slave *slaves;
> 	unsigned int count;
> 
>-	slaves = rcu_dereference(bond->slave_arr);
>+	slaves = rcu_dereference(bond->usable_slaves);
> 	count = slaves ? READ_ONCE(slaves->count) : 0;
> 	if (likely(count)) {
> 		slave = slaves->arr[bond_xmit_hash(bond, skb) % count];
>@@ -4483,9 +4488,9 @@ static void bond_uninit(struct net_device *bond_dev)
> 		__bond_release_one(bond_dev, slave->dev, true, true);
> 	netdev_info(bond_dev, "Released all slaves\n");
> 
>-	arr = rtnl_dereference(bond->slave_arr);
>+	arr = rtnl_dereference(bond->usable_slaves);
> 	if (arr) {
>-		RCU_INIT_POINTER(bond->slave_arr, NULL);
>+		RCU_INIT_POINTER(bond->usable_slaves, NULL);
> 		kfree_rcu(arr, rcu);
> 	}
> 
>diff --git a/include/net/bonding.h b/include/net/bonding.h
>index dc2ce31a1f52..33bdb6d5182d 100644
>--- a/include/net/bonding.h
>+++ b/include/net/bonding.h
>@@ -200,7 +200,7 @@ struct bonding {
> 	struct   slave __rcu *curr_active_slave;
> 	struct   slave __rcu *current_arp_slave;
> 	struct   slave __rcu *primary_slave;
>-	struct   bond_up_slave __rcu *slave_arr; /* Array of usable slaves */
>+	struct   bond_up_slave __rcu *usable_slaves; /* Array of usable slaves */
> 	bool     force_primary;
> 	s32      slave_cnt; /* never change this value outside the attach/detach wrappers */
> 	int     (*recv_probe)(const struct sk_buff *, struct bonding *,
>-- 
>2.17.2
>
