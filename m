Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC80391A4B
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 16:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbhEZOfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 10:35:18 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:18264 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234669AbhEZOfR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 10:35:17 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622039625; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=cx/TUEyNqXeSLp9UoQnngGKYMbwq8P/Op8uX0hLOxm4=;
 b=s2HGEurqjFarNDfAh0L4YdQylMKAQYnimAZ5bWSuJxfZZANpiO+cWS3K8JWnw1TbQkgDjCa8
 je6KVMlX7oom9J23fcWHz4hkrB7VzO3UtBbVdNKIH3DDqPIqjrWnGbs+iUywbvoZ8epR8d16
 Adu8EIH8TGCvJ73StPadmRJnAJk=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 60ae5c49b15734c8f9812006 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 26 May 2021 14:33:44
 GMT
Sender: sharathv=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 45B3CC4360C; Wed, 26 May 2021 14:33:44 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: sharathv)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A64EDC433D3;
        Wed, 26 May 2021 14:33:42 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 26 May 2021 20:03:42 +0530
From:   sharathv@codeaurora.org
To:     Alex Elder <elder@ieee.org>
Cc:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5 3/3] net: ethernet: rmnet: Add support for
 MAPv5 egress packets
In-Reply-To: <67955e34-d1e1-f73a-8f21-938976d9f34b@ieee.org>
References:  <stranche@codeaurora.org linux-doc@vger.kernel.org
 corbet@lwn.net> <1619180343-3943-1-git-send-email-sharathv@codeaurora.org>
 <1619180343-3943-4-git-send-email-sharathv@codeaurora.org>
 <67955e34-d1e1-f73a-8f21-938976d9f34b@ieee.org>
Message-ID: <c4a6c20eab0818de4457bb0e4ca3bcd6@codeaurora.org>
X-Sender: sharathv@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-04-23 18:18, Alex Elder wrote:
> On 4/23/21 7:19 AM, Sharath Chandra Vurukala wrote:
>> Adding Support for MAPv5 egress packets.
>> Based on the configuration Request HW for csum offload
>> by setting the csum_valid_required of Mapv5 packet.
> 
> Please try to re-word this description.  I'm not sure
> I understand what it means.
> 
> I see what I think is a bug below.  Please either
> fix or explain.
> 
>> Acked-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
>> Acked-by: Alex Elder <elder@linaro.org>
> 
> I did not acknowledge this patch.
> 

I will rewrite the description with more details and clear wordings. 
Thanks.


>> Signed-off-by: Sharath Chandra Vurukala <sharathv@codeaurora.org>
>> ---
>>   drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h |  4 +-
>>   .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   | 14 +++-
>>   drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    |  8 +-
>>   .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   | 93 
>> ++++++++++++++++++++--
>>   drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c    |  3 +-
>>   include/uapi/linux/if_link.h                       |  1 +
>>   6 files changed, 109 insertions(+), 14 deletions(-)
>> 
>> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h 
>> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
>> index 8d8d469..8e64ca9 100644
>> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
>> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
>> @@ -1,5 +1,6 @@
>>   /* SPDX-License-Identifier: GPL-2.0-only */
>> -/* Copyright (c) 2013-2014, 2016-2018 The Linux Foundation. All 
>> rights reserved.
>> +/* Copyright (c) 2013-2014, 2016-2018, 2021 The Linux Foundation.
>> + * All rights reserved.
>>    *
>>    * RMNET Data configuration engine
>>    */
>> @@ -56,6 +57,7 @@ struct rmnet_priv_stats {
>>   	u64 csum_fragmented_pkt;
>>   	u64 csum_skipped;
>>   	u64 csum_sw;
>> +	u64 csum_hw;
> 
> Why is this new statistic type added?  Would it be
> meaningful to use before--with only QMAPv4?  Or is
> there something different about QMAPv5 (inline) checksum
> offload that makes this necessary or desirable?
> 
> This is something new that ought to be at least
> mentioned in the description at the top.  And for
> future reference, this could likely have been
> defined in a separate patch, before this one.
> 

Will update the description with details about this stat.

>>   };
>>     struct rmnet_priv {
>> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c 
>> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
>> index 706a225..51a2e94 100644
>> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
>> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
>> @@ -133,7 +133,7 @@ static int rmnet_map_egress_handler(struct sk_buff 
>> *skb,
>>   				    struct rmnet_port *port, u8 mux_id,
>>   				    struct net_device *orig_dev)
>>   {
>> -	int required_headroom, additional_header_len;
>> +	int required_headroom, additional_header_len, csum_type = 0;
>>   	struct rmnet_map_header *map_header;
>>     	additional_header_len = 0;
>> @@ -142,6 +142,10 @@ static int rmnet_map_egress_handler(struct 
>> sk_buff *skb,
>>   	if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV4) {
>>   		additional_header_len = sizeof(struct rmnet_map_ul_csum_header);
>>   		required_headroom += additional_header_len;
>> +		csum_type = RMNET_FLAGS_EGRESS_MAP_CKSUMV4;
>> +	} else if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV5) {
>> +		additional_header_len = sizeof(struct rmnet_map_v5_csum_header);
>> +		csum_type = RMNET_FLAGS_EGRESS_MAP_CKSUMV5;
>>   	}
> 
> Does additional_header_len need to be added to required_headroom,
> as it is for QMAPv4 above?
> 
> If so, this is a bug and must be fixed.
> 
> What I tested last week (and verified work for IPA v3.5.1 and
> IPA v4.2) looked like this:
> 
>     if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV4) {
>         additional_header_len = sizeof(struct 
> rmnet_map_ul_csum_header);
>         csum_type = RMNET_FLAGS_EGRESS_MAP_CKSUMV4;
>     } else if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV5) {
>         additional_header_len = sizeof(struct 
> rmnet_map_v5_csum_header);
>         csum_type = RMNET_FLAGS_EGRESS_MAP_CKSUMV5;
>     }
>     required_headroom += additional_header_len;
> 
> 					-Alex
> 

Thanks a lot in identifying the bug, I messed up with the patches before 
raising them for review.
Will share the corrected version in subsequent patch.

>>   	if (skb_headroom(skb) < required_headroom) {
>> @@ -149,10 +153,12 @@ static int rmnet_map_egress_handler(struct 
>> sk_buff *skb,
>>   			return -ENOMEM;
>>   	}
>>   -	if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV4)
>> -		rmnet_map_checksum_uplink_packet(skb, orig_dev);
>> +	if (csum_type)
>> +		rmnet_map_checksum_uplink_packet(skb, port, orig_dev,
>> +						 csum_type);
>>   -	map_header = rmnet_map_add_map_header(skb, additional_header_len, 
>> 0);
>> +	map_header = rmnet_map_add_map_header(skb, additional_header_len,
>> +					      port, 0);
>>   	if (!map_header)
>>   		return -ENOMEM;
>>   diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h 
>> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
>> index 1a399bf..e5a0b38 100644
>> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
>> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
>> @@ -43,11 +43,15 @@ enum rmnet_map_commands {
>>   struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
>>   				      struct rmnet_port *port);
>>   struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff 
>> *skb,
>> -						  int hdrlen, int pad);
>> +						  int hdrlen,
>> +						  struct rmnet_port *port,
>> +						  int pad);
>>   void rmnet_map_command(struct sk_buff *skb, struct rmnet_port 
>> *port);
>>   int rmnet_map_checksum_downlink_packet(struct sk_buff *skb, u16 
>> len);
>>   void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
>> -				      struct net_device *orig_dev);
>> +				      struct rmnet_port *port,
>> +				      struct net_device *orig_dev,
>> +				      int csum_type);
>>   int rmnet_map_process_next_hdr_packet(struct sk_buff *skb, u16 len);
>>     #endif /* _RMNET_MAP_H_ */
>> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c 
>> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
>> index 43813cf..339d964 100644
>> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
>> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
>> @@ -12,6 +12,7 @@
>>   #include "rmnet_config.h"
>>   #include "rmnet_map.h"
>>   #include "rmnet_private.h"
>> +#include <linux/bitfield.h>
>>     #define RMNET_MAP_DEAGGR_SPACING  64
>>   #define RMNET_MAP_DEAGGR_HEADROOM (RMNET_MAP_DEAGGR_SPACING / 2)
>> @@ -251,12 +252,69 @@ rmnet_map_ipv6_ul_csum_header(void *ip6hdr,
>>   }
>>   #endif
>>   +static void rmnet_map_v5_checksum_uplink_packet(struct sk_buff 
>> *skb,
>> +						struct rmnet_port *port,
>> +						struct net_device *orig_dev)
>> +{
>> +	struct rmnet_priv *priv = netdev_priv(orig_dev);
>> +	struct rmnet_map_v5_csum_header *ul_header;
>> +
>> +	if (!(port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV5))
>> +		return;
>> +
>> +	ul_header = skb_push(skb, sizeof(*ul_header));
>> +	memset(ul_header, 0, sizeof(*ul_header));
>> +	ul_header->header_info = RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD <<
>> +					MAPV5_HDRINFO_HDR_TYPE_SHIFT;
>> +
>> +	if (skb->ip_summed == CHECKSUM_PARTIAL) {
>> +		void *iph = (char *)ul_header + sizeof(*ul_header);
>> +		__sum16 *check;
>> +		void *trans;
>> +		u8 proto;
>> +
>> +		if (skb->protocol == htons(ETH_P_IP)) {
>> +			u16 ip_len = ((struct iphdr *)iph)->ihl * 4;
>> +
>> +			proto = ((struct iphdr *)iph)->protocol;
>> +			trans = iph + ip_len;
>> +		} else if (skb->protocol == htons(ETH_P_IPV6)) {
>> +#if IS_ENABLED(CONFIG_IPV6)
>> +			u16 ip_len = sizeof(struct ipv6hdr);
>> +
>> +			proto = ((struct ipv6hdr *)iph)->nexthdr;
>> +			trans = iph + ip_len;
>> +#else
>> +			priv->stats.csum_err_invalid_ip_version++;
>> +			goto sw_csum;
>> +#endif /* CONFIG_IPV6 */
>> +		} else {
>> +			priv->stats.csum_err_invalid_ip_version++;
>> +			goto sw_csum;
>> +		}
>> +
>> +		check = rmnet_map_get_csum_field(proto, trans);
>> +		if (check) {
>> +			skb->ip_summed = CHECKSUM_NONE;
>> +			/* Ask for checksum offloading */
>> +			ul_header->csum_info |= MAPV5_CSUMINFO_VALID_FLAG;
>> +			priv->stats.csum_hw++;
>> +			return;
>> +		}
>> +	}
>> +
>> +sw_csum:
>> +	priv->stats.csum_sw++;
>> +}
>> +
>>   /* Adds MAP header to front of skb->data
>>    * Padding is calculated and set appropriately in MAP header. Mux ID 
>> is
>>    * initialized to 0.
>>    */
>>   struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff 
>> *skb,
>> -						  int hdrlen, int pad)
>> +						  int hdrlen,
>> +						  struct rmnet_port *port,
>> +						  int pad)
>>   {
>>   	struct rmnet_map_header *map_header;
>>   	u32 padding, map_datalen;
>> @@ -267,6 +325,10 @@ struct rmnet_map_header 
>> *rmnet_map_add_map_header(struct sk_buff *skb,
>>   			skb_push(skb, sizeof(struct rmnet_map_header));
>>   	memset(map_header, 0, sizeof(struct rmnet_map_header));
>>   +	/* Set next_hdr bit for csum offload packets */
>> +	if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV5)
>> +		map_header->flags |= MAP_NEXT_HEADER_FLAG;
>> +
>>   	if (pad == RMNET_MAP_NO_PAD_BYTES) {
>>   		map_header->pkt_len = htons(map_datalen);
>>   		return map_header;
>> @@ -394,11 +456,8 @@ int rmnet_map_checksum_downlink_packet(struct 
>> sk_buff *skb, u16 len)
>>   	return 0;
>>   }
>>   -/* Generates UL checksum meta info header for IPv4 and IPv6 over 
>> TCP and UDP
>> - * packets that are supported for UL checksum offload.
>> - */
>> -void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
>> -				      struct net_device *orig_dev)
>> +static void rmnet_map_v4_checksum_uplink_packet(struct sk_buff *skb,
>> +						struct net_device *orig_dev)
>>   {
>>   	struct rmnet_priv *priv = netdev_priv(orig_dev);
>>   	struct rmnet_map_ul_csum_header *ul_header;
>> @@ -417,10 +476,12 @@ void rmnet_map_checksum_uplink_packet(struct 
>> sk_buff *skb,
>>     		if (skb->protocol == htons(ETH_P_IP)) {
>>   			rmnet_map_ipv4_ul_csum_header(iphdr, ul_header, skb);
>> +			priv->stats.csum_hw++;
>>   			return;
>>   		} else if (skb->protocol == htons(ETH_P_IPV6)) {
>>   #if IS_ENABLED(CONFIG_IPV6)
>>   			rmnet_map_ipv6_ul_csum_header(iphdr, ul_header, skb);
>> +			priv->stats.csum_hw++;
>>   			return;
>>   #else
>>   			priv->stats.csum_err_invalid_ip_version++;
>> @@ -437,6 +498,26 @@ void rmnet_map_checksum_uplink_packet(struct 
>> sk_buff *skb,
>>   	priv->stats.csum_sw++;
>>   }
>>   +/* Generates UL checksum meta info header for IPv4 and IPv6 over 
>> TCP and UDP
>> + * packets that are supported for UL checksum offload.
>> + */
>> +void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
>> +				      struct rmnet_port *port,
>> +				      struct net_device *orig_dev,
>> +				      int csum_type)
>> +{
>> +	switch (csum_type) {
>> +	case RMNET_FLAGS_EGRESS_MAP_CKSUMV4:
>> +		rmnet_map_v4_checksum_uplink_packet(skb, orig_dev);
>> +		break;
>> +	case RMNET_FLAGS_EGRESS_MAP_CKSUMV5:
>> +		rmnet_map_v5_checksum_uplink_packet(skb, port, orig_dev);
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +}
>> +
>>   /* Process a MAPv5 packet header */
>>   int rmnet_map_process_next_hdr_packet(struct sk_buff *skb,
>>   				      u16 len)
>> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c 
>> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
>> index 41fbd2c..bc6d6ac 100644
>> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
>> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
>> @@ -174,6 +174,7 @@ static const char 
>> rmnet_gstrings_stats[][ETH_GSTRING_LEN] = {
>>   	"Checksum skipped on ip fragment",
>>   	"Checksum skipped",
>>   	"Checksum computed in software",
>> +	"Checksum computed in hardware",
>>   };
>>     static void rmnet_get_strings(struct net_device *dev, u32 
>> stringset, u8 *buf)
>> @@ -354,4 +355,4 @@ int rmnet_vnd_update_dev_mtu(struct rmnet_port 
>> *port,
>>   	}
>>     	return 0;
>> -}
>> \ No newline at end of file
>> +}
>> diff --git a/include/uapi/linux/if_link.h 
>> b/include/uapi/linux/if_link.h
>> index 21529b3..1691f3a 100644
>> --- a/include/uapi/linux/if_link.h
>> +++ b/include/uapi/linux/if_link.h
>> @@ -1236,6 +1236,7 @@ enum {
>>   #define RMNET_FLAGS_INGRESS_MAP_CKSUMV4           (1U << 2)
>>   #define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
>>   #define RMNET_FLAGS_INGRESS_MAP_CKSUMV5           (1U << 4)
>> +#define RMNET_FLAGS_EGRESS_MAP_CKSUMV5            (1U << 5)
>>     enum {
>>   	IFLA_RMNET_UNSPEC,
>> 
