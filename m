Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD00336BE2
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhCKGNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbhCKGMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 01:12:52 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B699C061574;
        Wed, 10 Mar 2021 22:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=h8aFuwdEQbq+Mg1pCOr++y0lRKxSpzr2i/D/1Sn40JY=; b=SQ71kkj+hQqJeaEdQu9vCbegeT
        n1GqRDzngRCaYc9rpXClkElVhb8Zfx1hTZNIbZS/jy4AQg5o7wfBimD6oD0rDeO7OtFNKHYYleNKJ
        OcxN+42NjXwBjzNJZm97rUHBShy443c35g+O/TuqQBazSG9s83Q7/8ZsDiiwDFeYteNX2yoB+uBpc
        xQjihJ08mlZ2Bp75Ur27Vgc+FdopqAyXOxL4xRQzoQToRpjkSybCyFP4feDrIbXYqoCmaFd1VzRKo
        907hCWSrMnK+YF7HEN5Fq3BH5aJzsn5M7WU0UNLuqThkZ/TESIIJ3EcN9a9+e7M4evsOkXfl/QFX9
        v0rYPP+Q==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by merlin.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lKEYz-000tUv-0m; Thu, 11 Mar 2021 06:12:49 +0000
Subject: Re: [PATCH] net: core: Few absolutely rudimentary typo fixes
 throughout the file filter.c
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210311055608.12956-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <786f4801-c41f-cddd-c855-b388ec026614@infradead.org>
Date:   Wed, 10 Mar 2021 22:12:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210311055608.12956-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 9:56 PM, Bhaskar Chowdhury wrote:
> 
> Trivial spelling fixes throughout the file.
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Hi Bhaskar,

FYI:

a. we accept British or American spellings
b. we accept one or two spaces after a period ('.') at the end of a sentence
c. we accept Oxford (serial) comma or not

> ---
>  net/core/filter.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 255aeee72402..931ee5f39ae7 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -2927,7 +2927,7 @@ BPF_CALL_4(bpf_msg_pop_data, struct sk_msg *, msg, u32, start,
>  	 *
>  	 * Then if B is non-zero AND there is no space allocate space and
>  	 * compact A, B regions into page. If there is space shift ring to
> -	 * the rigth free'ing the next element in ring to place B, leaving
> +	 * the right freeing the next element in ring to place B, leaving
>  	 * A untouched except to reduce length.
>  	 */
>  	if (start != offset) {
> @@ -3710,7 +3710,7 @@ static inline int __bpf_skb_change_tail(struct sk_buff *skb, u32 new_len,
>  	 * be the one responsible for writing buffers.
>  	 *
>  	 * It's really expected to be a slow path operation here for
> -	 * control message replies, so we're implicitly linearizing,
> +	 * control message replies, so we're implicitly linearising,
>  	 * uncloning and drop offloads from the skb by this.
>  	 */
>  	ret = __bpf_try_make_writable(skb, skb->len);
> @@ -3778,7 +3778,7 @@ static inline int __bpf_skb_change_head(struct sk_buff *skb, u32 head_room,
>  		 * allow to expand on mac header. This means that
>  		 * skb->protocol network header, etc, stay as is.
>  		 * Compared to bpf_skb_change_tail(), we're more
> -		 * flexible due to not needing to linearize or
> +		 * flexible due to not needing to linearise or
>  		 * reset GSO. Intention for this helper is to be
>  		 * used by an L3 skb that needs to push mac header
>  		 * for redirection into L2 device.
> --


-- 
~Randy

