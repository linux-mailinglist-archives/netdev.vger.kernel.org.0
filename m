Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A739622D5EC
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 09:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgGYH6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 03:58:01 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:47723 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbgGYH6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 03:58:00 -0400
Received: from mail-qt1-f169.google.com ([209.85.160.169]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1N9M1q-1kvJNS2iUG-015J4a; Sat, 25 Jul 2020 09:57:58 +0200
Received: by mail-qt1-f169.google.com with SMTP id h21so2218814qtp.11;
        Sat, 25 Jul 2020 00:57:58 -0700 (PDT)
X-Gm-Message-State: AOAM531uZjJYB8cu37wMA9gEr3iS+uXdtkWQ1L3OmAG3klRrftf8oDGX
        e67p7cOO//lCAmbJHiGZz3oCo/vwrJzMV1392ZI=
X-Google-Smtp-Source: ABdhPJwbhu349b6W7ly80SHf5qioCZqejIeokVKsvAD15ZNpVnDPsfJClkcWiDwOwPkEJU9Y0uBI/RPbLezsgxUVny8=
X-Received: by 2002:ac8:4589:: with SMTP id l9mr13039488qtn.204.1595663877320;
 Sat, 25 Jul 2020 00:57:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200724214221.28125-1-grygorii.strashko@ti.com> <a91d2bad-b794-fe07-679a-e5096aa5ace8@oracle.com>
In-Reply-To: <a91d2bad-b794-fe07-679a-e5096aa5ace8@oracle.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sat, 25 Jul 2020 09:57:41 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3N70PbotC18K-SG9+XgfApHNZyCYvUgOyfrxrP55zSEw@mail.gmail.com>
Message-ID: <CAK8P3a3N70PbotC18K-SG9+XgfApHNZyCYvUgOyfrxrP55zSEw@mail.gmail.com>
Subject: Re: [RESEND PATCH] ARM: dts: keystone-k2g-evm: fix rgmii phy-mode for
 ksz9031 phy
To:     "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Cc:     "arm@kernel.org" <arm@kernel.org>, Olof Johansson <olof@lixom.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Philippe Schenker <philippe.schenker@toradex.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:NQRxxDNnaKwYvx9fuQIat0bcb+FYdaDNsod9SW/Hh8SMJ15t2Hm
 8H/MC2t87Y+kuUKfnf4iisQZxL+/hXLlTSZmGnBRNdO4JyKgMULV13Wzza0VUyDGVHDv2KM
 sGIqkK6zOZeacv7Rv9aLSg7q92CzlOc87cHGcFS6AIqoUQK2dFP5s24Djyv9pAF2PKhslVK
 canfZfxOyCb9JNxyMRxjQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:L9DkJih6lFA=:xuAAaUn/2gYK/Eo24+3/GV
 pBWcIbwgw2zDaf0YQeuIkgRwoSOw40ibvpwrnE81EBKdf9jdg5TUf1t/uClTsHWrU70ze8Y6b
 0g5K76juwtDaUdPeyiCP2OjspVKvzG6mkJzhILMc1pr7ruY8m2LaGxb381OZ2GI/2srYqAtnG
 LH0whww7Ze3QhfSjHgddIT3Ld3UevkjgmFK3t9GKVpv82KjAhh+zkVtbndU+6uO5TXK5JPFGU
 xoGQveQWGrgEh1R0e6bAlMFc0x/UkAgkxWxu7WBQyYyioa/qfPIUivYvs1KGAQTsKUR3HjOnb
 eTCb+UnuxiGEpi3nVUer0BeON7QNckbO2ebFXmBz1k4PJX7kZMZoGb2E3ayA7QOVW1yMRANYH
 4uZSnnD7+4gOvmSMGScgIQYDCswFgqyxER6QGqfWoj6oXaChTheHxxgYK0g0GzKx9BdYr2ZXC
 3/4idNixwcMWiSGfx3iJLVcLk9eONXWEExrPqGpHZYVhVxVf5B+FxAWDk++VDqI0zoaDkXntQ
 /Rv9TTQb05w1xpNe5DTi/Zf8m51xOzcDOCVU3UOUEH7WghghFd4vNvpPqBRa9r1OKB1wB8qCA
 McCMpkhotmdBYi57cIkjxQaQSJDErX+W8sAQdSzOhwAsUCuPOnGr6QA6F6Hac3yJsvW/tp5Jm
 /M/RRS1ii59PKkYfngX5uIgzoC0IrgWYwZxyAJ66F/shlghP/O/2P6vKQWHkSsNGWDmyixryu
 fMjETuHe+5tNKucCpt0Y7EVcg1T/EhJ/luObjLForjGRrA44fd+uaRe/GFLUmsNhTzSkw0crh
 ie+WwxXeL5iSmqhHsp3LSYsZJTINjo6HUEuIoMFjkbbinL2SnAQdnFk4q7NOaoZjAScxjbGaM
 WidK+jl/beWkxqn/bW93+iYlTRiJWjWys+PotWUJM92e6A+5hy5INk7Z3NZijtPBICT0JUGUe
 PImiyc3jDT7X79goHKRAzjl8C7WqCdIaNAKtCa5gsV9rqjHqghfTV
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 11:57 PM santosh.shilimkar@oracle.com
<santosh.shilimkar@oracle.com> wrote:
> On 7/24/20 2:42 PM, Grygorii Strashko wrote:
> > Since commit bcf3440c6dd7 ("net: phy: micrel: add phy-mode support for the
> > KSZ9031 PHY") the networking is broken on keystone-k2g-evm board.
> >
> > The above board have phy-mode = "rgmii-id" and it is worked before because
> > KSZ9031 PHY started with default RGMII internal delays configuration (TX
> > off, RX on 1.2 ns) and MAC provided TX delay by default.
> > After above commit, the KSZ9031 PHY starts handling phy mode properly and
> > enables both RX and TX delays, as result networking is become broken.
> >
> > Fix it by switching to phy-mode = "rgmii-rxid" to reflect previous
> > behavior.
> >
> > Cc: Oleksij Rempel <o.rempel@pengutronix.de>
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: Philippe Schenker <philippe.schenker@toradex.com>
> > Fixes: bcf3440c6dd7 ("net: phy: micrel: add phy-mode support for the KSZ9031 PHY")
> > Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> > ---
> > Fix for one more broken TI board with KSZ9031 PHY.
> Can you please apply this patch to your v5.8 fixes branch and send it
> upstream ? Without the fix K2G EVM board is broken with v5.8.
>
> Am hoping you can pick this up with pull request since it just one
> patch.

I've applied it now, but would point out that it's generally better if you could
forward the patch to soc@kernel.org with your Signed-off-by if you come
across a similar patch again. That way it ends up in patchwork, and we
are more likely to pick it up quickly.

       Arnd
