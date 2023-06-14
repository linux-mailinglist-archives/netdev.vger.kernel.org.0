Return-Path: <netdev+bounces-10829-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17B6E730632
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:41:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7845E280F85
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B92A12EC3C;
	Wed, 14 Jun 2023 17:41:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B257F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 17:41:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AC5C433C8;
	Wed, 14 Jun 2023 17:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686764494;
	bh=CUYf/mEpnKS33qUE+7VaJsixEwVTMHMSW91RBVToosY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lxFxPw+HduQci86H431rVnO0ky88Vyd80gifwZwDt20Aayq0gTdLtw9Gwm1y1EHIP
	 +xSQKczG7lMjyH1rOan1kA52MLvzSNGrKlkbxsqm1dzw4XxAttHGBR9BzNgtqPGIIo
	 yFCNLlr/GcqHkjxOxfpQQlDDgBQahvKrXTXcH3/rWpdKuPfmv6PlL1k5lb0PWk757U
	 RsVh8lKGdxwlJhErb5onZmrHjmzIFacTTyNaMzXLqBQDEXy/LB6pUmiCXDWQPkd1jF
	 9Ehmu2grRTP0T6T3Jl8rP2GEdxz/a9wpVemFtCHZbA3tF2OvJSOuRySsEfrhQFxx8A
	 OLeetvW578BSQ==
Date: Wed, 14 Jun 2023 10:41:33 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Matthieu Baerts <matthieu.baerts@tessares.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, David Miller
 <davem@davemloft.net>, Networking <netdev@vger.kernel.org>, Linux Kernel
 Mailing List <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>, Mat Martineau <martineau@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20230614104133.55c93a32@kernel.org>
In-Reply-To: <c473ffea-49c3-1c9c-b35c-cd3978369d0f@tessares.net>
References: <20230614111752.74207e28@canb.auug.org.au>
	<c473ffea-49c3-1c9c-b35c-cd3978369d0f@tessares.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 10:51:16 +0200 Matthieu Baerts wrote:
> I added a note about the conflicts on the cover-letter:
> 
> https://lore.kernel.org/netdev/20230609-upstream-net-20230610-mptcp-selftests-support-old-kernels-part-3-v1-0-2896fe2ee8a3@tessares.net/
> 
> Maybe it was not a good place? I didn't know where to put it as there
> were multiple patches that were conflicting with each others even if the
> major conflicts were between 47867f0a7e83 ("selftests: mptcp: join: skip
> check if MIB counter not supported") and 0639fa230a21 ("selftests:
> mptcp: add explicit check for new mibs"). I guess next time I should add
> a comment referring to the cover-letter in the patches creating conflicts.

Hm, yeah, I think the cover letter may not be the best way.
Looks like Stephen didn't use it, anyway, and it confused patchwork.
No better idea where to put it tho :(

Maybe a link to a git rerere resolution uploaded somewhere we can wget
from easily?

