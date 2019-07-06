Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38FDB60FE1
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 12:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbfGFKlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 06:41:36 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40710 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbfGFKlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 06:41:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=x8xrypbhTWD1eWxAgLr7OjCl2dz8XFdFHYVEQD+l2xE=; b=YBvr4PY1Da2Hx3f7iSWvlPukP
        XbOYF2nAlGklvMISBtplGqU/b14y4fzaIQRcBUXwTlVjP/RP6dOV0RlTBXmTwT1CfKGKGciWFl5du
        b4b3cBo3O8z3yXD1nvSYMMDOWbwgHWouDGhSADzwfwA9Qm6uyZcweCcmo96c/ckGZLYGeOVuZ64ly
        5gBICvY5YcW2NxdEDWyS4FfRL3zcOwXSGLhCk0jo8H+GSEGe1eqbOnl4pWZhaMUhRTjSuHCW4FwKQ
        NKb9Oa3HttarFKO3DQFaIC1yifRDMHCZS5a/koauXe+hzqed8li7bGQynmTKFugnD7KIuBPk+ZQTw
        u+zCYCLqA==;
Received: from 177.205.70.5.dynamic.adsl.gvt.net.br ([177.205.70.5] helo=coco.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hji8K-0007Fa-2X; Sat, 06 Jul 2019 10:41:32 +0000
Date:   Sat, 6 Jul 2019 07:41:26 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Vadim Pasternak <vadimp@mellanox.com>,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-leds@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH 24/43] docs: leds: convert to ReST
Message-ID: <20190706074047.58c23fe9@coco.lan>
In-Reply-To: <0b2a2452-20ca-1651-e03b-a15a8502b028@gmail.com>
References: <cover.1561723979.git.mchehab+samsung@kernel.org>
        <2fecbe9a9cefda64771b43c5fc67495d897dd722.1561723980.git.mchehab+samsung@kernel.org>
        <0b2a2452-20ca-1651-e03b-a15a8502b028@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, 28 Jun 2019 21:01:40 +0200
Jacek Anaszewski <jacek.anaszewski@gmail.com> escreveu:

> Hi Mauro,
>=20
> On 6/28/19 2:20 PM, Mauro Carvalho Chehab wrote:
> > Rename the leds documentation files to ReST, add an
> > index for them and adjust in order to produce a nice html
> > output via the Sphinx build system.
> >=20
> > At its new index.rst, let's add a :orphan: while this is not linked to
> > the main index.rst file, in order to avoid build warnings.
> >=20
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > Acked-by: Pavel Machek <pavel@ucw.cz>
> > ---
> >  Documentation/laptops/thinkpad-acpi.txt       |   4 +-
> >  Documentation/leds/index.rst                  |  25 ++
> >  .../leds/{leds-blinkm.txt =3D> leds-blinkm.rst} |  64 ++---
> >  ...s-class-flash.txt =3D> leds-class-flash.rst} |  49 ++--
> >  .../leds/{leds-class.txt =3D> leds-class.rst}   |  15 +-
> >  .../leds/{leds-lm3556.txt =3D> leds-lm3556.rst} | 100 ++++++--
> >  .../leds/{leds-lp3944.txt =3D> leds-lp3944.rst} |  23 +-
> >  Documentation/leds/leds-lp5521.rst            | 115 +++++++++
> >  Documentation/leds/leds-lp5521.txt            | 101 --------
> >  Documentation/leds/leds-lp5523.rst            | 147 ++++++++++++
> >  Documentation/leds/leds-lp5523.txt            | 130 ----------
> >  Documentation/leds/leds-lp5562.rst            | 137 +++++++++++
> >  Documentation/leds/leds-lp5562.txt            | 120 ----------
> >  Documentation/leds/leds-lp55xx.rst            | 224 ++++++++++++++++++
> >  Documentation/leds/leds-lp55xx.txt            | 194 ---------------
> >  Documentation/leds/leds-mlxcpld.rst           | 118 +++++++++
> >  Documentation/leds/leds-mlxcpld.txt           | 110 ---------
> >  ...edtrig-oneshot.txt =3D> ledtrig-oneshot.rst} |  11 +-
> >  ...ig-transient.txt =3D> ledtrig-transient.rst} |  63 +++--
> >  ...edtrig-usbport.txt =3D> ledtrig-usbport.rst} |  11 +-
> >  Documentation/leds/{uleds.txt =3D> uleds.rst}   |   5 +-
> >  MAINTAINERS                                   |   2 +-
> >  drivers/leds/trigger/Kconfig                  |   2 +-
> >  drivers/leds/trigger/ledtrig-transient.c      |   2 +-
> >  net/netfilter/Kconfig                         |   2 +-
> >  25 files changed, 996 insertions(+), 778 deletions(-)
> >  create mode 100644 Documentation/leds/index.rst
> >  rename Documentation/leds/{leds-blinkm.txt =3D> leds-blinkm.rst} (57%)
> >  rename Documentation/leds/{leds-class-flash.txt =3D> leds-class-flash.=
rst} (74%)
> >  rename Documentation/leds/{leds-class.txt =3D> leds-class.rst} (92%)
> >  rename Documentation/leds/{leds-lm3556.txt =3D> leds-lm3556.rst} (70%)
> >  rename Documentation/leds/{leds-lp3944.txt =3D> leds-lp3944.rst} (78%)
> >  create mode 100644 Documentation/leds/leds-lp5521.rst
> >  delete mode 100644 Documentation/leds/leds-lp5521.txt
> >  create mode 100644 Documentation/leds/leds-lp5523.rst
> >  delete mode 100644 Documentation/leds/leds-lp5523.txt
> >  create mode 100644 Documentation/leds/leds-lp5562.rst
> >  delete mode 100644 Documentation/leds/leds-lp5562.txt
> >  create mode 100644 Documentation/leds/leds-lp55xx.rst
> >  delete mode 100644 Documentation/leds/leds-lp55xx.txt
> >  create mode 100644 Documentation/leds/leds-mlxcpld.rst
> >  delete mode 100644 Documentation/leds/leds-mlxcpld.txt
> >  rename Documentation/leds/{ledtrig-oneshot.txt =3D> ledtrig-oneshot.rs=
t} (90%)
> >  rename Documentation/leds/{ledtrig-transient.txt =3D> ledtrig-transien=
t.rst} (81%)
> >  rename Documentation/leds/{ledtrig-usbport.txt =3D> ledtrig-usbport.rs=
t} (86%)
> >  rename Documentation/leds/{uleds.txt =3D> uleds.rst} (95%) =20
>=20
> Patches 4/9 and 24/43 applied to the for-next branch of linux-leds.git.

Thanks!

I'll keep this one on my tree:

	[PATCH 10/39] docs: leds: add it to the driver-api book

=46rom the other series. If everything goes well, either Jon or I should
be sending upstream by the end of the merge window, after rebasing it,
together with a bunch of other patches touching the driver-api index.rst.

That should hopefully avoid merge conflicts.

Regards,
Mauro
