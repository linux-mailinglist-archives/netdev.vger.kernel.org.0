Return-Path: <netdev+bounces-9739-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8069872A596
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 23:50:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3ABB0281A63
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:50:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEFEC23C93;
	Fri,  9 Jun 2023 21:50:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827EE23C8A
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 21:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 009E9C4339C;
	Fri,  9 Jun 2023 21:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686347427;
	bh=r2Y+228UlLq+QM7mfqslZHNjL/SyNkUkIeXEObG7vQc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=q7TOufpnQ0NsPR0M1i/t7jLYUbJhcewn+7nSn9kvMJR3ET2bkHcwCS1VE5rMLIInL
	 WL8XO97dJrpK231k2zL48itQShpps5f+2KqXx79xTqX2oMEBdTZ0K6csoylx70TW44
	 9aSAj9ix5HbPtsOLGCiwVzeydQIsPymRDYx1N7MpVFYp19dHZqoerwFp0FxUNgClWz
	 +nbc2n7TbREhZtq8a4nSXf1qqW7sUM8qJzAttaFBbXDVEkO5XZK/zJymc9uJ5hELp9
	 jxD+SJMB7SkHoSK7Hf/8fEFjHIeZIZg4u+g6FlnTDOb+zPr1JjHEvlD9njpbjut28t
	 SlUknM5HLSSFw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DD8DDC395F3;
	Fri,  9 Jun 2023 21:50:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v3 00/12] Introduce new dcb-rewr subcommand
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168634742690.21323.10833908657473917944.git-patchwork-notify@kernel.org>
Date: Fri, 09 Jun 2023 21:50:26 +0000
References: <20230510-dcb-rewr-v3-0-60a766f72e61@microchip.com>
In-Reply-To: <20230510-dcb-rewr-v3-0-60a766f72e61@microchip.com>
To: Daniel Machon <daniel.machon@microchip.com>
Cc: netdev@vger.kernel.org, dsahern@kernel.org, stephen@networkplumber.org,
 petrm@nvidia.com, UNGLinuxDriver@microchip.com, me@pmachata.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Tue, 6 Jun 2023 09:19:35 +0200 you wrote:
> ========================================================================
> Introduction:
> ========================================================================
> 
> This series introduces a new DCB subcommand: rewr, which is used to
> configure the in-kernel DCB rewrite table [1].
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v3,01/12] dcb: app: add new dcbnl attribute field
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=1b276ffad53d
  - [iproute2-next,v3,02/12] dcb: app: replace occurrences of %d with %u for printing unsigned int
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=503e150007a1
  - [iproute2-next,v3,03/12] dcb: app: move colon printing out of callbacks
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=00d59f4013b8
  - [iproute2-next,v3,04/12] dcb: app: rename dcb_app_print_key_*() functions
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=b4a52658a06f
  - [iproute2-next,v3,05/12] dcb: app: modify dcb_app_print_filtered() for dcb-rewr reuse
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=a245bfe1c0c6
  - [iproute2-next,v3,06/12] dcb: app: modify dcb_app_table_remove_replaced() for dcb-rewr reuse
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=369a2df62a0d
  - [iproute2-next,v3,07/12] dcb: app: expose functions required by dcb-rewr
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=1be8ab537824
  - [iproute2-next,v3,08/12] dcb: rewr: add new dcb-rewr subcommand
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=1b2680f4696b
  - [iproute2-next,v3,09/12] dcb: rewr: add symbol for max DSCP value
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=19919442f1b1
  - [iproute2-next,v3,10/12] man: dcb-rewr: add new manpage for dcb-rewr
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=e97dcb5b150d
  - [iproute2-next,v3,11/12] man: dcb: add additional references under 'SEE ALSO'
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=9a3b4f7a5dee
  - [iproute2-next,v3,12/12] man: dcb-app: clean up a few mistakes
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=05241f063005

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



