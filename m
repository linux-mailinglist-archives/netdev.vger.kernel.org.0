Return-Path: <netdev+bounces-10076-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD21F72BE5D
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 12:10:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4ED21C20971
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A727B18C29;
	Mon, 12 Jun 2023 10:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121C818B07
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 10:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8A73DC4339C;
	Mon, 12 Jun 2023 10:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686564621;
	bh=uP2l2BJmQspQVoWsRtgyzT95+fcOAjE2Ba/WofqfqWY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=hATCNYdECRaMz8yHt5k7kJtoT6RDUkzC5+iz8YNXTSEpl98BX+vV9Xvf9g02cXDWg
	 Ux3MGtGrs5Ha4edokgON3cRtrerKqzNQt36kSZaW2yzGPhZXlAUMYvHivq5B0qaQc6
	 lui8QmY0OMApzuO9PYONOLln23obwwDgGhRDFFe0UDWz4FWYTZqwE6z4M2gD/SwyHA
	 TWtkzwDOPI59HNKofWy0uvbh37xJor+kHH0dQL3R88PzitH/a22cyAF8w4TQPyGd6J
	 djqnzuZ5uexjJ/19FbwI+ZBkQ2anuWVMhlHGFdUJWdU9xfKm2daCSTQ/y9xqBDgkWm
	 t6wH09G1UsUHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6A9AAC395EC;
	Mon, 12 Jun 2023 10:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/12] tools: ynl: generate code for the ethtool
 family
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168656462143.8451.16448391404469889104.git-patchwork-notify@kernel.org>
Date: Mon, 12 Jun 2023 10:10:21 +0000
References: <20230609214346.1605106-1-kuba@kernel.org>
In-Reply-To: <20230609214346.1605106-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, sdf@google.com

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri,  9 Jun 2023 14:43:34 -0700 you wrote:
> And finally ethtool support. Thanks to Stan's work the ethtool family
> spec is quite complete, so there is a lot of operations to support.
> 
> I chickened out of stats-get support, they require at the very least
> type-value support on a u64 scalar. Type-value is an arrangement where
> a u16 attribute is encoded directly in attribute type. Code gen can
> support this if the inside is a nest, we just throw in an extra
> field into that nest to carry the attr type. But a little more coding
> is needed to for a scalar, because first we need to turn the scalar
> into a struct with one member, then we can add the attr type.
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] tools: ynl-gen: support excluding tricky ops
    https://git.kernel.org/netdev/net-next/c/008bcd6835a2
  - [net-next,02/12] tools: ynl-gen: record extra args for regen
    https://git.kernel.org/netdev/net-next/c/33eedb0071c8
  - [net-next,03/12] netlink: specs: support setting prefix-name per attribute
    https://git.kernel.org/netdev/net-next/c/ed2042cc77f1
  - [net-next,04/12] netlink: specs: ethtool: add C render hints
    https://git.kernel.org/netdev/net-next/c/d4813b11d679
  - [net-next,05/12] tools: ynl-gen: don't generate enum types if unnamed
    https://git.kernel.org/netdev/net-next/c/dddc9f53da3e
  - [net-next,06/12] tools: ynl-gen: resolve enum vs struct name conflicts
    https://git.kernel.org/netdev/net-next/c/2c9d47a095f7
  - [net-next,07/12] netlink: specs: ethtool: add empty enum stringset
    https://git.kernel.org/netdev/net-next/c/180ad455273a
  - [net-next,08/12] netlink: specs: ethtool: untangle UDP tunnels and cable test a bit
    https://git.kernel.org/netdev/net-next/c/37c852222712
  - [net-next,09/12] netlink: specs: ethtool: untangle stats-get
    https://git.kernel.org/netdev/net-next/c/709d0c3b3d4c
  - [net-next,10/12] netlink: specs: ethtool: mark pads as pads
    https://git.kernel.org/netdev/net-next/c/68335713d2ea
  - [net-next,11/12] tools: ynl: generate code for the ethtool family
    https://git.kernel.org/netdev/net-next/c/2d7be507d65e
  - [net-next,12/12] tools: ynl: add sample for ethtool
    https://git.kernel.org/netdev/net-next/c/f561ff232a6b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



