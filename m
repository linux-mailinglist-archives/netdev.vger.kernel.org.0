Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433235143AE
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 10:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354977AbiD2IPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 04:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236729AbiD2IPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 04:15:15 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5562A27B10;
        Fri, 29 Apr 2022 01:11:58 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id a14-20020a7bc1ce000000b00393fb52a386so5969802wmj.1;
        Fri, 29 Apr 2022 01:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XqvrYci+95js6f4mZtp9h/yUnthzubPuS18nX3bTZPY=;
        b=Agh0hWfNWOLsgMtRQM7cd5+lULJfekaq2Bdh3j5NJrn8b77Zijoq0Lzu+L84ZM2LVz
         wt1r36bJC8X6sII7aa0Y1uCvfy4g0T+Wg9D0SorY0VU7U5eyo+kztqsvp/jueHRWzWzq
         Clcs/GPXTwguYJs/ySHdd4cVkPfhD7usB5qc1a4HNTnkYp8PYLFPtPSZ0K7NsQXyHsce
         TMHr7eRmKAKhHpRhZdf9P8Yc0fC+6ukgaRo55rChtq9CrWhXGHGrwvZl7oJXgq9/ekOV
         ejIe2PNvw6G5fOikA75aBhkkFGyeLnA85N/DohY9YkAcFI/QMcwRGVZXPcl/thf+D2TZ
         1wJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XqvrYci+95js6f4mZtp9h/yUnthzubPuS18nX3bTZPY=;
        b=Fvt6MN5kmgjnb5pYzYN+NFNyKK5UHTGPZZ94c8lN46PVZwm79YT+X8ktGd3LNdGjp3
         ZCkyrtP7Hn8kdfNV+4Wos3TNmflTrVfSfnqbhdJNGHYNtPJxSWiXG7GbI9bNGVwgq/Mj
         4u/jjA94dXXrA46bn5G+mSIa5yA9VmXoO8XGQEMFdm09Oamo9o3YuislLbXeOqyRa97R
         vJY1t2NtwuHGnvGpP250BvUDdNJrBPKlxZ+GAyXywDWR4K1ku6el0MJNeZ7gg6sjPB1J
         jds8Pa2Xv22wCx8NS8QkhumkxKHgFMBhRoA1nefZQDCA6sm+uPxbtT0ScFEooaA43y8k
         SI9g==
X-Gm-Message-State: AOAM532a9gNxRkGoPf2zLikgpCrBHx6V0qq/zOX6BMWdFcRrCrWQ+8b3
        UKE3Fs4hVQDJC/fFb5jJEM0=
X-Google-Smtp-Source: ABdhPJzYf70fG27iHwc3wFbKY4QIqsyyUy9X0QI973D1I4SxhcbTK5uGUHInLMnygbTBJgrDh3XA3g==
X-Received: by 2002:a7b:cbc2:0:b0:388:faec:2036 with SMTP id n2-20020a7bcbc2000000b00388faec2036mr2089539wmi.190.1651219916786;
        Fri, 29 Apr 2022 01:11:56 -0700 (PDT)
Received: from [10.7.237.11] (54-240-197-227.amazon.com. [54.240.197.227])
        by smtp.gmail.com with ESMTPSA id q16-20020a1ce910000000b0038eabd31749sm2222371wmc.32.2022.04.29.01.11.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 01:11:56 -0700 (PDT)
Message-ID: <c962f441-05b8-8aa1-5186-c85251f3e0ba@gmail.com>
Date:   Fri, 29 Apr 2022 09:11:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Reply-To: paul@xen.org
Subject: Re: [PATCH net-next v2 01/15] eth: remove copies of the
 NAPI_POLL_WEIGHT define
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        ulli.kroll@googlemail.com, linus.walleij@linaro.org,
        mlindner@marvell.com, stephen@networkplumber.org, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        matthias.bgg@gmail.com, grygorii.strashko@ti.com,
        wei.liu@kernel.org, paul@xen.org,
        prabhakar.mahadev-lad.rj@bp.renesas.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-omap@vger.kernel.org,
        xen-devel@lists.xenproject.org
References: <20220428212323.104417-1-kuba@kernel.org>
 <20220428212323.104417-2-kuba@kernel.org>
From:   "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <20220428212323.104417-2-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/04/2022 22:23, Jakub Kicinski wrote:
> Defining local versions of NAPI_POLL_WEIGHT with the same
> values in the drivers just makes refactoring harder.
> 
> Drop the special defines in a bunch of drivers where the
> removal is relatively simple so grouping into one patch
> does not impact reviewability.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: ulli.kroll@googlemail.com
> CC: linus.walleij@linaro.org
> CC: mlindner@marvell.com
> CC: stephen@networkplumber.org
> CC: nbd@nbd.name
> CC: john@phrozen.org
> CC: sean.wang@mediatek.com
> CC: Mark-MC.Lee@mediatek.com
> CC: matthias.bgg@gmail.com
> CC: grygorii.strashko@ti.com
> CC: wei.liu@kernel.org
> CC: paul@xen.org
> CC: prabhakar.mahadev-lad.rj@bp.renesas.com
> CC: linux-arm-kernel@lists.infradead.org
> CC: linux-mediatek@lists.infradead.org
> CC: linux-omap@vger.kernel.org
> CC: xen-devel@lists.xenproject.org
> ---
>   drivers/net/ethernet/cortina/gemini.c         | 4 +---
>   drivers/net/ethernet/marvell/skge.c           | 3 +--
>   drivers/net/ethernet/marvell/sky2.c           | 3 +--
>   drivers/net/ethernet/mediatek/mtk_star_emac.c | 3 +--
>   drivers/net/ethernet/ti/davinci_emac.c        | 3 +--
>   drivers/net/ethernet/ti/netcp_core.c          | 5 ++---
>   drivers/net/xen-netback/interface.c           | 3 +--
>   7 files changed, 8 insertions(+), 16 deletions(-)
> 

xen-netback patch...

Reviewed-by: Paul Durrant <paul@xen.org>
