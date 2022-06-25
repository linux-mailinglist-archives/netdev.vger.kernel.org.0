Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5674C55A62D
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 04:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbiFYCiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 22:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbiFYCiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 22:38:51 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC503BA7D;
        Fri, 24 Jun 2022 19:38:51 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id k12-20020a17090a404c00b001eaabc1fe5dso7329466pjg.1;
        Fri, 24 Jun 2022 19:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fOgjuDzPZVt/q69/LO7Flq6m00+TfHUL7No44QTlZ+U=;
        b=f9LsBcMVMU2ESn2LtZ7VVBQktDhJ125N5eJrnokuNutaWjeo5eyFlhtt1qTCUsVLRs
         JksT6pKgZpMVBexcXTPDoWn8Rs/cMio7fnEiWWdA5H82eoMQHetzb2YJv1GteKmwIY3E
         S/QirS8uPj2GXvNSx+867aWhVtf7ij0Jk+0HWlY+rbdkYk54cr4VeKdwWBmHJmKqzbqP
         ln/0klZRkHPuthsRKqFhtAxMa3m5uTVXZ3UFvJ+v8p4RyDvBe9IdDHNOueBS2DaJHHEk
         G/pAWBxNAySXJWwGQGpytXmoTejB3K/gZnwRkrhXMNbm5XHBCphoAwhjnvb0WiVfG9zI
         bm2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fOgjuDzPZVt/q69/LO7Flq6m00+TfHUL7No44QTlZ+U=;
        b=fRamvy43sFFBiadtevOLRYHxK7D6j3Vhj/e2iN+d5bQChYz2aais6oOm5Y5FCzVdv+
         aho6NZom6RLIEv0tYxE/wUSHuG0l6weM1A5zNVm3rZOBcv3CFYI1KN1r88zPl0ouEvmP
         ASQoefWnQVvEVoY8HvuRBe/EKMKRWvCJ5axwl05YpuSh3lt8/V/wrRhEvLp/sNmCUEyX
         a/cytEJWGGX3YL7Nz6KP7DbBFPJmHHXYLHkXXfej5EdpgaDniNK47rWbcRHsP10neagK
         hSMqszjDHd3Pf2OWB/S3DLXs301GeptrkPOt8b4zqvjzxqA+XO7Hfs7srp5Ne4n4yzUk
         khdQ==
X-Gm-Message-State: AJIora/62hR08rD3siSJD7N4s2ndIfRLjic+FfIKgrLjtBrP7MsMVJdV
        /OCxWfhrY1PV9mX5e48souo=
X-Google-Smtp-Source: AGRyM1sJb+8DwmNwylzoYNdQcm31CTH1xkGiZjbmgS9tRMZP3FjQpxVADRE27etrfrjJNDd0pOa3IA==
X-Received: by 2002:a17:902:ccc4:b0:156:5d37:b42f with SMTP id z4-20020a170902ccc400b001565d37b42fmr2181474ple.157.1656124730783;
        Fri, 24 Jun 2022 19:38:50 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:edae:5ad3:3d10:1075? ([2600:8802:b00:4a48:edae:5ad3:3d10:1075])
        by smtp.gmail.com with ESMTPSA id b8-20020a17090a010800b001ecd9a69933sm4669327pjb.34.2022.06.24.19.38.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jun 2022 19:38:50 -0700 (PDT)
Message-ID: <dd4326e3-9d32-dd9c-04be-6919aa3f7118@gmail.com>
Date:   Fri, 24 Jun 2022 19:38:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v9 13/16] ARM: dts: r9a06g032: describe GMAC2
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
 <20220624144001.95518-14-clement.leger@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220624144001.95518-14-clement.leger@bootlin.com>
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
> RZ/N1 SoC includes two MAC named GMACx that are compatible with the
> "snps,dwmac" driver. GMAC1 is connected directly to the MII converter
> port 1. GMAC2 however can be used as the MAC for the switch CPU
> management port or can be muxed to be connected directly to the MII
> converter port 2. This commit add description for the GMAC2 which will
> be used by the switch description.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
