Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6937585678
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 23:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238817AbiG2VY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 17:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbiG2VYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 17:24:53 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B838BA8B
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 14:24:53 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id q22so1902745pfn.9
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 14:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=HlhQSe8JPPoTM03QiXKr5nJRIJvrGI/Hcq4MVfHK348=;
        b=QOMYUzuket6dH7SDS7xe+hU+0Yhp4/priRyU+ohixnUfONm9/g6q8g1ldqh4Q+4gJB
         Pajt+LR8Ucs+nfUcN0HMaKV3TX5KByzstl0t9PwtGAqDI7O0f8SU0rw2WR3Tyi8pKnzk
         zknt/iBT08xtufjXRQw2UhTmOgcpfwtYUXi0oraQM/J7WHDb2sDl9zhlXdzpwZc58697
         JzBoqqirF42EukU59uqRJ3DUqEhv7oXRUmu9GA0DzIHCSbc6Svw73+Op5dKn8BcXPCEl
         W5Qzs9ll+btJpy+O7Z5ejjTL1gs3JMeNARp7+F6/3+sVy96bVb0aJeNhznbwbYbUY6N3
         w4sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=HlhQSe8JPPoTM03QiXKr5nJRIJvrGI/Hcq4MVfHK348=;
        b=2SWeJXsX340C13HzImvqt4ms2M1I0i8Gk+zYpeJolRQ/2Hdc0AWeHCxM0kRA0Nq48P
         lZUaAFcfxkcbjcV4dhnC3R6Ae+U+A2UaiNuRN5HQZZZfqQg+rtyi8VnGcVyoXsooHMD3
         6W4/PACNdViae3g3saFfzmHvYhLpa0l3AUtAu43hNjlDPjcMsH/H/n0CaDPRPX0gbFg0
         HJ1RkA6cqxnskKaYE0jgEcbuO010l5FoqI3IAMIWZbDGkUJTLSbEP+kaVfRqAXMuJvy0
         pMa0h5bmAGnXoAZDdZxjUMU3KOFQ66hQj47QH0KdUn+xBcIhiR1yyvpj9qvDCuG8tefG
         2+4A==
X-Gm-Message-State: AJIora+V7eBSMpH8PT4UCvrObZInA+M8G4/dw7eQaJLWZYhHfl1loynR
        Pj6ecRzzEndB0gz4M0UKkww=
X-Google-Smtp-Source: AGRyM1v9JQmhwmLxF/pNl4Oi0hElUuZDK37M3RjSY7L9X/8LbECve9rKXQzkSymYU+vIv225j2tEsA==
X-Received: by 2002:a63:b15:0:b0:41b:3459:e8a5 with SMTP id 21-20020a630b15000000b0041b3459e8a5mr4410140pgl.454.1659129892454;
        Fri, 29 Jul 2022 14:24:52 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id md14-20020a17090b23ce00b001f29ba338c1sm14948100pjb.2.2022.07.29.14.24.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 14:24:51 -0700 (PDT)
Message-ID: <7a8b57c3-5b5a-dfc8-67cb-52061fb9085e@gmail.com>
Date:   Fri, 29 Jul 2022 14:24:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 net-next 4/4] net: dsa: validate that DT nodes of
 shared ports have the properties they need
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Marcin Wojtas <mw@semihalf.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
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
 <YuROg1t+dXMwddi6@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YuROg1t+dXMwddi6@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/22 14:17, Andrew Lunn wrote:
>> What I propose is to enforce more strictly an update of DT description
>> with a specified timeline, abandoning 'camps' idea and driver-specific
>> contents in the generic code.
> 
> Regressions are the problem. We are supposed to be backwards
> compatible with older DT blobs. If we now say old DT blobs are
> invalid, and refuse to probe, we cause a regression.
> 
> For some of the in kernel DT files using the mv88e6xxx i can make a
> good guess at what the missing properties are. However, i'm bound to
> guess wrong at some point, and cause a regression. So we could change
> just those we can test. But at some point, the other blobs are going
> to fail the enforces checks and cause a regression anyway.
> 
> And what about out of tree blobs? Probably OpenWRT have some. Do we
> want to cause them to regress?

No, we do not want that, which is why Vladimir's approach IMHO is reasonable in that it acknowledges mistakes or shortcomings of the past into the present, and expects the future to be corrected and not repeat those same mistakes. The deprectiation window idea is all well and good in premise, however with such a large user base, I am not sure it is going to go very far unfortunately, nor that it will hinder our ability to have a more maintainable DSA framework TBH.

BTW, OpenWrt does not typically ship DT blobs that stay frozen, all of the kernel, DTBs, root filesystem, and sometimes a recent u-boot copy will be updated at the same time because very rarely do the existing boot loader satisfy modern requirements (PSCI, etc.).
-- 
Florian
