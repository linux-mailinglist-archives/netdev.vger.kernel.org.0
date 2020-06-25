Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E2B209E4D
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 14:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404658AbgFYMSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 08:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404475AbgFYMSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 08:18:00 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565EBC0613ED
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 05:17:59 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id f18so5704540wml.3
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 05:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aA/oXrkv3sIy+s2Zp87t2t4rA27Esv7FPgR5kYDO2Ko=;
        b=BauguZ0b2C8HJrzUizMCRyp+s56kk9/WlVHsF82HHJ/NSEAvFJlBn0pGIcffmJHk+t
         zkWH6DMsT/W6wF6p7zptOq0diTzk2pnVtrp88121PFTHh49uhmJgfI6aCr+eIcO4pUkp
         qkj/JmOypfYmcJjsnQu9xtWJgEFGq7jSTpBdU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aA/oXrkv3sIy+s2Zp87t2t4rA27Esv7FPgR5kYDO2Ko=;
        b=dpCyDmBsLp24EbG42hy6qs/scmpA+bTaSlb7Mekd6bcgD8kn4gdSWm3qOyT996EymU
         KxfFV6roR9W5VddkPiq/6Xl6RIZWVhSndr6jEZWLwHqHOPR8XWomtdwfoEWVKAgUdCXf
         3PlqYfgMu9Q57FB0YuC2ZrgcHX7OxRR7YUoJv/E1ux2IIMyX2m0zG02P9tBQkDb12VBa
         ZY9OD9Vr1r90PxjO7+gRzf4512laHP/dyk2wNqB4jLnbCtHXWkLy9y2htIx5b1emqORv
         2ED15gVfaiPXLRIrYyZQnUo0K2maiZSrKhzlGi72TczvGU8nb4ScqUH/oU3MPtG/zqu2
         Rfsg==
X-Gm-Message-State: AOAM530lcb/a5Yw4B9n85MQ4P9CY8KpEkY+0cuhStNAXi1YbWv0IWJC3
        JYwPEEWaXz7cBaGQcNxLOKUrxQ==
X-Google-Smtp-Source: ABdhPJzJgrOf1IvTIuo5ckdk8A5+c8I2EDpfgIjr6HNxJY1iwBurIE4Cc4aGzr5Gw1lHTVtUd48q5g==
X-Received: by 2002:a1c:e355:: with SMTP id a82mr3162219wmh.165.1593087477784;
        Thu, 25 Jun 2020 05:17:57 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id k126sm6799176wme.17.2020.06.25.05.17.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 05:17:56 -0700 (PDT)
Subject: Re: [PATCH net-next v2] bridge: mrp: Extend MRP netlink interface
 with IFLA_BRIDGE_MRP_CLEAR
To:     kernel test robot <lkp@intel.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        roopa@cumulusnetworks.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     kbuild-all@lists.01.org
References: <20200625070630.3267620-1-horatiu.vultur@microchip.com>
 <202006251953.iZkqIUMb%lkp@intel.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <e0c847b9-8af5-c24f-8813-cffb388e3e23@cumulusnetworks.com>
Date:   Thu, 25 Jun 2020 15:17:55 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <202006251953.iZkqIUMb%lkp@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/06/2020 15:03, kernel test robot wrote:
> Hi Horatiu,
> 
> Thank you for the patch! Perhaps something to improve:
> 

Hi,
I think you should drop the __rcu tag for the mrp_list member and also
from the "list" member of struct br_mrp to fix most of the below.

Cheers,
 Nik

> [auto build test WARNING on net-next/master]
> 
> url:    https://github.com/0day-ci/linux/commits/Horatiu-Vultur/bridge-mrp-Extend-MRP-netlink-interface-with-IFLA_BRIDGE_MRP_CLEAR/20200625-150941
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 147373d968f1c1b5d6bb71e4e8b7495eeb9cdcae
> config: i386-randconfig-s001-20200624 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-13) 9.3.0
> reproduce:
>         # apt-get install sparse
>         # sparse version: v0.6.2-dirty
>         # save the attached .config to linux build tree
>         make W=1 C=1 ARCH=i386 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> 
> sparse warnings: (new ones prefixed by >>)
> 
>    net/bridge/br_mrp.c:106:18: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned short [usertype] @@     got restricted __be16 [usertype] @@
>    net/bridge/br_mrp.c:106:18: sparse:     expected unsigned short [usertype]
>    net/bridge/br_mrp.c:106:18: sparse:     got restricted __be16 [usertype]
>    net/bridge/br_mrp.c:281:23: sparse: sparse: incorrect type in argument 1 (different modifiers) @@     expected struct list_head *entry @@     got struct list_head [noderef] * @@
>    net/bridge/br_mrp.c:281:23: sparse:     expected struct list_head *entry
>    net/bridge/br_mrp.c:281:23: sparse:     got struct list_head [noderef] *
>    net/bridge/br_mrp.c:332:28: sparse: sparse: incorrect type in argument 1 (different modifiers) @@     expected struct list_head *new @@     got struct list_head [noderef] * @@
>    net/bridge/br_mrp.c:332:28: sparse:     expected struct list_head *new
>    net/bridge/br_mrp.c:332:28: sparse:     got struct list_head [noderef] *
>    net/bridge/br_mrp.c:332:40: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected struct list_head *head @@     got struct list_head [noderef] * @@
>    net/bridge/br_mrp.c:332:40: sparse:     expected struct list_head *head
>    net/bridge/br_mrp.c:332:40: sparse:     got struct list_head [noderef] *
>    net/bridge/br_mrp.c:691:29: sparse: sparse: incorrect type in argument 1 (different modifiers) @@     expected struct list_head const *head @@     got struct list_head [noderef] * @@
>    net/bridge/br_mrp.c:691:29: sparse:     expected struct list_head const *head
>    net/bridge/br_mrp.c:691:29: sparse:     got struct list_head [noderef] *
>>> net/bridge/br_mrp.c:383:9: sparse: sparse: dereference of noderef expression
>>> net/bridge/br_mrp.c:383:9: sparse: sparse: dereference of noderef expression
>>> net/bridge/br_mrp.c:383:9: sparse: sparse: dereference of noderef expression
> 
> vim +383 net/bridge/br_mrp.c
> 
>    284	
>    285	/* Adds a new MRP instance.
>    286	 * note: called under rtnl_lock
>    287	 */
>    288	int br_mrp_add(struct net_bridge *br, struct br_mrp_instance *instance)
>    289	{
>    290		struct net_bridge_port *p;
>    291		struct br_mrp *mrp;
>    292		int err;
>    293	
>    294		/* If the ring exists, it is not possible to create another one with the
>    295		 * same ring_id
>    296		 */
>    297		mrp = br_mrp_find_id(br, instance->ring_id);
>    298		if (mrp)
>    299			return -EINVAL;
>    300	
>    301		if (!br_mrp_get_port(br, instance->p_ifindex) ||
>    302		    !br_mrp_get_port(br, instance->s_ifindex))
>    303			return -EINVAL;
>    304	
>    305		/* It is not possible to have the same port part of multiple rings */
>    306		if (!br_mrp_unique_ifindex(br, instance->p_ifindex) ||
>    307		    !br_mrp_unique_ifindex(br, instance->s_ifindex))
>    308			return -EINVAL;
>    309	
>    310		mrp = kzalloc(sizeof(*mrp), GFP_KERNEL);
>    311		if (!mrp)
>    312			return -ENOMEM;
>    313	
>    314		mrp->ring_id = instance->ring_id;
>    315		mrp->prio = instance->prio;
>    316	
>    317		p = br_mrp_get_port(br, instance->p_ifindex);
>    318		spin_lock_bh(&br->lock);
>    319		p->state = BR_STATE_FORWARDING;
>    320		p->flags |= BR_MRP_AWARE;
>    321		spin_unlock_bh(&br->lock);
>    322		rcu_assign_pointer(mrp->p_port, p);
>    323	
>    324		p = br_mrp_get_port(br, instance->s_ifindex);
>    325		spin_lock_bh(&br->lock);
>    326		p->state = BR_STATE_FORWARDING;
>    327		p->flags |= BR_MRP_AWARE;
>    328		spin_unlock_bh(&br->lock);
>    329		rcu_assign_pointer(mrp->s_port, p);
>    330	
>    331		INIT_DELAYED_WORK(&mrp->test_work, br_mrp_test_work_expired);
>  > 332		list_add_tail_rcu(&mrp->list, &br->mrp_list);
>    333	
>    334		err = br_mrp_switchdev_add(br, mrp);
>    335		if (err)
>    336			goto delete_mrp;
>    337	
>    338		return 0;
>    339	
>    340	delete_mrp:
>    341		br_mrp_del_impl(br, mrp);
>    342	
>    343		return err;
>    344	}
>    345	
>    346	/* Deletes the MRP instance from which the port is part of
>    347	 * note: called under rtnl_lock
>    348	 */
>    349	void br_mrp_port_del(struct net_bridge *br, struct net_bridge_port *p)
>    350	{
>    351		struct br_mrp *mrp = br_mrp_find_port(br, p);
>    352	
>    353		/* If the port is not part of a MRP instance just bail out */
>    354		if (!mrp)
>    355			return;
>    356	
>    357		br_mrp_del_impl(br, mrp);
>    358	}
>    359	
>    360	/* Deletes existing MRP instance based on ring_id
>    361	 * note: called under rtnl_lock
>    362	 */
>    363	int br_mrp_del(struct net_bridge *br, struct br_mrp_instance *instance)
>    364	{
>    365		struct br_mrp *mrp = br_mrp_find_id(br, instance->ring_id);
>    366	
>    367		if (!mrp)
>    368			return -EINVAL;
>    369	
>    370		br_mrp_del_impl(br, mrp);
>    371	
>    372		return 0;
>    373	}
>    374	
>    375	/* Deletes all MRP instances on the bridge
>    376	 * note: called under rtnl_lock
>    377	 */
>    378	int br_mrp_clear(struct net_bridge *br)
>    379	{
>    380		struct br_mrp *mrp;
>    381		struct br_mrp *tmp;
>    382	
>  > 383		list_for_each_entry_safe(mrp, tmp, &br->mrp_list, list) {
>    384			br_mrp_del_impl(br, mrp);
>    385		}
>    386	
>    387		return 0;
>    388	}
>    389	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 

