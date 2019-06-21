Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82D7A4DF6C
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 05:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbfFUDza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 23:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbfFUDza (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 23:55:30 -0400
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B649520675;
        Fri, 21 Jun 2019 03:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561089330;
        bh=CB0BVuWRQkXTBVGb9UHWbA6rwa6WvzmY/NDqRPZYwwU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XqPDN2ZNzQB7DkBCUx2OniciL88yDnBFNm/5PmwYB93b79pLI7Z17M2QDvSTXMHHj
         F7o6gG+d1hqN8C8vmFdKyx+tbk1OYLK75yqwvKJM6fAquijXJBT3Z0KydXF/UNM2RY
         sBdJHRE1y9eY9ZHD6OE+gYe/IXrb2O7Y7U+dXy7c=
Received: by mail-wr1-f47.google.com with SMTP id p11so5047791wre.7;
        Thu, 20 Jun 2019 20:55:29 -0700 (PDT)
X-Gm-Message-State: APjAAAUq1bhcLGo1rA4vXD0ulrmCRHIjxnlwsI3hrsQQT0w2T7BV6tQH
        zhuVBq83waSw5awCj9hc7q94kLito1NU6ZiwLH4=
X-Google-Smtp-Source: APXvYqw1oBEMTWkRYK4KwUGgtatvlFEs4uRUsVCarkwsEYrBQV82ffY92H9Yw+zgQ2sCr1HJP1H7CJMT60ddiXTlSDw=
X-Received: by 2002:adf:afd5:: with SMTP id y21mr92411754wrd.12.1561089328389;
 Thu, 20 Jun 2019 20:55:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190620122155.32078-1-opensource@vdorst.com> <74C80E79-877C-4DEC-BC82-1195C3D0981F@public-files.de>
In-Reply-To: <74C80E79-877C-4DEC-BC82-1195C3D0981F@public-files.de>
From:   Sean Wang <sean.wang@kernel.org>
Date:   Thu, 20 Jun 2019 20:55:17 -0700
X-Gmail-Original-Message-ID: <CAGp9Lzon8QMO3=jwLYNO_je+x2E3E-Zocm=Do-=5x334GqZZLw@mail.gmail.com>
Message-ID: <CAGp9Lzon8QMO3=jwLYNO_je+x2E3E-Zocm=Do-=5x334GqZZLw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 0/2] net: mediatek: Add MT7621 TRGMII mode support
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        =?UTF-8?B?U2VhbiBXYW5nICjnjovlv5fkupgp?= <sean.wang@mediatek.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, vivien.didelot@gmail.com,
        netdev@vger.kernel.org,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, linux-mips@vger.kernel.org,
        John Crispin <john@phrozen.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 6:02 AM Frank Wunderlich
<frank-w@public-files.de> wrote:
>
> Tested on Bananapi R2 (mt7623)
>
> Tested-by: "Frank Wunderlich" <frank-w@public-files.de>

These changes also look good to me, thanks for add the patch to enrich
different application variants.

Acked-by: Sean Wang <sean.wang@kernel.org>

>
> Am 20. Juni 2019 14:21:53 MESZ schrieb "Ren=C3=A9 van Dorst" <opensource@=
vdorst.com>:
> >Like many other mediatek SOCs, the MT7621 SOC and the internal MT7530
> >switch both supports TRGMII mode. MT7621 TRGMII speed is fix 1200MBit.
> >
> >v1->v2:
> > - Fix breakage on non MT7621 SOC
> > - Support 25MHz and 40MHz XTAL as MT7530 clocksource
> >
> >Ren=C3=A9 van Dorst (2):
> >  net: ethernet: mediatek: Add MT7621 TRGMII mode support
> >  net: dsa: mt7530: Add MT7621 TRGMII mode support
> >
> > drivers/net/dsa/mt7530.c                    | 46 ++++++++++++++++-----
> > drivers/net/dsa/mt7530.h                    |  4 ++
> > drivers/net/ethernet/mediatek/mtk_eth_soc.c | 38 +++++++++++++++--
> > drivers/net/ethernet/mediatek/mtk_eth_soc.h | 11 +++++
> > 4 files changed, 85 insertions(+), 14 deletions(-)
>
> _______________________________________________
> Linux-mediatek mailing list
> Linux-mediatek@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-mediatek
