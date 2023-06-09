Return-Path: <netdev+bounces-9527-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00EE67299EA
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:28:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A949C2818DF
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:28:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE372171C0;
	Fri,  9 Jun 2023 12:28:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C25679E5
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:28:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2611C433EF;
	Fri,  9 Jun 2023 12:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686313695;
	bh=xmQbsGpjE1ohlx+uMchWdzhzKFcj0m+A3jS6YKTfnMc=;
	h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
	b=FL6vxUbsONT2hmbK18cIHVPbawKYk8VAgSBj7WFBSxWl84GGO7zXCfzioco6I1PZJ
	 MN/Z6rw9uCQXfMbp1nk7tfPcNnZalT0T6gChLEBvoUlSJYyavNR6wGHxYXnuARdVit
	 AoMqqTiNPeI1MVVqEdP3a6VW6h/TT2lYUjp9MnHwoeJYAF+0NmOlBwSAz0NE6z827c
	 pK7zCS6feJV+Q4YfAtvrbXXTa+XfO98X7EdtRWZfcQpliA46HtsM4t5Gt8eh+xXFtj
	 T0m7H+YgSqvAUt3opAf31cVx8jyPV0GIlCjjxvMAJhbPo3lbLDZJMNGYD4VwWTHPoL
	 PtmdyD9WbIHaQ==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/4] ath10k: Drop cleaning of driver data from
 probe
 error path and remove
From: Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230601082556.2738446-2-u.kleine-koenig@pengutronix.de>
References: <20230601082556.2738446-2-u.kleine-koenig@pengutronix.de>
To: =?utf-8?q?Uwe_Kleine-K=C3=B6nig?=  <u.kleine-koenig@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, ath10k@lists.infradead.org,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org, kernel@pengutronix.de
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168631369188.10496.13768584046079083634.kvalo@kernel.org>
Date: Fri,  9 Jun 2023 12:28:13 +0000 (UTC)

Uwe Kleine-König  <u.kleine-koenig@pengutronix.de> wrote:

> The driver core cares for resetting driver data if probe fails and after
> remove. So drop the explicit and duplicate cleanup in the driver's
> functions.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

4 patches applied to ath-next branch of ath.git, thanks.

ec3b1ce2ca34 wifi: ath10k: Drop cleaning of driver data from probe error path and remove
fad5ac80dfa5 wifi: ath10k: Drop checks that are always false
d457bff27633 wifi: ath10k: Convert to platform remove callback returning void
6358b1037157 wifi: atk10k: Don't opencode ath10k_pci_priv() in ath10k_ahb_priv()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230601082556.2738446-2-u.kleine-koenig@pengutronix.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


