Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C77755A61D
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 04:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbiFYCf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 22:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiFYCf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 22:35:28 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C70C3AA68;
        Fri, 24 Jun 2022 19:35:28 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id x4so4070318pfq.2;
        Fri, 24 Jun 2022 19:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=AhW5dPn4vcxyE5LCTzwkvfsWSt6blPNQmQT3nX9+C3w=;
        b=XuwEKU8RHAuR7o3ifTkInF67PIZITa0a2kvZCc90QxhIBMC2IqHqiw8fEJjRuCMd3y
         JggmiEE4efIR9EJ9DyNUSeyvDCOj4scfOGJLYluld84PBcXb+qHNSBGHwJ6w+sPkLINg
         0s4Hpw2CJO740upXABF+S1qMkbgMGcGp+LFWoT5XEsSFK6ftb3UUxu5g+6fWqBRnrG+j
         3NP2QJ2DX2ceylChGRN0K/k9vNKFbvZfF1I176KLd5f1bmEDuIhy7PkVgHRYgYznXTAg
         xJbl/i+xZ0FWdJva1VM9+NCuz1veE08c5fbfGF7fLTfGwtc8Ip5NJxhkltia376D40y7
         2png==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AhW5dPn4vcxyE5LCTzwkvfsWSt6blPNQmQT3nX9+C3w=;
        b=HpoFlHwVlNtGxNfoSwkx3L9xGtw6OEWZOPDIbIWmHmj0wt+uxFQf2E07FnkSd4lK6C
         /3p+q5JiERVM37tYP0YqJaiZD02vctXMULisMviwIf7ktklUsvucqZ3xrieDFqh/DNZE
         f/OQ4D0S/k8uv3qvZu3sGLOjn9A0eWpIJo2f+eL48lFFbuZoMN7d5Ai5KAq9F9ertvxk
         WtQu2vERdoVUPu4QAIIWXfn5WZdPgqFkXxbJ14463zSTvVBHOYei2E90gldvapZP2sLZ
         nKJrENefS64r0dyzaZqvy/vqGtRsWv7o9b9UIQnaiTVBwIlkt1aoPp8RYn9pjjUC5vJO
         x9xA==
X-Gm-Message-State: AJIora/yOVl8ejYxZnEUMXNnUb0Y1tTcSNYlfOiGsGHhZ0una4g3eJHh
        HHJ9V/DXetO5d+gqZOFVsaU=
X-Google-Smtp-Source: AGRyM1usgE6ZETXZYus4hRhHBYQ/PkwVQUz0WxxcgiEgOsNQFCGNtMOkODVCZj8MUiNSUbtu0QUs0w==
X-Received: by 2002:aa7:8a54:0:b0:525:217e:fb29 with SMTP id n20-20020aa78a54000000b00525217efb29mr2001124pfa.45.1656124527587;
        Fri, 24 Jun 2022 19:35:27 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:edae:5ad3:3d10:1075? ([2600:8802:b00:4a48:edae:5ad3:3d10:1075])
        by smtp.gmail.com with ESMTPSA id a26-20020a62bd1a000000b0051c66160a3asm2381948pff.181.2022.06.24.19.35.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jun 2022 19:35:26 -0700 (PDT)
Message-ID: <2b73119a-73e5-c62e-7aef-f941f5262221@gmail.com>
Date:   Fri, 24 Jun 2022 19:35:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v9 05/16] net: pcs: add Renesas MII converter
 driver
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
 <20220624144001.95518-6-clement.leger@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220624144001.95518-6-clement.leger@bootlin.com>
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
> Add a PCS driver for the MII converter that is present on the Renesas
> RZ/N1 SoC. This MII converter is reponsible for converting MII to
> RMII/RGMII or act as a MII pass-trough. Exposing it as a PCS allows to
> reuse it in both the switch driver and the stmmac driver. Currently,
> this driver only allows the PCS to be used by the dual Cortex-A7
> subsystem since the register locking system is not used.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
