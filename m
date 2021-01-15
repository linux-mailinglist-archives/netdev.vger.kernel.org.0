Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244802F6FB5
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 01:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731361AbhAOAut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 19:50:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726127AbhAOAus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 19:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 755A923A9D;
        Fri, 15 Jan 2021 00:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610671808;
        bh=Zs/xzfywYlzI0f/0qRqgJ118N7gbr6wAB3LcILg2684=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VT1nQlYm5LAplU8aPzgXzh+OgwYyYn6Ufbdanptk0VHKk0oS5KGyNHXctmFOSMEc1
         ITnw9nIkylY9GdeyxqSVBvRlMUt7G3FIo3o9ta3pNlXbwHW6eM68ML82QMpfWA/1q4
         5atY1mtxdTePzJ77RbmSZxze6JBDE2CJA3Qi5OnNdZMpfB4vvD/orBYE0r+LN6c+xd
         x2270peTNbaEEWmOieFF2XjKOKvLNoBeCLiGVNhqRFhNYl+JK0gWSX1d3RAl4L2mMW
         yNqNt5g23IOU9gsYRoMkYlmz1zqzf9z1DpVn3wNDQC6fhJ01CuFtpNuryGW4RwBonb
         VciNrYuA/OwpA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 6A26460593;
        Fri, 15 Jan 2021 00:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: openvswitch: add log message for error case
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161067180842.3913.12424945524200609000.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Jan 2021 00:50:08 +0000
References: <161054576573.26637.18396634650212670580.stgit@ebuild>
In-Reply-To: <161054576573.26637.18396634650212670580.stgit@ebuild>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org,
        kuba@kernel.org, pshelar@ovn.org, bindiyakurle@gmail.com,
        fbl@sysclose.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 13 Jan 2021 14:50:00 +0100 you wrote:
> As requested by upstream OVS, added some error messages in the
> validate_and_copy_dec_ttl function.
> 
> Includes a small cleanup, which removes an unnecessary parameter
> from the dec_ttl_exception_handler() function.
> 
> Reported-by: Flavio Leitner <fbl@sysclose.org>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: openvswitch: add log message for error case
    https://git.kernel.org/netdev/net-next/c/a5317f3b06b3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


