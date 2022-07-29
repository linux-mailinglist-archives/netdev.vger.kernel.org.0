Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6845856A2
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 23:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239438AbiG2Voo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 17:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239328AbiG2Vom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 17:44:42 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE118C3EC
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 14:44:41 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id y1so5692013pja.4
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 14:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=AG3Cx+REcnvB64RcYdxCO+ogkVVrATf2Cm8UsJip7n8=;
        b=qcVn7NVgWMhCk1kqhTLSvEcmsNod7ME112oa2+l5etGV2KDacouTw/7l7btXJeriOA
         k1WCyjdT6Yw3M6blvAMooeUnjlkQKtLspYuJsmAneOqwCBshMf82YpTLPbZncB+pFA0N
         fxWvudoyqQw6DuUXKAnf82cD0/qL5kuymxmADSGKTMu8NYcBCJgyJ/0JZNMAXEVPkbkB
         Gi2vIGOe2+NLnKgx1geLWa/ZNpCKikAE6Y3LgArYqNBNS7mfgRJpemW2CfgKJhvfyPDB
         UaIwMpm4FIq2cGzhLtKN8e48lCNiQagC7drHH1k23FcWV9XAOqYSMPeWaQboYV7K8JyQ
         f46Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=AG3Cx+REcnvB64RcYdxCO+ogkVVrATf2Cm8UsJip7n8=;
        b=P2KY+vCgroZqGTuqqPpCuK4kGmAAExiQqZC0I1fjfnLxkLR6bgZtaGb9SxsxoY3H8M
         UAj7Nt78qrgojytxeM51UxEet/8OIKIFrC2X8HD55S2OrKZl4d+G5SCfw1/ABpw0sk03
         c9WrR7oKsRpI2uNpkjtu3Mpn1EjxM8Na12WfTjWbhGl73ZKk+gGwol+lGpIhGwKvTf/P
         D4Klq1a7wGJ+1P/jkMrh/WUnBXmgqSQZY9Ee1DfQg0COa4xYk4ZqItYr2Sf+l1+GXBkk
         i0q9q0J0pWj9IQhzFXrlG//kBrgm+NrT8+XXftdC+3ZlfJyx7w88J+Rox/HwuzHaOTDM
         U9iQ==
X-Gm-Message-State: ACgBeo2DP/ArtW8uvbwf4WK8Vh0qQl3/3mBf/Upm4ZIMpk89FBuoM7l+
        sJdas8cVbPXvi0LUGbMWGcg=
X-Google-Smtp-Source: AA6agR4PW95eagQiD7IusIUn/wB3aJsZu1Buaf3jbAWPl47I84swE4dul1jn+xpZ7WCkMsaSver71w==
X-Received: by 2002:a17:90b:3c05:b0:1f4:ca8d:c05e with SMTP id pb5-20020a17090b3c0500b001f4ca8dc05emr1826444pjb.113.1659131080671;
        Fri, 29 Jul 2022 14:44:40 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u17-20020a170903125100b0016db43e5212sm4107624plh.175.2022.07.29.14.44.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 14:44:40 -0700 (PDT)
Message-ID: <2a159954-7175-b747-a53b-0282998eec90@gmail.com>
Date:   Fri, 29 Jul 2022 14:44:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 net-next 4/4] net: dsa: validate that DT nodes of
 shared ports have the properties they need
Content-Language: en-US
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev <netdev@vger.kernel.org>,
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
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>
References: <20220729132119.1191227-1-vladimir.oltean@nxp.com>
 <20220729132119.1191227-5-vladimir.oltean@nxp.com>
 <CAPv3WKe7BVS3cjPws69Zi=XqBE3UkgQM1yLKJgmphiQO_n8Jgw@mail.gmail.com>
 <20220729183444.jzr3eoj6xdumezwu@skbuf>
 <CAPv3WKfLc_3D+BQg0Mhp9t8kHzpfYo1SKZkSDHYBLEoRbTqpmw@mail.gmail.com>
 <YuROg1t+dXMwddi6@lunn.ch> <7a8b57c3-5b5a-dfc8-67cb-52061fb9085e@gmail.com>
 <CAPv3WKcoi8M6WmEtUXAObhRjJmR3jm7MguWUyw=RJQfNnt7c6w@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CAPv3WKcoi8M6WmEtUXAObhRjJmR3jm7MguWUyw=RJQfNnt7c6w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
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

On 7/29/22 14:33, Marcin Wojtas wrote:
> pt., 29 lip 2022 o 23:24 Florian Fainelli <f.fainelli@gmail.com> napisał(a):
>>
>> On 7/29/22 14:17, Andrew Lunn wrote:
>>>> What I propose is to enforce more strictly an update of DT description
>>>> with a specified timeline, abandoning 'camps' idea and driver-specific
>>>> contents in the generic code.
>>>
>>> Regressions are the problem. We are supposed to be backwards
>>> compatible with older DT blobs. If we now say old DT blobs are
>>> invalid, and refuse to probe, we cause a regression.
>>>
>>> For some of the in kernel DT files using the mv88e6xxx i can make a
>>> good guess at what the missing properties are. However, i'm bound to
>>> guess wrong at some point, and cause a regression. So we could change
>>> just those we can test. But at some point, the other blobs are going
>>> to fail the enforces checks and cause a regression anyway.
>>>
>>> And what about out of tree blobs? Probably OpenWRT have some. Do we
>>> want to cause them to regress?
>>
>> No, we do not want that, which is why Vladimir's approach IMHO is reasonable in that it acknowledges mistakes or shortcomings of the past into the present, and expects the future to be corrected and not repeat those same mistakes. The deprectiation window idea is all well and good in premise, however with such a large user base, I am not sure it is going to go very far unfortunately, nor that it will hinder our ability to have a more maintainable DSA framework TBH.
>>
>> BTW, OpenWrt does not typically ship DT blobs that stay frozen, all of the kernel, DTBs, root filesystem, and sometimes a recent u-boot copy will be updated at the same time because very rarely do the existing boot loader satisfy modern requirements (PSCI, etc.).
> 
> Initially, I thought that the idea is a probe failure (hence the camps
> to prevent that) - but it was clarified later, it's not the case.
> 
> I totally agree and I am all against breaking the backward
> compatibility (this is why I work on ACPI support that much :) ). The
> question is whether for existing deployments with 'broken' DT
> description we would be ok to introduce a dev_warn/WARN_ON message
> after a kernel update. That would be a case if the check is performed
> unconditionally - this way we can keep compat strings out of net/dsa.
> What do you think?

A warning seems fine and appropriate to give just the right amount of nudge to get things fixed, I would not as far as a full backtrace WARN() because those will definitively upset people's CI in a wayt that seems a bit over reacting. Anyway I do have my share of DT blobs to update.
-- 
Florian
