Return-Path: <netdev+bounces-7636-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0487720E3F
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 09:00:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C75D281B8A
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 07:00:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B063FA954;
	Sat,  3 Jun 2023 07:00:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C9BEA0
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 07:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 07CF9C433D2;
	Sat,  3 Jun 2023 07:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685775622;
	bh=otChWLMM6+DgC5sU96UtDU6GARkomiqyXLNhTkbHgVw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=X76nRbPEwxbNaYcYc4JJoAOA5VgcYw4w24GG164Af0Ic9NpVi3lYxzUdG0jr8QOtP
	 DM1WhlW8353Qyb58jPk1qF9Lmyq9dpvuJ9ERsePUV0YlDymhA6ye2+XRdYJJJhARB3
	 RcL67NneKl5wtAtm++bVLFWGxmr/mZMyz4OmHIqYe8Am0MIbwGErH/bRLIiH6a9OLM
	 nGvZ3ANyWEEswN6yotsxmJVz0blb1RsuJiv3gu2Huqk1zA4FnnnHlt+0dgjYHMhHw0
	 KHJjoSSlZeWWBUZ7rXWGJ842IIkWoOAOaAnrZ1ru6MuMfM2i1Eeh6fn5BmNjwTAEU/
	 V6Etj/YNGrZPw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E4E92C395E0;
	Sat,  3 Jun 2023 07:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phylink: actually fix ksettings_set() ethtool call
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168577562193.13767.8075188819836108856.git-patchwork-notify@kernel.org>
Date: Sat, 03 Jun 2023 07:00:21 +0000
References: <E1q4eLm-00Ayxk-GZ@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1q4eLm-00Ayxk-GZ@rmk-PC.armlinux.org.uk>
To: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, Raju.Lakkaraju@microchip.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 01 Jun 2023 10:12:06 +0100 you wrote:
> Raju Lakkaraju reported that the below commit caused a regression
> with Lan743x drivers and a 2.5G SFP. Sadly, this is because the commit
> was utterly wrong. Let's fix this properly by not moving the
> linkmode_and(), but instead copying the link ksettings and then
> modifying the advertising mask before passing the modified link
> ksettings to phylib.
> 
> [...]

Here is the summary with links:
  - [net] net: phylink: actually fix ksettings_set() ethtool call
    https://git.kernel.org/netdev/net/c/03c44a21d033

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



