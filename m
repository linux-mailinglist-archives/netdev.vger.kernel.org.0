Return-Path: <netdev+bounces-8393-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 753B2723E27
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:48:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5B1E1C20B52
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:47:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9280294FD;
	Tue,  6 Jun 2023 09:47:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDFD294DC
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:47:58 +0000 (UTC)
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725E610E7;
	Tue,  6 Jun 2023 02:47:48 -0700 (PDT)
X-GND-Sasl: miquel.raynal@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686044866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ApW14yUphjoVxJ8OfyJdmz2zYwhytsITbf5DWcM7pbA=;
	b=dg+sYQGnLW0QH4rB/42gLxiZpgIs4N4MWvuVIdXz5PKjRuujNIMthpmHOKMJKu9Utmjou6
	Md0BouvLY6nH6sPN4Mg77MHfCkpjKLozxV2XfUCDJPRRTZVIpF5TtXoimeOG8d50bTi5uL
	bDvoCdz2E55HOi5d1fjbXXS4Ty7iOOMK8vgf/ripk51upIbWRXGVA/P2irt7h4mw1DGYHe
	qV7js6mvf9pzNfsVQaie4v8vuWFiRo80orhoUiOLw0uKslu4UcvFGS4eLxV1zxEdc/fwim
	+XmP8wZpcXTpfn8uLzennrhF31RV+YxKsKOVhK/s3JkOasCoFVvDhnu1jCtu8Q==
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 787262000D;
	Tue,  6 Jun 2023 09:47:44 +0000 (UTC)
Date: Tue, 6 Jun 2023 11:47:43 +0200
From: Miquel Raynal <miquel.raynal@bootlin.com>
To: Alexander Aring <aahringo@redhat.com>
Cc: Simon Horman <simon.horman@corigine.com>, Stefan Schmidt
 <stefan@datenfreihafen.org>, linux-wpan@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Aring
 <alex.aring@gmail.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH net-next v1 1/1] ieee802154: ca8210: Remove stray
 gpiod_unexport() call
Message-ID: <20230606114743.30f7567e@xps-13>
In-Reply-To: <CAK-6q+hkL8cStdSPnZF_D1CtLvJZ=P16TJ8BCGpkGwrbh8uN3A@mail.gmail.com>
References: <20230528140938.34034-1-andriy.shevchenko@linux.intel.com>
	<ZHWo3LHLunOkXaqW@corigine.com>
	<ZH3srm+8PnZ1rJm9@smile.fi.intel.com>
	<CAK-6q+hkL8cStdSPnZF_D1CtLvJZ=P16TJ8BCGpkGwrbh8uN3A@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


aahringo@redhat.com wrote on Tue, 6 Jun 2023 05:33:47 -0400:

> Hi,
>=20
> On Mon, Jun 5, 2023 at 10:12=E2=80=AFAM Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> >
> > On Tue, May 30, 2023 at 09:42:20AM +0200, Simon Horman wrote: =20
> > > On Sun, May 28, 2023 at 05:09:38PM +0300, Andy Shevchenko wrote: =20
> > > > There is no gpiod_export() and gpiod_unexport() looks pretty much s=
tray.
> > > > The gpiod_export() and gpiod_unexport() shouldn't be used in the co=
de,
> > > > GPIO sysfs is deprecated. That said, simply drop the stray call.
> > > >
> > > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com> =
=20
> > >
> > > Reviewed-by: Simon Horman <simon.horman@corigine.com> =20
> >
> > Thank you!
> > Can this be applied now? =20
>=20
> ping, Miquel? :)

I already applied it locally, but I am trying to fix my "thanks for
patch" routine to not tell you it was applied on the mtd tree :-p

Cheers,
Miqu=C3=A8l

