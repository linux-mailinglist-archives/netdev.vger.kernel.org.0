Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43DAE52211A
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 18:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347339AbiEJQ0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 12:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347319AbiEJQZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 12:25:57 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256C82CE0F;
        Tue, 10 May 2022 09:22:00 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id a11so15354538pff.1;
        Tue, 10 May 2022 09:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Pbf0U9Vnpx4jkjWp1F0KY1vQuVLo9K0VLSq7N3TN5ZI=;
        b=EBmeLMxb+tNSLdGXw+Plepzz/BILeSIgS8UJ0x0BpAl5rKivDI1nrZd+GPdJx4XC8Y
         d/gVeEcu0rCLMEqAyBI6SwM1vh7bcU1uCDTFcMO5sGdMX9U7N3BuUSJr5DjtH0eiIKt0
         ICapWbtDXO3OVV53RMgKuSOjAGEiDlMHjhKLWi2UFAMeBNpOlPIMlc2w9kEZg3ViJ8es
         gjkprP3QXgUa4PtjxA5AoFKsuZKzF+G3LAzIClkIgpsIBxu62se2rhOCWaZ9FkGpj9I+
         IUQ5tjHGMrPky9ofvVkUaEQmMl3Fjn8JpFSMdJndIHdPeMMHUkpSotU712bPJUZjVIhn
         tvzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Pbf0U9Vnpx4jkjWp1F0KY1vQuVLo9K0VLSq7N3TN5ZI=;
        b=lxNMFVcRqvZMlJxZ8E624o9uFDp02Eg4NdPgdLrkwDvQXUF7/Iwr0MM3s17dlCPe62
         mze2CykSakY+Sqku7GY3ee4kYbsDEXRt26B/EPqbzfNDi4fFIU10WiaSPMQJWwu3S39g
         TrXI1pCGC18vlf84n7ejZwystPY6+roVWKshmR6fDf/t7asz3roplyMMDtPanVO942Rs
         GdVJtw2QT7H6DR4QC/89bKNZcxJ5KOmNFN//MElDXyVTZMkntBNdlBN1qVxStBV3hX6E
         zZEsnNoTUHpy6SF9nbmeg3wXcxbAGIXFD0VHWP9H/7LQUBmdaW/36ijNoaObAAaYEHdJ
         MdGg==
X-Gm-Message-State: AOAM533AM7FeOo7LC9o8idqzSrmKWOWrmvnUGxtKNwsqwqH04Xa+/WZv
        wo/l25aAfzd4b3Ivr5ioqik=
X-Google-Smtp-Source: ABdhPJwTomrdTK6D+UsyoNNSWLOmSNkKE2NiG1YyqE6019zPkmBGLLBGI6NzoahHEx6Fw3YJi73+1Q==
X-Received: by 2002:a62:5ec6:0:b0:50d:a467:3cb7 with SMTP id s189-20020a625ec6000000b0050da4673cb7mr20609487pfb.85.1652199719604;
        Tue, 10 May 2022 09:21:59 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id nn6-20020a17090b38c600b001d8abe4bb17sm2083985pjb.32.2022.05.10.09.21.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 09:21:59 -0700 (PDT)
Message-ID: <ff1e936b-a56c-3177-0fcf-1549c44ac837@gmail.com>
Date:   Tue, 10 May 2022 09:21:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next v4 03/12] dt-bindings: net: pcs: add bindings for
 Renesas RZ/N1 MII converter
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
 <20220509131900.7840-4-clement.leger@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220509131900.7840-4-clement.leger@bootlin.com>
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
> This MII converter can be found on the RZ/N1 processor family. The MII
> converter ports are declared as subnodes which are then referenced by
> users of the PCS driver such as the switch.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
