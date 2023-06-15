Return-Path: <netdev+bounces-11224-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 47E3C732080
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 21:51:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82D791C20EDD
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 19:51:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61A68EAF0;
	Thu, 15 Jun 2023 19:51:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3702E0F5
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 19:50:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B69C433C8;
	Thu, 15 Jun 2023 19:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686858659;
	bh=2bbMoNJtloMz3PN/dxm0qKq6WULxG+X/hxRiIP+tqBA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GY2VS4p1gihCnSa+b5ubgxIJ2tz+Snm7goYwKeO/zGCMQZf88nskdr5qxw4i/G1Ks
	 Htjmwe36iune2mFu0ZGLtkbEa12+g5o38JEcSvS3lYL3toFBg9DCwaJgEu6JM9XS4W
	 IYEBcziahUPoc3bUeTz31IBpKYejKAI8lyFrVWQDI5NuqSgWwOgQFF52FadnC00fZp
	 xRz5prEdD+kN2LK33SgNJ9qlTDqWSYAyZI+Jp9RtJ4KqvSBzviouQOokfBTaj9C+9r
	 h8JxFKVsKqDMCsQJjyhbpLPu66E1JLUHahYpZtm94KHoD+GHEj0JE2zt5dSee4nbaj
	 /5AY0zvnvYc1w==
Date: Thu, 15 Jun 2023 12:50:58 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pavan Chebbi <pavan.chebbi@broadcom.com>
Cc: Alex Maftei <alex.maftei@amd.com>, richardcochran@gmail.com,
 shuah@kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] selftests/ptp: Fix timestamp printf format for
 PTP_SYS_OFFSET
Message-ID: <20230615125058.369367a6@kernel.org>
In-Reply-To: <CALs4sv2+nb3i8VQKNsqLzrCR0Sq6oHPwrzxYdeAaMVX+1-Z+VA@mail.gmail.com>
References: <20230615083404.57112-1-alex.maftei@amd.com>
	<CALs4sv2+nb3i8VQKNsqLzrCR0Sq6oHPwrzxYdeAaMVX+1-Z+VA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Jun 2023 15:13:27 +0530 Pavan Chebbi wrote:
> Change looks good but can you mark this for "net" correctly and get
> CI/sanity checks done.

It may be failing path selection, bot needs some changes in what it
considers "networking", tools/testing/selftests/ptp is not on the list.

If you have a few cycles feel free to extend this list:
https://github.com/kuba-moo/nipa/blob/master/netdev/tree_match.py#L47
post a PR on GH, I'll merge it in.

The patch is just a test fix, not worth reposting, IMHO.

