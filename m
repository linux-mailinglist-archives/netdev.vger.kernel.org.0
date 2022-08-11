Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A4F58F9F7
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 11:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbiHKJTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 05:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233601AbiHKJTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 05:19:02 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283EE3DBCD;
        Thu, 11 Aug 2022 02:18:59 -0700 (PDT)
Received: from mail-ej1-f50.google.com ([209.85.218.50]) by
 mrelayeu.kundenserver.de (mreue107 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1M7KKA-1oImYo20HE-007kT7; Thu, 11 Aug 2022 11:18:58 +0200
Received: by mail-ej1-f50.google.com with SMTP id kb8so32467918ejc.4;
        Thu, 11 Aug 2022 02:18:58 -0700 (PDT)
X-Gm-Message-State: ACgBeo2gIjfjhJE4k/diPz/LVWEedhLQwiDuJR/tOHDSPZQhXlZRvsPJ
        ZyfLid40udud/LFzdbSicHydMUbTlJjPPBrNtHY=
X-Google-Smtp-Source: AA6agR7793vtAT5/iReFiO2sCTCKBsra3/+Yy59MDOySE4yQjjz2qCqgzvmq59hWiN13Dny+AM7IRNv5cww+NHAnkx8=
X-Received: by 2002:a17:907:7609:b0:730:d70a:1efc with SMTP id
 jx9-20020a170907760900b00730d70a1efcmr23313824ejc.766.1660209538126; Thu, 11
 Aug 2022 02:18:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220426175436.417283-1-kuba@kernel.org> <20220426175436.417283-4-kuba@kernel.org>
 <8576aef3-37e4-8bae-bab5-08f82a78efd3@kernel.org> <CAK8P3a01yfeg-3QO=MeDG7JzXEsTGxK+vMpFJ83SGwPto4AOxw@mail.gmail.com>
 <20220810094206.36dcfca8@kernel.org> <de3170f3-6035-21e4-8ca5-427ca878b3a4@kernel.org>
In-Reply-To: <de3170f3-6035-21e4-8ca5-427ca878b3a4@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 11 Aug 2022 11:18:42 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1E=e5YNj9i0nwj=D=xBg=gi8AqfDcMwZpGCNn81+v5cQ@mail.gmail.com>
Message-ID: <CAK8P3a1E=e5YNj9i0nwj=D=xBg=gi8AqfDcMwZpGCNn81+v5cQ@mail.gmail.com>
Subject: Re: [PATCH net-next 3/6] net: atm: remove support for ZeitNet ZN122x
 ATM devices
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:hw0fM17XgH4ooVwXhSVrvcQk3lSb8dZo/DFgOHKEXIUK1is+xp1
 GBJ708wis33HVgT7lMhSKP7cW6UKLse0Jvho2u10y/BpSHvolwX2n6cZwUvC6weMc4mZJ8U
 2VKsqlRFv4mbEfYtmGBl8RuOK2uqdO4oI9B+Nu85W24YmfS/3f4trniA74opdEeilqHohKq
 qjCUK4LVD/8VJJeD6u8xA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:kYWfpa0p78I=:Cq4TsAq/hHWsh0moBzD6pz
 96NpqysGjLea2LwPpSImuNHTGuVZzjF2ng/84XckkCpSBpmDSCtG3ROYCcAXwMZwMTEHwPRo5
 9r6sShXuuhSdXoeUa0iiljp1lVRlVQWwCeohanhk5UlI4ke3cnh/Io2MwecD7McJ4KtulEtUM
 a9OlLwq5ojlXW0Cv2Y51l8gX4q3vvY0aLWqIxicbS+/j4uPVysFKrxHbWDK2oCoWz0Cf05dWv
 y86vc/BvWe8RxFBVJmY68syanEiTf8xUTZxSXpTFkFyma6i7J6b5cHkoU5dUDu1qGCrsnDGMb
 uqHaPfEEFWsj0yKJPjb4F1NFhAZaxXSq3toSRE8QW3CkW7nu7dPlccTPaIvm2PnIC4w1N2cD4
 BWoPu7o1WZ8esqa+D4/FW1qiSBcORhK/pet50bkXvaWUBlxY19tDP0KeWXwgdl54oXzhZsp+k
 iHmD3afEQKlK4vkAAs+7UuOsowZVLKZX/GmEsqLLfmoTD9PuJIWJ5g8E1KG10bA2djUkJtd0/
 wQdKlVH006p3MMrjnFMC99geILNz5wLxRtOvbgbjsetv0hSsJcmB/+prjGfxsjY/HoSj6Hp5i
 WJaS3byQ1tMEBodPeRWwoeKJZ2fWNZpGbHgfOvyn3+s8t6lJXAOuoH6DO00fLgq8KvME28M3L
 BEA4azOkMyUO0957AYo+4BeQR7yp2C/HhKFQHrZyl3jZ5xa4w6UDPJF+KQHuaV43Q6hdeDrkv
 KTid1pZPBrZzXuC//ybCS6np0rHNu51/3VJAyA==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 11, 2022 at 7:19 AM Jiri Slaby <jirislaby@kernel.org> wrote:
> On 10. 08. 22, 18:42, Jakub Kicinski wrote:
> > On Wed, 10 Aug 2022 11:11:32 +0200 Arnd Bergmann wrote:
> >>> This unfortunately breaks linux-atm:
> >>> zntune.c:18:10: fatal error: linux/atm_zatm.h: No such file or directory
> >>>
> >>> The source does also:
> >>> ioctl(s,ZATM_SETPOOL,&sioc)
> >>> ioctl(s,zero ? ZATM_GETPOOLZ : ZATM_GETPOOL,&sioc)
> >>> etc.
> >>>
> >>> So we should likely revert the below:
> >>
> >> I suppose there is no chance of also getting the linux-atm package updated
> >> to not include those source files, right? The last release I found on
> >> sourceforge
> >> is 12 years old, but maybe I was looking in the wrong place.
> >
> > Is linux-atm used for something remotely modern? PPPoA? Maybe it's
> > time to ditch it completely? I'll send the revert in any case.
>
> Sorry, I have no idea. openSUSE is just a provider of an rpm -- if there
> any users? Who knows...

I think in theory this is the subsystem that DSL drivers would use, but
there is only one driver for the "Solos ADSL2+".

OpenWRT used to support the TI AR7 platform (later owned by Infineon,
Lantiq, and Intel, now Maxlinear) with the "sangam-atm" driver for DSL,
but that driver was never available in mainline Linux and is now gone
from OpenWRT as well.

It appears that the later hardware that is still supported uses a custom
atm driver implementation rather than the in-kernel subsystem, using
a different set of ioctls:
https://git.openwrt.org/?p=openwrt/openwrt.git;a=tree;f=package/kernel/lantiq/ltq-atm/src

There are also DSL SoCs from (at least) Broadcom, Realtek, Mediatek and
Qualcomm, but no open source drivers, so I guess they probably all
use their own kernel subsystems.

       Arnd
