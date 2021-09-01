Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8293FD91D
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 14:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243888AbhIAMBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 08:01:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241703AbhIAMBC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 08:01:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ACD6A60F92;
        Wed,  1 Sep 2021 12:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630497605;
        bh=TJFWF6O/M89tOe5peR6syhL+AxR3eCH5u5/tmbONARo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MeUibz2+NACwzj+yYImBUDj7lXfryqKpsaSlTQD0i509zUUYu8alDFycFfxt1iR1P
         LaW4l79kFUPZ2/kOs6ORWyA/UUXDc/Hyao50RLQkZtmcGUPqZaHxQ+nMWzUMnpl0WT
         SQmdODUe1wu6fzpMfZ+IWVrbDUoau5NHwgkKslA8D9M6jQJnK5W8vXFWqb+xbm3Oz4
         QhkRCOZh27rSUHooyz5HjEfOTL5hFWytuw8Yoh0fqwzaLt+96Qn60b2DWsCkIRN8Lr
         rNL1YzdKjUOLcBbw6D8PDjNLFQ5zbMiT9E7EfqLeWsrq4wlG3vzitYn1n9ECysfzeJ
         Vz/UgK4uCSCxg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 989FF609CF;
        Wed,  1 Sep 2021 12:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [v3] mptcp: Fix duplicated argument in protocol.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163049760562.5493.836304668668785008.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Sep 2021 12:00:05 +0000
References: <20210901031932.7734-1-wanjiabing@vivo.com>
In-Reply-To: <20210901031932.7734-1-wanjiabing@vivo.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, kael_w@yeah.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  1 Sep 2021 11:19:32 +0800 you wrote:
> Fix the following coccicheck warning:
> ./net/mptcp/protocol.h:36:50-73: duplicated argument to & or |
> 
> The OPTION_MPTCP_MPJ_SYNACK here is duplicate.
> Here should be OPTION_MPTCP_MPJ_ACK.
> 
> Fixes: 74c7dfbee3e18 ("mptcp: consolidate in_opt sub-options fields in a bitmask")
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> 
> [...]

Here is the summary with links:
  - [v3] mptcp: Fix duplicated argument in protocol.h
    https://git.kernel.org/netdev/net/c/780aa1209f88

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


