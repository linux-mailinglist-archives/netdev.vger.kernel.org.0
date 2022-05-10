Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCB552211C
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 18:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347353AbiEJQ0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 12:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347373AbiEJQ0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 12:26:17 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7255A2CE0F;
        Tue, 10 May 2022 09:22:20 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id p12so15376351pfn.0;
        Tue, 10 May 2022 09:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wDcu7cYJsfVy9NZ2SD6dApJl14bL51Onqrh/Ptthpp4=;
        b=KtpfJ91v3P2mWa1pFoDdeyhatEDDR/W5ra/i0ENEI9u5JfpBbEkgMnILHew3y5n8XW
         wmkWwbqSITv+DZL2stLCETXImSeJre2g0PBrO7m2kJpjJDZM/cHKcTeiJQ535cuvnSts
         yeSr4PtvCDcBzSClfw158sUHyEy4/S5kOIv6TfLK1rgt0U9aXCcTn67a63fuJFoZRp7U
         DN8TvroE7haUpGanCpuCr0XGI4sZpRZuhUjGo4jsnsCalulYj8DjCvSGGRaUllRC0UMd
         XGDP9zXqOOaZ70DiBJSusiz3le6VuryU4WTES6Qe78jTddIPl8rPtyuU0yLNDW/GY5e1
         fAYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wDcu7cYJsfVy9NZ2SD6dApJl14bL51Onqrh/Ptthpp4=;
        b=equs28Q6AyBAhBKK9R8HQMS1Nzc+JL34wWXUkaNONUFmWKLX346j0wJiKmZKcUClEs
         gJY1Tk1keKxaypNnNrbsOS3xQlkZwUPoBqJ8DYHqv90fUxUJ3zRdtESh9e6tVW83V88E
         87G+bwQx+J+3oqVcqtSYXw4gTaTOlOhHylZgtaMAX51xLnDESZTVVm2l1iBMW2yIEoC7
         z5Xw5yYZ9YIpmEnRGd0b5iy5en3fP0vr7Dt0oo6oW7ibyZ3SL3PzORza2rIDtUrq7aF2
         Q/3y6cdmhdEhtetmE+aJvQx9DhfSmT4d6NTJmxXVkQdcvnGlL1s6JFYrGuIlw9i8/Get
         E5CA==
X-Gm-Message-State: AOAM532FBGuX53SayymfyaiJUhsVNU1UL/Ba3lI65bvBSRw7SoJPUMXs
        rWGXQC/dCvnfisady+fq4xg=
X-Google-Smtp-Source: ABdhPJznDioIYRZQ6kHDdNYT91FyrGUHdUILDV/CzrKwzLNPJTKRVK/u+ya1aX7C4x75oENByjA8Ww==
X-Received: by 2002:a63:a18:0:b0:3c6:12b1:a8d0 with SMTP id 24-20020a630a18000000b003c612b1a8d0mr17519099pgk.534.1652199739898;
        Tue, 10 May 2022 09:22:19 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bb10-20020a170902bc8a00b0015e8d4eb1f9sm2274457plb.67.2022.05.10.09.22.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 09:22:19 -0700 (PDT)
Message-ID: <67a3c327-80c7-bdb2-1add-89e5a3dc781f@gmail.com>
Date:   Tue, 10 May 2022 09:22:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next v4 12/12] MAINTAINERS: add Renesas RZ/N1 switch
 related driver entry
Content-Language: en-US
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=c3=a8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
References: <20220509131900.7840-1-clement.leger@bootlin.com>
 <20220509131900.7840-13-clement.leger@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220509131900.7840-13-clement.leger@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/22 06:19, Clément Léger wrote:
> After contributing the drivers, volunteer for maintenance and add
> myself as the maintainer for Renesas RZ/N1 switch related drivers.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
