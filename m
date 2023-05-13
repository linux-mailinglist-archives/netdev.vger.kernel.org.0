Return-Path: <netdev+bounces-2406-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 120DC701BF6
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 08:33:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E71428175C
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 06:33:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 083391C08;
	Sun, 14 May 2023 06:33:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499681376;
	Sun, 14 May 2023 06:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C435C433EF;
	Sun, 14 May 2023 06:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684045980;
	bh=1dZ7d937g3cEehK4Bk2L/HX89vq34GtVVpU+t+w4bes=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YR+Cf42wmgwUAKpVoPu7zi/HZsELdI7vnMIwpriO5yuT2WZb0z8wbgLyNfDEu7Xqf
	 8Yabcdp8jdKn4jvlVbZggOodgMhjV2nFOzalYBcvgbfhh38YMKt8KEzh0wUKzMjzn8
	 an+gOaOOS9yOngVUTSsyoY/GIUOMV/UmprUY7Z74=
Date: Sun, 14 May 2023 00:07:28 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Richard Fontana <rfontana@redhat.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>,
	Linux SPDX Licenses <linux-spdx@vger.kernel.org>,
	Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Networking <netdev@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Staging Drivers <linux-staging@lists.linux.dev>,
	Linux Watchdog Devices <linux-watchdog@vger.kernel.org>,
	Linux Kernel Actions <linux-actions@lists.infradead.org>,
	Diederik de Haas <didi.debian@cknow.org>,
	Kate Stewart <kstewart@linuxfoundation.org>,
	Philippe Ombredanne <pombredanne@nexb.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Airlie <airlied@redhat.com>,
	Karsten Keil <isdn@linux-pingi.de>,
	Jay Vosburgh <j.vosburgh@gmail.com>,
	Andy Gospodarek <andy@greyhouse.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sam Creasey <sammy@sammy.net>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Daniel Mack <daniel@zonque.org>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Guenter Roeck <linux@roeck-us.net>, Jan Kara <jack@suse.com>,
	Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Ray Lehtiniemi <rayl@mail.com>,
	Alessandro Zummo <a.zummo@towertech.it>,
	Andrey Panin <pazke@donpac.ru>, Oleg Drokin <green@crimea.edu>,
	Marc Zyngier <maz@kernel.org>,
	Jonas Jensen <jonas.jensen@gmail.com>,
	Sylver Bruneau <sylver.bruneau@googlemail.com>,
	Andrew Sharp <andy.sharp@lsi.com>,
	Denis Turischev <denis@compulab.co.il>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Alan Cox <alan@linux.intel.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH v2 08/10] drivers: watchdog: Replace GPL license notice
 with SPDX identifier
Message-ID: <2023051414-headroom-maimed-553c@gregkh>
References: <20230512100620.36807-1-bagasdotme@gmail.com>
 <20230512100620.36807-9-bagasdotme@gmail.com>
 <CAC1cPGy=78yo2XcJPNZVvdjBr2-XzSq76JrAinSe42=sNdGv3w@mail.gmail.com>
 <ef31b33f-8e66-4194-37e3-916b53cf7088@gmail.com>
 <CAC1cPGzznK8zoLaT1gBjpHP1eKFvTKKi+SW6xuXF3B8aHN27=g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC1cPGzznK8zoLaT1gBjpHP1eKFvTKKi+SW6xuXF3B8aHN27=g@mail.gmail.com>

On Sat, May 13, 2023 at 09:43:39AM -0400, Richard Fontana wrote:
> On Sat, May 13, 2023 at 6:53 AM Bagas Sanjaya <bagasdotme@gmail.com> wrote:
> >
> > On 5/12/23 19:46, Richard Fontana wrote:
> > > On Fri, May 12, 2023 at 6:07 AM Bagas Sanjaya <bagasdotme@gmail.com> wrote:
> > >
> > >
> > >> diff --git a/drivers/watchdog/sb_wdog.c b/drivers/watchdog/sb_wdog.c
> > >> index 504be461f992a9..822bf8905bf3ce 100644
> > >> --- a/drivers/watchdog/sb_wdog.c
> > >> +++ b/drivers/watchdog/sb_wdog.c
> > >> @@ -1,3 +1,4 @@
> > >> +// SPDX-License-Identifier: GPL-1.0+
> > >>  /*
> > >>   * Watchdog driver for SiByte SB1 SoCs
> > >>   *
> > >> @@ -38,10 +39,6 @@
> > >>   *     (c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
> > >>   *                                             All Rights Reserved.
> > >>   *
> > >> - *     This program is free software; you can redistribute it and/or
> > >> - *     modify it under the terms of the GNU General Public License
> > >> - *     version 1 or 2 as published by the Free Software Foundation.
> > >
> > > Shouldn't this be
> > > // SPDX-License-Identifier: GPL-1.0 OR GPL-2.0
> > > (or in current SPDX notation GPL-1.0-only OR GPL-2.0-only) ?
> > >
> >
> > Nope, as it will fail spdxcheck.py. Also, SPDX specification [1]
> > doesn't have negation operator (NOT), thus the licensing requirement
> > on the above notice can't be expressed reliably in SPDX here.
> >
> > [1]: https://spdx.github.io/spdx-spec/v2.3/SPDX-license-expressions/
> 
> The GPL identifiers in recent versions of SPDX include an `-only` and
> an `-or-later` variant.

But Linux does not use the newer versions of SPDX given that we started
the conversion before the "-only" variant came out.  Let's stick with
the original one please before worrying about converting to a newer
version of SPDX and mixing things up.

thanks,

greg k-h

