Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701752DEC87
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 01:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgLSAus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 19:50:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:36102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgLSAus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 19:50:48 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608339007;
        bh=NhKP7ANtvI3jGn7JPhsnGw4wSN2Cmx61bYdgLkCHJMc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Sd9H9Pj5DoSl/OCCXjG/FdLXL9dBB9mUNJzPPJYnlGsHxujjLR8bDtTyTtCBU2TUh
         uQxpmWavBgQPBUg69FmNVJn74ul2b96M4t7oajcFO5xjWOJbjLMwFNLw2BnvJnv2SW
         2F2LdNVPFIZ12FP02NcsBBjDZ/d5K9sGvzu6jeKgB0hxtVIKUpx2aPp6XSDG/kczmd
         zTzJevK6baGWinbeO8m/4nANsS7Q4IWwzOwnr8VKMQiCgUMbmywFwW96y37+pLALqQ
         +qpkhoQEzaFrRuSYKnvScYxygUrq2nmi+JQfeMjpV2kNBTrCx7df3cQ8Zszre1ZYXc
         Fw91lnI+h3zjw==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: sch_taprio: ensure to reset/destroy all child
 qdiscs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160833900754.29545.12837650117741876707.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Dec 2020 00:50:07 +0000
References: <13edef6778fef03adc751582562fba4a13e06d6a.1608240532.git.dcaratti@redhat.com>
In-Reply-To: <13edef6778fef03adc751582562fba4a13e06d6a.1608240532.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, vinicius.gomes@intel.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 17 Dec 2020 22:29:46 +0100 you wrote:
> taprio_graft() can insert a NULL element in the array of child qdiscs. As
> a consquence, taprio_reset() might not reset child qdiscs completely, and
> taprio_destroy() might leak resources. Fix it by ensuring that loops that
> iterate over q->qdiscs[] don't end when they find the first NULL item.
> 
> Fixes: 44d4775ca518 ("net/sched: sch_taprio: reset child qdiscs before freeing them")
> Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net] net/sched: sch_taprio: ensure to reset/destroy all child qdiscs
    https://git.kernel.org/netdev/net/c/698285da79f5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


