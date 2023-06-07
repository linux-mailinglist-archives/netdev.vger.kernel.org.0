Return-Path: <netdev+bounces-9057-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 02611726D78
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:42:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DDAF1C208FF
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:42:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C59AE28C1D;
	Wed,  7 Jun 2023 20:42:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F81C38CBB
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 20:41:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B017C433EF;
	Wed,  7 Jun 2023 20:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686170519;
	bh=V7sBdU5qW0cbepwfGbWCvfkWf1L9gYfiiKnVcHhktPs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hcghqIFIS5PFaHYqlgjAD3tu6VSDe0KxS7Qe96zxvFQwoNPqSV7yvtiTBTZRMbxfQ
	 6NZGMB89OgSLTVqwrPxEXB+0bloCweBviC+GaA8AI+voUq+7mXTFy6Xzn2xMJQc0rV
	 EGIIUDxrdNLi7sZ8cWZPOEiEG2CMUK1Wl2pWVOhei4cFpMgC3KfLLDtVqjcRUJl9Ds
	 ZrfV7w41jw+yhm3X/dOsi4ebsDfs+ibKcEpGFdlrkZAG212uX5yRvMcTLLsGVSgjcO
	 EWdsMILeF8O7QVqoUtTz7B59lbWNxJoTCiwmGX6gUnYBKvfH9CqzX280jitJ5sK5D0
	 KnozvBPgX6kGA==
Date: Wed, 7 Jun 2023 13:41:58 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: pch_gbe: Allow build on MIPS_GENERIC kernel
Message-ID: <20230607134158.5438d28c@kernel.org>
In-Reply-To: <20230607055953.34110-1-jiaxun.yang@flygoat.com>
References: <20230607055953.34110-1-jiaxun.yang@flygoat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  7 Jun 2023 13:59:53 +0800 Jiaxun Yang wrote:
> v2: Add PTP_1588_CLOCK_PCH dependency.
> 
> Netdev maintainers, is it possible to squeeze this tiny patch into
> fixes tree?

Hm.. probably a little late for that. The first version didn't build,
feels too risky. We don't want to break the build of Linus's tree at
rc6/rc7. The merge window is two weeks out, is that really too long
of a wait?

