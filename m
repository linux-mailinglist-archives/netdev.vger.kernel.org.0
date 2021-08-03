Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845B13DED47
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 14:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235782AbhHCMAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 08:00:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235655AbhHCMAR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 08:00:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7051460F35;
        Tue,  3 Aug 2021 12:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627992006;
        bh=CeoHiAgowtSqyiJONjacEyNAEmsq6aLlBpbaSGS2984=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EFE854lnGJo1UND6xvQZcMAg0BOh9O602RpDupO6KwjZKbSf1fXVBrkyEIZFUkT5Y
         HJdKMpU8w6G/l8A8GsSpbNMAd/uq0oQvlS0My3oVZ0fFsKFKW32pc8w+Q/jDI6Pjne
         qCiE/RnOHeNso2DmsMW9dxvw0G6JttSoflETEXeTwh5xU1Yd/xf8UmcI9Q2bLEsHxm
         eaDoj0YB3qwQm/9DzKvdC2rSgsNgJdqYhvWE2LSN0GucmPThp5DHOfBMtwyawIXJwC
         100kf0gr9FsxvpTcbG2jUf5Z+hsWyuwpxlSHgAjGqI6N5nwWgHwLVA8EAFD+E2b3lC
         EKW3zX3S6H21A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6870860A44;
        Tue,  3 Aug 2021 12:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: minor kdoc fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162799200642.3942.6713167878359867115.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Aug 2021 12:00:06 +0000
References: <20210803094019.17291-1-simon.horman@corigine.com>
In-Reply-To: <20210803094019.17291-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@mellanox.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        bijie.xu@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue,  3 Aug 2021 11:40:17 +0200 you wrote:
> Hi,
> 
> this short series fixes two kdoc errors that were noticed
> during development.
> 
> Bijie Xu (2):
>   net: flow_offload: correct comments mismatch with code
>   net: sched: provide missing kdoc for tcf_pkt_info and tcf_ematch_ops
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: flow_offload: correct comments mismatch with code
    https://git.kernel.org/netdev/net/c/c87a4c542b5a
  - [net-next,2/2] net: sched: provide missing kdoc for tcf_pkt_info and tcf_ematch_ops
    https://git.kernel.org/netdev/net/c/0161d151f3e3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


