Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9F12F266A
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 03:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732224AbhALCvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 21:51:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbhALCvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 21:51:35 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C12C061786;
        Mon, 11 Jan 2021 18:50:55 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id u17so1027334iow.1;
        Mon, 11 Jan 2021 18:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5w78tzUXX0I8RLg/o+73uKu20yriP3eTMDkxoUSEBt8=;
        b=NHJNCgjrOquzygHREJEL8tOelgSod+g5e14cUUQBq3m6q9Tz7J7kiFWgiqScncNVa7
         VtHn9W+sU/HKdfD3qR7v5xRLrKMbfNHHzzpC+dPGuA6ZVNhDN5GiTHPAdTX/GWIgL7Zk
         ZSqwdCu8uD4NTwENzTRv2gLX9uyzmLvoH+s958GGTh6A3pDLE5iw+rlFMt9azCpqzhPt
         lQ7W1L010BxxiDvfV29HppOK5smgJ3xRPGWdLQrN4kexe7ZVHxZZ+rpTK43nSC51xLYg
         6McdgrO73jIn+GCdIEab7GPB4pEvCTaXPLwtEnoISDVaBuXHuQH4eL9KDpTjz9lpejyx
         VtMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5w78tzUXX0I8RLg/o+73uKu20yriP3eTMDkxoUSEBt8=;
        b=jakVDGrwAWHbvKgFHBJW98NmyNViYjAHmfsGXf7cKctsqlxWnCYsFIKxEc7lId9AUE
         FFR10TKZhylYcp9ufYDu9vsLBOVoCwVUlTDT0YlNQmBhhl4+naFMD9kYeSk4sKW1Dtc3
         eE7OvVvfLDar1S3VrkVSpwubC/Bc2zh1OeOLOQi40xqo97TfPdfXiM2T6JkPyAXVgjg5
         0fszSPvoa0HatgdVj0zsLk0BHKa7LGChGrVVO4vcWB7MEp7omHvrGr4gitII5hy0Wwlm
         A2clEtxNBrZFdG8gu3AOh5EMLTDeI0UZsCvIBSFFw3cDwoFP1iv2n0PSxj/pSpjrzvRb
         X+Fg==
X-Gm-Message-State: AOAM531v7zZ5M+sg1PB+nSJuxWW7w+uYtUYW+wk5AS0s/5uifHpAJuXr
        6waRX/+QnrWX1ldOifi2k0ew1pL5pvAjotBzcwU=
X-Google-Smtp-Source: ABdhPJz0j5BLfPgmG13n4HxFvJkNZxPuemZywJs7U1swOc8i0mMqZy/C2uAL4yRDpNC/M7qFtc/loQ/5mbS5Plf+tnI=
X-Received: by 2002:a6b:b5d2:: with SMTP id e201mr1630874iof.111.1610419854594;
 Mon, 11 Jan 2021 18:50:54 -0800 (PST)
MIME-Version: 1.0
References: <20210111054428.3273-1-dqfext@gmail.com> <20210111164616.1947d779@kernel.org>
In-Reply-To: <20210111164616.1947d779@kernel.org>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Tue, 12 Jan 2021 10:50:54 +0800
Message-ID: <CALW65jboizW2J1S0BYBrOM_xNEzpFM-gdJ6OF33+65vMiJtmWg@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] dsa: add MT7530 GPIO support
To:     =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, linux-kernel@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Mon, Jan 11, 2021 at 11:46 PM Marek Beh=C3=BAn <kabel@kernel.org> wrote:
>
> what modes does the LED support? Does it support blinking on rx/tx?
> What about link status?

Yes. But unfortunately they cannot be controlled individually, unless
on GPIO mode.

> I'd like to know because I am still working on patches which add
> ethernet PHY/switch LEDs, with transparent offloading of netdev trigger.
>
> Marek
