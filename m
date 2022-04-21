Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1B050AAA4
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 23:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380667AbiDUVUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 17:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349339AbiDUVUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 17:20:19 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343504BFFF;
        Thu, 21 Apr 2022 14:17:26 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id B5A9C30B2946;
        Thu, 21 Apr 2022 23:16:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:content-type
        :content-type:date:from:from:in-reply-to:message-id:mime-version
        :references:reply-to:subject:subject:to:to; s=felkmail; bh=T+UJh
        pf6iwfqO+KD/Gn6n7F7lGzmkVfknCJtUCxzGTs=; b=LvUqvG4hGglewdm9FVTmB
        9HmYxnXZy+jTMXLuFwNUdqGKSLfjTHAk8LRKPqMwaAaQK+urCZhFd5PWKRzeeYUw
        zLpmRpcF4nWzHbf8I4icqltXFDZEZftZsywK7wcTZO8gViboDYQBpGyeHoRYCo5X
        jthqsP2Zql35RUjeDfrk+HkWleFnebyO5BEo/JZNXR8ju4cIB4VDe4+xXyoI3zhF
        m98SyDLGB+cLQpqwq/EUXk9NabJiyOIpcfBr24LZ+y0XP/BEipGhiIx6Jha/QsAd
        h/fPijFzTnmvKr2SL7+/wJE0FTdzHazwRCZEV83ZhWa3M+YUBwNCr9vCN4rQpeEJ
        g==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 54AFB30B2943;
        Thu, 21 Apr 2022 23:16:54 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 23LLGsXX026471;
        Thu, 21 Apr 2022 23:16:54 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 23LLGrIN026468;
        Thu, 21 Apr 2022 23:16:53 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: Re: [PATCH] can: ctucanfd: Remove unnecessary print function dev_err()
Date:   Thu, 21 Apr 2022 23:16:53 +0200
User-Agent: KMail/1.9.10
Cc:     ondrej.ille@gmail.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
References: <20220421203242.7335-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20220421203242.7335-1-jiapeng.chong@linux.alibaba.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202204212316.53141.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for checking

On Thursday 21 of April 2022 22:32:42 Jiapeng Chong wrote:
> The print function dev_err() is redundant because platform_get_irq()
> already prints an error.
>
> Eliminate the follow coccicheck warnings:
>
> ./drivers/net/can/ctucanfd/ctucanfd_platform.c:67:2-9: line 67 is
> redundant because platform_get_irq() already prints an error.
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Acked-by: Pave Pisa <pisa@cmp.felk.cvut.cz>

>  drivers/net/can/ctucanfd/ctucanfd_platform.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/net/can/ctucanfd/ctucanfd_platform.c
> b/drivers/net/can/ctucanfd/ctucanfd_platform.c index
> 5e4806068662..89d54c2151e1 100644
> --- a/drivers/net/can/ctucanfd/ctucanfd_platform.c
> +++ b/drivers/net/can/ctucanfd/ctucanfd_platform.c
> @@ -64,7 +64,6 @@ static int ctucan_platform_probe(struct platform_device
> *pdev) }
>  	irq = platform_get_irq(pdev, 0);
>  	if (irq < 0) {
> -		dev_err(dev, "Cannot find interrupt.\n");
>  		ret = irq;
>  		goto err;
>  	}

