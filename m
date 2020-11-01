Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3B32A1B78
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 01:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgKAAaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 20:30:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726100AbgKAAaE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 20:30:04 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604190604;
        bh=gKWzrxkN7Wx91lxnK0lhaEB/Re5oBDLBxHidd1kTmuI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dt6zDx9OEzq3efY5Nm1ZvbE1sHoELfsL20iLIppJDEqm+3C1clCAGTzZxeo1trmTr
         fTm5C+nSfFjzehbNiXNrjXfN4eIUhyJSVRs5Yh09XnxpIMyHRRMtL6xgUihDOvvxSg
         ShPomvje1gE0JjOX1t6kePxTw5LxQQkEp/oGFPLM=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] ip_tunnel: fix over-mtu packet send fail without
 TUNNEL_DONT_FRAGMENT flags
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160419060434.13806.246425942222069111.git-patchwork-notify@kernel.org>
Date:   Sun, 01 Nov 2020 00:30:04 +0000
References: <1604028728-31100-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1604028728-31100-1-git-send-email-wenxu@ucloud.cn>
To:     wenxu <wenxu@ucloud.cn>
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 30 Oct 2020 11:32:08 +0800 you wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> The tunnel dvice such as vxlan, bareudp  and geneve in the lwt mode set
> the outer df only based TUNNEL_DONT_FRAGMENT.
> And this is also the some behavior for gre device before switching to use
> ip_md_tunnel_xmit as the following patch.
> 
> [...]

Here is the summary with links:
  - [net,v2] ip_tunnel: fix over-mtu packet send fail without TUNNEL_DONT_FRAGMENT flags
    https://git.kernel.org/netdev/net/c/20149e9eb68c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


