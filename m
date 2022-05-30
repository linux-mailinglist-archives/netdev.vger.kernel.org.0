Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6B9537428
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 06:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbiE3EvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 00:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiE3EvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 00:51:22 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F69B70927;
        Sun, 29 May 2022 21:51:21 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id s24so5656304wrb.10;
        Sun, 29 May 2022 21:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=LELXwtIIYJe0NF4K6OawoTsFSY6J+FVjbPvU3ikss6s=;
        b=KRC5F4j041Kk3SA3GmG7xlhhwYLCjfRxlQde+xEyn10pTqxTs4zg5NEYCGpCTLKjaQ
         VwbGZ4HdcH7ntSS8Wj1wAoZUeugoNg8tABp03jedsE0Arbs95+M24rfoUzgZ8NvcqMbb
         MbUcveKEdIDaVyy/XlY9Ei0GUwqkTzDwuoSwJ7Y7hO2yPzYu7RynUzzKsbEvUmW1XFTI
         pu2WZgb/GKJUoLWFRBP5OqhfvW62qwFKlJj7ytWsfALiRI+53qTt7XlD2+rD8/cnJqWx
         /uo4LqP/AqyE03Lfa0PDgDw4/NkZNR3j3CuxWRFN6lsx3bgzLpxOlcF+zmyxTTP3KmU3
         QcXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=LELXwtIIYJe0NF4K6OawoTsFSY6J+FVjbPvU3ikss6s=;
        b=pfwfJ1uQeghrZ3E0Z8p3UCaTxpQ9cbuw0xiDVKEr4ul9r5u2ln7KBA2gE9LOyx9TQB
         f7nm0coQNoa4mReycTNbmArAw1gBOKh59SecOF5TM3F18NVJAGfNmNJZaif0bFEnWvUp
         Gsf1t8wyirzxXIp0uelhKGakf4Cg1/ZtUk5/+kbOssvqAzN6MDfKbOCw+8Fm2mDZMpnm
         epsCJqLIdqMEUAuF+oT3j/6AwxQfT735na2aKF7IVk/zOjbJy3EQdJ3wvByrcmgeIIZo
         mhsEFez+pRkGNXEu6jxkJ37ZUnZ6gIejTv8Sf0F8nXdEa/yPH0HNICGDBV1+kySz5Dj6
         OzCg==
X-Gm-Message-State: AOAM533g2vLthpJTfLa9hbhrDY/GlXZ4TTystKjxeT1/wTepQc/m/4MI
        NClzt2UeyeZmTWkjEbNIRYs=
X-Google-Smtp-Source: ABdhPJzj/tnDr26ClZFxa3yjdjaUe1R7YLdcAYEMa/2HHDD9FQr5zW6KCuCqvWXKlbBurv+oKKHssA==
X-Received: by 2002:a05:6000:1549:b0:20f:c4c7:a697 with SMTP id 9-20020a056000154900b0020fc4c7a697mr36185138wry.716.1653886279691;
        Sun, 29 May 2022 21:51:19 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id k1-20020adfe8c1000000b0021031c894d3sm2300562wrn.94.2022.05.29.21.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 May 2022 21:51:19 -0700 (PDT)
Date:   Mon, 30 May 2022 06:51:14 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     None <conleylee@foxmail.com>, davem@davemloft.net, kuba@kernel.org,
        mripard@kernel.org, wens@csie.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] sun4i-emac.c: add dma support
Message-ID: <YpRNQlPHiuNoLu3J@Red>
References: <tencent_DE05ADA53D5B084D4605BE6CB11E49EF7408@qq.com>
 <164082961168.30206.13406661054070190413.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <164082961168.30206.13406661054070190413.git-patchwork-notify@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Thu, Dec 30, 2021 at 02:00:11AM +0000, patchwork-bot+netdevbpf@kernel.org a écrit :
> Hello:
> 
> This patch was applied to netdev/net-next.git (master)
> by Jakub Kicinski <kuba@kernel.org>:
> 
> On Wed, 29 Dec 2021 09:43:51 +0800 you wrote:
> > From: Conley Lee <conleylee@foxmail.com>
> > 
> > Thanks for your review. Here is the new version for this patch.
> > 
> > This patch adds support for the emac rx dma present on sun4i. The emac
> > is able to move packets from rx fifo to RAM by using dma.
> > 
> > [...]
> 
> Here is the summary with links:
>   - [v6] sun4i-emac.c: add dma support
>     https://git.kernel.org/netdev/net-next/c/47869e82c8b8
> 
> You are awesome, thank you!
> -- 
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
> 

Hello

Any news on patch which enable sun4i-emac DMA in DT ?

Regards
