Return-Path: <netdev+bounces-3382-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A83A706C74
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:18:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A6961C20AF4
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 15:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 553F9A93B;
	Wed, 17 May 2023 15:18:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191473FFB
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 15:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C00C433D2;
	Wed, 17 May 2023 15:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684336682;
	bh=cWcgy+WXrTxYPzrTHi3+xEB3IMvot8diduwzGD+rAso=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Muyi2vS/UZSeib2ZIaK3A6mhcUzwDoUbr430Vj/VgbMDPlC3VtXusO6AFKADj13Ae
	 nce3X9fosN7mCH8Z/Mriu/yKFbDEStAJwvQB3LBsOPpsGKxvjSYIkaY4sH/jxqSgtN
	 U5HhKEyL7kthKjPRqQLsZ3BFOhUZGlYPIlfZx68cYZREnygb62F7W8iW7xZwb1Zs14
	 Zw1iM4OHEI3nwFXOkkvZooXjGLhc891+Vqy74qFNcjTbQ73ePph2CyLj88aQF+RN/d
	 t3RztcR+0HOoiOiZJa9eklzDMxFp9oxvxPuV6rxkY+H/qW4voVA3zGts/6Whkp8aLi
	 1OibkELrhSwiA==
Date: Wed, 17 May 2023 08:18:01 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: yunchuan <yunchuan@nfschina.com>
Cc: rmody@marvell.com, skalluru@marvell.com, GR-Linux-NIC-Dev@marvell.com,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: bna: bnad: Remove unnecessary (void*)
 conversions
Message-ID: <20230517081801.508322e7@kernel.org>
In-Reply-To: <bea72de9-5f97-16a9-6703-05789ed53c1d@nfschina.com>
References: <20230516201739.21c37850@kernel.org>
	<bea72de9-5f97-16a9-6703-05789ed53c1d@nfschina.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 17 May 2023 13:14:11 +0800 yunchuan wrote:
> =E5=9C=A8 2023/5/17 11:17, Jakub Kicinski =E5=86=99=E9=81=93:
> > On Wed, 17 May 2023 10:27:05 +0800 wuych wrote: =20
> >> Pointer variables of void * type do not require type cast. =20
> > What tool are you using to find these.
> > How many of such patches will it take to clean up the entire tree? =20
>=20
> I use the scripts I found on the=C2=A0 kernel Newbies to find these.
>=20
> website: https://kernelnewbies.org/KernelJanitors/Todo/VoidPointerConvs

How many of such patches will it take to clean up all of net/ and drivers/n=
et ?=20

