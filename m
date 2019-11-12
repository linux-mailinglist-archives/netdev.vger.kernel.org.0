Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6216AF937E
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 16:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfKLPAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 10:00:52 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44506 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726953AbfKLPAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 10:00:51 -0500
Received: by mail-wr1-f65.google.com with SMTP id f2so18840586wrs.11
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 07:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5UwP7siHF7rXmwCKrvI+cVhn0JyvOeSUcSusWVJIBwM=;
        b=1x1jPWdzU7c+Yrtlase69mZpy1u6gho3J/UUk2vh8ig52gH+WlLkljzOObNK+S+gBJ
         VEhhyd/ewCJ6KEgaYKRjNnz69TjSlt2InZNzXwIAsTpRKQsWwoULr+gq+0V9k3/uaIq8
         EUvM+2YH1hv69THV/e+h0kcWdsoKE3XDovxDub7fsArXj5PiVk8kBrx8npCEReRLTdc1
         7Nq4v2E2UW7yEv+qywYF90LHWP0si+Xqalp4CO7Q8kW/Q2A3FaXQf0j/PHuLwtGjRJW6
         9+CPlluBi6DlyCyrfjQF+YPWr4L5WQHdpZ4BHEeHoFtSI2PfF43chQoUFr5KAZ7TOIYt
         AAIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5UwP7siHF7rXmwCKrvI+cVhn0JyvOeSUcSusWVJIBwM=;
        b=quXgEoG5ZRalvNN4isgPeqE56NxkLI+r0SY6yBtN8pA8mPxzWLkvLHvnDoXFh9iE9v
         SSEOJ1K5CaEP6PUE1a5gVIvuMa9ayxwHlRN3aQUhiYBZZS6WPGoOgujHyaicpndQ6MFS
         xXChYsfcHWdEVDbT1cH9ufk0U0PWeKVruhadXmLCwI0a/Jzt9IvqMSwyOf7N1hm2awND
         6gMwAqMmXDcTpDn8BRA5NSJbVOVors20eymHA6GRL6/rrDEH92E5xWemPC3i74Xx73bM
         qJqJRDmHFb9JPGxb5uJvzI3bTaa0guSlhLusjMpRdq76fX2eIn5N6ocMfRCgy1rfWu7G
         ol0g==
X-Gm-Message-State: APjAAAXjwtm1DNkZXLo+774+yULl7O9lFmPMrmCezc7C2XvhEwQYEOcW
        3nluY7AjPaBfQDhjbgLTYNnVDg==
X-Google-Smtp-Source: APXvYqzclVPnWuMSYRfa8xkYEomDe4ABUuF6Pz3Hl0PtMzAhJIz7fko6JVjkJtqri3TCQNzwuG10NQ==
X-Received: by 2002:a5d:678f:: with SMTP id v15mr24776473wru.242.1573570848873;
        Tue, 12 Nov 2019 07:00:48 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id n17sm18481152wrp.40.2019.11.12.07.00.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Nov 2019 07:00:48 -0800 (PST)
Date:   Tue, 12 Nov 2019 16:00:47 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bindiya Kurle <bindiyakurle@gmail.com>
Subject: Re: [PATCH net-next] openvswitch: add TTL decrement action
Message-ID: <20191112150046.2aehmeoq7ri6duwo@netronome.com>
References: <20191112102518.4406-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112102518.4406-1-mcroce@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 11:25:18AM +0100, Matteo Croce wrote:
> New action to decrement TTL instead of setting it to a fixed value.
> This action will decrement the TTL and, in case of expired TTL, send the
> packet to userspace via output_userspace() to take care of it.
> 
> Supports both IPv4 and IPv6 via the ttl and hop_limit fields, respectively.
> 
> Tested with a corresponding change in the userspace:
> 
>     # ovs-dpctl dump-flows
>     in_port(2),eth(),eth_type(0x0800), packets:0, bytes:0, used:never, actions:dec_ttl,1
>     in_port(1),eth(),eth_type(0x0800), packets:0, bytes:0, used:never, actions:dec_ttl,2
>     in_port(1),eth(),eth_type(0x0806), packets:0, bytes:0, used:never, actions:2
>     in_port(2),eth(),eth_type(0x0806), packets:0, bytes:0, used:never, actions:1
> 
>     # ping -c1 192.168.0.2 -t 42
>     IP (tos 0x0, ttl 41, id 61647, offset 0, flags [DF], proto ICMP (1), length 84)
>         192.168.0.1 > 192.168.0.2: ICMP echo request, id 386, seq 1, length 64
>     # ping -c1 192.168.0.2 -t 120
>     IP (tos 0x0, ttl 119, id 62070, offset 0, flags [DF], proto ICMP (1), length 84)
>         192.168.0.1 > 192.168.0.2: ICMP echo request, id 388, seq 1, length 64
>     # ping -c1 192.168.0.2 -t 1
>     #
> 
> Co-authored-by: Bindiya Kurle <bindiyakurle@gmail.com>
> Signed-off-by: Bindiya Kurle <bindiyakurle@gmail.com>
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Usually OVS achieves this behaviour by matching on the TTL and
setting it to the desired value, pre-calculated as TTL -1.
With that in mind could you explain the motivation for this
change?

> ---
>  include/uapi/linux/openvswitch.h |  2 ++
>  net/openvswitch/actions.c        | 46 ++++++++++++++++++++++++++++++++
>  net/openvswitch/flow_netlink.c   |  6 +++++
>  3 files changed, 54 insertions(+)
> 
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> index 1887a451c388..a3bdb1ecd1e7 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -890,6 +890,7 @@ struct check_pkt_len_arg {
>   * @OVS_ACTION_ATTR_CHECK_PKT_LEN: Check the packet length and execute a set
>   * of actions if greater than the specified packet length, else execute
>   * another set of actions.
> + * @OVS_ACTION_ATTR_DEC_TTL: Decrement the IP TTL.
>   *
>   * Only a single header can be set with a single %OVS_ACTION_ATTR_SET.  Not all
>   * fields within a header are modifiable, e.g. the IPv4 protocol and fragment
> @@ -925,6 +926,7 @@ enum ovs_action_attr {
>  	OVS_ACTION_ATTR_METER,        /* u32 meter ID. */
>  	OVS_ACTION_ATTR_CLONE,        /* Nested OVS_CLONE_ATTR_*.  */
>  	OVS_ACTION_ATTR_CHECK_PKT_LEN, /* Nested OVS_CHECK_PKT_LEN_ATTR_*. */
> +	OVS_ACTION_ATTR_DEC_TTL,      /* Decrement ttl action */
>  
>  	__OVS_ACTION_ATTR_MAX,	      /* Nothing past this will be accepted
>  				       * from userspace. */
> diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> index 12936c151cc0..077b7f309c93 100644
> --- a/net/openvswitch/actions.c
> +++ b/net/openvswitch/actions.c
> @@ -1174,6 +1174,43 @@ static int execute_check_pkt_len(struct datapath *dp, struct sk_buff *skb,
>  			     nla_len(actions), last, clone_flow_key);
>  }
>  
> +static int execute_dec_ttl(struct sk_buff *skb, struct sw_flow_key *key)
> +{
> +	int err;
> +
> +	if (skb->protocol == htons(ETH_P_IPV6)) {
> +		struct ipv6hdr *nh = ipv6_hdr(skb);
> +
> +		err = skb_ensure_writable(skb, skb_network_offset(skb) +
> +					  sizeof(*nh));
> +		if (unlikely(err))
> +			return err;
> +
> +		if (nh->hop_limit <= 1)
> +			return -EHOSTUNREACH;
> +
> +		key->ip.ttl = --nh->hop_limit;
> +	} else {
> +		struct iphdr *nh = ip_hdr(skb);
> +		u8 old_ttl;
> +
> +		err = skb_ensure_writable(skb, skb_network_offset(skb) +
> +					  sizeof(*nh));
> +		if (unlikely(err))
> +			return err;
> +
> +		if (nh->ttl <= 1)
> +			return -EHOSTUNREACH;
> +
> +		old_ttl = nh->ttl--;
> +		csum_replace2(&nh->check, htons(old_ttl << 8),
> +			      htons(nh->ttl << 8));
> +		key->ip.ttl = nh->ttl;
> +	}

The above may send packets with TTL = 0, is that desired?

> +
> +	return 0;
> +}
> +
>  /* Execute a list of actions against 'skb'. */
>  static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
>  			      struct sw_flow_key *key,
> @@ -1345,6 +1382,15 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
>  
>  			break;
>  		}
> +
> +		case OVS_ACTION_ATTR_DEC_TTL:
> +			err = execute_dec_ttl(skb, key);
> +			if (err == -EHOSTUNREACH) {
> +				output_userspace(dp, skb, key, a, attr,
> +						 len, OVS_CB(skb)->cutlen);
> +				OVS_CB(skb)->cutlen = 0;
> +			}
> +			break;
>  		}
>  
>  		if (unlikely(err)) {
> diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
> index 65c2e3458ff5..d17f2d4b420f 100644
> --- a/net/openvswitch/flow_netlink.c
> +++ b/net/openvswitch/flow_netlink.c
> @@ -79,6 +79,7 @@ static bool actions_may_change_flow(const struct nlattr *actions)
>  		case OVS_ACTION_ATTR_SET_MASKED:
>  		case OVS_ACTION_ATTR_METER:
>  		case OVS_ACTION_ATTR_CHECK_PKT_LEN:
> +		case OVS_ACTION_ATTR_DEC_TTL:
>  		default:
>  			return true;
>  		}
> @@ -3005,6 +3006,7 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
>  			[OVS_ACTION_ATTR_METER] = sizeof(u32),
>  			[OVS_ACTION_ATTR_CLONE] = (u32)-1,
>  			[OVS_ACTION_ATTR_CHECK_PKT_LEN] = (u32)-1,
> +			[OVS_ACTION_ATTR_DEC_TTL] = 0,
>  		};
>  		const struct ovs_action_push_vlan *vlan;
>  		int type = nla_type(a);
> @@ -3233,6 +3235,10 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
>  			break;
>  		}
>  
> +		case OVS_ACTION_ATTR_DEC_TTL:
> +			/* Nothing to do.  */
> +			break;
> +
>  		default:
>  			OVS_NLERR(log, "Unknown Action type %d", type);
>  			return -EINVAL;
> -- 
> 2.23.0
> 
