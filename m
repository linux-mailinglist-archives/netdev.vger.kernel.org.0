Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A61588B15
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 13:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbiHCLZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 07:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiHCLZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 07:25:03 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67E01D33E;
        Wed,  3 Aug 2022 04:25:02 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id b96so10729255edf.0;
        Wed, 03 Aug 2022 04:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=rzsx5Tl32YZaKPBUKPIfYuRz4YmHmbjR35PJaDpZxi4=;
        b=Q36U/PUyD1XC7xp8IKIluUgwPby2NF6JP6vHf2lnL8TNlpGFGQ74Gi+nYiYRKNTjWP
         6ustjFUsVA7OJmAQLTFce8rpdiK50Wr5FnxIs42rv8cIl7pynUDS/yAv9sUYsDASzE8I
         8CSFYm3feh5fiIICPAwyhEDuPg1ryHl+Cn/yfy9PSdSAGsV7gOe203Ic2iH67yHHRSrO
         34un/sIC6WFPubFp+TLykcI8Wz90Kto3+qMdf2q43hRmnaWq8v5h2B4iRPsTI6WxhXz3
         2EpwBgFs8fUa6M1xgEVS/vHOWCwvOv20tT344I9UfEeBhO07zqaom8l6Bd57SquV2nbE
         7UBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=rzsx5Tl32YZaKPBUKPIfYuRz4YmHmbjR35PJaDpZxi4=;
        b=uvBObA0DLzD6uo67S5Odg2VeyXbi8U1RB0sKb92jnHTcs09+fE0uV1Y7rb+41g4a9D
         zFY4YBLKO6jLbtgHDmErq4vbcVWHSBgL/dDZkqEr7aNgNmNEZ6CaNFDtr/7hFKyuiVnJ
         pM2U2b1WlJkemRK++1QgCPNXb7F0wx584UzyeVrVhqbzH4NWmACVKDqqu0MEkJi9htd5
         5T+Zmb+waS7wCW8eEJ2WMgZ49PkFbuwuu/ga+urTQ+YOHnt0WiPsO4nC+QUKKkELbMGn
         I+aOn/kEPXd2LOmIxFyr0yQBa0LGdfhpFsLRypD10vVJ23fOXJoa57En1yDfq6j2UcKq
         qYlw==
X-Gm-Message-State: AJIora8lkfvCRkLK5rO+VYwqhp2MSF1a4R35YGenubKCf7r87jwM2fSp
        GdLiRwMP7QpRiUxgbBhwyOh5LegylK/dbEoN2R0=
X-Google-Smtp-Source: AGRyM1sEMFX3FX4WRh9HyclH5SqElJJYGrwCbBNRHs8iaD2aY7oi6LLBuGXGMA2R2pI3JC13sUHbkid9/YWZAmDv6Ig=
X-Received: by 2002:a05:6402:280b:b0:43b:5d75:fcfa with SMTP id
 h11-20020a056402280b00b0043b5d75fcfamr24651501ede.114.1659525901203; Wed, 03
 Aug 2022 04:25:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220802212144.6743-1-andriy.shevchenko@linux.intel.com> <87h72tga8y.fsf@kurt>
In-Reply-To: <87h72tga8y.fsf@kurt>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 3 Aug 2022 13:24:24 +0200
Message-ID: <CAHp75VcuFMwTn+EBYGJNPZYzMdFcKTrY2W-u7K79OZRHXyoGRA@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/1] net: dsa: hellcreek: Get rid of custom led_init_default_state_get()
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 3, 2022 at 7:39 AM Kurt Kanzenbach <kurt@linutronix.de> wrote:
>
> On Wed Aug 03 2022, Andy Shevchenko wrote:
> > LED core provides a helper to parse default state from firmware node.
> > Use it instead of custom implementation.
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  drivers/net/dsa/hirschmann/hellcreek_ptp.c | 45 ++++++++++++----------
> >  1 file changed, 24 insertions(+), 21 deletions(-)
> >
> > diff --git a/drivers/net/dsa/hirschmann/hellcreek_ptp.c b/drivers/net/d=
sa/hirschmann/hellcreek_ptp.c
> > index b28baab6d56a..793b2c296314 100644
> > --- a/drivers/net/dsa/hirschmann/hellcreek_ptp.c
> > +++ b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
> > @@ -297,7 +297,8 @@ static enum led_brightness hellcreek_led_is_gm_get(=
struct led_classdev *ldev)
> >  static int hellcreek_led_setup(struct hellcreek *hellcreek)
> >  {
> >       struct device_node *leds, *led =3D NULL;
> > -     const char *label, *state;
> > +     enum led_default_state state;
> > +     const char *label;
> >       int ret =3D -EINVAL;
> >
> >       of_node_get(hellcreek->dev->of_node);
> > @@ -318,16 +319,17 @@ static int hellcreek_led_setup(struct hellcreek *=
hellcreek)
> >       ret =3D of_property_read_string(led, "label", &label);
> >       hellcreek->led_sync_good.name =3D ret ? "sync_good" : label;
> >
> > -     ret =3D of_property_read_string(led, "default-state", &state);
> > -     if (!ret) {
> > -             if (!strcmp(state, "on"))
> > -                     hellcreek->led_sync_good.brightness =3D 1;
> > -             else if (!strcmp(state, "off"))
> > -                     hellcreek->led_sync_good.brightness =3D 0;
> > -             else if (!strcmp(state, "keep"))
> > -                     hellcreek->led_sync_good.brightness =3D
> > -                             hellcreek_get_brightness(hellcreek,
> > -                                                      STATUS_OUT_SYNC_=
GOOD);
> > +     state =3D led_init_default_state_get(of_fwnode_handle(led));
>
> Applied your patch to net-next/master and this yields:
>
> |drivers/net/dsa/hirschmann/hellcreek_ptp.c: In function =E2=80=98hellcre=
ek_led_setup=E2=80=99:
> |drivers/net/dsa/hirschmann/hellcreek_ptp.c:430:10: error: implicit decla=
ration of function =E2=80=98led_init_default_state_get=E2=80=99; did you me=
an =E2=80=98led_get_default_pattern=E2=80=99? [-Werror=3Dimplicit-function-=
declaration]
> |  430 |  state =3D led_init_default_state_get(of_fwnode_handle(led));
> |      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~
> |      |          led_get_default_pattern
>
> The header is missing:
>
> |diff --git a/drivers/net/dsa/hirschmann/hellcreek_ptp.c b/drivers/net/ds=
a/hirschmann/hellcreek_ptp.c
> |index df339f3e1803..430f39172d58 100644
> |--- a/drivers/net/dsa/hirschmann/hellcreek_ptp.c
> |+++ b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
> |@@ -14,6 +14,8 @@
> | #include "hellcreek_ptp.h"
> | #include "hellcreek_hwtstamp.h"
> |
> |+#include "../../../leds/leds.h"
> |+
> | u16 hellcreek_ptp_read(struct hellcreek *hellcreek, unsigned int offset=
)
> | {
> |        return readw(hellcreek->ptp_base + offset);
>
> Maybe move led_init_default_state_get() to linux/leds.h?

Yep, thanks! Missed patch and all of them should be sent as a series...


--=20
With Best Regards,
Andy Shevchenko
