Return-Path: <netdev+bounces-6995-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26F317192CF
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 07:56:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2A881C20F11
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 05:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F9C37464;
	Thu,  1 Jun 2023 05:56:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228526FC8
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 05:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC49C433D2;
	Thu,  1 Jun 2023 05:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685599006;
	bh=pXabiGJ+htGEj/q+weEbEcWMJYpdgQiGnMtsp5LisfA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CT/WInhgDmXi6INmuUydbkLvokkuTmPCTHqpX9/limsAoJc94jgidTn0axLkWJS04
	 1Oa/m1CgttuTwo1mNgehK5kf8ii0wccHwBHwAeY1MYslHa2cnQuDCGC+1QucEKZLMd
	 XiuuLEPDmA2+Rc5tvdefatUDo9iCsFiKiMWM9D4TDI0cj78cTKo42Na72KNNQtLxbc
	 jlW1du0/FeSFSJYx266ADX2UjJXewnvWZ9GxkrWxWSftmOQRLvGEyPqDLaH4v7mtxY
	 p0iQ/KTqM4D/nBm4PDlHRzZIKWZxt5VZ7/A/iSKiN0o4caNHs9xFj8+LYk1Q6/iPch
	 sJ9aY0YCJNxDQ==
Date: Wed, 31 May 2023 22:56:45 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: msmulski2@gmail.com
Cc: netdev@vger.kernel.org, michal.smulski@ooma.com
Subject: Re: [PATCH net-next v4] net: dsa: mv88e6xxx: implement USXGMII mode
 for mv88e6393x
Message-ID: <20230531225645.4b219034@kernel.org>
In-Reply-To: <20230531174720.7821-1-msmulski2@gmail.com>
References: <20230531174720.7821-1-msmulski2@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 31 May 2023 10:47:20 -0700 msmulski2@gmail.com wrote:
> From: Michal Smulski <michal.smulski@ooma.com>
> 
> Enable USXGMII mode for mv88e6393x chips. Tested on Marvell 88E6191X.

Doesn't seem to apply to net-next, and the CC list is definitely way
too short. You must CC people who responded to previous version of 
the patch and the maintainers.

Failed to apply patch:
Applying: net: dsa: mv88e6xxx: implement USXGMII mode for mv88e6393x
Using index info to reconstruct a base tree...
M	drivers/net/dsa/mv88e6xxx/chip.c
M	drivers/net/dsa/mv88e6xxx/port.c
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/dsa/mv88e6xxx/port.c
Auto-merging drivers/net/dsa/mv88e6xxx/chip.c
CONFLICT (content): Merge conflict in drivers/net/dsa/mv88e6xxx/chip.c
Recorded preimage for 'drivers/net/dsa/mv88e6xxx/chip.c'
error: Failed to merge in the changes.
hint: Use 'git am --show-current-patch=diff' to see the failed patch
Patch failed at 0001 net: dsa: mv88e6xxx: implement USXGMII mode for mv88e6393x
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

-- 
pw-bot: cr

