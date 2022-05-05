Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040B351BD65
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 12:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355879AbiEEKqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 06:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352217AbiEEKqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 06:46:11 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF5353716;
        Thu,  5 May 2022 03:42:32 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id q4so1125144plr.11;
        Thu, 05 May 2022 03:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VwJgS7EQVPINql3/IWkqXNQpE3klGJYH+DfKyFv2JQY=;
        b=KScEbK/eLpYZn24jwF/V+qYRxX8O/bC1VEZvrmcsUkkJu4xqN8E5HS5Qvwka7XPO49
         5or89yjGgo9Yn5/NV+02Q5SNhQIyCDWey8hzkvXBh5WygVRjT5xAy+FGXRp7Zw6VjIqV
         7yLhmcTbdrmz9jNKLeHbn9tZhP/LZTsFJ2CoGkyfP2YnUhsSHoSlinnudG2p9F73Fo7a
         7qqAZBw+wMLobNXMovDXCTZ7k67QmS96xA7OnpIjPqRm+xN+4RJBV+RkUKSKK5rgY6Bd
         KRcweSrM3/OHbqzTseBZX1mG3A811JeVF3+3SaCo83JpRLR0J4x/n+b6sBgctJgm/9kg
         fORA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VwJgS7EQVPINql3/IWkqXNQpE3klGJYH+DfKyFv2JQY=;
        b=eKKpsNp/eKTXKgMga182+RHIfmPcSmzX/Y7Ptu954QISrcItUYhZm5C7noLWCa0lw9
         aWS8DAlINh8JTTZKG1xlLrrH5VGRwS/V3hto3HQ1RsnbzHh+bfZ442h+3nzwzC1O4HRF
         3AoPVrxQjFz1YBP3Wuvyeix5A29sRmrtse495O7yKeTCUWneBMGJ4Y7RQNCMbsF3PKlk
         WWukw0UmROe0zsr86NEdubO+NbYaMbEXSBRjRJe+Coymh5uQlajgV0LOpShD6vvEy+9i
         BXh+0PvPfyivtr6mriY3IyVjdx9DTc7hclJHGM1klJ3ghZ7HIfhOi6kVk/B5eSKQJJvS
         L1kA==
X-Gm-Message-State: AOAM531hgjgzdAfDYyKwzk8Oz75iRNZqy1W/pdWWBGEN8A5U8R5h6lyO
        5ASUvVeboBeNNiUUl/mcFEtiAju6W2s=
X-Google-Smtp-Source: ABdhPJzwPf1b02txXmiAhAdw7c4vm2/gjm8vTxHsLDx9RjanrKorKqFZ30wz0saply+QWDTItl3umg==
X-Received: by 2002:a17:90b:1d83:b0:1dc:4362:61bd with SMTP id pf3-20020a17090b1d8300b001dc436261bdmr5338472pjb.126.1651747352073;
        Thu, 05 May 2022 03:42:32 -0700 (PDT)
Received: from [192.168.11.5] (KD106167171201.ppp-bb.dion.ne.jp. [106.167.171.201])
        by smtp.gmail.com with ESMTPSA id d20-20020a056a00199400b0050dc7628156sm1098222pfl.48.2022.05.05.03.42.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 03:42:31 -0700 (PDT)
Message-ID: <c7a501cc-0a09-9f3d-8200-50fc3a854853@gmail.com>
Date:   Thu, 5 May 2022 19:42:26 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next v2] net/core: use ReST block quote in
 __dev_queue_xmit() comment
Content-Language: en-US
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Ben Greear <greearb@candelatech.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220505082907.42393-1-bagasdotme@gmail.com>
From:   Akira Yokosawa <akiyks@gmail.com>
In-Reply-To: <20220505082907.42393-1-bagasdotme@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/05/05 17:29,
Bagas Sanjaya wrote:
> When merging net-next for linux-next tree, Stephen Rothwell reported
> htmldocs warning:
> 
> Documentation/networking/kapi:92: net/core/dev.c:4101: WARNING: Missing matching underline for section title overline.
> 
> -----------------------------------------------------------------------------------
>      I notice this method can also return errors from the queue disciplines,
>      including NET_XMIT_DROP, which is a positive value.  So, errors can also
> 
> The warning is due to comment quote by Ben from commit af191367a75262
> ("[NET]: Document ->hard_start_xmit() locking in comments.") interacts
> with commit c526fd8f9f4f21 ("net: inline dev_queue_xmit()").

I don't see why the change in commit c526fd8f9f4f21 caused the new
warning.
Please explain.  Just saying "interacts with" does not explain
anything.

        Thanks, Akria

> 
> Fix the warning by using ReST block quote syntax for the comment quote.
> Note that the actual description for the method will be rendered above
> "Description" section instead of below of it. However, preserve the
> comment quote for now.
> 
> Fixes: c526fd8f9f4f21 ("net: inline dev_queue_xmit()")
> Link: https://lore.kernel.org/linux-next/20220503073420.6d3f135d@canb.auug.org.au/
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Ben Greear <greearb@candelatech.com>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Akira Yokosawa <akiyks@gmail.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-next@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  Changes since v1 [1]:
>    - Use ReST block quote instead of deleting the comment quote
>    - Mention the originating commit that introduces the quote
> 
>  [1]: https://lore.kernel.org/linux-doc/20220503072949.27336-1-bagasdotme@gmail.com/
>  net/core/dev.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index c2d73595a7c369..bcb47b889f5857 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4099,17 +4099,18 @@ struct netdev_queue *netdev_core_pick_tx(struct net_device *dev,
>   *	to congestion or traffic shaping.
>   *
>   * -----------------------------------------------------------------------------------
> - *      I notice this method can also return errors from the queue disciplines,
> - *      including NET_XMIT_DROP, which is a positive value.  So, errors can also
> - *      be positive.
>   *
> - *      Regardless of the return value, the skb is consumed, so it is currently
> - *      difficult to retry a send to this method.  (You can bump the ref count
> - *      before sending to hold a reference for retry if you are careful.)
> + *        I notice this method can also return errors from the queue disciplines,
> + *        including NET_XMIT_DROP, which is a positive value.  So, errors can also
> + *        be positive.
>   *
> - *      When calling this method, interrupts MUST be enabled.  This is because
> - *      the BH enable code must have IRQs enabled so that it will not deadlock.
> - *          --BLG
> + *        Regardless of the return value, the skb is consumed, so it is currently
> + *        difficult to retry a send to this method.  (You can bump the ref count
> + *        before sending to hold a reference for retry if you are careful.)
> + *
> + *        When calling this method, interrupts MUST be enabled.  This is because
> + *        the BH enable code must have IRQs enabled so that it will not deadlock.
> + *        --BLG
>   */
>  int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
>  {
> 
> base-commit: 4950b6990e3b1efae64a5f6fc5738d25e3b816b3
