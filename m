Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1A44D8E5C
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 21:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245174AbiCNUky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 16:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245120AbiCNUkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 16:40:51 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7E13DDFD
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 13:39:24 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id c25so19451058edj.13
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 13:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brouer-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:cc:subject:content-language
         :to:references:from:in-reply-to:content-transfer-encoding;
        bh=S5i0TLtrk4dOBmRRh+Yq7O8vfz6Gv5F2Xy81kPlrcb8=;
        b=ggWuAf6kql6XuEjSmVdrtbeA+ledbku/VCzhTOGydbN7ihVWVJZqSsS9cXkCzeBwzc
         PT5b68J6dvNY5tGIC7oMwgoDUWlJgQfoo66XCE9LM+TTncaEfEbsCTxSIrk0CSvxhO6F
         uwOT/Hi35BDE5FPmVcY0/yCLwH1RJIuU7x8jG9fcJFOFRSBQXsuE+yH5VkpwRpzs7WXY
         IdutiG8kI90HMeOXokmTL7XoYH5emWygBc3LyxIcBxcpwMTpBjrhKMBTuH0i2ExExwjk
         Bepot4/Fi8Unz6EcGddzqeULx75F6sTPcF3+if19+i3iMDkYBATvX7/ieMl5c3OYgrR6
         QE8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=S5i0TLtrk4dOBmRRh+Yq7O8vfz6Gv5F2Xy81kPlrcb8=;
        b=IPEi4NnA+FopM4WMKONnLgCHwXKpfZaduJSCqo0AzYVfm5/NTxNOctVcd/RYMv2oR0
         /tunRWJYaTP3HgYKV78e+6DiS15q9Ugvs2hxrm7xkQS9dg54wnh6qizKSZkchTFgk8vz
         a+TBIHTk223pWlaZGfP9JClu3rploLypyHSZJEjZebAG7K6kGuEmtiuK7DwA7tfjHRne
         bISEdb2/5WYFta7zS5Cx3Zbg6/KXV4vOIyTwGysX8tH0tub+Z0zvbujnuTMeN/Mua0n8
         NR7wuHMl72DBhTGdr7BRqRLeiiyC2LYP4MThGHgmqd+t8NeV9ane59XWpWy1LgfBQTLy
         NDrA==
X-Gm-Message-State: AOAM533Zt331q+K93PRjcP8FY4VM0TVTm346+i39BkOSxJ7K7oHX8nFz
        QLHo/TkTUS73C/qodPUwBscAUw==
X-Google-Smtp-Source: ABdhPJxn49rfigm6oyzlOa1QiSW4nVPQhw1iGEPDV8463LVZNCdjKfNbRll1asF8O5lCnehxEtJSag==
X-Received: by 2002:a05:6402:5244:b0:417:adbe:e9f6 with SMTP id t4-20020a056402524400b00417adbee9f6mr15251242edd.282.1647290363249;
        Mon, 14 Mar 2022 13:39:23 -0700 (PDT)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id ca21-20020aa7cd75000000b004188bc5712fsm1950419edb.73.2022.03.14.13.39.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 13:39:22 -0700 (PDT)
Message-ID: <86137924-b3cb-3d96-51b1-19923252f092@brouer.com>
Date:   Mon, 14 Mar 2022 21:39:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, Toke Hoiland Jorgensen <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net: xdp: allow user space to request a smaller packet
 headroom requirement
Content-Language: en-US
To:     Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        bpf <bpf@vger.kernel.org>
References: <20220314102210.92329-1-nbd@nbd.name>
From:   "Jesper D. Brouer" <netdev@brouer.com>
In-Reply-To: <20220314102210.92329-1-nbd@nbd.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Cc. BPF list and other XDP maintainers)

On 14/03/2022 11.22, Felix Fietkau wrote:
> Most ethernet drivers allocate a packet headroom of NET_SKB_PAD. Since it is
> rounded up to L1 cache size, it ends up being at least 64 bytes on the most
> common platforms.
> On most ethernet drivers, having a guaranteed headroom of 256 bytes for XDP
> adds an extra forced pskb_expand_head call when enabling SKB XDP, which can
> be quite expensive.
> Many XDP programs need only very little headroom, so it can be beneficial
> to have a way to opt-out of the 256 bytes headroom requirement.

IMHO 64 bytes is too small.
We are using this area for struct xdp_frame and also for metadata
(XDP-hints).  This will limit us from growing this structures for
the sake of generic-XDP.

I'm fine with reducting this to 192 bytes, as most Intel drivers
have this headroom, and have defacto established that this is
a valid XDP headroom, even for native-XDP.

We could go a small as two cachelines 128 bytes, as if xdp_frame
and metadata grows above a cache-line (64 bytes) each, then we have
done something wrong (performance wise).


> Add an extra flag XDP_FLAGS_SMALL_HEADROOM that can be set when attaching
> the XDP program, which reduces the minimum headroom to 64 bytes.

I don't like a flags approach.

Multiple disadvantages.
  (a) Harder to use
  (b) Now reading a new cache-line in net_device

> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>   include/linux/netdevice.h          | 1 +
>   include/uapi/linux/bpf.h           | 1 +
>   include/uapi/linux/if_link.h       | 4 +++-
>   net/core/dev.c                     | 9 ++++++++-
>   tools/include/uapi/linux/if_link.h | 4 +++-
>   5 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 0d994710b335..f6f270a5e301 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -2274,6 +2274,7 @@ struct net_device {
>   	bool			proto_down;
>   	unsigned		wol_enabled:1;
>   	unsigned		threaded:1;
> +	unsigned		xdp_small_headroom:1;
>   

Looks like we need to read this cache-line, in a XDP (generic) fastpath.

>   	struct list_head	net_notifier_list;
>   
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 4eebea830613..7635dfb02313 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5688,6 +5688,7 @@ struct bpf_xdp_sock {
>   };
>   
>   #define XDP_PACKET_HEADROOM 256
> +#define XDP_PACKET_HEADROOM_SMALL 64

Define it 192 instead.

>   
>   /* User return codes for XDP prog type.
>    * A valid XDP program must return one of these defined values. All other
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index e003a0b9b4b2..acb996334910 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -1275,11 +1275,13 @@ enum {
>   #define XDP_FLAGS_DRV_MODE		(1U << 2)
>   #define XDP_FLAGS_HW_MODE		(1U << 3)
>   #define XDP_FLAGS_REPLACE		(1U << 4)
> +#define XDP_FLAGS_SMALL_HEADROOM	(1U << 5)
>   #define XDP_FLAGS_MODES			(XDP_FLAGS_SKB_MODE | \
>   					 XDP_FLAGS_DRV_MODE | \
>   					 XDP_FLAGS_HW_MODE)
>   #define XDP_FLAGS_MASK			(XDP_FLAGS_UPDATE_IF_NOEXIST | \
> -					 XDP_FLAGS_MODES | XDP_FLAGS_REPLACE)
> +					 XDP_FLAGS_MODES | XDP_FLAGS_REPLACE | \
> +					 XDP_FLAGS_SMALL_HEADROOM)
>   
>   /* These are stored into IFLA_XDP_ATTACHED on dump. */
>   enum {
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 8d25ec5b3af7..cb12379b8f11 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4722,6 +4722,7 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
>   				     struct xdp_buff *xdp,
>   				     struct bpf_prog *xdp_prog)
>   {
> +	int min_headroom = XDP_PACKET_HEADROOM;
>   	u32 act = XDP_DROP;
>   
>   	/* Reinjected packets coming from act_mirred or similar should
> @@ -4730,12 +4731,15 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
>   	if (skb_is_redirected(skb))
>   		return XDP_PASS;
>   
> +	if (skb->dev->xdp_small_headroom)
> +		min_headroom = XDP_PACKET_HEADROOM_SMALL;
> +
>   	/* XDP packets must be linear and must have sufficient headroom
>   	 * of XDP_PACKET_HEADROOM bytes. This is the guarantee that also
>   	 * native XDP provides, thus we need to do it here as well.
>   	 */
>   	if (skb_cloned(skb) || skb_is_nonlinear(skb) ||
> -	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
> +	    skb_headroom(skb) < min_headroom) {

Use define XDP_PACKET_HEADROOM_SMALL here directly.

>   		int hroom = XDP_PACKET_HEADROOM - skb_headroom(skb);
>   		int troom = skb->tail + skb->data_len - skb->end;
>   
> @@ -9135,6 +9139,9 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
>   			return err;
>   	}
>   
> +	if (mode == XDP_MODE_SKB)
> +		dev->xdp_small_headroom = !!(flags & XDP_FLAGS_SMALL_HEADROOM);
> +
>   	if (link)
>   		dev_xdp_set_link(dev, mode, link);
>   	else
> diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
> index e1ba2d51b717..0df737a6c489 100644
> --- a/tools/include/uapi/linux/if_link.h
> +++ b/tools/include/uapi/linux/if_link.h
> @@ -1185,11 +1185,13 @@ enum {
>   #define XDP_FLAGS_DRV_MODE		(1U << 2)
>   #define XDP_FLAGS_HW_MODE		(1U << 3)
>   #define XDP_FLAGS_REPLACE		(1U << 4)
> +#define XDP_FLAGS_SMALL_HEADROOM	(1U << 5)
>   #define XDP_FLAGS_MODES			(XDP_FLAGS_SKB_MODE | \
>   					 XDP_FLAGS_DRV_MODE | \
>   					 XDP_FLAGS_HW_MODE)
>   #define XDP_FLAGS_MASK			(XDP_FLAGS_UPDATE_IF_NOEXIST | \
> -					 XDP_FLAGS_MODES | XDP_FLAGS_REPLACE)
> +					 XDP_FLAGS_MODES | XDP_FLAGS_REPLACE | \
> +					 XDP_FLAGS_SMALL_HEADROOM)
>   
>   /* These are stored into IFLA_XDP_ATTACHED on dump. */
>   enum {
> 

--Jesper
