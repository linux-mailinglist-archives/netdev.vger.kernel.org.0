Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E8D50001A
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 22:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237509AbiDMUnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 16:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbiDMUnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 16:43:24 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6022D2529D;
        Wed, 13 Apr 2022 13:41:02 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id q3so2950585plg.3;
        Wed, 13 Apr 2022 13:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IUPk0cjP+4hWCuB6avcV0cHzsw30NHswIq8OiU3ddNU=;
        b=ReI3wLYKxYQMcshcryGDuOkOSHoAFa0/OEAHRf/wkZ/mdy+ST3238gUuSKvkQ9/pHn
         JBgQp3a8PjBGmyt8YpOoOfII3nMYgePm8zQGH9CH4M7eNGEg0bRhPPrjTiD6QzYji85l
         MPCiGDloipFaxOVtQ6ZzJyxwMuPBVwXnKJ9obXWiSYZ9ffa/8j3IR/vFRRYvvXyULukq
         j9cNWJ5Voz75RzwhYeK3kOf7xUgmpaAfWMtQL5CKS/irlXKZNUiIHxuu+2iQ/n4TkIaA
         3mLjdGRoJN9gku4tOva0XC2ipg1G2sdgltRV42ff9bAh9aJxIspOOlaXworShpKB93D3
         7OlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IUPk0cjP+4hWCuB6avcV0cHzsw30NHswIq8OiU3ddNU=;
        b=MCydicPed1upQhKUls7ljHLy+3KAWVsAugIGmsryx4oTDu74dJXG42w0aMp5k+HRyZ
         CPHOuznPBhnP/7ddhBWVwkWZgCEAPi+601SIFp3juEdP9DEvnRpkB04yb6PQbunw6jYS
         df0f/oW4wEwA4L6N9QCQqh6i1jwsNH3sJPoPoPo7FjtTf5LPs0W3LJoPQcAGixT9W43Q
         d7YlWDRbPIFtW+VRh2I519uAm923wrCp07aLclEM6hmTz57POtEG/7Xy9Ur16n3ngxnq
         ifEHRQCOnmLK/G4w/AwZAIEFR5/r6MyYW3hTbbhObyGKQ6rQoghbEOjTfX83nejUsUzc
         PE5w==
X-Gm-Message-State: AOAM5332mO+dgVOOzFA32/YWMTwGpEZFCSc24CwqeFiRh6RDVwQRw8Nw
        ra7xBIFm8MJs8yzpH4yI99I=
X-Google-Smtp-Source: ABdhPJwaJgi/MY4HCRItMOFzgS3VZEdf0c8cSo1OiMQsEJZQPYqQUgGG6nvWq6rw1GphN+dA6QhmBw==
X-Received: by 2002:a17:90b:4b0e:b0:1cd:a983:6aac with SMTP id lx14-20020a17090b4b0e00b001cda9836aacmr8108pjb.33.1649882461718;
        Wed, 13 Apr 2022 13:41:01 -0700 (PDT)
Received: from ?IPV6:2620:15c:2c1:200:4cf8:b337:73c1:2c25? ([2620:15c:2c1:200:4cf8:b337:73c1:2c25])
        by smtp.gmail.com with ESMTPSA id b12-20020a17090aa58c00b001ca977b49d5sm3828062pjq.31.2022.04.13.13.41.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 13:41:01 -0700 (PDT)
Message-ID: <62903323-d1c0-79cd-7cf8-d6c4b89ff848@gmail.com>
Date:   Wed, 13 Apr 2022 13:40:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next 8/9] net: ipv6: add skb drop reasons to
 ip6_rcv_core()
Content-Language: en-US
To:     menglong8.dong@gmail.com, dsahern@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, pabeni@redhat.com,
        benbjiang@tencent.com, flyingpeng@tencent.com,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        mengensun@tencent.com, dongli.zhang@oracle.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20220413081600.187339-1-imagedong@tencent.com>
 <20220413081600.187339-9-imagedong@tencent.com>
From:   Eric Dumazet <edumazet@gmail.com>
In-Reply-To: <20220413081600.187339-9-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/13/22 01:15, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
>
> Replace kfree_skb() used in ip6_rcv_core() with kfree_skb_reason().
> No new drop reasons are added.
>
> Seems now we use 'SKB_DROP_REASON_IP_INHDR' for too many case during
> ipv6 header parse or check, just like what 'IPSTATS_MIB_INHDRERRORS'
> do. Will it be too general and hard to know what happened?
>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> ---
>   net/ipv6/ip6_input.c | 24 ++++++++++++++++--------
>   1 file changed, 16 insertions(+), 8 deletions(-)
>
> diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> index b4880c7c84eb..1b925ecb26e9 100644
> --- a/net/ipv6/ip6_input.c
> +++ b/net/ipv6/ip6_input.c
> @@ -145,13 +145,14 @@ static void ip6_list_rcv_finish(struct net *net, struct sock *sk,
>   static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
>   				    struct net *net)
>   {
> +	enum skb_drop_reason reason;
>   	const struct ipv6hdr *hdr;
>   	u32 pkt_len;
>   	struct inet6_dev *idev;
>   
>   	if (skb->pkt_type == PACKET_OTHERHOST) {
>   		dev_core_stats_rx_otherhost_dropped_inc(skb->dev);
> -		kfree_skb(skb);
> +		kfree_skb_reason(skb, SKB_DROP_REASON_OTHERHOST);
>   		return NULL;
>   	}
>   
> @@ -161,9 +162,12 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
>   
>   	__IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_IN, skb->len);
>   
> +	SKB_DR_SET(reason, NOT_SPECIFIED);
>   	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL ||
>   	    !idev || unlikely(idev->cnf.disable_ipv6)) {
>   		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INDISCARDS);
> +		if (unlikely(idev->cnf.disable_ipv6))

idev can be NULL here (according to surrounding code), and we crash :/



> +			SKB_DR_SET(reason, IPV6DISABLED);
>   		goto drop;
>   	}
>   
> @@ -187,8 +191,10 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
>   
>   	hdr = ipv6_hdr(skb);
>   
> -	if (hdr->version != 6)
> +	if (hdr->version != 6) {
> +		SKB_DR_SET(reason, UNHANDLED_PROTO);
>   		goto err;
> +	}
>   
>   	__IP6_ADD_STATS(net, idev,
>   			IPSTATS_MIB_NOECTPKTS +
> @@ -226,8 +232,10 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
>   	if (!ipv6_addr_is_multicast(&hdr->daddr) &&
>   	    (skb->pkt_type == PACKET_BROADCAST ||
>   	     skb->pkt_type == PACKET_MULTICAST) &&
> -	    idev->cnf.drop_unicast_in_l2_multicast)
> +	    idev->cnf.drop_unicast_in_l2_multicast) {
> +		SKB_DR_SET(reason, UNICAST_IN_L2_MULTICAST);
>   		goto err;
> +	}
>   
>   	/* RFC4291 2.7
>   	 * Nodes must not originate a packet to a multicast address whose scope
> @@ -256,12 +264,11 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
>   		if (pkt_len + sizeof(struct ipv6hdr) > skb->len) {
>   			__IP6_INC_STATS(net,
>   					idev, IPSTATS_MIB_INTRUNCATEDPKTS);
> +			SKB_DR_SET(reason, PKT_TOO_SMALL);
>   			goto drop;
>   		}
> -		if (pskb_trim_rcsum(skb, pkt_len + sizeof(struct ipv6hdr))) {
> -			__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
> -			goto drop;
> -		}
> +		if (pskb_trim_rcsum(skb, pkt_len + sizeof(struct ipv6hdr)))
> +			goto err;
>   		hdr = ipv6_hdr(skb);
>   	}
>   
> @@ -282,9 +289,10 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
>   	return skb;
>   err:
>   	__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
> +	SKB_DR_OR(reason, IP_INHDR);
>   drop:
>   	rcu_read_unlock();
> -	kfree_skb(skb);
> +	kfree_skb_reason(skb, reason);
>   	return NULL;
>   }
>   
