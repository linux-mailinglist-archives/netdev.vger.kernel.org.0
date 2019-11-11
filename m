Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7DB4F7489
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 14:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbfKKNHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 08:07:40 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39289 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfKKNHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 08:07:40 -0500
Received: by mail-wr1-f68.google.com with SMTP id l7so2984643wrp.6
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 05:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8D5RyHByUACLTDf+YxM/lLJKAl5xVjctGwF16QtQ67o=;
        b=pRg1SnpsOwO8+LKszb5bWojvVtMO8n7Ps6LEDfJtTbZqhi3VDAXfcgjsIeX1nsk0CN
         umCuZqF9z1u4Oq5zGAZzk7UuBwV+5j1+zigxs7hDpB7m+YaBEYeH2xEyR3ucqdDwQS1P
         mb4LeboOHD7V7HrjXOM9v4U6Z3NTIbMZef//FovwIXpeA42CrDWe74tmMXGdvTzt1IDr
         CcYuC0b7rcpj/FcKDqWTwPQe2rXdK1eaAivU5DED7ErER6vUJjmhbmWUeJcB7VEWkqi0
         vEFLgMXvUKOmECljsk0YoCeQmpyrPolQceArlOKYYpzgW8fgzF54ruqY9odlfLjMPSgY
         jojQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8D5RyHByUACLTDf+YxM/lLJKAl5xVjctGwF16QtQ67o=;
        b=LDFUaYzarEX2x+i0DMn5HuflbhKVkgyIU5rM4HEnHsBZeNvgBElX/yYywdc2eR0zGi
         xm2P8pLnK8V2dF1qTaYIfwthWnWotcozexYzCr4xtnEf6ORWHjPtgz2zw4B9cjNIahA2
         XD1Sk8bd+yhLDVh8hgiy+asxvAAv5moMue0hc5O4JTbvyT1xhJzjey/A+y+nCetZ536X
         5BQAOL7cHJRWlOMRsRPVATCDqE9Bil+LSa4Xwmy63ENINnUUpSulWJwXHVQzuQlkAO4H
         20cWTDndbT0mmykFc7T1KcHeL4wpeFkikvLzQzlsbjgZz2dkERqCtn9XYeS226nE8QBk
         IznA==
X-Gm-Message-State: APjAAAXFHSBx+OEoWe1T0vmxv687wAG4/Ru11BN0ZtjhRBVuKh8am3aM
        oyHD6kWGA4ENvodsFeyO5NnSvY62Sg0=
X-Google-Smtp-Source: APXvYqzK5qoHOuNCMxrBLvaheTTqAmfQg813+/KJsQ+cE5Wre0Iliy5nuoXTWyzVpFUEhIvBFvO9oQ==
X-Received: by 2002:a5d:4a45:: with SMTP id v5mr22279758wrs.288.1573477657445;
        Mon, 11 Nov 2019 05:07:37 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id j67sm19610067wmb.43.2019.11.11.05.07.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Nov 2019 05:07:37 -0800 (PST)
Date:   Mon, 11 Nov 2019 14:07:36 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     xiangxia.m.yue@gmail.com
Cc:     pshelar@ovn.org, blp@ovn.org, netdev@vger.kernel.org,
        dev@openvswitch.org, ychen103103@163.com
Subject: Re: [PATCH net-next] net: openvswitch: add hash info to upcall
Message-ID: <20191111130736.pyicdoc7x55fqosq@netronome.com>
References: <1573386258-35040-1-git-send-email-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573386258-35040-1-git-send-email-xiangxia.m.yue@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 07:44:18PM +0800, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> When using the kernel datapath, the upcall don't
> add skb hash info relatived. That will introduce
> some problem, because the hash of skb is very
> important (e.g. vxlan module uses it for udp src port,
> tx queue selection on tx path.).
> 
> For example, there will be one upcall, without information
> skb hash, to ovs-vswitchd, for the first packet of one tcp
> session. When kernel sents the tcp packets, the hash is
> random for a tcp socket:
> 
> tcp_v4_connect
>   -> sk_set_txhash (is random)
> 
> __tcp_transmit_skb
>   -> skb_set_hash_from_sk
> 
> Then the udp src port of first tcp packet is different
> from rest packets. The topo is shown.
> 
> $ ovs-vsctl add-br br-int
> $ ovs-vsctl add-port br-int vxl0 -- \
> 		set Interface vxl0 type=vxlan options:key=100 options:remote_ip=1.1.1.200
> 
> $ __tap is internal type on host
> $ or tap net device for VM/Dockers
> $ ovs-vsctl add-port br-int __tap
> 
> +---------------+          +-------------------------+
> |   Docker/VMs  |          |     ovs-vswitchd        |
> +----+----------+          +-------------------------+
>      |                       ^                    |
>      |                       |                    |
>      |                       |  upcall            v recalculate packet hash
>      |                     +-+--------------------+--+
>      |  tap netdev         |                         |   vxlan modules
>      +--------------->     +-->  Open vSwitch ko   --+--->
>        internal type       |                         |
>                            +-------------------------+

I think I see the problem that you are trying to solve, but this approach
feels wrong to me. In my view the HASH is transparent to components
outside of the datapath (in this case the Open vSwitch ko box).

For one thing, with this change ovs-vswitchd can now supply any hash
value it likes.

Is it not possible to fix things so that "recalculate packet hash"
in fact recalculates the same hash value as was calculated before
the upcall?

> 
> Reported-at: https://mail.openvswitch.org/pipermail/ovs-dev/2019-October/364062.html
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  include/uapi/linux/openvswitch.h |  2 ++
>  net/openvswitch/datapath.c       | 31 ++++++++++++++++++++++++++++++-
>  net/openvswitch/datapath.h       |  3 +++
>  3 files changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> index 1887a451c388..1c58e019438e 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -170,6 +170,7 @@ enum ovs_packet_cmd {
>   * output port is actually a tunnel port. Contains the output tunnel key
>   * extracted from the packet as nested %OVS_TUNNEL_KEY_ATTR_* attributes.
>   * @OVS_PACKET_ATTR_MRU: Present for an %OVS_PACKET_CMD_ACTION and
> + * @OVS_PACKET_ATTR_HASH: Packet hash info (e.g. hash, sw_hash and l4_hash in skb)
>   * @OVS_PACKET_ATTR_LEN: Packet size before truncation.
>   * %OVS_PACKET_ATTR_USERSPACE action specify the Maximum received fragment
>   * size.
> @@ -190,6 +191,7 @@ enum ovs_packet_attr {
>  	OVS_PACKET_ATTR_PROBE,      /* Packet operation is a feature probe,
>  				       error logging should be suppressed. */
>  	OVS_PACKET_ATTR_MRU,	    /* Maximum received IP fragment size. */
> +	OVS_PACKET_ATTR_HASH,	    /* Packet hash. */
>  	OVS_PACKET_ATTR_LEN,		/* Packet size before truncation. */
>  	__OVS_PACKET_ATTR_MAX
>  };
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index 2088619c03f0..f938c43e3085 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -350,7 +350,8 @@ static size_t upcall_msg_size(const struct dp_upcall_info *upcall_info,
>  	size_t size = NLMSG_ALIGN(sizeof(struct ovs_header))
>  		+ nla_total_size(hdrlen) /* OVS_PACKET_ATTR_PACKET */
>  		+ nla_total_size(ovs_key_attr_size()) /* OVS_PACKET_ATTR_KEY */
> -		+ nla_total_size(sizeof(unsigned int)); /* OVS_PACKET_ATTR_LEN */
> +		+ nla_total_size(sizeof(unsigned int)) /* OVS_PACKET_ATTR_LEN */
> +		+ nla_total_size(sizeof(u64)); /* OVS_PACKET_ATTR_HASH */
>  
>  	/* OVS_PACKET_ATTR_USERDATA */
>  	if (upcall_info->userdata)
> @@ -393,6 +394,7 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
>  	size_t len;
>  	unsigned int hlen;
>  	int err, dp_ifindex;
> +	u64 hash;
>  
>  	dp_ifindex = get_dpifindex(dp);
>  	if (!dp_ifindex)
> @@ -504,6 +506,24 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
>  		pad_packet(dp, user_skb);
>  	}
>  
> +	if (skb_get_hash_raw(skb)) {
> +		hash = skb_get_hash_raw(skb);
> +
> +		if (skb->sw_hash)
> +			hash |= OVS_PACKET_HASH_SW;
> +
> +		if (skb->l4_hash)
> +			hash |= OVS_PACKET_HASH_L4;
> +
> +		if (nla_put(user_skb, OVS_PACKET_ATTR_HASH,
> +			    sizeof (u64), &hash)) {
> +			err = -ENOBUFS;
> +			goto out;
> +		}
> +
> +		pad_packet(dp, user_skb);
> +	}
> +
>  	/* Only reserve room for attribute header, packet data is added
>  	 * in skb_zerocopy() */
>  	if (!(nla = nla_reserve(user_skb, OVS_PACKET_ATTR_PACKET, 0))) {
> @@ -543,6 +563,7 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
>  	struct datapath *dp;
>  	struct vport *input_vport;
>  	u16 mru = 0;
> +	u64 hash;
>  	int len;
>  	int err;
>  	bool log = !a[OVS_PACKET_ATTR_PROBE];
> @@ -568,6 +589,14 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
>  	}
>  	OVS_CB(packet)->mru = mru;
>  
> +	if (a[OVS_PACKET_ATTR_HASH]) {
> +		hash = nla_get_u64(a[OVS_PACKET_ATTR_HASH]);
> +
> +		__skb_set_hash(packet, hash & 0xFFFFFFFFUL,
> +			       !!(hash & OVS_PACKET_HASH_SW),
> +			       !!(hash & OVS_PACKET_HASH_L4));
> +	}
> +
>  	/* Build an sw_flow for sending this packet. */
>  	flow = ovs_flow_alloc();
>  	err = PTR_ERR(flow);
> diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
> index 81e85dde8217..ba89a08647ac 100644
> --- a/net/openvswitch/datapath.h
> +++ b/net/openvswitch/datapath.h
> @@ -248,3 +248,6 @@ do {								\
>  		pr_info("netlink: " fmt "\n", ##__VA_ARGS__);	\
>  } while (0)
>  #endif /* datapath.h */
> +
> +#define OVS_PACKET_HASH_SW	(1ULL << 32)
> +#define OVS_PACKET_HASH_L4	(1ULL << 33)

I think that BIT macro is appropriate here.

> -- 
> 2.23.0
> 
