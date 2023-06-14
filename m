Return-Path: <netdev+bounces-10575-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C9C872F2E8
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 05:05:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 353C828113F
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 03:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62DBD381;
	Wed, 14 Jun 2023 03:05:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82ED5363
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 03:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16113C433C8;
	Wed, 14 Jun 2023 03:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686711909;
	bh=xoHQmnYmJ6KBtKA70fFzukdRNsmAvtvdjH+4lJYpfs8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=H8AjZnOE3c4oFK069c25pRamwKCTAO3UFDBCBBfL8iGkIzl6+RSBevwcnMLPF5Zbb
	 FY8iHS3XT+rAxvS0X1rQgVCdCGGY53I2vP0GpcIS9ckB8GfUGwr7y8O/Bbb1I+OpEA
	 xtcLZ9nIGmTe4cI9F26keoIOSnVhGl7b1mC97WwJ3iXo6JgnP9Y24rW9HYfPw73kji
	 7Bb0AnJC9apV2pILWcF6PUwyD8TRI1ln+Hfh8v0QJCT7bpOoiespzMBJJ8qaoYpwye
	 sMFq+yxG4CD3/eQL/9+Dz8i8/WDfICKOuNoOwT9n7WQeFhYKWJgE4xZh+t0UCdx6R6
	 YFfAro/NQYUrw==
Date: Tue, 13 Jun 2023 20:05:08 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: baomingtong001@208suo.com
Cc: rajur@chelsio.com, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: Remove unneeded variable
Message-ID: <20230613200423.5114ca53@kernel.org>
In-Reply-To: <da4db284f25d227586a0e45c910eb402@208suo.com>
References: <20230614014154.59776-1-luojianhong@cdjrlc.com>
	<da4db284f25d227586a0e45c910eb402@208suo.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 09:44:22 +0800 baomingtong001@208suo.com wrote:
> Fix the following coccicheck warning:
> 
> drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c:640:14-21: Unneeded 
> variable: "fw_caps".

Please don't send these kind of changes for any code under net/
or drivers/net, it's pointless noise.

