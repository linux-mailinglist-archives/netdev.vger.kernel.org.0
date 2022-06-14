Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2388F54BD00
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 23:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358251AbiFNVvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 17:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358246AbiFNVvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 17:51:01 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C822E522D0;
        Tue, 14 Jun 2022 14:51:00 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id z17so9719881pff.7;
        Tue, 14 Jun 2022 14:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=DdiU4z+su+Aykj01hg8vIOLoe2+XDYXw9wc9xiDbsWI=;
        b=AuqiuSMN5MSp6ls0luhwmIaWF6Xt5e1j5NtOpH+BG5C2qQ0Alg+B7i0MDm2Wtsn3wB
         OEuzLKGipNBRaTU8rFqueAMORPUGsjV0d/Z90ejlJMEmYwnfSbdsQu4m6YE2uvztixeL
         eE13JMUvqevDQH3RBS5gOtE8S2k6QR/iBWuVH7e/7Zhwbzwvt6nmU9hI+Tuzizr6v1vX
         XN/sBfmuCQ8ntW2wn27SAFK3nTdGV3lxzVPu0K3MMkQVvfu+26OYquE9C0nozcq/tnro
         J3igX9L6CUQXisxUgJcbxK4/J8Krmrs/qEgdEg8R3v2MUrS54Amq8m+EbcQH+FEojEH/
         +ogw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DdiU4z+su+Aykj01hg8vIOLoe2+XDYXw9wc9xiDbsWI=;
        b=rF+mrXhrltkXiZCKI5wtJlV4UZudjro0LqARtaukGxuoaOSOz6gn7OWB0mFiEnclCu
         TmrIXd9fQb0CcGW8ArmjOyqpjD0Rei757IfweJUYct7fsMTfvNPpM9QkhqrkNoBI9ldF
         f95QqJjrgZqvvi5fKVGZ8U26qV9rIQCAmuAA6xPeKxkkOJGdLVl1mdEN9RukQejLGkCa
         LFdCADaTH+VsxqgWNrTrP18xydFQaNMB2G1che3uPxEz/u27/X54oJn2YsGxcwm0WYtG
         IQQDw4PJOMUkT4pfiykJe07tZ00wIa9nf1FOC7EunOew8GlFf8uiEq2pMf0oAKg6ustn
         tKWA==
X-Gm-Message-State: AOAM532+Ha9xtFl0eDd8Ovy0tNcaSkgQP4WUPVjtv6e0XC+PpYDzVQcg
        BXixyYCbIw8o1glO5kUfVS0=
X-Google-Smtp-Source: ABdhPJzDlgVRxOW+j9yp1YHgAe7h27C7K7NKmQZcbzMb8fYcSCJEctLwR4WZqvNL1coMpbptILfNrw==
X-Received: by 2002:a63:86c3:0:b0:3fd:9c06:ee37 with SMTP id x186-20020a6386c3000000b003fd9c06ee37mr6041699pgd.357.1655243460199;
        Tue, 14 Jun 2022 14:51:00 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ep11-20020a17090ae64b00b001eab4d6de9esm3911689pjb.3.2022.06.14.14.50.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 14:50:59 -0700 (PDT)
Message-ID: <e0a11fd8-09a8-3272-af1d-58f36a09b722@gmail.com>
Date:   Tue, 14 Jun 2022 14:50:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH RESEND net-next v7 10/16] dt-bindings: net: snps,dwmac:
 add "power-domains" property
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
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Rob Herring <robh@kernel.org>
References: <20220610103712.550644-1-clement.leger@bootlin.com>
 <20220610103712.550644-11-clement.leger@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220610103712.550644-11-clement.leger@bootlin.com>
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
> Since the stmmac driver already uses pm_runtime*() functions, describe
> "power-domains" property in the binding.
> 
> Acked-by: Rob Herring <robh@kernel.org>
> Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
