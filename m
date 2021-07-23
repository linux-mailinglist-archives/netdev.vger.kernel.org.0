Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4A83D3DDD
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 18:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhGWQJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:09:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231273AbhGWQJd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 12:09:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4F10A60F21;
        Fri, 23 Jul 2021 16:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627059006;
        bh=N8zwSDKem/95zByuI5bXLywsTICIN6iInFBNMK0Cjm8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YkLs6jwkbDNhRdzjWv2FW16mjXUP5cyxHAqKgHEbGxSe2szqOOC5BkZ/IMRAOjfdA
         IXjWyuvY0XLfPc1INrM/9lKqDeRCc6Ys1R9joHfwTjfZnjj9+FWy6CwaZ6mdRV1umQ
         1hyKq+04sKzKSwm52kK2gp0XbgJv4FJ9qoLTmmqHgou0O95gMFbsgTRYXYALMpVerS
         RKdm/KNR28uERiggYpq8A8l+I7eIzZ+pl2U/pJQnKiJsJgJsGN+6cEdKG8b565Wm+R
         DuxcKYPGkM0SxdLNzEjz2RT2zDysMWdjrzyo2RIYRYVrSaEuIA8uz24iMLqNT5RjSa
         ba3Mlcyo4RGjg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 46382608AF;
        Fri, 23 Jul 2021 16:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH v2] octeontx2-af: Fix uninitialized variables in
 rvu_switch
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162705900628.21133.8027963820102031285.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Jul 2021 16:50:06 +0000
References: <1627027578-24848-1-git-send-email-sbhatta@marvell.com>
In-Reply-To: <1627027578-24848-1-git-send-email-sbhatta@marvell.com>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sgoutham@marvell.com, hkelam@marvell.com, gakula@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 23 Jul 2021 13:36:18 +0530 you wrote:
> Get the number of VFs of a PF correctly by calling
> rvu_get_pf_numvfs in rvu_switch_disable function.
> Also hwvf is not required hence remove it.
> 
> Fixes: 23109f8dd06d ("octeontx2-af: Introduce internal packet switching")
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] octeontx2-af: Fix uninitialized variables in rvu_switch
    https://git.kernel.org/netdev/net/c/9986066d94c9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


