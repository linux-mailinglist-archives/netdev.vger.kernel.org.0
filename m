Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E65255A639
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 04:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbiFYCic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 22:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbiFYCib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 22:38:31 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6833D32ECE;
        Fri, 24 Jun 2022 19:38:30 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so7302149pjl.5;
        Fri, 24 Jun 2022 19:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Rl1DccSSA6ElUwTWPwY0Dr5s4J+vIlJW3i/vZtLO92k=;
        b=HR/2M8Tse3qDCcnZx7IgWUpMNiNq2VyxgDApc5LXB00oA+5S6AUUsVv6uDeJcwSo8v
         B0kKXU3fz7uxHrkus+C4fCQB8UhFgny/7rEJFZWjitPOA94ZlAYWtk03twL2fzffs78M
         PLWC8rXaACPbEj8Ogjt8Thm2soiTAKZkB7tHX7qjp1HXqVA7ufFjXJFL2R2zf27x0Z2g
         JuYIbM70uGjDJryswL+oRwAz9CqwFi4h6lwrJuU4+riCB0GF/Gr/MAykclyOHWdXqlZZ
         ed4OwxlfNXh94DJx5hr/GNEOnDzhzEp0jknRsDXl1ESJMH3UaJoZcROqRc04KcCOGHBg
         xDlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Rl1DccSSA6ElUwTWPwY0Dr5s4J+vIlJW3i/vZtLO92k=;
        b=zA0YY4UNaSKtZv0z5Np3rB1Mhp3UvvmcRf/9VoE6bmS+iCW1fvqhBCchnhEY0Fjto+
         GJ+fsG9KbAi9kPw+A54AiYsS+OdaR/fWPuiXAGycDdBab7N88gNTWtLaXuoe/CQ77suh
         0+bFHtt1yWvJU2H+FKxe49xIu6I8XuASYsDvJEVcC6eDWljTI3aQO0zexG2vIFRdXdC0
         zuU0tktvjiZvO1YyGwe+lul20OW2lwv8TFV8FlU/+DIDr04JO86ZhQLJCKP+QaFYvNdD
         JeOZ5s5OLPeK5wP38STz6OhabsXwRRw+6xpgw8YsKfMgDKV8t5wl5gGngk9KPqIr+QqW
         Spfg==
X-Gm-Message-State: AJIora8R9sWjWdcR07WdATpBBqBXe4+/4Ss8vwhBfDmgo9qqK5qMJw2i
        7MkMtgaVWTQJCjsJ8vDV1oU=
X-Google-Smtp-Source: AGRyM1vdaWymGGrFew5kRx609FUgDY2Q3HupGEgwT3v0siX2tL2T2Af8FK3Ahn6UWyd1iG/IrmtNsA==
X-Received: by 2002:a17:90a:a08:b0:1ea:f03c:51f7 with SMTP id o8-20020a17090a0a0800b001eaf03c51f7mr2181027pjo.49.1656124709838;
        Fri, 24 Jun 2022 19:38:29 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:edae:5ad3:3d10:1075? ([2600:8802:b00:4a48:edae:5ad3:3d10:1075])
        by smtp.gmail.com with ESMTPSA id i68-20020a636d47000000b003fd1deccd4dsm2276256pgc.59.2022.06.24.19.38.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jun 2022 19:38:29 -0700 (PDT)
Message-ID: <ae27f3a9-6abf-d805-a386-ee42400a99b9@gmail.com>
Date:   Fri, 24 Jun 2022 19:38:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v9 12/16] ARM: dts: r9a06g032: describe MII
 converter
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
        Russell King <linux@armlinux.org.uk>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=c3=a8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
References: <20220624144001.95518-1-clement.leger@bootlin.com>
 <20220624144001.95518-13-clement.leger@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220624144001.95518-13-clement.leger@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/2022 7:39 AM, Clément Léger wrote:
> Add the MII converter node which describes the MII converter that is
> present on the RZ/N1 SoC.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
