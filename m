Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C37657F611
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 18:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiGXQ7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 12:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGXQ7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 12:59:21 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A398E028
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 09:59:20 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id c13so1743255pla.6
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 09:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=AXlUp3i+4GE3qxAPmYlb+5CeQNJkVDxjR0wfzW+Ngp0=;
        b=ZYBHdf65uZCxuWrfAAvR/NHUnCxHUQt8FzVv0lZdDHwc12G37VYuImeQcF5ih7NIFr
         5d33dnRH8/RWI0GZabQefz+q81UpNCOtwzsHHefIC05uSUBk9uaHOcHUHPYCSqb9mfmv
         p7uj5PGYOIiWGBvFmM2KTp3YTriGopLTRkqJ9Jj7yQyWwvrf/NYszt3fljdwX+MEfmUZ
         XEF7qKSk+Y2QERyUDQ2VL80MaBeVOKySQzmsX2LgTtuDfRrDWTax3uWwLeoNJEtkTaO/
         8B27RqVGgBwovFlCEVFaNdkieIYeSF5xgwazwy5nlZPC+JFRG+VltlnugBCsbCv2w+ze
         Oa6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AXlUp3i+4GE3qxAPmYlb+5CeQNJkVDxjR0wfzW+Ngp0=;
        b=lYjJ0lLyDR9+R1s8+E0cxzmuGatPe68bibH52NhQ5rdaC2/VFQybTVT/H5qFXEM8uN
         qXOw9IdhxUWxdnjryPLgUeQ8OHFh6rSVOVK85XpwWRZDOeaSWvcg9AilDPRexWYPIFED
         lPlf+FimPI/hKQTQofXfJgI1xxPEgDIb/ZvTaxU76iON2+mjCBXG71fp02pOLTP0Vxts
         VDdkzq1H3d5rvPEau+2TEkS7aTuC/TYYWAO8gr5ct3ffz+ed57xuX+9vKQ0iePzmpRW/
         9rV2Ff/PNm1wp26c3vtOl3FfVb3j2kDXbTdSSQix+esBJe1sZ7JJnWe6HteTrwrQdNh1
         x7SA==
X-Gm-Message-State: AJIora/f3+TvRwUKJ3LR8+ORWfvKDyXEXUf5lxCpJGs33DxYRKcxUJR0
        sbxsYhe9fxB4TWj83AkJxmE=
X-Google-Smtp-Source: AGRyM1vCd2/J2S6cOEZ6Kx0UBZoWHBBPKFl1HrgmsRC7H5RYj08f6AsUpr62E0ALhCdFJsUeOptnkQ==
X-Received: by 2002:a17:90b:350e:b0:1f2:467e:b28 with SMTP id ls14-20020a17090b350e00b001f2467e0b28mr15681812pjb.154.1658681959266;
        Sun, 24 Jul 2022 09:59:19 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:22cf:30ff:fe38:5254? ([2600:8802:b00:4a48:22cf:30ff:fe38:5254])
        by smtp.googlemail.com with ESMTPSA id q3-20020a632a03000000b00415b0c3f0b1sm6773316pgq.69.2022.07.24.09.59.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Jul 2022 09:59:18 -0700 (PDT)
Message-ID: <df5bb0c3-d0c6-9184-5c46-f6888f9c601d@gmail.com>
Date:   Sun, 24 Jul 2022 09:59:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH net-next] net: dsa: validate that DT nodes of shared ports
 have the properties they need
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <20220723164635.1621911-1-vladimir.oltean@nxp.com>
 <Ytw5XrDYa4FQF+Uk@lunn.ch> <20220724142158.dsj7yytiwk7welcp@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220724142158.dsj7yytiwk7welcp@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 24/07/2022 à 07:21, Vladimir Oltean a écrit :
> On Sat, Jul 23, 2022 at 08:09:34PM +0200, Andrew Lunn wrote:
>> Hi Vladimir
>>
>> I think this is a first good step.
>>
>>> +static const char * const dsa_switches_skipping_validation[] = {
>>
>> One thing to consider is do we want to go one step further and make
>> this dsa_switches_dont_enforce_validation
>>
>> Meaning always run the validation, and report what is not valid, but
>> don't enforce with an -EINVAL for switches on the list?
> 
> Can do. The question is what are our prospects of eventually getting rid
> of incompletely specified DT blobs. If they're likely to stay around
> forever, maybe printing with dev_err() doesn't sound like such a great
> idea?
> 
> I know what's said in Documentation/devicetree/bindings/net/dsa/marvell.txt
> about not putting a DT blob somewhere where you can't update it, but
> will that be the case for everyone? Florian, I think some bcm_sf2 device
> trees are pretty much permanent, based on some of your past commits?

The Device Tree blob is provided and runtime populated by the 
bootloader, so we can definitively make changes and missing properties 
are always easy to add as long as we can keep a reasonable window of 
time (2 to 3 years seems to be about the right window) for people to 
update their systems. FWIW, all of the bcm_sf2 based systems have had a 
fixed-link property for the CPU port.

> 
>> Maybe it is too early for that, we first need to submit patches to the
>> mainline DT files to fixes those we can?
>>
>> Looking at the mv88e6xxx instances, adding fixed-links should not be
>> too hard. What might be harder is the phy-mode, in particular, what
>> RGMII delay should be specified.
> 
> Since DT blobs and kernels have essentially separate lifetimes, I'm
> thinking it doesn't matter too much if we first fix the mainline DT
> blobs or not; it's not like that would avoid users seeing errors.
> 
> Anyway I'm thinking it would be useful in general to verbally resolve
> some of the incomplete DT descriptions I've pointed out here. This would
> be a good indication whether we can add automatic logic that comes to
> the same resolution at least for all known cases.

Agreed.
-- 
Florian
