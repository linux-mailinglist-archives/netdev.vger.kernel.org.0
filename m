Return-Path: <netdev+bounces-9252-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F419728478
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:01:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8495C1C20FF7
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BEAF16414;
	Thu,  8 Jun 2023 16:01:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7451628F3
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FC0C433EF;
	Thu,  8 Jun 2023 16:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686240111;
	bh=uxVKn8B7UnQ7DreeWBr1pGGtJNVRbe4Xc8LONzaoKIo=;
	h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
	b=HmC8d/8cWuDnixAGJOBiwaVNqpPdxrnj2y90EpYHdD9J3T1n9znwL8njhjbYfG5K6
	 P/b/3utJHAuGyP363I8W6hymnA6B5oypOD4H29DCTtAvrExZcvH1NUhfIpXgqRkTkQ
	 s5PVA8Hj33SfKBm53uffoR3sp0SqRBNXQwIUO9l7VzWaoFdSwuvOOUo9hTko1GYP9/
	 LoB5/vdyFN9l0L7xXluzMYAL0UUro9wSSeg9LEhaPMrZ0Sk6YaG6hcmeR8UcKfSvn8
	 TUt/iifOyBpgGx/HZtLMXJPsaZTpnHUjAHeKhcPMyKxaDB0eBBVzvUzSWQwQ/9Vd7/
	 2e/wVIC3KKqXw==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rsi: Do not configure WoWlan in shutdown hook if
 not
 enabled
From: Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230527222833.273741-1-marex@denx.de>
References: <20230527222833.273741-1-marex@denx.de>
To: Marek Vasut <marex@denx.de>
Cc: linux-wireless@vger.kernel.org, Marek Vasut <marex@denx.de>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Jilin Yuan <yuanjilin@cdjrlc.com>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168624010800.5828.9610241801394227388.kvalo@kernel.org>
Date: Thu,  8 Jun 2023 16:01:49 +0000 (UTC)

Marek Vasut <marex@denx.de> wrote:

> In case WoWlan was never configured during the operation of the system,
> the hw->wiphy->wowlan_config will be NULL. rsi_config_wowlan() checks
> whether wowlan_config is non-NULL and if it is not, then WARNs about it.
> The warning is valid, as during normal operation the rsi_config_wowlan()
> should only ever be called with non-NULL wowlan_config. In shutdown this
> rsi_config_wowlan() should only ever be called if WoWlan was configured
> before by the user.
> 
> Add checks for non-NULL wowlan_config into the shutdown hook. While at it,
> check whether the wiphy is also non-NULL before accessing wowlan_config .
> Drop the single-use wowlan_config variable, just inline it into function
> call.
> 
> Fixes: 16bbc3eb8372 ("rsi: fix null pointer dereference during rsi_shutdown()")
> Signed-off-by: Marek Vasut <marex@denx.de>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Patch applied to wireless-next.git, thanks.

b241e260820b wifi: rsi: Do not configure WoWlan in shutdown hook if not enabled

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230527222833.273741-1-marex@denx.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


