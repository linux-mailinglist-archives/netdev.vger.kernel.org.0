Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8C932F4BE
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 21:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhCEUsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 15:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhCEUsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 15:48:07 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9BFC06175F
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 12:48:07 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id c10so3215878ilo.8
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 12:48:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SvNmRuIoqt9yBGKC87aP7RKIfOjztdCj2S+d/4PaE5Q=;
        b=MuQqzBoUK+hIP0ksd28r5AlKjrdqtbYn8/9W/EIbbvpVbs0bqyP9dZhN/XaSz+KB+3
         SHLg4NL1VMdz8EPd2IGVF8R7DZ62FkaCse5NBzAfIrNOTsF1FTQc/j5jRIvXMabEE5I3
         4C7alXAaC1qlDeGkDy7yZVLOJQtyfDRwWujCLE4ldVhF8hLuQqpK74eVOv4LZno+VqBL
         i5puK+sJ+8Jb9mx5LTOYMUH1CQhxW24xVarBHmE17QQW7Az1Bjm5QGvhQKXhfXfzksEq
         ktYPs9I0zUGWBD85NW1EVfxOTLQ9SjTdjI39yjz2slyNe+3zDyNx+5wsX108AHr45IEg
         5A4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SvNmRuIoqt9yBGKC87aP7RKIfOjztdCj2S+d/4PaE5Q=;
        b=BxXmnj948plzSFEvCo4xxlWR0B1puHEPE5uwycSmMwKnRqn4mf/HjRwZnLrI1sy5d0
         x97NC1MeS/gi32OXLh3yh6pDW0ciGVyYeCFcnEH7PyyTa7ZGxB/rRoevLM+5VjKcE50p
         XNyiMRzyzLPjLm60+kO79o7vq/2ie5x55qc/kzccqxki2/aLI+gVXTCLi5Df+dYJboyN
         mLySBctHwuJt//UXJThqXlfc3++hKXju9O4bJAZQExTSKUecyGdSy/0H8Rl4VzSl+rH5
         8ZWCAovAJVhfwKLiJzvtE25vMcJ3pD42gsJUifjxmSx+fxFeGm3kK3Kf2x9s0gX1cOc+
         mDLg==
X-Gm-Message-State: AOAM533P+dOiFVb8xxRoCSP/K9t83N+6fsUbPNI//BFd7D8nLZkSukSU
        vwk9D+iXBtCMkCJ/LW290/i84w==
X-Google-Smtp-Source: ABdhPJx2qCd+aPJw6CAChPDeDCAvEcbcPDWYDWCH1KBtuwtoM7H9ruwefiFwzX7g9T+0CEYLCNiIwA==
X-Received: by 2002:a92:194c:: with SMTP id e12mr10468416ilm.292.1614977286822;
        Fri, 05 Mar 2021 12:48:06 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id k14sm1725564iob.34.2021.03.05.12.48.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 12:48:06 -0800 (PST)
Subject: Re: [PATCH net-next 6/6] net: qualcomm: rmnet: don't use C bit-fields
 in rmnet checksum header
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, sharathv@codeaurora.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210304223431.15045-1-elder@linaro.org>
 <20210304223431.15045-7-elder@linaro.org> <YEHBANdYaI+Meb7t@builder.lan>
From:   Alex Elder <elder@linaro.org>
Message-ID: <59b7dd84-5115-81e1-f4a4-5cab6466544f@linaro.org>
Date:   Fri, 5 Mar 2021 14:48:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YEHBANdYaI+Meb7t@builder.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/21 11:26 PM, Bjorn Andersson wrote:
> On Thu 04 Mar 16:34 CST 2021, Alex Elder wrote:
> 
>> Replace the use of C bit-fields in the rmnet_map_ul_csum_header
>> structure with a single two-byte (big endian) structure member,
>> and use field masks to encode or get values within it.
>>
>> Previously rmnet_map_ipv4_ul_csum_header() would update values in
>> the host byte-order fields, and then forcibly fix their byte order
>> using a combination of byte order operations and types.
>>
>> Instead, just compute the value that needs to go into the new
>> structure member and save it with a simple byte-order conversion.
>>
>> Make similar simplifications in rmnet_map_ipv6_ul_csum_header().
>>
>> Finally, in rmnet_map_checksum_uplink_packet() a set of assignments
>> zeroes every field in the upload checksum header.  Replace that with
>> a single memset() operation.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>   .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 34 ++++++-------------
>>   include/linux/if_rmnet.h                      | 21 ++++++------
>>   2 files changed, 21 insertions(+), 34 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
>> index 29d485b868a65..db76bbf000aa1 100644
>> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
>> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
>> @@ -198,23 +198,19 @@ rmnet_map_ipv4_ul_csum_header(void *iphdr,
>>   			      struct rmnet_map_ul_csum_header *ul_header,
>>   			      struct sk_buff *skb)
>>   {
>> -	__be16 *hdr = (__be16 *)ul_header;
>>   	struct iphdr *ip4h = iphdr;
>>   	u16 offset;
>> +	u16 val;
>>   
>>   	offset = skb_transport_header(skb) - (unsigned char *)iphdr;
>>   	ul_header->csum_start_offset = htons(offset);
>>   
>> -	ul_header->csum_insert_offset = skb->csum_offset;
>> -	ul_header->csum_enabled = 1;
>> +	val = be16_encode_bits(1, MAP_CSUM_UL_ENABLED_FMASK);
> 
> Why are you using be16_ here? Won't that cancel the htons() below?

Yes.  This was a mistake, and as you know, the kernel test
robot caught the problem with assigning a big endian value
to a host byte order variable.  This cannot have worked
before and I'm not sure what happened.

I've updated this series and am re-testing everything.  That
includes running the patches through sparse, but also includes
running with checksum offload enabled and verifying errors
are not reported when checksum offload active.

					-Alex

> Regards,
> Bjorn
> 
>>   	if (ip4h->protocol == IPPROTO_UDP)
>> -		ul_header->udp_ind = 1;
>> -	else
>> -		ul_header->udp_ind = 0;
>> +		val |= be16_encode_bits(1, MAP_CSUM_UL_UDP_FMASK);
>> +	val |= be16_encode_bits(skb->csum_offset, MAP_CSUM_UL_OFFSET_FMASK);
>>   
>> -	/* Changing remaining fields to network order */
>> -	hdr++;
>> -	*hdr = htons((__force u16)*hdr);
>> +	ul_header->csum_info = htons(val);
>>   
>>   	skb->ip_summed = CHECKSUM_NONE;
>>   
>> @@ -241,24 +237,19 @@ rmnet_map_ipv6_ul_csum_header(void *ip6hdr,
>>   			      struct rmnet_map_ul_csum_header *ul_header,
>>   			      struct sk_buff *skb)
>>   {
>> -	__be16 *hdr = (__be16 *)ul_header;
>>   	struct ipv6hdr *ip6h = ip6hdr;
>>   	u16 offset;
>> +	u16 val;
>>   
>>   	offset = skb_transport_header(skb) - (unsigned char *)ip6hdr;
>>   	ul_header->csum_start_offset = htons(offset);
>>   
>> -	ul_header->csum_insert_offset = skb->csum_offset;
>> -	ul_header->csum_enabled = 1;
>> -
>> +	val = be16_encode_bits(1, MAP_CSUM_UL_ENABLED_FMASK);
>>   	if (ip6h->nexthdr == IPPROTO_UDP)
>> -		ul_header->udp_ind = 1;
>> -	else
>> -		ul_header->udp_ind = 0;
>> +		val |= be16_encode_bits(1, MAP_CSUM_UL_UDP_FMASK);
>> +	val |= be16_encode_bits(skb->csum_offset, MAP_CSUM_UL_OFFSET_FMASK);
>>   
>> -	/* Changing remaining fields to network order */
>> -	hdr++;
>> -	*hdr = htons((__force u16)*hdr);
>> +	ul_header->csum_info = htons(val);
>>   
>>   	skb->ip_summed = CHECKSUM_NONE;
>>   
>> @@ -425,10 +416,7 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
>>   	}
>>   
>>   sw_csum:
>> -	ul_header->csum_start_offset = 0;
>> -	ul_header->csum_insert_offset = 0;
>> -	ul_header->csum_enabled = 0;
>> -	ul_header->udp_ind = 0;
>> +	memset(ul_header, 0, sizeof(*ul_header));
>>   
>>   	priv->stats.csum_sw++;
>>   }
>> diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
>> index 1fbb7531238b6..149d696feb520 100644
>> --- a/include/linux/if_rmnet.h
>> +++ b/include/linux/if_rmnet.h
>> @@ -33,17 +33,16 @@ struct rmnet_map_dl_csum_trailer {
>>   
>>   struct rmnet_map_ul_csum_header {
>>   	__be16 csum_start_offset;
>> -#if defined(__LITTLE_ENDIAN_BITFIELD)
>> -	u16 csum_insert_offset:14;
>> -	u16 udp_ind:1;
>> -	u16 csum_enabled:1;
>> -#elif defined (__BIG_ENDIAN_BITFIELD)
>> -	u16 csum_enabled:1;
>> -	u16 udp_ind:1;
>> -	u16 csum_insert_offset:14;
>> -#else
>> -#error	"Please fix <asm/byteorder.h>"
>> -#endif
>> +	__be16 csum_info;		/* MAP_CSUM_UL_*_FMASK */
>>   } __aligned(1);
>>   
>> +/* csum_info field:
>> + *  ENABLED:	1 = checksum computation requested
>> + *  UDP:	1 = UDP checksum (zero checkum means no checksum)
>> + *  OFFSET:	where (offset in bytes) to insert computed checksum
>> + */
>> +#define MAP_CSUM_UL_OFFSET_FMASK	GENMASK(13, 0)
>> +#define MAP_CSUM_UL_UDP_FMASK		GENMASK(14, 14)
>> +#define MAP_CSUM_UL_ENABLED_FMASK	GENMASK(15, 15)
>> +
>>   #endif /* !(_LINUX_IF_RMNET_H_) */
>> -- 
>> 2.20.1
>>

