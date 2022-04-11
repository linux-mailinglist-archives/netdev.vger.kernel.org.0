Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991844FB67D
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 10:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343958AbiDKI4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 04:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343971AbiDKI4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 04:56:42 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1574BAE62
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 01:54:26 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id c64so5302142edf.11
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 01:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JxZ2hlYLrrpKGyiepxnEHdzTqv0QjHLglHvt+oTkvEM=;
        b=e1F6Y+s4NKxa/aJY1S9ih7E+QUeVyubwzEhYWEERSiEZCWNUJxSSs/nfq/SAvlC7V3
         ERpSnJdRWRjAYssNqUsBXkPYJkpEPVNeBHumb9VhhNygdS608KLVOGz5qqi4YNKbvob4
         /+u4AOiRa1E5wvBx8pQAxy5/r4YQxjBfrSgyE5D41yowRW3inyfAgw+yuH+6+d8UZHUO
         JfHgcLFrHW+52VLKiVsR4t9ELfOLeormR87COlsqem1EVZ2JTO16+kNkhDgLaw3TJCpC
         dJBju6fUXnghaKHagmEc3hu6kKG+vc9YodsIMFFx3ulqt8Vz8cROWShWnn/eqAjJvzS/
         XDAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JxZ2hlYLrrpKGyiepxnEHdzTqv0QjHLglHvt+oTkvEM=;
        b=5LazAhT0/+2chSQwF+uzgXTaBsbwT4x6YU/7s97VYDra6lOcYDlNRRa4xLHdzl/5cc
         +OFdK7xiTRCJ4ykfLJCjQSiHofAyXpnNsvnfTygHFgNST+Qzx1CKe/4Vqs4ylorQcfcL
         ehrUgIKqRE/oIBrwQEETPeKR6zBEhTI8feM7G4phsZdMvSj5YL3LjG+gl4pNSWobzg/u
         n1jKegv7qvs+0KMXboZhY7oy/crJe/AZv3dpNwqrqIsr8y+MDbMzEPuVPGdkre+YYVLO
         7L9DRKRxFVFwWF+2/JejCNjJo4CvOKktGlxOv/VL4Vt0aIRLBfK7rTvNoyM1dYGMncYp
         gwuQ==
X-Gm-Message-State: AOAM533sr3GKLc+V1tgzEd2Xua4Xk798UjGNiUraCmaBcNiNCJ+W8bEi
        6YVKLz9Q4ya0Rzc6mWC+2KJhFw==
X-Google-Smtp-Source: ABdhPJw0AT3PvOPLD5Fg3jXy+PICvPP/6IfWEvvGC+i9T26lfDk/Ku6wAuoEwdj4X6RehJ6oaEGYSQ==
X-Received: by 2002:a05:6402:3044:b0:41c:d4d4:8664 with SMTP id bs4-20020a056402304400b0041cd4d48664mr32199003edb.239.1649667264862;
        Mon, 11 Apr 2022 01:54:24 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id z21-20020a1709063a1500b006da6436819dsm11681279eje.173.2022.04.11.01.54.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 01:54:24 -0700 (PDT)
Message-ID: <5a86141c-7d82-18f7-077c-89cd01bc6d9e@blackwall.org>
Date:   Mon, 11 Apr 2022 11:54:23 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next 2/6] net: bridge: fdb: add support for
 fine-grained flushing
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, kuba@kernel.org,
        davem@davemloft.net, bridge@lists.linux-foundation.org
References: <20220409105857.803667-1-razor@blackwall.org>
 <20220409105857.803667-3-razor@blackwall.org> <YlPk4GGqcAGCEZ4s@shredder>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <YlPk4GGqcAGCEZ4s@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/04/2022 11:20, Ido Schimmel wrote:
> On Sat, Apr 09, 2022 at 01:58:53PM +0300, Nikolay Aleksandrov wrote:
>> Add the ability to specify exactly which fdbs to be flushed. They are
>> described by a new structure - net_bridge_fdb_flush_desc. Currently it
>> can match on port/bridge ifindex, vlan id and fdb flags. It is used to
>> describe the existing dynamic fdb flush operation.
>>
>> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
>> ---
>>  net/bridge/br_fdb.c      | 36 +++++++++++++++++++++++++++++-------
>>  net/bridge/br_netlink.c  |  9 +++++++--
>>  net/bridge/br_private.h  | 10 +++++++++-
>>  net/bridge/br_sysfs_br.c |  6 +++++-
>>  4 files changed, 50 insertions(+), 11 deletions(-)
>>
>> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
>> index 6ccda68bd473..4b0bf88c4121 100644
>> --- a/net/bridge/br_fdb.c
>> +++ b/net/bridge/br_fdb.c
>> @@ -558,18 +558,40 @@ void br_fdb_cleanup(struct work_struct *work)
>>  	mod_delayed_work(system_long_wq, &br->gc_work, work_delay);
>>  }
>>  
>> -/* Completely flush all dynamic entries in forwarding database.*/
>> -void br_fdb_flush(struct net_bridge *br)
>> +static bool __fdb_flush_matches(const struct net_bridge *br,
>> +				const struct net_bridge_fdb_entry *f,
>> +				const struct net_bridge_fdb_flush_desc *desc)
>> +{
>> +	const struct net_bridge_port *dst = READ_ONCE(f->dst);
>> +	int port_ifidx, br_ifidx = br->dev->ifindex;
>> +
>> +	port_ifidx = dst ? dst->dev->ifindex : 0;
>> +
>> +	return (!desc->vlan_id || desc->vlan_id == f->key.vlan_id) &&
>> +	       (!desc->port_ifindex ||
>> +		(desc->port_ifindex == port_ifidx ||
>> +		 (!dst && desc->port_ifindex == br_ifidx))) &&
>> +	       (!desc->flags_mask ||
>> +		((f->flags & desc->flags_mask) == desc->flags));
> 
> I find this easier to read:
> 
> port_ifidx = dst ? dst->dev->ifindex : br_ifidx;
> 
> if (desc->vlan_id && desc->vlan_id != f->key.vlan_id)
> 	return false;
> if (desc->port_ifindex && desc->port_ifindex != port_ifidx)
> 	return false;
> if (desc->flags_mask && (f->flags & desc->flags_mask) != desc->flags)
> 	return false;
> 
> return true;
> 

Ack

>> +}
>> +
>> +/* Flush forwarding database entries matching the description */
>> +void br_fdb_flush(struct net_bridge *br,
>> +		  const struct net_bridge_fdb_flush_desc *desc)
>>  {
>>  	struct net_bridge_fdb_entry *f;
>> -	struct hlist_node *tmp;
>>  
>> -	spin_lock_bh(&br->hash_lock);
>> -	hlist_for_each_entry_safe(f, tmp, &br->fdb_list, fdb_node) {
>> -		if (!test_bit(BR_FDB_STATIC, &f->flags))
>> +	rcu_read_lock();
>> +	hlist_for_each_entry_rcu(f, &br->fdb_list, fdb_node) {
>> +		if (!__fdb_flush_matches(br, f, desc))
>> +			continue;
>> +
>> +		spin_lock_bh(&br->hash_lock);
>> +		if (!hlist_unhashed(&f->fdb_node))
>>  			fdb_delete(br, f, true);
>> +		spin_unlock_bh(&br->hash_lock);
>>  	}
>> -	spin_unlock_bh(&br->hash_lock);
>> +	rcu_read_unlock();
>>  }
>>  
>>  /* Flush all entries referring to a specific port.
>> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
>> index fe2211d4c0c7..6e6dce6880c9 100644
>> --- a/net/bridge/br_netlink.c
>> +++ b/net/bridge/br_netlink.c
>> @@ -1366,8 +1366,13 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
>>  		br_recalculate_fwd_mask(br);
>>  	}
>>  
>> -	if (data[IFLA_BR_FDB_FLUSH])
>> -		br_fdb_flush(br);
>> +	if (data[IFLA_BR_FDB_FLUSH]) {
>> +		struct net_bridge_fdb_flush_desc desc = {
>> +			.flags_mask = BR_FDB_STATIC
>> +		};
>> +
>> +		br_fdb_flush(br, &desc);
> 
> I wanted to ask why you are not doing the same for IFLA_BRPORT_FLUSH,
> but then I read the implementation of br_fdb_delete_by_port() and
> remembered the comment in the cover letter regarding fdb_delete vs
> fdb_delete_local. Probably best to note it in the commit message
> 

Yup, good point. Will add.

>> +	}
>>  
>>  #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
>>  	if (data[IFLA_BR_MCAST_ROUTER]) {
>> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
>> index 6e62af2e07e9..e6930e9ee69d 100644
>> --- a/net/bridge/br_private.h
>> +++ b/net/bridge/br_private.h
>> @@ -274,6 +274,13 @@ struct net_bridge_fdb_entry {
>>  	struct rcu_head			rcu;
>>  };
>>  
>> +struct net_bridge_fdb_flush_desc {
>> +	unsigned long			flags;
>> +	unsigned long			flags_mask;
>> +	int				port_ifindex;
>> +	u16				vlan_id;
>> +};
>> +
>>  #define MDB_PG_FLAGS_PERMANENT	BIT(0)
>>  #define MDB_PG_FLAGS_OFFLOAD	BIT(1)
>>  #define MDB_PG_FLAGS_FAST_LEAVE	BIT(2)
>> @@ -759,7 +766,8 @@ int br_fdb_init(void);
>>  void br_fdb_fini(void);
>>  int br_fdb_hash_init(struct net_bridge *br);
>>  void br_fdb_hash_fini(struct net_bridge *br);
>> -void br_fdb_flush(struct net_bridge *br);
>> +void br_fdb_flush(struct net_bridge *br,
>> +		  const struct net_bridge_fdb_flush_desc *desc);
>>  void br_fdb_find_delete_local(struct net_bridge *br,
>>  			      const struct net_bridge_port *p,
>>  			      const unsigned char *addr, u16 vid);
>> diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
>> index 3f7ca88c2aa3..612e367fff20 100644
>> --- a/net/bridge/br_sysfs_br.c
>> +++ b/net/bridge/br_sysfs_br.c
>> @@ -344,7 +344,11 @@ static DEVICE_ATTR_RW(group_addr);
>>  static int set_flush(struct net_bridge *br, unsigned long val,
>>  		     struct netlink_ext_ack *extack)
>>  {
>> -	br_fdb_flush(br);
>> +	struct net_bridge_fdb_flush_desc desc = {
>> +		.flags_mask = BR_FDB_STATIC
>> +	};
>> +
>> +	br_fdb_flush(br, &desc);
>>  	return 0;
>>  }
>>  
>> -- 
>> 2.35.1
>>

