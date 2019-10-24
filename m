Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9125E3D81
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 22:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbfJXUro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 16:47:44 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46160 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbfJXUro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 16:47:44 -0400
Received: by mail-pg1-f195.google.com with SMTP id f19so5054pgn.13
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 13:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6UtVkElgUlM/zYf2z9xQ4vpWwexeLVXf3dgUkD/4jLA=;
        b=Eb3HOtWpI3HnJx2/NOGFzo4+gucLI3ndX6GG7L0sAGfQpyFn9LAwrmN/zYKRFjJPbm
         SKgRMyHwy9oBW93pJ4uHBchJEzi2leiQgNVpZwhDcdg4u2+7udzeGiUAcJ8mcBRID2tu
         LpMrRP9BOU7idXYykqoA4/vHlMf0KvagTICxEybHNTWQz6zzbcvy/lwU0xBtkyet1y2y
         rYVplIHn0+IXeeF4bKLoCfYxnhbmLZ1Y96NoXynWoVjArvFdmWUn6D8sDOoz90Jckgy9
         naARJhIqNgU9w6IxFiphdubpMMKSczfAKKm5fB3ik1uqHaRYV+FWvMhjUoi5p4BL9t8C
         1aUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6UtVkElgUlM/zYf2z9xQ4vpWwexeLVXf3dgUkD/4jLA=;
        b=CMl7qJreFqGuwegE+Jc1ucNUMG0Aqp+AM3JNECd65/WdfwLup3Hm7QeGgEVTe/p3Yx
         U1C3KtKJwiRzz165bFa3i/fEFshz0qkwMMdmnwQCtUqqT5nYH7ub62CT9rBflH2AhrjQ
         y7ISlYsBcw1eUX563DSsEk67DiXUOyBNQPLaaQ+X6FuXOApdDxsCu9IerDNCbKYUCZir
         49/iEoL25/ngjk4fBiUDeMsWKM4Ir4eVXGaC5NMOtAQ822ePahaqRKyz9F0voyKfLCFE
         MTAcSShi3sSwTCxbpe+URCCQ/zh83BwJOuY5ultePPoHZcVNv25zrT1BQx5D6RyJb50X
         brYQ==
X-Gm-Message-State: APjAAAXsefIgxpzlyxhpYCDEe9iDk7hkORklUQX2Rq62n8dipP9g4AMV
        1TZncC2B81demvw2NIrfYDs=
X-Google-Smtp-Source: APXvYqyVDcLm+8DPjs6QbnXf7PrqXL32OqjmX4F9SWz3De0w7FtBcqt11xBB6C2EMUsGzG36wYfL6A==
X-Received: by 2002:aa7:8197:: with SMTP id g23mr19682855pfi.247.1571950063370;
        Thu, 24 Oct 2019 13:47:43 -0700 (PDT)
Received: from gmail.com ([66.170.99.95])
        by smtp.gmail.com with ESMTPSA id v19sm29231245pff.46.2019.10.24.13.47.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Oct 2019 13:47:42 -0700 (PDT)
Date:   Thu, 24 Oct 2019 13:47:40 -0700
From:   William Tu <u9012063@gmail.com>
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: Re: [PATCH v2] Change in Openvswitch to support MPLS label depth of
 3 in ingress direction
Message-ID: <20191024204740.GA74879@gmail.com>
References: <1571580702-18476-1-git-send-email-martinvarghesenokia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571580702-18476-1-git-send-email-martinvarghesenokia@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 20, 2019 at 07:41:42PM +0530, Martin Varghese wrote:
> From: Martin Varghese <martin.varghese@nokia.com>
> 
> The openvswitch was supporting a MPLS label depth of 1 in the ingress
> direction though the userspace OVS supports a max depth of 3 labels.
> This change enables openvswitch module to support a max depth of
> 3 labels in the ingress.
> 

Hi Martin,
Thanks for the patch. I have one comment below.

> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> ---
> Changes in v2
>    - Moved MPLS count validation from datapath to configuration.
>    - Fixed set mpls function.
> 
>  net/openvswitch/actions.c      |  2 +-
>  net/openvswitch/flow.c         | 20 ++++++++++-----
>  net/openvswitch/flow.h         |  9 ++++---
>  net/openvswitch/flow_netlink.c | 57 +++++++++++++++++++++++++++++++++---------
>  4 files changed, 66 insertions(+), 22 deletions(-)
> 
> diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> index 3572e11..f3125d7 100644
> --- a/net/openvswitch/actions.c
> +++ b/net/openvswitch/actions.c
> @@ -199,7 +199,7 @@ static int set_mpls(struct sk_buff *skb, struct sw_flow_key *flow_key,
>  	if (err)
>  		return err;
>  
> -	flow_key->mpls.top_lse = lse;
> +	flow_key->mpls.lse[0] = lse;
>  	return 0;
>  }
>  
> diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
> index dca3b1e..c101355 100644
> --- a/net/openvswitch/flow.c
> +++ b/net/openvswitch/flow.c
> @@ -699,27 +699,35 @@ static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
>  			memset(&key->ipv4, 0, sizeof(key->ipv4));
>  		}
>  	} else if (eth_p_mpls(key->eth.type)) {
> -		size_t stack_len = MPLS_HLEN;
> +		u8 label_count = 1;
>  
> +		memset(&key->mpls, 0, sizeof(key->mpls));
>  		skb_set_inner_network_header(skb, skb->mac_len);
>  		while (1) {
>  			__be32 lse;
>  
> -			error = check_header(skb, skb->mac_len + stack_len);
> +			error = check_header(skb, skb->mac_len +
> +					     label_count * MPLS_HLEN);
>  			if (unlikely(error))
>  				return 0;
>  
>  			memcpy(&lse, skb_inner_network_header(skb), MPLS_HLEN);
>  
> -			if (stack_len == MPLS_HLEN)
> -				memcpy(&key->mpls.top_lse, &lse, MPLS_HLEN);
> +			if (label_count <= MPLS_LABEL_DEPTH)
> +				memcpy(&key->mpls.lse[label_count - 1], &lse,
> +				       MPLS_HLEN);
>  
> -			skb_set_inner_network_header(skb, skb->mac_len + stack_len);
> +			skb_set_inner_network_header(skb, skb->mac_len +
> +						     label_count * MPLS_HLEN);
>  			if (lse & htonl(MPLS_LS_S_MASK))
>  				break;
>  
> -			stack_len += MPLS_HLEN;
> +			label_count++;
>  		}
> +		if (label_count > MPLS_LABEL_DEPTH)
> +			label_count = MPLS_LABEL_DEPTH;
> +
> +		key->mpls.num_labels_mask = GENMASK(label_count - 1, 0);

>  	} else if (key->eth.type == htons(ETH_P_IPV6)) {
>  		int nh_len;             /* IPv6 Header + Extensions */
>  
> diff --git a/net/openvswitch/flow.h b/net/openvswitch/flow.h
> index 3e2cc22..d9eccbe 100644
> --- a/net/openvswitch/flow.h
> +++ b/net/openvswitch/flow.h
> @@ -30,6 +30,7 @@ enum sw_flow_mac_proto {
>  	MAC_PROTO_ETHERNET,
>  };
>  #define SW_FLOW_KEY_INVALID	0x80
> +#define MPLS_LABEL_DEPTH       3
>  
>  /* Store options at the end of the array if they are less than the
>   * maximum size. This allows us to get the benefits of variable length
> @@ -85,9 +86,6 @@ struct sw_flow_key {
>  					 */
>  	union {
>  		struct {
> -			__be32 top_lse;	/* top label stack entry */
> -		} mpls;
> -		struct {
>  			u8     proto;	/* IP protocol or lower 8 bits of ARP opcode. */
>  			u8     tos;	    /* IP ToS. */
>  			u8     ttl;	    /* IP TTL/hop limit. */
> @@ -135,6 +133,11 @@ struct sw_flow_key {
>  				} nd;
>  			};
>  		} ipv6;
> +		struct {
> +			u32 num_labels_mask;    /* labels present bitmap of effective length MPLS_LABEL_DEPTH */

Why using a bitmap here? why not just num_labels?
I saw that you have to convert it using hweight_long()
to num_labels a couple places below.

Regards,
William

> +			__be32 lse[MPLS_LABEL_DEPTH];     /* label stack entry  */
> +		} mpls;
> +
>  		struct ovs_key_nsh nsh;         /* network service header */
>  	};
>  	struct {
> diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
> index d7559c6..21de061 100644
> --- a/net/openvswitch/flow_netlink.c
> +++ b/net/openvswitch/flow_netlink.c
> @@ -424,7 +424,7 @@ size_t ovs_key_attr_size(void)
>  	[OVS_KEY_ATTR_DP_HASH]	 = { .len = sizeof(u32) },
>  	[OVS_KEY_ATTR_TUNNEL]	 = { .len = OVS_ATTR_NESTED,
>  				     .next = ovs_tunnel_key_lens, },
> -	[OVS_KEY_ATTR_MPLS]	 = { .len = sizeof(struct ovs_key_mpls) },
> +	[OVS_KEY_ATTR_MPLS]	 = { .len = OVS_ATTR_VARIABLE },
>  	[OVS_KEY_ATTR_CT_STATE]	 = { .len = sizeof(u32) },
>  	[OVS_KEY_ATTR_CT_ZONE]	 = { .len = sizeof(u16) },
>  	[OVS_KEY_ATTR_CT_MARK]	 = { .len = sizeof(u32) },
> @@ -1628,10 +1628,25 @@ static int ovs_key_from_nlattrs(struct net *net, struct sw_flow_match *match,
>  
>  	if (attrs & (1 << OVS_KEY_ATTR_MPLS)) {
>  		const struct ovs_key_mpls *mpls_key;
> +		u32 hdr_len;
> +		u32 label_count, label_count_mask, i;
>  
>  		mpls_key = nla_data(a[OVS_KEY_ATTR_MPLS]);
> -		SW_FLOW_KEY_PUT(match, mpls.top_lse,
> -				mpls_key->mpls_lse, is_mask);
> +		hdr_len = nla_len(a[OVS_KEY_ATTR_MPLS]);
> +		label_count = hdr_len / sizeof(struct ovs_key_mpls);
> +
> +		if (label_count == 0 || label_count > MPLS_LABEL_DEPTH ||
> +		    hdr_len % sizeof(struct ovs_key_mpls))
> +			return -EINVAL;
> +
> +		label_count_mask =  GENMASK(label_count - 1, 0);
> +
> +		for (i = 0 ; i < label_count; i++)
> +			SW_FLOW_KEY_PUT(match, mpls.lse[i],
> +					mpls_key[i].mpls_lse, is_mask);
> +
> +		SW_FLOW_KEY_PUT(match, mpls.num_labels_mask,
> +				label_count_mask, is_mask);
>  
>  		attrs &= ~(1 << OVS_KEY_ATTR_MPLS);
>  	 }
> @@ -2114,13 +2129,18 @@ static int __ovs_nla_put_key(const struct sw_flow_key *swkey,
>  		ether_addr_copy(arp_key->arp_sha, output->ipv4.arp.sha);
>  		ether_addr_copy(arp_key->arp_tha, output->ipv4.arp.tha);
>  	} else if (eth_p_mpls(swkey->eth.type)) {
> +		u8 i, num_labels;
>  		struct ovs_key_mpls *mpls_key;
>  
> -		nla = nla_reserve(skb, OVS_KEY_ATTR_MPLS, sizeof(*mpls_key));
> +		num_labels = hweight_long(output->mpls.num_labels_mask);
> +		nla = nla_reserve(skb, OVS_KEY_ATTR_MPLS,
> +				  num_labels * sizeof(*mpls_key));
>  		if (!nla)
>  			goto nla_put_failure;
> +
>  		mpls_key = nla_data(nla);
> -		mpls_key->mpls_lse = output->mpls.top_lse;
> +		for (i = 0; i < num_labels; i++)
> +			mpls_key[i].mpls_lse = output->mpls.lse[i];
>  	}
>  
>  	if ((swkey->eth.type == htons(ETH_P_IP) ||
> @@ -2957,6 +2977,10 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
>  	u8 mac_proto = ovs_key_mac_proto(key);
>  	const struct nlattr *a;
>  	int rem, err;
> +	u32 mpls_label_count = 0;
> +
> +	if (eth_p_mpls(eth_type))
> +		mpls_label_count = hweight_long(key->mpls.num_labels_mask);
>  
>  	nla_for_each_nested(a, attr, rem) {
>  		/* Expected argument lengths, (u32)-1 for variable length. */
> @@ -3065,25 +3089,34 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
>  			     !eth_p_mpls(eth_type)))
>  				return -EINVAL;
>  			eth_type = mpls->mpls_ethertype;
> +			mpls_label_count++;
>  			break;
>  		}
>  
> -		case OVS_ACTION_ATTR_POP_MPLS:
> +		case OVS_ACTION_ATTR_POP_MPLS: {
> +			__be16  proto;
>  			if (vlan_tci & htons(VLAN_CFI_MASK) ||
>  			    !eth_p_mpls(eth_type))
>  				return -EINVAL;
>  
> -			/* Disallow subsequent L2.5+ set and mpls_pop actions
> -			 * as there is no check here to ensure that the new
> -			 * eth_type is valid and thus set actions could
> -			 * write off the end of the packet or otherwise
> -			 * corrupt it.
> +			/* Disallow subsequent L2.5+ set actions as there is
> +			 * no check here to ensure that the new eth type is
> +			 * valid and thus set actions could write off the
> +			 * end of the packet or otherwise corrupt it.
>  			 *
>  			 * Support for these actions is planned using packet
>  			 * recirculation.
>  			 */
> -			eth_type = htons(0);
> +			proto = nla_get_be16(a);
> +			mpls_label_count--;
> +
> +			if (!eth_p_mpls(proto) || !mpls_label_count)
> +				eth_type = htons(0);
> +			else
> +				eth_type =  proto;
> +
>  			break;
> +		}
>  
>  		case OVS_ACTION_ATTR_SET:
>  			err = validate_set(a, key, sfa,
> -- 
> 1.8.3.1
> 
