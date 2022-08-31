Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDF6F5A7607
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 07:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiHaFzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 01:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiHaFzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 01:55:23 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E1330F77
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 22:55:21 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id k22so13501665ljg.2
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 22:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=IM2/armwaGbJ5BRoqgOihKiS/QWf6zEeXMXaeEouNZg=;
        b=jD4yyFj1mxf9u5IoMLUAQQtv1OiNcZVH/kEYMWrd33Wp4bzJ+yf5MnF34a40HIKPzK
         swwYV8SixU95k9mADI2q4gDyiTTRkjT5dU62tsWshmjcFwC3NcsAAViLvRc1OolXJU/I
         XoVLF1aE4GiXqG79+6RnmpG1KNY8t19Da4fRw2uOS2C6+lQ69o2+BDM0xH1hZDd52ZrM
         GfNUlXGH8Bg+D8kpkzbuy/05HNG9Nh3oEHd1oKhBmthrft3/LjIEHEywsldBkkPArFt8
         2ILAzZTeENCuUW2vSbCwwU/6jGF8R/9DdxNvo7ohLC9BnWyK0oD+uLtCwhKdTr9QHWsr
         xlOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=IM2/armwaGbJ5BRoqgOihKiS/QWf6zEeXMXaeEouNZg=;
        b=bR5d0jUWJPaPpCkGxE8Gxt65WsBUQkCqNxM8Smnv8Tde09iEaOhu4Gep2LIsh0lTQr
         WCNFZ7FcaPhbyeN/uBZOTCoWW9R6yiLkCxZWEJH8bYp//6LRESHgt2ldBfjq9hmUDFS3
         qyJI7OYX7rG0xR7rU3FiYmEE/pqLO8YP8Y3CKPamP33SKAb5W8GPN2a0TQM0KGu7v54x
         pHWJcc6fBB1GlO2E8FBY6BrKMmhdv4q12jrCgrDC9G1IZDBpi8Xbbcn72DazSO0kqVq3
         jfxU9a9H8QfKEpKg93/P1EKqgsGsLeW36avjt9b1v9Vqyxb9eckdDn4vUA6HImSkM/d5
         /1fQ==
X-Gm-Message-State: ACgBeo04ZAXCZZ6nthbg4w8savBGQOH3z5E5bjztfxgG9wshS6DyWFRE
        CPl2q4uaam+w1pqrtcf0Ey0=
X-Google-Smtp-Source: AA6agR7+PzoDS3/7m3RO+PLft5H+KqoFBEM3VE9HAW0jkjomCnUzmIdUwiJ6ibJYokWCQTemb5VVSg==
X-Received: by 2002:a2e:b5a2:0:b0:263:3745:a554 with SMTP id f2-20020a2eb5a2000000b002633745a554mr5236647ljn.190.1661925319675;
        Tue, 30 Aug 2022 22:55:19 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id u16-20020a056512129000b00492c2394ea5sm1294653lfs.165.2022.08.30.22.55.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 22:55:19 -0700 (PDT)
Message-ID: <e5a698cf-71ae-fa47-8157-42fb161082f4@gmail.com>
Date:   Wed, 31 Aug 2022 07:55:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v2 1/3] dsa: Implement RMU layer in DSA
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220826063816.948397-1-mattias.forsblad@gmail.com>
 <20220826063816.948397-2-mattias.forsblad@gmail.com>
 <20220830154737.no5rd5k4ateu56zs@skbuf>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <20220830154737.no5rd5k4ateu56zs@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-08-30 17:47, Vladimir Oltean wrote:

>> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
>> ---
>>  include/net/dsa.h             |   7 +++
>>  include/uapi/linux/if_ether.h |   1 +
>>  net/dsa/tag_dsa.c             | 109 +++++++++++++++++++++++++++++++++-
>>  3 files changed, 114 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/net/dsa.h b/include/net/dsa.h
>> index f2ce12860546..54f7f3494f84 100644
>> --- a/include/net/dsa.h
>> +++ b/include/net/dsa.h
>> @@ -92,6 +92,7 @@ struct dsa_switch;
>>  struct dsa_device_ops {
>>  	struct sk_buff *(*xmit)(struct sk_buff *skb, struct net_device *dev);
>>  	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev);
>> +	int (*inband_xmit)(struct sk_buff *skb, struct net_device *dev, int seq_no);
> 
> There isn't a reason that I can see to expand the DSA tagger ops with an
> inband_xmit(). DSA tagging protocol ops are reactive hooks to modify
> packets belonging to slave interfaces, rather than initiators of traffic.
> 
> Here you are calling tag_ops->inband_xmit() from mv88e6xxx_rmu_tx(),
> i.e. this operation is never invoked from the DSA core, but from a code
> path fully in control of the hardware driver. We don't usually (ever?)
> use DSA ops in this way, but rather just a way for the framework to
> invoke driver-specific code.
> 
> Is there a reason why dsa_inband_xmit_ll() cannot simply live within the
> mv88e6xxx driver (the direct caller) rather than within the dsa/edsa tagger?
> 
> Tagging protocols can be changed at driver runtime, but only while the
> DSA master is down. So when the master goes up, you can also check which
> tagging protocol is in use, and cache/use that to construct the skb.
> 
> Furthermore, there is no slave interface associated with RMU traffic,
> although in your proposed implementation here, there is (that's what
> "struct net_device *dev" passed here is).
> 
> Which slave @dev are you passing? That's right, dev_get_by_name(&init_net, "chan0").
> I think it's pretty obvious there is a systematic problem with your approach.
> Not everyone has a slave net device called chan0 in the main netns.
> 
> The qca8k implementation, as opposed to yours, calls dev_queue_xmit()
> with skb->dev directly on the DSA master, and forgoes the DSA tagger on
> TX. I don't see a problem with that approach, on the contrary, I think
> it's better and simpler.
> 

Yes, I agree and will rework it more in line with qca8k.

>>  	void (*flow_dissect)(const struct sk_buff *skb, __be16 *proto,
>>  			     int *offset);
>>  	int (*connect)(struct dsa_switch *ds);
>> @@ -1193,6 +1194,12 @@ struct dsa_switch_ops {
>>  	void	(*master_state_change)(struct dsa_switch *ds,
>>  				       const struct net_device *master,
>>  				       bool operational);
>> +
>> +	/*
>> +	 * RMU operations
>> +	 */
>> +	int (*inband_receive)(struct dsa_switch *ds, struct sk_buff *skb,
>> +			int seq_no);
>>  };
>>  
>>  #define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
>> diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
>> index d370165bc621..9de1bdc7cccc 100644
>> --- a/include/uapi/linux/if_ether.h
>> +++ b/include/uapi/linux/if_ether.h
>> @@ -158,6 +158,7 @@
>>  #define ETH_P_MCTP	0x00FA		/* Management component transport
>>  					 * protocol packets
>>  					 */
>> +#define ETH_P_RMU_DSA   0x00FB          /* RMU DSA protocol */
> 
> I think it's more normal to set skb->protocol = eth->h_proto = htons(the actual EtherType),
> rather than introducing a new skb->protocol which won't be used anywhere.
> 
>>  
>>  /*
>>   *	This is an Ethernet frame header.
>> diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
>> index e4b6e3f2a3db..36f02e7dd3c3 100644
>> --- a/net/dsa/tag_dsa.c
>> +++ b/net/dsa/tag_dsa.c
>> @@ -123,6 +123,90 @@ enum dsa_code {
>>  	DSA_CODE_RESERVED_7    = 7
>>  };
>>  
>> +#define DSA_RMU_RESV1   0x3e
>> +#define DSA_RMU         1
>> +#define DSA_RMU_PRIO    6
>> +#define DSA_RMU_RESV2   0xf
>> +
>> +static int dsa_inband_xmit_ll(struct sk_buff *skb, struct net_device *dev,
>> +			      const u8 *header, int header_len, int seq_no)
>> +{
>> +	static const u8 dest_addr[ETH_ALEN] = { 0x01, 0x50, 0x43, 0x00, 0x00, 0x00 };
>> +	struct dsa_port *dp;
>> +	struct ethhdr *eth;
>> +	u8 *data;
>> +
>> +	if (!dev)
>> +		return -ENODEV;
>> +
>> +	dp = dsa_slave_to_port(dev);
>> +	if (!dp)
>> +		return -ENODEV;
>> +
>> +	/* Create RMU L2 header */
>> +	data = skb_push(skb, 6);
>> +	data[0] = (DSA_CMD_FROM_CPU << 6) | dp->ds->index;
>> +	data[1] = DSA_RMU_RESV1 << 2 | DSA_RMU << 1;
>> +	data[2] = DSA_RMU_PRIO << 5 | DSA_RMU_RESV2;
>> +	data[3] = seq_no;
>> +	data[4] = 0;
>> +	data[5] = 0;
>> +
>> +	/* Add header if any */
>> +	if (header) {
>> +		data = skb_push(skb, header_len);
>> +		memcpy(data, header, header_len);
>> +	}
>> +
>> +	/* Create MAC header */
>> +	eth = (struct ethhdr *)skb_push(skb, 2 * ETH_ALEN);
>> +	memcpy(eth->h_source, dev->dev_addr, ETH_ALEN);
>> +	memcpy(eth->h_dest, dest_addr, ETH_ALEN);
>> +
>> +	skb->protocol = htons(ETH_P_RMU_DSA);
>> +
>> +	dev_queue_xmit(skb);
> 
> Just for things to be 100% clear for everyone. Per your design, we have
> dsa_inband_xmit() which gets called by the driver with a slave @dev, and
> this constructs an skb without the DSA/EDSA header. Then dev_queue_xmit()
> will invoke the ndo_start_xmit of DSA, dsa_slave_xmit(). In turn this
> will enter the tagging protocol driver a second time, through p->xmit() ->
> dsa_xmit_ll(). The second time is when the DSA/EDSA header is actually
> introduced.
> 
> This is way more complicated than it needs to be.
> 

See comment above.

>> +
>> +	return 0;
>> +}
>> +
>> +static int dsa_inband_rcv_ll(struct sk_buff *skb, struct net_device *dev)
>> +{
>> +	struct dsa_switch *ds;
>> +	int source_device;
>> +	u8 *dsa_header;
>> +	int rcv_seqno;
>> +	int ret = 0;
>> +
>> +	if (!dev || !dev->dsa_ptr)
>> +		return 0;
> 
> Way too defensive programming which wastes CPU cycles for nothing. The
> DSA rcv hook runs as an ETH_P_XDSA packet_type handler on the DSA master,
> based on eth_type_trans() which had set skb->protocol to ETH_P_XDSA
> based on the presence of dev->dsa_ptr. So yes, the DSA master is not NULL,
> and yes, the DSA master's dev->dsa_ptr is not NULL either.
> 
>> +
>> +	ds = dev->dsa_ptr->ds;
>> +	if (!ds)
>> +		return 0;
> 
> We don't have NULL pointers in cpu_dp->ds lying around. dp->ds is set by
> dsa_port_touch(), which runs earlier than dsa_master_setup() sets
> dev->dsa_ptr in such a way that we start processing RX packets.
> 
>> +
>> +	dsa_header = skb->data - 2;
> 
> Please use dsa_etype_header_pos_rx(). In fact, this pointer was already
> available in dsa_rcv_ll().
> 

I did see it, thanks.

>> +
>> +	source_device = dsa_header[0] & 0x1f;
>> +	ds = dsa_switch_find(ds->dst->index, source_device);
>> +	if (!ds) {
>> +		net_dbg_ratelimited("DSA inband: Didn't find switch with index %d", source_device);
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* Get rcv seqno */
>> +	rcv_seqno = dsa_header[3];
>> +
>> +	skb_pull(skb, DSA_HLEN);
>> +
>> +	if (ds->ops && ds->ops->inband_receive(ds, skb, rcv_seqno)) {
> 
> I think the reason why Andrew is asking you to find common aspects with
> qca8k which can be further generalized is because your proposed code is
> very ambitious, introducing a generic ds->ops->inband_receive() like this.
> 
> I personally wouldn't be so ambitious for myself. The way the qca8k
> driver and tagging protocol work together is that they set up a group of
> driver-specific function pointers, rw_reg_ack_handler and mib_autocast_handler,
> through which the switch driver connected to the tagger may subscribe as
> a consumer to the received Ethernet management packets. Whereas you are
> proposing a one-size-fits-all ds->ops->inband_receive with no effort to
> see if it fits even the single other user of this concept, qca8k.
> 
> What I would do is introduce one more case of driver-specific consumer
> of RMU packets, specific to the dsa/edsa tagger <-> mv88e6xxx driver pair.
> I'd let things sit for a while, maybe wait for a third user, then see
> how/if the prototype for consuming Ethernet management packets can be
> made generic.
> 
> But in general, we need drivers to handle non-data RX packets coming
> from the switch for all sorts of reasons. For example SJA1110 delivers
> back TX timestamps as Ethernet packets, and I wouldn't consider
> expanding ds->ops for that. This driver-specific hook mechanism
> ("tagger owned storage" as I named it) is flexible enough to allow each
> driver to respond to the needs of its hardware, without needing
> everybody else to follow suit or suffer of ops bloat because of it.
> I wouldn't rush.
> 

I'll come back with a new version to discuss.

>> +		dev_dbg_ratelimited(ds->dev, "DSA inband: error decoding packet");
>> +		ret = -EIO;
>> +	}
>> +
>> +	return ret;

