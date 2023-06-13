Return-Path: <netdev+bounces-10474-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D6AF72EA9A
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 20:14:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A1C91C208A8
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 18:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B06923C0BE;
	Tue, 13 Jun 2023 18:14:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780C738CA4;
	Tue, 13 Jun 2023 18:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC10CC433D9;
	Tue, 13 Jun 2023 18:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686680083;
	bh=fjT4gpdjI8bzfc0kSPvWLMcKfBFEaXgHEzlFBmmWqkQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=YPBwCeRUs39kxlaLzdOB3U/bmTyHUsAgwUCs8NioF14TZY5ElTAYwBY3aLoc8t+wS
	 e7bjbenC0hl1zrZBBwEJynjtkv3y8YHI3Y0EL41PdFbkLqqmFNzGbNGIRl/VZnFsYI
	 CEwTLDbyKWuoN9nk3I/ejgmZ+2WowJN20sz99hVWF4I8TU1yLWxTHyDtznWvx7r7qp
	 Vri8t/fEYXoWjE2p8JoArbh5O2YE0NPTL2eCwWxwE7P/vGrX8992LrfTUUX5KaU5v4
	 52tJPG2/TK+wz8hZw12VOptpVSyRZhteeSItM9u2L0OhNiloXN3I+k9XVhutsfKh78
	 0Uq9DJwQX5BaA==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 64961BBEAD1; Tue, 13 Jun 2023 20:14:40 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To: Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 regressions@lists.linux.dev, Johannes Berg <johannes@sipsolutions.net>,
 Jakub Kicinski <kuba@kernel.org>
Subject: Re: Closing down the wireless trees for a summer break?
In-Reply-To: <87y1kncuh4.fsf@kernel.org>
References: <87y1kncuh4.fsf@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Tue, 13 Jun 2023 20:14:40 +0200
Message-ID: <871qifxm9b.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Kalle Valo <kvalo@kernel.org> writes:

> Me and Johannes are planning to take a longer break from upstream this
> summer. To keep things simple my suggestion is that we would official
> close wireless and wireless-next trees from June 23rd to August 14th
> (approximately).
>
> During that time urgent fixes would need go directly to the net tree.
> Patches can keep flowing to the wireless list but the the net
> maintainers will follow the list and they'll just apply them to the
> net tree directly.
>
> The plan here is that -next patches would have to wait for
> wireless-next to open. Luckily the merge window for v6.6 most likely
> opens beginning of September[1] so after our break we would have few
> weeks to get -next patches ready for v6.6.
>
> And the v6.5 -next patches should be ready by Monday June 19th so that we
> have enough time to get them into the tree before we close the trees.
>
> What do people think, would this work? This is the first time we are
> doing this so we would like to hear any comments about this, both
> negative and positive. You can also reply to me and Johannes privately,
> if that's easier.

I think this sounds reasonable, and I applaud the effort to take some
time off during the summer :)

One question that comes to mind is how would this work for patchwork?
Would we keep using the wireless patchwork instance for the patches
going to -net in that period, or will there be some other process for
this? I realise the setup we have for ath9k is a bit special in this
regard with the ack-on-list+delegation, so I'm obviously mostly
interested in what to do about that... :)

-Toke

