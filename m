Return-Path: <netdev+bounces-10256-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA4C672D410
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 00:05:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 852BF28100F
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 22:05:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD3C223429;
	Mon, 12 Jun 2023 22:05:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5325D22D44
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 22:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74BAC433D2;
	Mon, 12 Jun 2023 22:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686607528;
	bh=67j+zg7ffLZr8d1DjU5R47Sa/2k7qREoVr6vB5Cd3Ak=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hatKJDtMvsdi7USGKbReD6lLZDJamN3rTvZ/af6LWTc9abHe2bv81ZiFuwsFTvgdV
	 WvbJk6hoz3MePv8iMRZjT6erUwQfTAeTOUniXNm7WBUIswCSV4+HQn/PamoS5zHPbj
	 9oUBAr7bY3yUJW9zLCdQHp7/LjjpQwppjP/Bwp7WcOsHRl2vbALIPU3Gq1AVkXv53N
	 5fWnV4fNE+5/PxWb009SHsqJga4tZbqUzRyRVpvKP3KxlVxmtzS2FKQAJsn4XDNuTI
	 THOSvXA1XDbdPG5xE+eqKzOTaU/ySDaAeKYDBL4EDJRvcEYSlO9ZXjQpS0tgUum7WM
	 b9QSonWi2YC3w==
Date: Mon, 12 Jun 2023 15:05:26 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tree Davies <tdavies@darkphysics.net>
Cc: anthony.l.nguyen@intel.com, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/e1000: Fix single statement blocks warning
Message-ID: <20230612150526.10ca14ac@kernel.org>
In-Reply-To: <ZIZI5czU2Qv5KrPA@oatmeal.darkphysics>
References: <ZIZI5czU2Qv5KrPA@oatmeal.darkphysics>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 11 Jun 2023 15:21:36 -0700 Tree Davies wrote:
> This patch fixes checkpatch.pl warning of type:
> WARNING: braces {} are not necessary for single statement blocks

We don't accept pure checkpatch "fixes" in networking, sorry.

