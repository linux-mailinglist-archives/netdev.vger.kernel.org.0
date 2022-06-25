Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C3755A624
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 04:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbiFYCkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 22:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbiFYCkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 22:40:06 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E2760E16;
        Fri, 24 Jun 2022 19:40:06 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id a11-20020a17090acb8b00b001eca0041455so6465955pju.1;
        Fri, 24 Jun 2022 19:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=HDcuGmdEJPjYJ8xyZzVCZ34wGorcrWsLrP0TcStyIDc=;
        b=H8Fg5efefLr38e5HBlnt8y+P6HIRWd5N8+heYgU29UAjguRYsuoZkhH6oG2mjAlg6z
         /WtmeRQQRRJafhqAHkQjmSaX0JrxoWwFLSOIMrhYChW+ehWgt3JESegQ0XX0jGpKqCEK
         vAyIGAq0cf9NJH0rVqcgrRjX0+Y5rLyVBv80gCNltXc7GRX8lkpdG02xAtLKm0xygXwR
         HBOJ256W6P8smV74nif5aCk4QGHoUr0kTktnB2aSqhOHdqD7jQpptUBdU1dndkw2zHq9
         aCfd77WepwECJkV/W0HqF7Ov0aRx1fqQC62i3U3Svum2dNDUvRlHr39IQ7vn8JtAihEt
         X+nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HDcuGmdEJPjYJ8xyZzVCZ34wGorcrWsLrP0TcStyIDc=;
        b=KXuoR/LREZiu+gRzNmqXlheS78B4+vR3+2vEmuXNS8Gmt3p+7GR1oyY6aM1YvUAmZY
         IbQ3YimNCi+YN53de0NJfKg+INEIREe/VWljNFw+wjPZa4rr3nLsZ2KdSSrVuEIxlV+z
         jljhDDbffQrLngy9ZMSoxGfLt+wredPQ7oalUVX/9GtXSRUU85AHJFnXKP7BGOIqCEwa
         zKdfxohE/u6I+TL4kiyEa7ClLHY/ooIcFWVBWOZCQbhq3YGoMJi3vcv6XI5WZMkhyxOr
         Q/+FdD2be15ZIzG6+Wom8J3OAF/xx+QkDkuPAYWqNO1Mt7Z6chX5k+tCeGO1jRCLUblG
         FbEA==
X-Gm-Message-State: AJIora+bCA+A2LLn8dA3kUOec09xI1RoGwfYle+CieXjW/n0smsAv7Wb
        D/AP4YKi27q3XUs34bZchUQ=
X-Google-Smtp-Source: AGRyM1tOBmd4L43N9HbayQSoq747LhviG51zoGht0eLNqkVxb7H0EzM9XOSN1cvmX+UFsdXxr98SSQ==
X-Received: by 2002:a17:902:ef8f:b0:16a:728b:795d with SMTP id iz15-20020a170902ef8f00b0016a728b795dmr2251632plb.84.1656124805583;
        Fri, 24 Jun 2022 19:40:05 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:edae:5ad3:3d10:1075? ([2600:8802:b00:4a48:edae:5ad3:3d10:1075])
        by smtp.gmail.com with ESMTPSA id i16-20020a17090a7e1000b001e2afd35791sm2523536pjl.18.2022.06.24.19.40.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jun 2022 19:40:05 -0700 (PDT)
Message-ID: <475ea399-5bdf-1c71-5e10-8c7b201212ba@gmail.com>
Date:   Fri, 24 Jun 2022 19:40:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v9 15/16] ARM: dts: r9a06g032-rzn1d400-db: add
 switch description
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
 <20220624144001.95518-16-clement.leger@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220624144001.95518-16-clement.leger@bootlin.com>
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



On 6/24/2022 7:40 AM, Clément Léger wrote:
> Add description for the switch, GMAC2 and MII converter. With these
> definitions, the switch port 0 and 1 (MII port 5 and 4) are working on
> RZ/N1D-DB board.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> ---

[snip]

> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pins_mdio1>, <&pins_eth3>, <&pins_eth4>;
> +
> +	dsa,member = <0 0>;

Does not hurt to have it, but not required at this point. Not a reson to 
spin a v10 though:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
