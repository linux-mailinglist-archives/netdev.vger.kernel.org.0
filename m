Return-Path: <netdev+bounces-10842-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9656373080F
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:22:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7298A1C20D37
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:21:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1A9C11C85;
	Wed, 14 Jun 2023 19:21:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AEE2EC16;
	Wed, 14 Jun 2023 19:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A389DC433C0;
	Wed, 14 Jun 2023 19:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686770515;
	bh=pWxo7CHRl3J5qYPfbEQrjT3qEyGFaT8teEK3o66lcUg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dK0Dd7N/nvm9sa9sQ6YFqPCE0djK6abYGeOfqLaAE7OvmGz472hivmfCUPjdts4TH
	 lWlT7vbAcHHsUMba1vj+8aUrfOxPIj68Q1yX2s7UvyUY5mCfQP7WS3UtfxCqlW8fVp
	 C8v2z7HoXukO577ZJcuHlEaFxVfrq+Mo4O2xL5s+pHCFhnK0eWnPV3RWQnRF6kZon3
	 viVaPiKK9VKLFz5Y5pyaArOm/Lqmy0MkToDVJeYvh4xAEImO9OHI3Sdz7LvsD0djg6
	 ScEJyEIMlSNvmOehWIE4H3La7znDRQ1o9Vucgt7AyMCnEO1RGlOr9htW/N7lK6Q7D/
	 EG2L3x/IxylAw==
Date: Wed, 14 Jun 2023 12:21:53 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Kalle Valo <kvalo@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, Toke =?UTF-8?B?SMO4aWxhbmQt?=
 =?UTF-8?B?SsO4cmdlbnNlbg==?= <toke@kernel.org>,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: Closing down the wireless trees for a summer break?
Message-ID: <20230614122153.640292b9@kernel.org>
In-Reply-To: <87a5x2ccao.fsf@kernel.org>
References: <87y1kncuh4.fsf@kernel.org>
	<871qifxm9b.fsf@toke.dk>
	<20230613112834.7df36e95@kernel.org>
	<ba933d6e3d360298e400196371e37735aef3b1eb.camel@sipsolutions.net>
	<20230613195136.6815df9b@kernel.org>
	<c7c9418bcd5ac1035a007d336004eff48994dde7.camel@sipsolutions.net>
	<87a5x2ccao.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 18:07:43 +0300 Kalle Valo wrote:
> But do note that above is _only_ for -next patches. For patches going to
> -rc releases we apply the patches directly to wireless, no other trees
> are involved. My proposal was that net maintainers would take only fixes
> for -rc releases, my guess from history is that it would be maximum of
> 10-15 patches. And once me and Johannes are back we would sort out -next
> patches before the merge window. But of course you guys can do whatever
> you think is best :)

Ah, good note, I would have guessed that fixes go via special trees,
too. In that case it should indeed be easy. We'll just look out for
maintainer acks on the list and ping people if in doubt.

