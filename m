Return-Path: <netdev+bounces-47-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A9096F4EC2
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 04:10:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A881E280D3B
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 02:10:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF152803;
	Wed,  3 May 2023 02:10:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DB37E
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 02:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13C0C433D2;
	Wed,  3 May 2023 02:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683079837;
	bh=wlLqnHUGzvycqXH5Q4HaLgwB6qwtZiBANmFYGvbGLoc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bOEs8shwKMepLLJzPbt0IBRafnHOocUNB9srAPlG5bz5ifaQ8cylnNpB6TaQ9185j
	 qM8hy23eGfjBR+31Z4PVrX3DTENTUjGiRojwXqAYH2shotxULsclVigJwtnQUR1kG0
	 Sq7w1OclUBJ+Y6WNKeshRZg9so6QbZ2KoF1JBsztv8kNhrd2AzKq8qCkZmcraKv97w
	 xU2tlXzyYwYrpkmqvyTU5PT1ofRu671zKfkE4hDR9A9ik2+DAYUJs7sMVB0lNQqUEI
	 MxNEdFhLOEL6x9XHR/DK5F6XoPO0oBeIOKIKCkpz3sDz1iyw1TouQe2T18TpvBFUWJ
	 NOdPik8cZdedg==
Date: Tue, 2 May 2023 19:10:35 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>, John 'Warthog9'
 Hawley <warthog9@kernel.org>, David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, netdev-driver-reviewers@vger.kernel.org
Subject: Re: [ANN] Mailing list migration - Tue, May 2nd
Message-ID: <20230502191035.61d1f52d@kernel.org>
In-Reply-To: <20230502-greeter-swiftness-facc2c@meerkat>
References: <20230425140614.7cfe3854@kernel.org>
	<20230502-greeter-swiftness-facc2c@meerkat>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 2 May 2023 17:08:46 -0400 Konstantin Ryabitsev wrote:
> On Tue, Apr 25, 2023 at 02:06:14PM -0700, Jakub Kicinski wrote:
> > Hi all!
> >=20
> > We are planning to perform a migration of email distribution for=20
> > the netdev@vger mailing list on Tue, May 2nd (4PM EDT / 1PM PDT). =20
>=20
> Hi, all:
>=20
> This should be the final message to test archive propagation. The move has
> been complete -- if you notice that something isn't working right or not
> looking right, or not archiving right, please alert me.
>=20
> Everything regarding the list should work exactly as before, just the
> Received: headers will be a bit different.

Thanks for the migration, everything seems to be working fine!
Feels like an end of an era =F0=9F=A5=B2=EF=B8=8F

I don't have the right words to express the gratitude to DaveM
for maintaining vger over the years, along all his other community
responsibilities. Thank you!

And thanks to John for helping more recently and always answering
our inconveniently timed calls!

