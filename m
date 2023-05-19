Return-Path: <netdev+bounces-3792-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B42A4708E00
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 04:46:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 874AF1C211BA
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 02:46:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0FBE375;
	Fri, 19 May 2023 02:46:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BEF190
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 02:46:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2B0C433EF;
	Fri, 19 May 2023 02:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684464389;
	bh=HzVlejBquU/mmb9N9LGZsXPzxTgiTeUltfg3wkB5enM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JhsZps5y3teN7o2Ub3gAIL2XQCJvqlWWYqZ2xtzU5BJXtYcVL9XMJPOBN9lMJi9mU
	 QUkFMTyPOSIBWgDONh14j0KxzOLvTiOkLCVPQtLwq1ySN4fTU5b8kw2CqIR3Lyzybt
	 KgXdkF9rvq5usZ8xfj+vC5YeE6K5zFGofP6WDpTAZEhVOc0AuY67kxUB0ZiU1SpNP6
	 SxeLTNagpcmrUxnDTdPVx52iqvEcgNEUgfV6/FUuGiZqKOoeS/elhLwtWRbqJ22mVj
	 3cPiKKnIqxaPy9CvUbzmbvknoH2gmff0lVldsFohSwvdv6do4igJaCdGQ8LoHgu0WA
	 kjkMU9yhd5hHQ==
Date: Thu, 18 May 2023 19:46:27 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: yunchuan <yunchuan@nfschina.com>
Cc: rmody@marvell.com, skalluru@marvell.com, GR-Linux-NIC-Dev@marvell.com,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: bna: bnad: Remove unnecessary (void*)
 conversions
Message-ID: <20230518194627.4f9a6b04@kernel.org>
In-Reply-To: <f65fe4d6-7877-fd70-9e26-e94b4ebdde38@nfschina.com>
References: <20230517081801.508322e7@kernel.org>
	<f65fe4d6-7877-fd70-9e26-e94b4ebdde38@nfschina.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 19 May 2023 09:38:49 +0800 yunchuan wrote:
> >> website: https://kernelnewbies.org/KernelJanitors/Todo/VoidPointerConvs  
> > How many of such patches will it take to clean up all of net/ and drivers/net ?  
> 
> I have identified 48 areas that need to be modified using the script, 
> and have not yet confirmed whether all of them need to be modified.

Once you have worked thru all - please send the changes in series of 
10 patches at a time.

