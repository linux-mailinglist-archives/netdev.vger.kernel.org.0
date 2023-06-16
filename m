Return-Path: <netdev+bounces-11294-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F17987326F2
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F2A81C20F56
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 06:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0CB0ED4;
	Fri, 16 Jun 2023 06:00:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50427C
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 06:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3893EC433C8;
	Fri, 16 Jun 2023 06:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686895223;
	bh=HnQRwyunHewJwr7L0Fk6QAzen5YNO/w8JQDBxw1Fuqc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=gKDkbnabeVj3xONNJ/lcPjCyetDvJix+bmzeUzr0PWuIz5m3cgtSgibH1Ck747MoM
	 p7fXEC56JINWSMjK4FNZov9l9UJT6DlE5gqaR+BsYgLVs9UXJ/geqYFkVH3ofyjQEG
	 Uva0ZfQa4ttURf84Lgeu+4UJe98VZAvUWcCIkz33MaGqrhbPp+5eZzgG5lEAW9yrkV
	 AErf3c/y3VhDF2h6HtBdAQBRiHUzLfDw36gHgyRS/7ojQyPXUVfBdX6imwp3u3a+iY
	 1qY/pZvkKq97/p81JMJSv6wNnT4WHJ1DIq416vSkv71wUkSRcy6/kuUuzh9Qo2Gcrs
	 pyFEkiPZCZ2fw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 05EF0E21EE5;
	Fri, 16 Jun 2023 06:00:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/3] optimize procedure of changing MAC address on
 interface
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168689522302.30897.3895006000334449942.git-patchwork-notify@kernel.org>
Date: Fri, 16 Jun 2023 06:00:23 +0000
References: <20230614145302.902301-1-piotrx.gardocki@intel.com>
In-Reply-To: <20230614145302.902301-1-piotrx.gardocki@intel.com>
To: Piotr Gardocki <piotrx.gardocki@intel.com>
Cc: netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
 przemyslaw.kitszel@intel.com, michal.swiatkowski@linux.intel.com,
 pmenzel@molgen.mpg.de, kuba@kernel.org, maciej.fijalkowski@intel.com,
 anthony.l.nguyen@intel.com, simon.horman@corigine.com,
 aleksander.lobakin@intel.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 14 Jun 2023 16:52:59 +0200 you wrote:
> The first patch adds an if statement in core to skip early when
> the MAC address is not being changes.
> The remaining patches remove such checks from Intel drivers
> as they're redundant at this point.
> 
> v3: removed "This patch ..." from first patch to simplify sentence.
> v2: modified check in core to support addresses of any length,
> removed redundant checks in i40e and ice
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/3] net: add check for current MAC address in dev_set_mac_address
    https://git.kernel.org/netdev/net-next/c/ad72c4a06acc
  - [net-next,v3,2/3] i40e: remove unnecessary check for old MAC == new MAC
    https://git.kernel.org/netdev/net-next/c/c45a6d1a23c5
  - [net-next,v3,3/3] ice: remove unnecessary check for old MAC == new MAC
    https://git.kernel.org/netdev/net-next/c/96868cca7971

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



