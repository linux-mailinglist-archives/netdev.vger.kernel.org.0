Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3DB235D213
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 22:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343515AbhDLUaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 16:30:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245758AbhDLUa3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 16:30:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7FA946135C;
        Mon, 12 Apr 2021 20:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618259410;
        bh=n4qNQuTKbWPOkxn3gzzYSpK75xJFOY6n7v47uybhUrQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Xk1RiJeGYua3Ew4tePl+wyxCsHDHjR9VdtCEbjd/lnWVSlSK0y6dArtQSSpSW2gH+
         zO3RtHFQNUIcA2dKkBWoFUk84vm4YZw1OfnL1HkPptqCSMpM/MaWRgIM7IT1kVeSBs
         amos1n9PiVxEQyL+lej7zcNxT8ML1d4Q+3IaR3Q968eXlxGb5oizDBSc5t02GlUGXy
         vb93YHWQTWTbvovZkfl+yB/VK1ZFCH6FGghFAek5kHPcuTki3Wv08g0wM/JZ7rLVrj
         qwIqI10lyDCNGYiO3J0LQIXmZQXpKDsJAYSx2tLqpzEKaZPUrcFRyG1rCUcwGaTcJ+
         gl4rS/gxlANLA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 74AF360CD0;
        Mon, 12 Apr 2021 20:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] nfc: pn533: remove redundant assignment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161825941047.5277.17970239754082297288.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Apr 2021 20:30:10 +0000
References: <20210412022006.28532-1-samirweng1979@163.com>
In-Reply-To: <20210412022006.28532-1-samirweng1979@163.com>
To:     samirweng1979 <samirweng1979@163.com>
Cc:     gustavoars@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wengjianfeng@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 12 Apr 2021 10:20:06 +0800 you wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> In many places,first assign a value to a variable and then return
> the variable. which is redundant, we should directly return the value.
> in pn533_rf_field funciton,return rc also in the if statement, so we
> use return 0 to replace the last return rc.
> 
> [...]

Here is the summary with links:
  - [v2] nfc: pn533: remove redundant assignment
    https://git.kernel.org/netdev/net-next/c/a115d24a636e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


