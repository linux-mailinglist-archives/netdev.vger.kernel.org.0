Return-Path: <netdev+bounces-1001-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6915F6FBCC5
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 03:53:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3504B2811D8
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 01:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85AEF396;
	Tue,  9 May 2023 01:53:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6DD383;
	Tue,  9 May 2023 01:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FB4C433D2;
	Tue,  9 May 2023 01:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683597178;
	bh=ZrT0gSNPIiNetPH2MV3BTeAcr8ZyvZCNKjDIa3x8L8s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HApIz9EGUv9pnmM5TSNV1KdsvWz9ryrcO+UzR3eXqKpg/r/cMmzVbz1AVFvx2doiv
	 dj+FnoZ4PlNTIs5XHjqS2pca79EmNiHViVj0y5+q5TtM/Qog4hzwATgrW2lXy2/0ZG
	 NFG2hHE1QWOnhzw77ZdU+8i/7ZTuoy3MFeALJq3y7FkdGlPcR0cInqV/o58lZtw6pf
	 dPt36dSEdPWZ+0PDG/HzZpeLEkD+jd8n35EZokjZmaUcgORza4VXTeO/8oYX8l3znT
	 GJ8c3H9RbbNKTE3ltUio9apc088aAJYMkIggmkAb0G5qeIEZEAvf97+RnzbWPDY4pU
	 GL9osRwq7+/VA==
Date: Mon, 8 May 2023 18:52:57 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Taichi Nishimura <awkrail01@gmail.com>
Cc: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org
Subject: Re: [PATCH] add braces to rt_type == RTN_BROADCAST case
Message-ID: <20230508185257.2e4f7434@kernel.org>
In-Reply-To: <20230509013601.2544346-1-awkrail01@gmail.com>
References: <20230509013601.2544346-1-awkrail01@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  9 May 2023 10:36:01 +0900 Taichi Nishimura wrote:
> Add braces to rt->rt_type == RTN_BROADCAST to make it easier
> to grasp the if-else-if statement.
> I think that it is ok to remove braces of rt_type == RTN_MULTICAST
> because IP_UPD_PO_STATS is oneliner.

I'm sorry but unfortunately we don't take pure coding style changes
(AKA checkpatch changes) in networking because they make backports
harder for little gain.
-- 
pw-bot: reject

