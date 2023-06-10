Return-Path: <netdev+bounces-9794-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 39A2772A9C4
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 09:15:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52B3E281AA7
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 07:14:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5B0679E3;
	Sat, 10 Jun 2023 07:14:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A552F3C0B
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 07:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59D3C433D2;
	Sat, 10 Jun 2023 07:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686381296;
	bh=rZTHX692UfDQHCB5RcR/SsN4erGXYNxF+S+zHPxEXZM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UcKiP2NzfEsMIrjqjOaew/P0AvVmHau+sWz2weaCAzzLZsfOPmW40Dohi5fLD7/4+
	 9E8moZyqjGvUhWOdOa6KmaPfSi8x3M3+pv+n3dx5khy82MeM37LqPXxSImgc8pVCJx
	 q1AUrgBXJKSZIsr/hdCDALv+owO7zeSZr88FeWA74fBY8kEMIKFik7umGVqlE7fhyY
	 +7d855G26K8j6cqMLyuSWx6T5HFoNY3b3rbZdttZFLBCB4DKIvOA0JXjMq+9oFqV50
	 U0y45YN6DGwFJ97+OYPyGg3Krwa5mEQzvxXgUVsiau57RzrOLvRW99OkSp4E1RUNRk
	 8x5dSp/jX7ASA==
Date: Sat, 10 Jun 2023 00:14:54 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Naveen Mamindlapalli <naveenm@marvell.com>
Cc: <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
 <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <sgoutham@marvell.com>
Subject: Re: [net-next PATCH 0/6] RVU NIX AF driver updates
Message-ID: <20230610001454.6a6e9972@kernel.org>
In-Reply-To: <20230608105007.26924-1-naveenm@marvell.com>
References: <20230608105007.26924-1-naveenm@marvell.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 8 Jun 2023 16:20:01 +0530 Naveen Mamindlapalli wrote:
> This patch series includes a few enhancements and other updates to the
> RVU NIX AF driver.
> 
> The first patch adds devlink option to configure NPC MCAM high priority
> zone entries reservation. This is useful when the requester needs more
> high priority entries than default reserved entries.

Doesn't apply, reportedly, please rebase.
-- 
pw-bot: cr

