Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92FFF58AF4B
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 19:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240950AbiHER6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 13:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236261AbiHER6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 13:58:47 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED8DFD22;
        Fri,  5 Aug 2022 10:58:45 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id j11so2237096qvt.10;
        Fri, 05 Aug 2022 10:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=7yug3fTCxs/2cQiJqwS+blZsDjPS0f6w6Frl9fldv1c=;
        b=YqWsDVbQ09L4zl2hOU/yWraY0YGr9TaW1q9/Z4j4vlypb7Da5zEqhe2alpoDg6IeFJ
         isQHvop5rPRseDbDoiInydSbRL+sBsRVsab40XO0Vcvw4aXuj1qAX84RBjBnmdyC3Ef7
         NdqHp4D7k5HePPTpPrQqmKHqhLCONpMcELUDirmEZnLs38zrioaYyHY6QLePuiJzHHbE
         NFZ62GK2jutYOFtWSqpje2RMCNtIKmPwDBY3sBaE4Emv3GYQlM3m37+Uhjwz3uZLnzRk
         UlYDtMJzcUhpD2Msl1bozH4WXNicAESZxd4dz4+hfCBuEv4d59hgCAjW47w1DT2jPcum
         Z8cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=7yug3fTCxs/2cQiJqwS+blZsDjPS0f6w6Frl9fldv1c=;
        b=tWTBopHP1vrMYQ6JvOpjbh8FkiCK2gxPKoj5I0GpCpEYBLjHdasKvXVP1z8ZkB7lUi
         97/y2fQaFKbXf65lU46J/WbhNhbdsQGiB+8Ufs5eDCEz8BSJMhr2Po26dcr06K+wJwbV
         G6jjkteHSPKvax3fuKust4bT0pZ2Y9fIRLBEtFYmaFkkSiPUzIklir/jwPDdz4QF2Upx
         7gR5YiYHcn3a82rxwBdoXX5j1LYOOEp6SlmiwHz1bufNW6+CM+uy2AlbTWKXSujpz4RJ
         QGgriaPQs8VhSwYPaVv+CFxXXIKSQyL4GgKTpznJCiPfnn3EbUZ7nQD//QiDyLjabDsu
         q4Jw==
X-Gm-Message-State: ACgBeo0whQ5OMiSWioCHKCZ4riaXzbnSQ77z9wpb27CNOR/0r/+9p7Jd
        dcHtXEjse78m2N+3twQGOGbK7Y58fBGyD7WxbSs=
X-Google-Smtp-Source: AA6agR53z6cN0+jKYOGAt8YnON9hNH8Jc6tsKLfCHP3QkAWzd1gJo4Z/HzzMKqz8taikikocY53xowkP+6S5lziRLlU=
X-Received: by 2002:ad4:5cc3:0:b0:474:8dda:dfb6 with SMTP id
 iu3-20020ad45cc3000000b004748ddadfb6mr6705697qvb.82.1659722324386; Fri, 05
 Aug 2022 10:58:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220803054728.1541104-1-colin.foster@in-advantage.com>
 <20220803054728.1541104-10-colin.foster@in-advantage.com> <Yu1W8DMaP8xlyyr5@euler>
In-Reply-To: <Yu1W8DMaP8xlyyr5@euler>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 5 Aug 2022 19:58:06 +0200
Message-ID: <CAHp75VcVD4XxydmYkgybjpCKsh=0KS5+GnDGK5CJX-qZwJ06Cg@mail.gmail.com>
Subject: Re: [PATCH v15 mfd 9/9] mfd: ocelot: add support for the vsc7512 chip
 via spi
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 5, 2022 at 7:44 PM Colin Foster
<colin.foster@in-advantage.com> wrote:
>
> As I'm going through Andy's suggestions, I came across a couple more
> include changes / misses:
>
> On Tue, Aug 02, 2022 at 10:47:28PM -0700, Colin Foster wrote:

...

> > +int ocelot_chip_reset(struct device *dev)
>
> #include <linux/device.h>

Nope,

struct device;

...

> > +static int ocelot_spi_initialize(struct device *dev)
>
> #include <linux/device.h>

Ditto.

-- 
With Best Regards,
Andy Shevchenko
