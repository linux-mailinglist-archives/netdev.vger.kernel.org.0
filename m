Return-Path: <netdev+bounces-3172-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A8BB705DDF
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:17:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22B09281315
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 03:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A3FD17F2;
	Wed, 17 May 2023 03:17:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C333117E0
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 03:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43F6C433D2;
	Wed, 17 May 2023 03:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684293461;
	bh=iFD+DYOWkfeczPPjNdnXp8SDy5OJDTWmunWJyEwuxQk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EtrcOesYJl6GG6P4m3mD0bLmmE7MM71sTiX0A8JK6U1SGs2xbGUEIFhRNMl9O4TJ9
	 5tHsCnjXVihnNg4m9DLHgIg9hZ6LKb7Y81TBFxthWJ+tx4Cylvtnn658y0Uxy+ZEh+
	 FsIA8N1D0JghuMyjdaZb/r8ElJiR5ZL4dbEwKDAZfnFiOzhYXG7oBjWq8fM2QxVm2b
	 dBXUUvGZLN+lxsVJT8E+P+kzn+AlTVfiyksrH1TnJ9eldsqLn1VDpIHMjk89XlPPuy
	 v7h64xDRr0uJZ/fpprjCgCGDCwKWSoeeccAEb9N28NFQNEIpXfWyLNT6CnmttBCEJ1
	 Lv7xQP1qFuYxA==
Date: Tue, 16 May 2023 20:17:39 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: wuych <yunchuan@nfschina.com>
Cc: rmody@marvell.com, skalluru@marvell.com, GR-Linux-NIC-Dev@marvell.com,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: bna: bnad:  Remove unnecessary (void*)
 conversions
Message-ID: <20230516201739.21c37850@kernel.org>
In-Reply-To: <20230517022705.112448-1-yunchuan@nfschina.com>
References: <20230517022705.112448-1-yunchuan@nfschina.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 17 May 2023 10:27:05 +0800 wuych wrote:
> Pointer variables of void * type do not require type cast.

What tool are you using to find these.
How many of such patches will it take to clean up the entire tree?
-- 
pw-bot: reject

