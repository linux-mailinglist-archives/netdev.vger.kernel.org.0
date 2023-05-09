Return-Path: <netdev+bounces-1007-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F26B56FBCDD
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 04:06:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6457A280DBE
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 02:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E6ED38D;
	Tue,  9 May 2023 02:06:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA387C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 02:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190A2C433D2;
	Tue,  9 May 2023 02:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683597966;
	bh=dgjT6dL27HXmXM6P94ntzvFDyYMDcZP+Axttwbg850U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GAsKubYlmjrGlLNKt1lm9Pdu/5q0MFmImRgmZtY/yGOotgZL8hsqmCUYoimg40mZs
	 LabaR3SLRWzq7t7J3z7oPH4Lujw9yu83AfWywo9Me4Qkpf0vwdP7mVtVWw7W9IDUx9
	 WKTIZV7dkTyGc3OgQ3tBt9IVsjUwo0czCdmeDRqICICJouCHuzjluQKK5HhZuGTjgV
	 NGbVdqe0vG5fGxEydw8tSb71fqUtZS/g98oCuxclLniy6bUeqsbm9kkaT2gdpotnXw
	 x05ryE0BWFHmR75oLAFQidcnDh7AI6C9zOFfqycI4JIJ+PvzELKdoFhyFcBRvqsuuV
	 GBMP3MLuhr1ug==
Date: Mon, 8 May 2023 19:06:05 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Cathy Zhang <cathy.zhang@intel.com>
Cc: edumazet@google.com, davem@davemloft.net, pabeni@redhat.com,
 jesse.brandeburg@intel.com, suresh.srinivas@intel.com,
 tim.c.chen@intel.com, lizhen.you@intel.com, eric.dumazet@gmail.com,
 netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Message-ID: <20230508190605.11346b2f@kernel.org>
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
> Fixes: 4890b686f408 ("net: keep sk->sk_forward_alloc as small as possible")
> 

Ah, and for your future patches - no empty lines between trailers /
tags, please.

> Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
> Signed-off-by: Lizhen You <lizhen.you@intel.com>
> Tested-by: Long Tao <tao.long@intel.com>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
> Reviewed-by: Suresh Srinivas <suresh.srinivas@intel.com>

