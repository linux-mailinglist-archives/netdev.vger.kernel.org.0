Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D424EBE9F
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 12:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245317AbiC3KZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 06:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242881AbiC3KZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 06:25:29 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CC622B3B
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 03:23:40 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id bh17so1050776ejb.8
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 03:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KcemAQXGKS/bu1WPq66TUYrATVLlvsGVeMOPMU20wnE=;
        b=hcm4UeLCkZcBWsN+sqAaYrQ3UM6jSe/BWrZylHfI9zj1/b/B+Q2o3QKiHKheyLAkxb
         TTTsO73YQralOmuppkB2+AsMeaXa797UpzBV3SO2JiqC/haM2g5W/HHssc5l03WSzMnk
         wn9F0GM2KrEypygyS4rpwITD73NFnaaSzOZjURKKMUMgGUUN+5AGyKGyGqfFpoPPlZik
         7bauupYqlkr94v0NX7QgoLE/sPZKeL/LywTTXsDjCU6w3gcCcsnd+yvav04cGF5UCLHw
         PeZog8tVx2Ix8HE4SHEhnPXCXxqnXGAzNPi+HT5P7b2NoKmCWQXOLX7uyfG4A1L1fcPf
         la4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KcemAQXGKS/bu1WPq66TUYrATVLlvsGVeMOPMU20wnE=;
        b=BsnDeCdqKS5+bxjfcma4TmS7UGMtOpbpJTY/S+LWGShqqupvlRzl8f66Vr2Imt3AQO
         1KOTWtQTsdEBpUrwPB8IM3zaw8CMkcPTdEyQ5DU84AGvGyDl2UcI0cIN0j1fSCNRIoMS
         uvLduQwfOshkKZuAAhPcUxX4Q1+tG4m2Lf4j+xS9CG2cXxmqELs8pgsIFpFn+3UGVsJk
         AUW5+OwRn7ZlcZLpKZ8UQLpT5vHuOePCEb/mJvyitV41BXr1DVEuPL+1JMZ2Y2uC4nEM
         0ZMytOZZK5O+taY/n4qXT3DEAyrvZw9hpL1B6p3WujP5msPcl84SBf3LC68qfb4UX7Sw
         EWBQ==
X-Gm-Message-State: AOAM533qr/Mqj1HbXNB77X3JECDaOhbL8kA/r6MIvKsjCZHMp2s+0jjX
        mwUHJGWYhlZRVCGzPuZYh4MPTQ==
X-Google-Smtp-Source: ABdhPJwTgdnDKzDbzvdVTmiTIQ1Q2zMWj4qcPywFywtUZ2N7KTD7V6QRoheYFt356FxSjfWCf/dRmA==
X-Received: by 2002:a17:907:3d01:b0:6e0:c63b:1992 with SMTP id gm1-20020a1709073d0100b006e0c63b1992mr26541074ejc.422.1648635818836;
        Wed, 30 Mar 2022 03:23:38 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id hs12-20020a1709073e8c00b006dfdfdac005sm8141217ejc.174.2022.03.30.03.23.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 03:23:38 -0700 (PDT)
Message-ID: <d2e45c4a-ed34-10d3-58cd-01b1c19bd004@blackwall.org>
Date:   Wed, 30 Mar 2022 13:23:36 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH net-next v2] veth: Support bonding events
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>
References: <20220329114052.237572-1-wintera@linux.ibm.com>
 <20220329175421.4a6325d9@kernel.org>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220329175421.4a6325d9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/03/2022 03:54, Jakub Kicinski wrote:
> Dropping the BPF people from CC and adding Hangbin, bridge and
> bond/team. Please exercise some judgment when sending patches.
> 
> On Tue, 29 Mar 2022 13:40:52 +0200 Alexandra Winter wrote:
>> Bonding drivers generate specific events during failover that trigger
>> switch updates.  When a veth device is attached to a bridge with a
>> bond interface, we want external switches to learn about the veth
>> devices as well.
>>
>> Example:
>>
>> 	| veth_a2   |  veth_b2  |  veth_c2 |
>> 	------o-----------o----------o------
>> 	       \	  |	    /
>> 		o	  o	   o
>> 	      veth_a1  veth_b1  veth_c1
>> 	      -------------------------
>> 	      |        bridge         |
>> 	      -------------------------
>> 			bond0
>> 			/  \
>> 		     eth0  eth1
>>
>> In case of failover from eth0 to eth1, the netdev_notifier needs to be
>> propagated, so e.g. veth_a2 can re-announce its MAC address to the
>> external hardware attached to eth1.
>>
>> Without this patch we have seen cases where recovery after bond failover
>> took an unacceptable amount of time (depending on timeout settings in the
>> network).
>>
>> Due to the symmetric nature of veth special care is required to avoid
>> endless notification loops. Therefore we only notify from a veth
>> bridgeport to a peer that is not a bridgeport.
>>
>> References:
>> Same handling as for macvlan:
>> commit 4c9912556867 ("macvlan: Support bonding events")
>> and vlan:
>> commit 4aa5dee4d999 ("net: convert resend IGMP to notifier event")
>>
>> Alternatives:
>> Propagate notifier events to all ports of a bridge. IIUC, this was
>> rejected in https://www.spinics.net/lists/netdev/msg717292.html
> 
> My (likely flawed) reading of Nik's argument was that (1) he was
> concerned about GARP storms; (2) he didn't want the GARP to be
> broadcast to all ports, just the bond that originated the request.
> 

Yes, that would be ideal. Trying to avoid unnecessary bcasts, that is
especially important for large setups with lots of devices.

> I'm not sure I follow (1), as Hangbin said the event is rare, plus 
> GARP only comes from interfaces that have an IP addr, which IIUC
> most bridge ports will not have.
> 

Indeed, such setups are not the most common ones.

> This patch in no way addresses (2). But then, again, if we put 
> a macvlan on top of a bridge master it will shotgun its GARPS all 
> the same. So it's not like veth would be special in that regard.
> 
> Nik, what am I missing?
> 

If we're talking about macvlan -> bridge -> bond then the bond flap's
notify peers shouldn't reach the macvlan. Generally broadcast traffic
is quite expensive for the bridge, I have patches that improve on the
technical side (consider ports only for the same bcast domain), but you also
wouldn't want unnecessary bcast packets being sent around. :)
There are setups with tens of bond devices and propagating that to all would be
very expensive, but most of all unnecessary. It would also hurt setups with
a lot of vlan devices on the bridge. There are setups with hundreds of vlans
and hundreds of macvlans on top, propagating it up would send it to all of
them and that wouldn't scale at all, these mostly have IP addresses too.

Perhaps we can enable propagation on a per-port or per-bridge basis, then we
can avoid these walks. That is, make it opt-in.

>> It also seems difficult to avoid re-bouncing the notifier.
> 
> syzbot will make short work of this patch, I think the potential
> for infinite loops has to be addressed somehow. IIUC this is the 
> first instance of forwarding those notifiers to a peer rather
> than within a upper <> lower device hierarchy which is a DAG.
> 
>> Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
>> ---
>>  drivers/net/veth.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 53 insertions(+)
>>
>> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
>> index d29fb9759cc9..74b074453197 100644
>> --- a/drivers/net/veth.c
>> +++ b/drivers/net/veth.c
>> @@ -1579,6 +1579,57 @@ static void veth_setup(struct net_device *dev)
>>  	dev->mpls_features = NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE;
>>  }
>>  
>> +static bool netif_is_veth(const struct net_device *dev)
>> +{
>> +	return (dev->netdev_ops == &veth_netdev_ops);
> 
> brackets unnecessary 
> 
>> +}
>> +
>> +static void veth_notify_peer(unsigned long event, const struct net_device *dev)
>> +{
>> +	struct net_device *peer;
>> +	struct veth_priv *priv;
>> +
>> +	priv = netdev_priv(dev);
>> +	peer = rtnl_dereference(priv->peer);
>> +	/* avoid re-bounce between 2 bridges */
>> +	if (!netif_is_bridge_port(peer))
>> +		call_netdevice_notifiers(event, peer);
>> +}
>> +
>> +/* Called under rtnl_lock */
>> +static int veth_device_event(struct notifier_block *unused,
>> +			     unsigned long event, void *ptr)
>> +{
>> +	struct net_device *dev, *lower;
>> +	struct list_head *iter;
>> +
>> +	dev = netdev_notifier_info_to_dev(ptr);
>> +
>> +	switch (event) {
>> +	case NETDEV_NOTIFY_PEERS:
>> +	case NETDEV_BONDING_FAILOVER:
>> +	case NETDEV_RESEND_IGMP:
>> +		/* propagate to peer of a bridge attached veth */
>> +		if (netif_is_bridge_master(dev)) {
> 
> Having veth sift thru bridge ports seems strange.
> In fact it could be beneficial to filter the event based on
> port state (whether it's forwarding, vlan etc). But looking
> at details of port state outside the bridge would be even stranger.
> 
>> +			iter = &dev->adj_list.lower;
>> +			lower = netdev_next_lower_dev_rcu(dev, &iter);
>> +			while (lower) {
>> +				if (netif_is_veth(lower))
>> +					veth_notify_peer(event, lower);
>> +				lower = netdev_next_lower_dev_rcu(dev, &iter);
> 
> let's add netdev_for_each_lower_dev_rcu() rather than open-coding
> 
>> +			}
>> +		}
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +	return NOTIFY_DONE;
>> +}
>> +
>> +static struct notifier_block veth_notifier_block __read_mostly = {
>> +		.notifier_call  = veth_device_event,
> 
> extra tab here
> 
>> +};
>> +
>>  /*
>>   * netlink interface
>>   */
>> @@ -1824,12 +1875,14 @@ static struct rtnl_link_ops veth_link_ops = {
>>  
>>  static __init int veth_init(void)
>>  {
>> +	register_netdevice_notifier(&veth_notifier_block);
> 
> this can fail
> 
>>  	return rtnl_link_register(&veth_link_ops);
>>  }
>>  
>>  static __exit void veth_exit(void)
>>  {
>>  	rtnl_link_unregister(&veth_link_ops);
>> +	unregister_netdevice_notifier(&veth_notifier_block);
>>  }
>>  
>>  module_init(veth_init);
> 

