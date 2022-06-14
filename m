Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEAF54BD0A
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 23:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358161AbiFNVuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 17:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244679AbiFNVuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 17:50:50 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5627E51E6E;
        Tue, 14 Jun 2022 14:50:49 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 3-20020a17090a174300b001e426a02ac5so289931pjm.2;
        Tue, 14 Jun 2022 14:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=534jnMyjXJDH5tPiIXsvqj1wFYhLOPR/YzW0AR/zg9s=;
        b=Q5Ydc4v2Vwx66cKkGuC1yT3NCR/kREYjujI/wunEaT5V6vVKi3ndzh12gxALB0biRV
         qTwZ3JdJkaMisj/xDmm0by5duv6+sMTfTmr/rT+0bT02WwwZCMxsik69zJYRV6jXwgxT
         nmy/Z5wbvCgMeThQP2wtPYy7aZN2hmTlfrMJrjbUK+Dya93TReAT8bNg+iq3r9f8ch+l
         D8eBMqZTdFv3UQ+TjKX5AwxiIkPXutG9E1rQyOHVqIlI13NoNoUc7FOtYR7G9oV8eSe1
         D1MAouCbMh27wrPqEDlpW9N6ej1/ujFnugAuLgH/QVqjNhoMBHFLcsmElMkV8d59Nkv7
         GGNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=534jnMyjXJDH5tPiIXsvqj1wFYhLOPR/YzW0AR/zg9s=;
        b=tcGEFq2Mf4vMRRga++u70o+Bt6R+fhbDa/clcogUQoSbpRWlapXfgeDDZeLk5HY1Y5
         Bjs9pBOsi0LeBgtE55Lqcyvz4zBeQNNlb//juDKtD45DvvsE67s4S8CUztEegUwAmnSo
         Tghlu3aYJIB7IpviBIiHIki7rybB379AjoOTLkKcPgSsyuSbY96qQqTkHxgDzQkfdgls
         EwhZsckGp0juL/re1hXCG5ziya2UHDr1dYRmuJI3MdKw9QpK1f9LWz7sBy0WP6jykjrE
         QHI6vkurP/9rBuPeYVCSYtk06FpbHyZUy3MLrgDUtvxV9bOh1w9MZolvEsltRSsCK7HA
         K8Nw==
X-Gm-Message-State: AJIora/Pu18ju30CF6dP0bN6qfLY/f7AjwTZwodmpVELZOdWwEeJ1wzF
        oNM2Ac44Jl5DQo/9lSC77+Q=
X-Google-Smtp-Source: AGRyM1ticwDyN2sU2z5tvM3A3l7+/Y2FVdTBc/IbhqMWkuEjyWy0emkjO9z7U6RLRnuz2aLJEoh6rQ==
X-Received: by 2002:a17:903:2483:b0:168:c4c3:e895 with SMTP id p3-20020a170903248300b00168c4c3e895mr6115763plw.0.1655243448813;
        Tue, 14 Jun 2022 14:50:48 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id jc14-20020a17090325ce00b00163d76696e1sm7718805plb.102.2022.06.14.14.50.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 14:50:48 -0700 (PDT)
Message-ID: <46c9e73a-500e-66ed-9879-f41ad6e00ecd@gmail.com>
Date:   Tue, 14 Jun 2022 14:50:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH RESEND net-next v7 11/16] dt-bindings: net: snps,dwmac:
 add "renesas,rzn1" compatible
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
References: <20220610103712.550644-1-clement.leger@bootlin.com>
 <20220610103712.550644-12-clement.leger@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220610103712.550644-12-clement.leger@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/10/22 03:37, Clément Léger wrote:
> Add "renesas,rzn1-gmac" and "renesas,r9a06g032-gmac" compatible strings.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
