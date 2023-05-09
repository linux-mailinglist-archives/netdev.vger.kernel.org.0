Return-Path: <netdev+bounces-1004-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B3FA6FBCD0
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 04:02:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F1651C20A88
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 02:02:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0764E38D;
	Tue,  9 May 2023 02:02:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9314D7C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 02:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4347C433D2;
	Tue,  9 May 2023 02:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683597723;
	bh=SxyS5zjD/hMSTlJC9HTLVIMH84Er/uWS53zlBCckoZ4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=sMEOWK7zLM6TJaoKLAUYxU3i+GK4RU9oYg6BtWMvVJOHz9+1L+bAlxhJpxo27BHGe
	 xnRBQXDQ3kMKXX0a6HiK4ELX2Fzao++g2cDP0jH9Wo0HBaDR2o56PbpTh5ylLzvHxL
	 dJHxbw/m3UokDSF2g5k2Qt4SKNNwN1Im7lb2STZlMZufvctsEK6S/j3a996JvHPS4E
	 MOHvljnUgm3KSBGx4OH/x6DPj22opzckgvitfQlU370M7OEW1OZmkZIOIxAGCMWyJr
	 X+ruN3IK5iROZDtXERBhaUNgSPVAOGva1XRpVS2ae95/38qV7Oc1H0O6xwOHy78EnK
	 4GWelghpkfPAg==
Date: Mon, 8 May 2023 19:02:01 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Cathy Zhang <cathy.zhang@intel.com>
Cc: edumazet@google.com, davem@davemloft.net, pabeni@redhat.com,
 jesse.brandeburg@intel.com, suresh.srinivas@intel.com,
 tim.c.chen@intel.com, lizhen.you@intel.com, eric.dumazet@gmail.com,
 netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Message-ID: <20230508190201.121fb4d9@kernel.org>
In-Reply-To: <20230508020801.10702-2-cathy.zhang@intel.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
	<20230508020801.10702-2-cathy.zhang@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun,  7 May 2023 19:08:00 -0700 Cathy Zhang wrote:
> +#define SK_RECLAIM_THRESHOLD	(1 << 16)

nit: SZ_64K

