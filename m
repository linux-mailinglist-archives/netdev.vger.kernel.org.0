Return-Path: <netdev+bounces-9254-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D202772847A
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:02:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 920A6281756
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D37751641A;
	Thu,  8 Jun 2023 16:02:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8606B16403
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1744BC433D2;
	Thu,  8 Jun 2023 16:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686240145;
	bh=3wFt8CGVTKC+TV3zZFmR8UtSu/tv1yh19COQfQNVFV4=;
	h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
	b=cv4XJmPuQhkV96OOPDNq0lLupc7lCsqeokuA03XXvMGRry4tK26h71egDKttjmlnL
	 DwMaDWPJV/j7vzhRobwpIdZoNkRGJSyuJbyxE2mhAYGWbITyJwaPSCE6wU5E4fNnXz
	 Nw0DOhHHAD+hOw6rzL3BtXn+VzlSGfQYay923C8EbCOWpIkHlCviuPpbDbQcGKwro3
	 Q2juei7vt2k8ERpdiDLbSAoSA9Y8mLw8pAuiSUse37u3XeBD8E+IPO0hRj/1GdkxoM
	 xvOV9mUyFjO5aECHAK0HAYz9tvX7B8Kv5JIX5GThzyPdkbT/YrjW3k60Bi4CuqorrU
	 UvwSHk7DprqNA==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rsi: Do not set MMC_PM_KEEP_POWER in shutdown
From: Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230527222859.273768-1-marex@denx.de>
References: <20230527222859.273768-1-marex@denx.de>
To: Marek Vasut <marex@denx.de>
Cc: linux-wireless@vger.kernel.org, Marek Vasut <marex@denx.de>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Jilin Yuan <yuanjilin@cdjrlc.com>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168624014117.5828.4271353370998823332.kvalo@kernel.org>
Date: Thu,  8 Jun 2023 16:02:22 +0000 (UTC)

Marek Vasut <marex@denx.de> wrote:

> It makes no sense to set MMC_PM_KEEP_POWER in shutdown. The flag
> indicates to the MMC subsystem to keep the slot powered on during
> suspend, but in shutdown the slot should actually be powered off.
> Drop this call.
> 
> Fixes: 063848c3e155 ("rsi: sdio: Add WOWLAN support for S5 shutdown state")
> Signed-off-by: Marek Vasut <marex@denx.de>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Patch applied to wireless-next.git, thanks.

e74f562328b0 wifi: rsi: Do not set MMC_PM_KEEP_POWER in shutdown

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230527222859.273768-1-marex@denx.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


