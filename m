Return-Path: <netdev+bounces-4475-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E997870D13D
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:30:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB3FF280F02
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 02:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0732F1108;
	Tue, 23 May 2023 02:30:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6032A4C8E
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03DD5C433D2;
	Tue, 23 May 2023 02:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684809019;
	bh=/gIqHoFjt8M64XKdDtFb6V1OoH2Wd0AkbZsnebu7fCA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=dFUXAc4CyQTWZ+4Prfnd2mjS8phO0hWvb33eu8rh276o43ALcaKvUTZFgaYJx16Jh
	 4Ep+He9dHuXQnMZjfQgbBGskEq7MRX2OuonhGCwm1lo8JRp5kvzc8/GvJaJDnEicjO
	 U3xZolAu/4E2ZNYLSY4dnv0UsqAFKf+M5luJKtLJgOquywmS+MrMXhICdiVw/YaSI+
	 JO9M7Hyai9Pj6N2Y14AUS9D/Lue0p+nMSZfwOQ7FIGakPSwBsFDd1Bq7cpcFuhISPk
	 h+3iKU1HD5GtKZiU5V2eXxv74AAjH889ZaBDhjBCZf/UY0g3moBYc0+aP6spHzNpor
	 lgQVzT+KSX4NQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DC960E22B07;
	Tue, 23 May 2023 02:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] 3c589_cs: Fix an error handling path in tc589_probe()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168480901889.21333.9242102292843319105.git-patchwork-notify@kernel.org>
Date: Tue, 23 May 2023 02:30:18 +0000
References: <d8593ae867b24c79063646e36f9b18b0790107cb.1684575975.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <d8593ae867b24c79063646e36f9b18b0790107cb.1684575975.git.christophe.jaillet@wanadoo.fr>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, linux@dominikbrodowski.net, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org, netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 20 May 2023 11:48:55 +0200 you wrote:
> Should tc589_config() fail, some resources need to be released as already
> done in the remove function.
> 
> Fixes: 15b99ac17295 ("[PATCH] pcmcia: add return value to _config() functions")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/3com/3c589_cs.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net] 3c589_cs: Fix an error handling path in tc589_probe()
    https://git.kernel.org/netdev/net/c/640bf95b2c7c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



