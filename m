Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B1C397D7E
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 02:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235324AbhFBALy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 20:11:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235034AbhFBALu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 20:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EB4ED613B1;
        Wed,  2 Jun 2021 00:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622592608;
        bh=SARxzWeo07SUr/k3iwtdMoDiqSVpnA3KMnn+j9ptnog=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OlFexmKXplEPPZh8AtY0jGwyWqknq6MSGinxvfXXgdhGqBFKD07pGMgHsDYMijj/o
         E842OtuybzQunpBDTEyt85lLDhiOI7HqgpPrXnTeCizntLVjfBsAP1IaEhQ5Ys5+9A
         LdM3pIOjUb5BKSMRqQQo/4tB6DGeQC5sY2t8WZ18FMEJQ108xqP+gzuar9XcyPoguU
         36v18o8vuls7NBqReNh376qd3gvB2OaCpfTmy/5HOC5gxv4C/2c+/B5cbr3xi4D0ti
         O9EBMKyQLqrw/odqKbJmBgPXT/s9lwGGcfT8OarDT3uarGR7Hq8ute2oitfOG0h9Xz
         6Ao4QFMfz+LzA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DFB6B60A6F;
        Wed,  2 Jun 2021 00:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: usb: Fix spelling mistakes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162259260791.22595.15506600792243426755.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 00:10:07 +0000
References: <20210601141813.4131621-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210601141813.4131621-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     oliver@neukum.org, davem@davemloft.net, kuba@kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 1 Jun 2021 22:18:13 +0800 you wrote:
> wierdness  ==> weirdness
> multicat  ==> multicast
> limite  ==> limit
> adddress  ==> address
> operater  ==> operator
> intial  ==> initial
> smaler  ==> smaller
> Communcation  ==> Communication
> funcitons  ==> functions
> everytime  ==> every time
> Neigbor  ==> Neighbor
> performace  ==> performance
> 
> [...]

Here is the summary with links:
  - [net-next] net: usb: Fix spelling mistakes
    https://git.kernel.org/netdev/net-next/c/f62c4f3870d8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


