Return-Path: <netdev+bounces-10573-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A37B072F2D1
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 04:51:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE5DF2812CE
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 02:51:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0ECD363;
	Wed, 14 Jun 2023 02:51:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099AD17E;
	Wed, 14 Jun 2023 02:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0878AC433C0;
	Wed, 14 Jun 2023 02:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686711097;
	bh=N3q6ixAinHSWilzVMCv++DW3xSimSHnyP2PRlOaULYE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aHS8GGlVpVMza8fUd10dHWgjcsEcnhYF6mtda1PEif73/gG8DJjgjRD496BZG2+IQ
	 yZb0yLikA3pccFbH6043Pq5QZcqOroZdRH/n0aPMe6tt6rd6svMoQlkxrdOQGMmm5p
	 gPTCRZNFuEphlrZWYkI0t495rTPGdcZJ6IzKlD2J5Zsf62F+leEV0MUgVETVEw0vup
	 sMwdFgG4EQYtmZ9JqLK5OUrSJZXnIspVyWrfW0tKAsYBWwuyMLC6UVSY84A9XKx8KM
	 hmEOCqZIbZ55Y5QXW5euBztlUDZTHbx6k9Q1KnD2gow6ubRUlJEXvAxIGp7m80p1TK
	 vqIb4LmfdSHew==
Date: Tue, 13 Jun 2023 19:51:36 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=  <toke@kernel.org>, Kalle
 Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 regressions@lists.linux.dev
Subject: Re: Closing down the wireless trees for a summer break?
Message-ID: <20230613195136.6815df9b@kernel.org>
In-Reply-To: <ba933d6e3d360298e400196371e37735aef3b1eb.camel@sipsolutions.net>
References: <87y1kncuh4.fsf@kernel.org>
	<871qifxm9b.fsf@toke.dk>
	<20230613112834.7df36e95@kernel.org>
	<ba933d6e3d360298e400196371e37735aef3b1eb.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 13 Jun 2023 22:00:35 +0200 Johannes Berg wrote:
> On Tue, 2023-06-13 at 11:28 -0700, Jakub Kicinski wrote:
> > On Tue, 13 Jun 2023 20:14:40 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wro=
te: =20
> > > I think this sounds reasonable, and I applaud the effort to take some
> > > time off during the summer :)
> > >=20
> > > One question that comes to mind is how would this work for patchwork?
> > > Would we keep using the wireless patchwork instance for the patches
> > > going to -net in that period, or will there be some other process for
> > > this? I realise the setup we have for ath9k is a bit special in this
> > > regard with the ack-on-list+delegation, so I'm obviously mostly
> > > interested in what to do about that... :) =20
> >=20
> > Whatever's easiest :) It's probably a good idea for Kalle to write
> > down all the local rules and customs and share those with us.
>=20
> While that's probably a good idea regardless, I'd think that patchwork
> doesn't really matter that much - we'll have some catching up to do
> anyway after the vacations, so looking through patchwork etc. would be
> perfectly acceptable. Worst case we'd notice when a patch doesn't apply,
> right? :)

Right, I meant it more in terms of patch flow. Is looking at which
drivers have a tree specified in MAINTAINERS enough to know what
should be applied directly?

> Wrt. ath9k patches I guess "delegate in patchwork" won't work anymore,
> but "resend to netdev" or something perhaps?

We can watch PW state and apply from linux-wireless, I reckon.
That said I don't know how you use delegation :)

