Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B31F655A62B
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 04:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbiFYChL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 22:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiFYChK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 22:37:10 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404A453A79;
        Fri, 24 Jun 2022 19:37:10 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id jh14so3585278plb.1;
        Fri, 24 Jun 2022 19:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bZ2JFBbTQB6o/Oz+F/+cpa+6A/KrtjeFdar/iqFC7ZA=;
        b=gU9UQDyLOUURk2a7jAFY6YKu/uv6pUVmloTv5WV9z2KryrdP55t7JuT/QKgbB2SMHx
         Havlq+PCS58u4GBPwy8foQu1HBthvMFg1233Y+7DsklqIXDd8GYqBZRyBzm49dM7tfzQ
         rkU0vtN8NYfyZxAamS9AILAK7F+U4lyfGQLzdG7dz9m0h53qmFI7cWHwwJ4g6seXKGu+
         dhMxT9XXDcPoFlorjTuko/vg6fFghtt1pvwT2t42K7otslIHkhX2arkSh07KyYYhgE7O
         1VeeGc7dShOUKIaBViDBT11pbeXaOSFXVJkSPgMqpNeudG1KlrtbINpzOe52FpqMXiUC
         urLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bZ2JFBbTQB6o/Oz+F/+cpa+6A/KrtjeFdar/iqFC7ZA=;
        b=2SDHp5pezwrwAOR5r8jLPyeRatlGjA9KdvUaCkd5NOyuwK9+4P3ib263lsQ2T2usWS
         BOo4t/lRZ47GErqp1urP01NbSV4p0UsGmYh6SrHkz0XNVC76ZVY5xHMWl8eeP97C7xIl
         F3c3Jkk5FIabVabYQmVrZzae3v4y+BfoXr7f8AlIjr0QZG+M6C2qmsxI4y9r0RPLIXQ2
         uixMO92U3nTcdegO0XT7PS+ULO/9ip834WBuHbdLnnqoDmDgReoXmmDkoqRvy5SEAK4F
         EUnWnfDkvqVFSegLlzhqOhacNpa3RxiMueOF+NoAFknfdEbftQoNIzfWfQiyRKWIo0dR
         qEUw==
X-Gm-Message-State: AJIora80V4A0EfsXEoVqnihb3gwJxJy1/ULGUJl6doRB9gbT71gzzNAw
        UbstooItowKRoWuSzcfk5fs=
X-Google-Smtp-Source: AGRyM1s5DpbYZjBbrvAk4l9zl4OTQqM5zZ2pFlQVv2eXhouU73BCcAY/NoAWT+/EtkLOYF1howPdwQ==
X-Received: by 2002:a17:90a:4a90:b0:1e8:ad01:701a with SMTP id f16-20020a17090a4a9000b001e8ad01701amr7394781pjh.27.1656124629665;
        Fri, 24 Jun 2022 19:37:09 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:edae:5ad3:3d10:1075? ([2600:8802:b00:4a48:edae:5ad3:3d10:1075])
        by smtp.gmail.com with ESMTPSA id ij1-20020a170902ab4100b00168c1668a49sm2507442plb.85.2022.06.24.19.37.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jun 2022 19:37:09 -0700 (PDT)
Message-ID: <d3aca6d2-9980-383d-eeec-a2194875305d@gmail.com>
Date:   Fri, 24 Jun 2022 19:37:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v9 07/16] net: dsa: rzn1-a5psw: add Renesas RZ/N1
 advanced 5 port switch driver
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
        Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>,
        Phil Edworthy <phil.edworthy@renesas.com>
References: <20220624144001.95518-1-clement.leger@bootlin.com>
 <20220624144001.95518-8-clement.leger@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220624144001.95518-8-clement.leger@bootlin.com>
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
> Add Renesas RZ/N1 advanced 5 port switch driver. This switch handles 5
> ports including 1 CPU management port. A MDIO bus is also exposed by
> this switch and allows to communicate with PHYs connected to the ports.
> Each switch port (except for the CPU management ports) is connected to
> the MII converter.
> 
> This driver includes basic bridging support, more support will be added
> later (vlan, etc).
> 
> Suggested-by: Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>
> Suggested-by: Phil Edworthy <phil.edworthy@renesas.com>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
