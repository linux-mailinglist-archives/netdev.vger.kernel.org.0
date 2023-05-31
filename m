Return-Path: <netdev+bounces-6885-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E3BC71890C
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 20:10:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BB431C20F09
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D812A1950E;
	Wed, 31 May 2023 18:09:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8814171C4
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 18:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5364DC433D2;
	Wed, 31 May 2023 18:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685556595;
	bh=PWhPFiCOHH923ObIRtbVUyySoqmgH8UiDnR2j8EkypU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pDDD+ltCjRoYtvdKj+yHQ50EyxHO6MIFQh1p2mZRh7TfB/CW00XRG3hDsKp43rkK9
	 z1gwb8CaWPwNkMUE7rnjCrUgGxS1ZisbXjseCAefobj2HK07l4KFkgDz7eyMljp9V3
	 ssOyYtQknkRNYJVc3CKfbm8xgKHVw2OtspuLn3aIb1qrLspYMTjmFXhrwC8ghVKbUW
	 ASMq7EBarSBN/g71K87YHdYnc5lciqj+zMd6qGGbziCZtvCcOBULZC7iotx4arh5Ok
	 JASFRK7yJ1HqJjKeJy3g1RRFSY2npMtcuUBHt2/ZTrylE5lGx3Kff/MtaW9/9SzMHw
	 oSoKo03a0BRHQ==
Date: Wed, 31 May 2023 11:09:54 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: David Miller <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: don't set sw irq coalescing defaults in
 case of PREEMPT_RT
Message-ID: <20230531110954.6cbf69d1@kernel.org>
In-Reply-To: <87535ce9-4780-d982-0535-d010720aa636@gmail.com>
References: <f9439c7f-c92c-4c2c-703e-110f96d841b7@gmail.com>
	<20230530233055.44e18e3a@kernel.org>
	<87535ce9-4780-d982-0535-d010720aa636@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 31 May 2023 10:18:40 +0200 Heiner Kallweit wrote:
> > Did someone complain? I don't have an opinion, but I'm curious what
> > prompted the patch.  
> 
> No direct complain, and not covering exactly this point.
> Background: I witnessed some discussions between PREEMPT_RT users
> (e.g. from linuxcnc project) regarding network latency with
> RTL8168 NICs. It seems these users aren't really aware of the
> userspace knobs that the kernel provides for RT optimization.
> To make their life easier we could optimize few things for latency
> and use PREEMPT_RT as an indicator.

Makes sense.

