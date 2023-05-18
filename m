Return-Path: <netdev+bounces-3759-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 225D4708A09
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 23:04:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27B9028199F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 21:04:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 321361EA6E;
	Thu, 18 May 2023 21:04:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D7B1DDDF
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 21:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91402C433EF;
	Thu, 18 May 2023 21:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684443891;
	bh=WO1/uXc1qhLL3pth/REVtKNVS77zKXLjrxpiV+QO2eI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZXv6DNRu4yO34k4t0F53YYl8jm7CeWBYYR88nKMhOBMc3BdxCrd5frnfuyjljAzAv
	 AlT53Yn+GFRl555U2FfsQ7HmdJEPqivZ90jDQ+SDimP9mtBOq3307saZEloqOc4lS4
	 /MnxN/tJ/NlJB0+FNqcv/Cb8m7Q9wRGOkSu/3KoWmOw21mn2Y08R/TprHobyk61o28
	 wp34jW5PLhh+ui96ZVQib3ZMMrsf+1h58tANIYOwJP7FugRj8sbyPH5a6cWzn1iC34
	 zsvlJpllBXLpRNY0TCcq6k/lycXCohAAcl3DgpQUDgDXLqnSQfC/LPNRfzMWEs3tyg
	 VFy9TMt1rnf/Q==
Date: Thu, 18 May 2023 14:04:50 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 netfilter-devel <netfilter-devel@vger.kernel.org>, Jeremy Sowden
 <jeremy@azazel.net>
Subject: Re: [PATCH net-next 3/9] netfilter: nft_exthdr: add boolean DCCP
 option matching
Message-ID: <20230518140450.07248e4c@kernel.org>
In-Reply-To: <20230518100759.84858-4-fw@strlen.de>
References: <20230518100759.84858-1-fw@strlen.de>
	<20230518100759.84858-4-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 May 2023 12:07:53 +0200 Florian Westphal wrote:
> From: Jeremy Sowden <jeremy@azazel.net>
> 
> The xt_dccp iptables module supports the matching of DCCP packets based
> on the presence or absence of DCCP options.  Extend nft_exthdr to add
> this functionality to nftables.

Someone is actually using DCCP ? :o

