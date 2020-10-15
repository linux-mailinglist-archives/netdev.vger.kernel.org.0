Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8119528F8E1
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 20:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389793AbgJOSuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 14:50:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726877AbgJOSuD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 14:50:03 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602787802;
        bh=lzEq58ojFUDuqX9ecWN/GVC9Y8rc3xPA1K2INOFoh0Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NTxaGN0MR5bpj9YERmPh2BfJigfSvofw6Iass1HydJSGV5nhFDe+6Sp8B81oQ5K3Z
         ucLzpL7GVAoh6ujC0cZ/B24eXCeQhI+Lde0z1Kw5+4a7mXmMmskoHXNJkrrHh/cTfo
         TJVEIj/41Ezp3jVxaDqJl67JIJgGfAdLUrFH1qRo=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool] netlink: fix allocation failure handling in
 dump_features()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160278780283.28012.6567583320815769774.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Oct 2020 18:50:02 +0000
References: <20201014164952.CC0C860731@lion.mk-sys.cz>
In-Reply-To: <20201014164952.CC0C860731@lion.mk-sys.cz>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, ivecera@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to ethtool/ethtool.git (refs/heads/master):

On Wed, 14 Oct 2020 18:49:52 +0200 (CEST) you wrote:
> On allocation failure, dump_features() would set ret to -ENOMEM but then
> return 0 anyway. As there is nothing to free in this case anyway, the
> easiest fix is to simply return -ENOMEM rather than jumping to out_free
> label - which can be dropped as well as this was its only use.
> 
> Fixes: f2c17e107900 ("netlink: add netlink handler for gfeatures (-k)")
> Reported-by: Ivan Vecera <ivecera@redhat.com>
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> 
> [...]

Here is the summary with links:
  - [ethtool] netlink: fix allocation failure handling in dump_features()
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=09c67a720a07

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


