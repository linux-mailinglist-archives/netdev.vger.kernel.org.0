Return-Path: <netdev+bounces-4471-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A38C570D117
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:20:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E6A21C20BFF
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 02:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB31E1FB3;
	Tue, 23 May 2023 02:20:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1CA186D
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4906FC4339E;
	Tue, 23 May 2023 02:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684808422;
	bh=9W4xaa5QP+v4PDYZATxqoDcv/a3qmoU/poQKF9fCtF8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=rgKIMaO2+W2HBO/542ZFBigOCWVN0dXL5GxIdOHX9blLvkTNseQIpx4lvV8o1UInI
	 SUeYQMv/fiDGaDp/uhBxm2DanE/UEXqf41xWgNcqZmds6nADYhMXPvapz9Uk8ig9aq
	 0P89Txzw7dum84kzFj4Wh8DSmrGgg2ETY5fbpxT/tNx79IHDaXgUsRFU8tgAm+ivE9
	 0re7+Rgqq4iysCZFopTNCbnj4/BjKoJtyhsBaz2uuh/0rnXPAoeDC5h15rGTRZvrYt
	 a+jhFNA8ER8MjEOVlpNSrXzDwx6jO4B9O1SwlAeYxEuBbPfHrBH7+m8tuHGgkvOc6a
	 cmeEk4fNf/4Yw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 30053E22B07;
	Tue, 23 May 2023 02:20:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phylink: require supported_interfaces to be
 filled
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168480842219.16910.14868436676929905537.git-patchwork-notify@kernel.org>
Date: Tue, 23 May 2023 02:20:22 +0000
References: <E1q0K1u-006EIP-ET@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1q0K1u-006EIP-ET@rmk-PC.armlinux.org.uk>
To: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 20 May 2023 11:41:42 +0100 you wrote:
> We have been requiring the supported_interfaces bitmap to be filled in
> by MAC drivers that have a mac_select_pcs() method. Now that all MAC
> drivers fill in the supported_interfaces bitmap, it is time to enforce
> this. We have already required supported_interfaces to be set in order
> for optical SFPs to be configured in commit f81fa96d8a6c ("net: phylink:
> use phy_interface_t bitmaps for optical modules").
> 
> [...]

Here is the summary with links:
  - [net-next] net: phylink: require supported_interfaces to be filled
    https://git.kernel.org/netdev/net-next/c/de5c9bf40c45

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



