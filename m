Return-Path: <netdev+bounces-5862-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE1EF713361
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 10:31:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 750C61C20BA6
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 08:30:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCAB337D;
	Sat, 27 May 2023 08:30:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E40379
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 08:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C549C433D2;
	Sat, 27 May 2023 08:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685176255;
	bh=JPWS/TwdOmrDP3bAilXLTKSHhTzY9cMCJkusV8E0+Y4=;
	h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
	b=RIVD0UAN0fIQcBDS3hqZEECqeCQPULxMKN0dS0PPFeuev6RJALAXdbSt1MiLkfODQ
	 7MyPXAgCRJDky6cECRkUdCEuODEWOJWkMrh7rJ/iPcWs/CvyDmUbISdUV4yoEPzjqL
	 yzZNTfyhmku9xfspfEcJjvoIqsTHLrRuQqKGq0dIclLYC1XpH+Ph6cX+TtrbRR28Mc
	 1sfv6+AZlKl9uYmdmfGFtfyjl+G1V4kHaGWHPheDf71feV3w6cn2poiojStcV5X6TC
	 T4+PsWxYLmGphIYRCy2woGA3lzpFe3RgA6dr5/GjUYmATMCf9OWM3AppKuF4yhrYgY
	 ZTOXQJOOeoNwg==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/2] wifi: ray_cs: remove one redundant del_timer
From: Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230316133236.556198-2-dzm91@hust.edu.cn>
References: <20230316133236.556198-2-dzm91@hust.edu.cn>
To: Dongliang Mu <dzm91@hust.edu.cn>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Dongliang Mu <dzm91@hust.edu.cn>,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168517624975.21544.1147869212838344605.kvalo@kernel.org>
Date: Sat, 27 May 2023 08:30:53 +0000 (UTC)

Dongliang Mu <dzm91@hust.edu.cn> wrote:

> In ray_detach, it and its child function ray_release both call
> del_timer(_sync) on the same timer.
> 
> Fix this by removing the del_timer_sync in the ray_detach, and revising
> the del_timer to del_timer_sync.
> 
> Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>

2 patches applied to wireless-next.git, thanks.

daef020558bc wifi: ray_cs: remove one redundant del_timer
072210c725c4 wifi: ray_cs: add sanity check on local->sram/rmem/amem

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230316133236.556198-2-dzm91@hust.edu.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


