Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455FF42EEC1
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 12:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbhJOKcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 06:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232172AbhJOKcN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 06:32:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 29DE261027;
        Fri, 15 Oct 2021 10:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634293807;
        bh=Wi9Fodf6mJVDXOVz1zZEyZ8IClLLJSGYtoxm+eVMINI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iRb/t1Xbzx4V/8P+xyrcGHd53pobBg3/CghxkG511Hpa8TPvujzoLrVVrKQXxJxD+
         AmlTWSGOCkJ9XWdZej88ZI9fucJSHqNba1nGRXET6Ri6yO7UhTo+vXF0H8hkW9aIVT
         b+A60nEQE9GCTCcz1OSFGWn/xHmZlXt6NembS/SMCZKyboVyk7TYwwOZJHl7C2/w62
         nRC5EGLlAb3EuEpoD+nKlsU9y+73OSqOLqxUyrn/SihkReXCFS9BaNAy/9CI8CHho4
         JYrq+/4Jv24w7u/K3ErHpE5S5VD2YvwZwVhYT+l08KJBstzM7FZrPdSLVofjC5IvKj
         rvCCBDjmUPIBg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 19EDF609ED;
        Fri, 15 Oct 2021 10:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: fix transport encap_port update in sctp_vtag_verify
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163429380710.2368.12832143545984205795.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Oct 2021 10:30:07 +0000
References: <acbf36fdcdbe862de562d0d77fc918d8a886ba96.1634187055.git.lucien.xin@gmail.com>
In-Reply-To: <acbf36fdcdbe862de562d0d77fc918d8a886ba96.1634187055.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 14 Oct 2021 00:50:55 -0400 you wrote:
> transport encap_port update should be updated when sctp_vtag_verify()
> succeeds, namely, returns 1, not returns 0. Correct it in this patch.
> 
> While at it, also fix the indentation.
> 
> Fixes: a1dd2cf2f1ae ("sctp: allow changing transport encap_port by peer packets")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] sctp: fix transport encap_port update in sctp_vtag_verify
    https://git.kernel.org/netdev/net/c/075718fdaf0e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


