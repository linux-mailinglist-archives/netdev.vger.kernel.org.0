Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9F81C4CFA
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 06:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgEEEIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 00:08:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725272AbgEEEIL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 00:08:11 -0400
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 319202087E;
        Tue,  5 May 2020 04:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588651690;
        bh=uzzMCgqE/O5IIYjUlJGPkxkNrxePxpFGbx62v87B1yk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BN6Cy/3HpCwbAGqGdvC+qqnnmWcpBeTMOV+avy7c5MqADF8o2RkgcRkJzIQXdsCsk
         1Afk3jIt/KQM3TnQcStiKfqzuLsewX65wxQohWJds/+9oXyCCJshgXhqgUpXBb3dvp
         Pj9E/11iNOGPIQykmHB/KEKg0M4b5I2GMOZkNt/o=
Received: by mail-ot1-f54.google.com with SMTP id m13so561394otf.6;
        Mon, 04 May 2020 21:08:10 -0700 (PDT)
X-Gm-Message-State: AGi0PuYCc8W08LyWksuW5sQZqz/19WrYFFaUhJea7EHP7Nd0bFUJ8bMP
        TH24vvr7k6O4ssDpVm8Cn3ceMFQOC52xr3mHaw==
X-Google-Smtp-Source: APiQypKr0Hhrl0+e44U31hazXs0o4bScaIuGYf4nCgkUWwDdJ4zYt2nRLPemlwjIE7S1TGeNHXWRAj+I7RpOjlh+8dk=
X-Received: by 2002:a9d:7d85:: with SMTP id j5mr690540otn.107.1588651689440;
 Mon, 04 May 2020 21:08:09 -0700 (PDT)
MIME-Version: 1.0
References: <967df5c3303b478b76199d4379fe40f5094f3f9b.1588584538.git.mchehab+huawei@kernel.org>
 <20200504174522.GA3383@ravnborg.org> <20200504175553.jdm7a7aabloevxba@pengutronix.de>
In-Reply-To: <20200504175553.jdm7a7aabloevxba@pengutronix.de>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 4 May 2020 23:07:57 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJuRrhEtt5uxaQ=7WvDKiF_2v025GiYUvrrFE5jxBr-Xg@mail.gmail.com>
Message-ID: <CAL_JsqJuRrhEtt5uxaQ=7WvDKiF_2v025GiYUvrrFE5jxBr-Xg@mail.gmail.com>
Subject: Re: [PATCH] docs: dt: fix broken links due to txt->yaml renames
To:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Sam Ravnborg <sam@ravnborg.org>
Cc:     Linux-ALSA <alsa-devel@alsa-project.org>,
        Olivier Moysan <olivier.moysan@st.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        devicetree@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>, Jyri Sarha <jsarha@ti.com>,
        Mark Brown <broonie@kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Sandy Huang <hjc@rock-chips.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 4, 2020 at 12:56 PM Uwe Kleine-K=C3=B6nig
<u.kleine-koenig@pengutronix.de> wrote:
>
> Hi Sam,
>
> On Mon, May 04, 2020 at 07:45:22PM +0200, Sam Ravnborg wrote:
> > On Mon, May 04, 2020 at 11:30:20AM +0200, Mauro Carvalho Chehab wrote:
> > > There are some new broken doc links due to yaml renames
> > > at DT. Developers should really run:
> > >
> > >     ./scripts/documentation-file-ref-check
> > >
> > > in order to solve those issues while submitting patches.
> > Would love if some bot could do this for me on any patches that creates
> > .yaml files or so.
> > I know I will forget this and it can be automated.
> > If I get a bot mail that my patch would broke a link I would
> > have it fixed before it hits any tree.

I can probably add this to what I'm already checking. Not completely
automated though as it depends on me to review before sending.

> What about adding a check to check_patch?

That would be the best way to get submitters to do this.

Rob
