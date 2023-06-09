Return-Path: <netdev+bounces-9475-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BC2D729595
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:40:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35D332818D3
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 09:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 278B514267;
	Fri,  9 Jun 2023 09:40:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E350313AE1
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 54157C4339C;
	Fri,  9 Jun 2023 09:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686303622;
	bh=QsjPUpkRO5qwm0xSfCepOjD6AFakWYdIF5Oxfmz3lLo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=AvozqRxhS8wdOWpuR2IwxLOVmHpV8OMtKTIHCUC7neJhPIcj0U3WCnCaV1SPs3fUx
	 ZtZZnEaSHZi9HFWOYU/soFQ6G4oIdQNGLu/G+elYUGPsNLyOzdbuJ77t4V8jdZHXlG
	 gw7fDR3K43wWua4e2M+DdiN5hiUnMse7FAMyAWthEcJcXVrFx2nzQ/tFDxk4y4BC0j
	 bw56vf5WHzup4oz75gN08d2YGHA4uthN6HDJnBVrVATIgLjNu31yd45rSLh5zweRwD
	 7yXv3q6PoIZUI846QY1ZA5zbTcw+9h5aTaUM6Db2LTl9qevFxUkmHKZqcaGPOvzIiy
	 ayHvQP5+3FhJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3B998C43157;
	Fri,  9 Jun 2023 09:40:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/2] net/ncsi: refactoring for GMA command
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168630362223.15762.16643998871572719262.git-patchwork-notify@kernel.org>
Date: Fri, 09 Jun 2023 09:40:22 +0000
References: <20230607151742.6699-1-fr0st61te@gmail.com>
In-Reply-To: <20230607151742.6699-1-fr0st61te@gmail.com>
To: Ivan Mikhaylov <fr0st61te@gmail.com>
Cc: sam@mendozajonas.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, vijaykhemka@fb.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 openbmc@lists.ozlabs.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed,  7 Jun 2023 18:17:40 +0300 you wrote:
> Make one GMA function for all manufacturers, change ndo_set_mac_address
> to dev_set_mac_address for notifiying net layer about MAC change which
> ndo_set_mac_address doesn't do.
> 
> Changes from v1:
> 	1. delete ftgmac100.txt changes about mac-address-increment
> 	2. add convert to yaml from ftgmac100.txt
> 	3. add mac-address-increment option for ethernet-controller.yaml
> 
> [...]

Here is the summary with links:
  - [v3,1/2] net/ncsi: make one oem_gma function for all mfr id
    https://git.kernel.org/netdev/net-next/c/74b449b98dcc
  - [v3,2/2] net/ncsi: change from ndo_set_mac_address to dev_set_mac_address
    https://git.kernel.org/netdev/net-next/c/790071347a0a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



