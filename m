Return-Path: <netdev+bounces-9417-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AEBB728DFE
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 04:30:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8DEE280E68
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 02:30:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB9E3805;
	Fri,  9 Jun 2023 02:30:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7122D8462
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 02:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F19E7C433A1;
	Fri,  9 Jun 2023 02:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686277824;
	bh=1uvlMNAiH2pT+WfEUeqgVcjSsF9uldxpT/QwsRKWqVQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=SmDfAC68/iXWbbzMyKCok0SViqwcu9hfqP6Z9koUV1BidS7HuQvH57QDL74AmAMJy
	 KDYpkBB25bW0n71q02lWZhOexukHZK8ePaz4NjR056Z4y23Wayf0Mpr7bMaFdr+bbK
	 5s7N9E/KPOVohReQ9LSiXsFQC/2MdvVUnGcUieYmdpkcMPmYlsZESl4hVVwB+iQr6F
	 WWT9YgTgtHa+29UhgRBmQUJ1GgF7G9lyypKxhIJUNKrAik/YNT19nQ5/dk5kXvfk7x
	 ygl4dvK6MQh5RhpC7P0L1qxLGhMHGND2xFMMY5EClpFIZ4Vgu6JD3ggY6rGJYXM3e5
	 lKspOQxOTWQJQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D6000E4D015;
	Fri,  9 Jun 2023 02:30:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/11] complete Lynx mdio device handling
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168627782387.6230.14795941362471671231.git-patchwork-notify@kernel.org>
Date: Fri, 09 Jun 2023 02:30:23 +0000
References: <ZIBwuw+IuGQo5yV8@shell.armlinux.org.uk>
In-Reply-To: <ZIBwuw+IuGQo5yV8@shell.armlinux.org.uk>
To: Russell King (Oracle) <linux@armlinux.org.uk>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
 edumazet@google.com, ioana.ciornei@nxp.com, kuba@kernel.org,
 madalin.bucur@nxp.com, netdev@vger.kernel.org, pabeni@redhat.com,
 sean.anderson@seco.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 7 Jun 2023 12:57:47 +0100 you wrote:
> Hi,
> 
> This series completes the mdio device lifetime handling for Lynx PCS
> users which do not create their own mdio device, but instead fetch
> it using a firmware description - namely the DPAA2 and FMAN_MEMAC
> drivers.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/11] net: dpaa2-mac: allow lynx PCS to manage mdiodev lifetime
    https://git.kernel.org/netdev/net-next/c/6c79a9c8b1f3
  - [net-next,v2,02/11] net: fman_memac: allow lynx PCS to handle mdiodev lifetime
    https://git.kernel.org/netdev/net-next/c/d7b6ea1a14e4
  - [net-next,v2,03/11] net: pcs: lynx: remove lynx_get_mdio_device()
    https://git.kernel.org/netdev/net-next/c/b3b984dc0ba6
  - [net-next,v2,04/11] net: pcs: lynx: add lynx_pcs_create_fwnode()
    https://git.kernel.org/netdev/net-next/c/6e1a12821d34
  - [net-next,v2,05/11] net: dpaa2-mac: use lynx_pcs_create_fwnode()
    https://git.kernel.org/netdev/net-next/c/595fa7634d71
  - [net-next,v2,06/11] net: fman_memac: use lynx_pcs_create_fwnode()
    https://git.kernel.org/netdev/net-next/c/929a629c211f
  - [net-next,v2,07/11] net: pcs: lynx: make lynx_pcs_create() static
    https://git.kernel.org/netdev/net-next/c/84e476b876d9
  - [net-next,v2,08/11] net: pcs: lynx: change lynx_pcs_create() to return error-pointers
    https://git.kernel.org/netdev/net-next/c/05b606b88452
  - [net-next,v2,09/11] net: pcs: lynx: check that the fwnode is available prior to use
    https://git.kernel.org/netdev/net-next/c/d143898c6d7b
  - [net-next,v2,10/11] net: dpaa2: use pcs-lynx's check for fwnode availability
    https://git.kernel.org/netdev/net-next/c/8c1d0b339d67
  - [net-next,v2,11/11] net: fman_memac: use pcs-lynx's check for fwnode availability
    https://git.kernel.org/netdev/net-next/c/32fc30353f7c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



