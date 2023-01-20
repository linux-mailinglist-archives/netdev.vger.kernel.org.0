Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054DF675C7C
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 19:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjATSMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 13:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbjATSMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 13:12:05 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABF07B2E3;
        Fri, 20 Jan 2023 10:12:04 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id h5-20020a17090a9c0500b0022bb85eb35dso1289138pjp.3;
        Fri, 20 Jan 2023 10:12:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hho9/wgvGQ9svaK/5fZQfZ+rSQtb/lCF12NvQ5zzsS0=;
        b=Ci2qTDtkaTtOdztcEnTlSnK7FyOpejqRXsgG953VY1gsKf192FjDyBsnul1w7orrx2
         ZBjF9qXbWWUHxRaf+vrkQ4hk8YveJegcrAMHKNtV1+ZH3JScv5usjTDrrmqqe8c24mok
         V729t2P/luJkKM66jGu5FyDICaS+ZnsJasJeTtQmwSmZ3t8ePUBrC/UwYloez/+qwQvZ
         3McF4X0btfg6MWNHuQDp8FK7bbJ7BM+59WFKPbE8UD+s/xNbtnzvcJUl3X0ZtZ+8MZzG
         lso5jsYQQx6FdzegCY3GXg6oOrJ1a3kmuY5PR09d42YterpHIygeYe/X52iqdGe9SsYW
         0pzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hho9/wgvGQ9svaK/5fZQfZ+rSQtb/lCF12NvQ5zzsS0=;
        b=ZLqtcayZfBAgHhxf6Q13hMWfdL1msOSlDIJPjiBbjvKf+sp4f7Whm7w3iFwRQzwDxu
         lm0CAWzaQatvRYg+jIq03qhOJA8zqKuciXc8wv5VZ3nqui2WCVCXEZcJKhsd2+tnqBOH
         EKzclevQ2cbymFZIHNXicivakfx7SSyCUOn7uFclnyBrn9LKWlhUoeuvhMZ5VTj+vRo7
         QGYGA4MeP+yJ8XJ3RoS1OVNZwjTZ4KTEpfroo+qFvLkB4f8DVElGZKdTW6hn+FlR8l8x
         I+lr+YWfRn0gpVd/12JIBgxKjatoXacSrADnPwYZ2ntrAkVYBTTtR4fJKoBX/5cvrJ1R
         yHFA==
X-Gm-Message-State: AFqh2krmPPsmTUrl3bh1cPUFFjt1uvJHi4kNpyYj6voVlHqTa09r2NPq
        TfMZeEwGDC/JLnc1Kqi0AtnOdECBrTE=
X-Google-Smtp-Source: AMrXdXtdjHdvlLSUZbANAKsuDLgY0blFVWOcMjh+bJq9QL5NDAGyVQXQ90n/4iXxhXI3eWKlxEKezQ==
X-Received: by 2002:a17:902:aa05:b0:193:335a:989e with SMTP id be5-20020a170902aa0500b00193335a989emr16471296plb.25.1674238323685;
        Fri, 20 Jan 2023 10:12:03 -0800 (PST)
Received: from [10.14.5.12] ([192.19.161.248])
        by smtp.gmail.com with ESMTPSA id w3-20020a170902e88300b0019311ec702asm5588617plg.36.2023.01.20.10.12.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 10:12:03 -0800 (PST)
Message-ID: <8c43b018-8979-e93b-cc19-76de6f8b60d1@gmail.com>
Date:   Fri, 20 Jan 2023 10:12:01 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH net v2] net: dsa: microchip: fix probe of I2C-connected
 KSZ8563
Content-Language: en-US
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oleksij Rempel <linux@rempel-privat.de>
Cc:     kernel@pengutronix.de, ore@pengutronix.de,
        Arun.Ramadoss@microchip.com, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230120110933.1151054-1-a.fatoum@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230120110933.1151054-1-a.fatoum@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/20/2023 3:09 AM, Ahmad Fatoum wrote:
> Starting with commit eee16b147121 ("net: dsa: microchip: perform the
> compatibility check for dev probed"), the KSZ switch driver now bails
> out if it thinks the DT compatible doesn't match the actual chip ID
> read back from the hardware:
> 
>    ksz9477-switch 1-005f: Device tree specifies chip KSZ9893 but found
>    KSZ8563, please fix it!
> 
> For the KSZ8563, which used ksz_switch_chips[KSZ9893], this was fine
> at first, because it indeed shares the same chip id as the KSZ9893.
> 
> Commit b44908095612 ("net: dsa: microchip: add separate struct
> ksz_chip_data for KSZ8563 chip") started differentiating KSZ9893
> compatible chips by consulting the 0x1F register. The resulting breakage
> was fixed for the SPI driver in the same commit by introducing the
> appropriate ksz_switch_chips[KSZ8563], but not for the I2C driver.
> 
> Fix this for I2C-connected KSZ8563 now to get it probing again.
> 
> Fixes: b44908095612 ("net: dsa: microchip: add separate struct ksz_chip_data for KSZ8563 chip").
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
