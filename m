Return-Path: <netdev+bounces-10655-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41AFA72F965
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:39:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EEBE28132B
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:39:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F2CB569D;
	Wed, 14 Jun 2023 09:39:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324693D6C;
	Wed, 14 Jun 2023 09:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FAAC433C8;
	Wed, 14 Jun 2023 09:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686735545;
	bh=3dwGe7NBdzXEbIELVlW6d1uX67nXdWAeWyq/2PZLMRU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vySnYjmakgnaf6AEEztSRXrsR3h8XSRiPnxGet/fxNQPrrELN8Ig1s40OlktoLCcm
	 sOt2QWc8Xmb0xLit2YUDQw+0neV/yqbbB0D8Kk897ARFpHoua6P7DviRmpg3mHMcsZ
	 z7HUAMqyHFiEOWWq7CTcmDsplknix2T6ax52xWZA=
Date: Wed, 14 Jun 2023 11:39:02 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Kalle Valo <kvalo@kernel.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
	Johannes Berg <johannes@sipsolutions.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: Re: Closing down the wireless trees for a summer break?
Message-ID: <2023061447-sneezing-engraved-e7a1@gregkh>
References: <87y1kncuh4.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y1kncuh4.fsf@kernel.org>

On Tue, Jun 13, 2023 at 05:22:47PM +0300, Kalle Valo wrote:
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

Sounds reasonable to me, have a nice vacation!

greg k-h

