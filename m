Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438D3568F1C
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 18:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233615AbiGFQ1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 12:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234306AbiGFQ13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 12:27:29 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0AB27B09
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 09:27:28 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id r2so18934034qta.0
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 09:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OfBOZ4y4VnJEQETKJF+v25EGknGkkpD71yB8k2rSVjs=;
        b=Yfd6+mK6INo6uKnYDW80dmEpedZOkuslw2TkBnxzeEW6OORavuQnZURlsBlpBEQNm7
         9+YWS0ILQ3wvudBDbglPFLtAA6tE/u0wOCZ75+XjYtjBTRwSODMobr0sWCAK8yvUgdCg
         KcoDvJY7WgVLn86syRy2yMRLMJ1rHyp9cmhjFj0uRueEKAi2fhe2eaQHPtMXDl9QzwgD
         MMuQcx0TAC/lRM663n/GJ/10eHOhJdoVJURqmO0KLr02ccEpcsLB2O8i/wVxXHxhc9zl
         r+2RAQMsZJgmk+/e45R9BzXyyVtpCIk1mvKPai60Tth9QxhpNiPl0o7/OseY/Hmhc2j0
         x+Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OfBOZ4y4VnJEQETKJF+v25EGknGkkpD71yB8k2rSVjs=;
        b=Xoqza1oprnOzV6Oz2K0PUgBtUAWvCqlLIPbGLu0XB8d8O5hxyCY4OI2+wviNK8YWi/
         p9ZAbr7gBTCU4LmmrZ/sObqqQE9n7sPWAegcIlWSnVhqUgzt+f48ILslrCyFDjPDK6CL
         Tvvmd2UgpvX0L5kI6SeF8ktcr3+0phFtly/ZK1mwkh40y0jZwhibQQV/FrzsA528Gs5J
         hHh7esh7pkpuErxhUuNacPd/W0vhKaM1Gp940p5CJV7HtaE9wwIIUHlD5rcZkoLqF7oL
         KR1xObngwt3+VagMBD+7xvj5VS+CAEY8Nc6k9OIXAA2BCkD1RRsGTfHnopP/xsYuV1gc
         jGuw==
X-Gm-Message-State: AJIora8AQTl40u7n40itlEeGnUwgL1JfnSZ7Yu3/WR6NBS3d5Ia9BnsC
        Ai55T9N4qMAimTMRFULZIm4=
X-Google-Smtp-Source: AGRyM1tAF5bodD68xq2eUzGaMDiXpqw7KsTWSdoSBoqsGCJmgiwePaU5v3cgVMfITlfbVFQAUUpBgA==
X-Received: by 2002:ac8:570d:0:b0:31d:3d2a:c4b8 with SMTP id 13-20020ac8570d000000b0031d3d2ac4b8mr20898986qtw.61.1657124847975;
        Wed, 06 Jul 2022 09:27:27 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id dt51-20020a05620a47b300b006b539412be3sm1678621qkb.26.2022.07.06.09.27.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jul 2022 09:27:27 -0700 (PDT)
Message-ID: <d65824fc-a139-0430-5550-481dd202ad34@gmail.com>
Date:   Wed, 6 Jul 2022 09:27:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH RFC net-next v2 0/5] net: dsa: always use phylink
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
References: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
 <7fe6b661-06b9-96dd-e064-1db23a9eaae7@gmail.com>
 <20220706101459.tahby2xpm3e7okjz@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220706101459.tahby2xpm3e7okjz@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/6/22 03:14, Vladimir Oltean wrote:
> Hi Florian,
> 
> On Tue, Jul 05, 2022 at 09:42:33AM -0700, Florian Fainelli wrote:
>> On 7/5/22 02:46, Russell King (Oracle) wrote:
>>> A new revision of the series which incorporates changes that Marek
>>> suggested. Specifically, the changes are:
>>>
>>> 1. Patch 2 - use the phylink_get_caps method in mv88e6xxx to get the
>>>      default interface rather than re-using port_max_speed_mode()
>>>
>>> 2. Patch 4 - if no default interface is provided, use the supported
>>>      interface mask to search for the first interface that gives the
>>>      fastest speed.
>>>
>>> 3. Patch 5 - now also removes the port_max_speed_mode() method
>>
>> This was tested with bcm_sf2.c and b53_srab.b and did not cause regressions,
>> however we do have a 'fixed-link' property for the CPU port (always have had
>> one), so there was no regression expected.
> 
> What about arch/arm/boot/dts/bcm47189-tenda-ac9.dts?

You found one of the devices that I do not have access to and did not 
test, thanks. We do expect to run the port at 2GBits/sec on these 
devices however there is no "official" way to advertise that a port can 
run at 2Gbits/sec, as this is not even a "sanctioned" speed. I do have a 
similar device however, so let me run some more tests, we won't see a 
regression however since we do not use the NATP accelerator which would 
be the reason to run the port at 2Gbits/sec.
-- 
Florian
