Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95D2D531F06
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 01:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiEWXCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 19:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiEWXCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 19:02:07 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7A39C2C1
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 16:02:05 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id u27so22492300wru.8
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 16:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=K5m3JorSbh7rBFF372heH/N7LIeqaAnj+DOrd982lrg=;
        b=AJ5Aduu4xUuLKCBwtSjmpIEo55PbEvQ6cmEvHHNd2NtAJPwQHDzRC6cH2kbUKxtPRU
         DWb7cw0Zwr4AohJBxw0YcMjczQucsgYQvLNT0iXSZJbFatQweBpgM6hxxw8LGKVJ/jIn
         MLRPsH6xXB0V04g4XmEvx/TezTemW4JBrc17KLB//V2Fhuk+zzsKW/Eh1nWHnzz6MtRV
         L9HOiEcvgpy2eqrhp6Ua3X7TGHxlQr1CQOiQUp1OylyhjGspM1GtXNgF3N1fD/zwLBld
         wB+KkI1dkO6tcxX/81HJslrV0jwYa6mgI1QZtcveZIlxFzdLb00Pbypt5xzCUuxGfzMI
         vbQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=K5m3JorSbh7rBFF372heH/N7LIeqaAnj+DOrd982lrg=;
        b=B2Nxj310788/cTZZNIvKwIFH3bix6000ih51J/9LC5YtfVI75o9Rld8HmbWTtYBNyR
         EgtZXB+80Vhx4BJq0zWJH16tpUJAehAfGrIEXEbrYsI+gGjpVrp7SxdPnGELoENy+uGS
         ckx0TagN6L1JLZTvZILUVNs21Mo5iGxL0DozsWtgBoJ59R9VfN6wlGpLlnL/f8vhw7Mv
         nCuUZ1foJngHuq9zqICGCxBdkABaQQXTGzFVtqTkEOGhpSM+V7er+rVOvKsdtsNsj4D/
         9b29Yqz8LJzZthKofYi8nUWUZ9Yf/ACSRInyoe1aZ9t4i9ahg+rG04PBVh6sbrBrB6sl
         V4xg==
X-Gm-Message-State: AOAM5324w6dSmTVbD7JOzLokyIRBuOejPSge7pGBWkQUwlQ57t1dg/6+
        uZ05rQpv9jXIxO2RnmHHdnTZgA==
X-Google-Smtp-Source: ABdhPJwGSUTliv5/jOJQGFH8UuZNT7ndb6VjG5f6j6DUVaOBNIhwk8NiyZMjTjcBPucHxl+ZJAtcjw==
X-Received: by 2002:a05:6000:1acd:b0:20f:d7bc:e61a with SMTP id i13-20020a0560001acd00b0020fd7bce61amr7297013wry.36.1653346924232;
        Mon, 23 May 2022 16:02:04 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id m185-20020a1ca3c2000000b003942a244ee7sm403343wme.44.2022.05.23.16.02.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 16:02:03 -0700 (PDT)
Message-ID: <9320576e-50e2-29de-b253-22b414128c3a@blackwall.org>
Date:   Tue, 24 May 2022 02:02:02 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH net-next 04/12] net: bridge: move DSA master bridging
 restriction to DSA
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20220523104256.3556016-1-olteanv@gmail.com>
 <20220523104256.3556016-5-olteanv@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220523104256.3556016-5-olteanv@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/05/2022 13:42, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> When DSA gains support for multiple CPU ports in a LAG, it will become
> mandatory to monitor the changeupper events for the DSA master.
> 
> In fact, there are already some restrictions to be imposed in that area,
> namely that a DSA master cannot be a bridge port except in some special
> circumstances.
> 
> Centralize the restrictions at the level of the DSA layer as a
> preliminary step.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br_if.c | 20 --------------------
>  net/dsa/slave.c    | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 44 insertions(+), 20 deletions(-)

I gotta say I love patches like this one. Thanks,

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
