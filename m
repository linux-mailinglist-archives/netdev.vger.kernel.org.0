Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51B030546D
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbhA0HWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:22:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:48200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S317407AbhA0Al6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 19:41:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 92A8C64D85;
        Tue, 26 Jan 2021 23:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611703811;
        bh=rR19SpKbng4O/m5hurHHL1TQQLw77agzg4H49OFmfSs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P4DldOK7SbD/uAVEmd6xBxG2liAbgVw1kL15W//tznEOoyFe5hGiFSrTgrLcuj30U
         YvRw353e/Dh8amJBVgQwK8bXkwSj0dSFIRlnYx0EEmUXhofLCXwI0pSQ4DUu7wVdkN
         iSjvGdqAI9P5XR12IXYDgvZ9tpKVIdZNl/M04jMXAGqGSyo7SLEcyi71gP05sSf4Ss
         2utto15CBb8KCiWYMTSfzxoKLZFqru3v5ArxeWuklH5aMeFpWcrXhnL9bZuAOfPZ6z
         Jv/ku6scImtiORDPZvDOGHGXlEMKtJgtlxuDYOxLYXfmmdsJsKd+12NNVHuhKz27A2
         ML3/FdSClbtcA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8601665209;
        Tue, 26 Jan 2021 23:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] staging: rtl8723bs: fix wireless regulatory API misuse
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161170381154.29376.422652736680366832.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Jan 2021 23:30:11 +0000
References: <20210126115409.d5fd6f8fe042.Ib5823a6feb2e2aa01ca1a565d2505367f38ad246@changeid>
In-Reply-To: <20210126115409.d5fd6f8fe042.Ib5823a6feb2e2aa01ca1a565d2505367f38ad246@changeid>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        ilan.peer@intel.com, johannes.berg@intel.com, hdegoede@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 26 Jan 2021 11:54:09 +0100 you wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This code ends up calling wiphy_apply_custom_regulatory(), for which
> we document that it should be called before wiphy_register(). This
> driver doesn't do that, but calls it from ndo_open() with the RTNL
> held, which caused deadlocks.
> 
> [...]

Here is the summary with links:
  - staging: rtl8723bs: fix wireless regulatory API misuse
    https://git.kernel.org/netdev/net/c/81f153faacd0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


