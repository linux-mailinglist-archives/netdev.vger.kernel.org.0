Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD78522110
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 18:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347301AbiEJQYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 12:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347283AbiEJQYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 12:24:33 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6512A18A9;
        Tue, 10 May 2022 09:20:35 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id gj17-20020a17090b109100b001d8b390f77bso2435476pjb.1;
        Tue, 10 May 2022 09:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JTDKW3zTfzDJsAmgC+ubkiJdvpO7xvaogb5PEtcI/Jc=;
        b=LOK1arc2RFcfBI6fm5RGbi46GsRR5joJ0e3/aIjav2lWiOnkhhZ6n+dno1JPuGPz24
         IxPOIkDKxCnYTp1S+9XxjBoEKxq4iNoy35eaqJhifoc3+A5z707ZYh0Y/DrCvoCpstxE
         JUPYa48ANPzeqM1ANxUsy2mbYy3CFrC8QDVrj02RpGcRptjg4Q4wy9uIsZMd7cGdgOpT
         VTql6ZLws8REu3gDWu7KuidiPsJXNOoiVgEVnepRZa8jzcqp/TgQtpN7QEump6vlBLMW
         fcjkRV4MD5Fe35nM7ffdsx0LDJmeRpx6O9o3kmDMpR5zuIbPjKKO+cbCsyr2nbzsn1RU
         yUiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JTDKW3zTfzDJsAmgC+ubkiJdvpO7xvaogb5PEtcI/Jc=;
        b=HmaRK/biZn0bkP0Gfjt9RuJvSrYfWcb6dZuE+GSExFvMqFVQe+a4jdkiGOWiSrivxi
         k+dRxagFvk5VUJKawfkGOPlz8yb2e0dVRm97TJHwJlVdWuiEEldwb6ebanCwJAEQ+J/H
         Xt5zIgiISBaUv8JonLb2SbaP658qM0/8XfRkqGNUAUYpbxBUaz3Mux2asVUdT5rYR5EE
         LHevaxT17wJaroI6ml3qNKVEkwhyyJpAbGbqns70qF1PJ8cM/Hqzy4LgHbvqxyrERw0O
         ZxiqrtayHdqI4JtY3/M4Jm8NSfFKF343vBnEqK6pxhjjuUSxeZ3esGY9BLs9Gb0/Xc+Q
         RplQ==
X-Gm-Message-State: AOAM531eC2EwIvIEIVM8kFMqwkxI//BTMYUpWxActgnPAMvTETVu8Efa
        KBwJeUjSKIg441EHJKBbk6U=
X-Google-Smtp-Source: ABdhPJxGOIa07E4HYCiT2rECsBBRxdIB1gn1xzzk6Oc4sJL38iLR1SHF0i06C4ndD4tuFNsrLdYT8Q==
X-Received: by 2002:a17:90b:3445:b0:1d6:91a5:29fe with SMTP id lj5-20020a17090b344500b001d691a529femr729842pjb.138.1652199635172;
        Tue, 10 May 2022 09:20:35 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g8-20020aa78748000000b0050dc762817bsm10795496pfo.85.2022.05.10.09.20.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 09:20:34 -0700 (PDT)
Message-ID: <130a1b01-5777-c8b4-ca0f-0342c502a97a@gmail.com>
Date:   Tue, 10 May 2022 09:20:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next v4 02/12] net: dsa: add Renesas RZ/N1 switch tag
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
 <20220509131900.7840-3-clement.leger@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220509131900.7840-3-clement.leger@bootlin.com>
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

On 5/9/22 06:18, Clément Léger wrote:
> The switch that is present on the Renesas RZ/N1 SoC uses a specific
> VLAN value followed by 6 bytes which contains forwarding configuration.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
