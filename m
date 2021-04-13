Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004C735E8AE
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 00:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348561AbhDMWAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 18:00:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347013AbhDMWAc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 18:00:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E10B3613B1;
        Tue, 13 Apr 2021 22:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618351211;
        bh=j/AYgv69HBntVOwg2WIUQMPAJaKrQqE3LEUpXN2Ddq8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CeVwRUayYSKWdaV7cMW5wm3tEVpZ4JixuQsL0U/IiMdws5LZtW8H+huxI6A2rU4nc
         ybfnn/adCLm+GXully6useUp98h21H045ghJJjnff/eSftYQt6u/J1NA4mBHdjSjIP
         xI6WHipPXxfoeN/kHZF40YE5TprjjSoTH/1DOKIb3/7X5Sm+BbPyDu1mv964VTM4GE
         aJN6O2oBajRO0K8KvZK9tRalWK0NaYKkKJDQn10ni5HHrVQDFfjkGOSL33Zm8ddVyP
         GckVuRJhU7GdbPiJeIH7990QEbaF9zUG3/cZES6BBg+x7Bkq67cOZwigcg1daEuc2q
         J2P0A6cq7oPIw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D2FFF609B9;
        Tue, 13 Apr 2021 22:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc: st-nci: remove unnecessary label
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161835121185.27588.5056681740611769897.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Apr 2021 22:00:11 +0000
References: <20210413094530.22076-1-samirweng1979@163.com>
In-Reply-To: <20210413094530.22076-1-samirweng1979@163.com>
To:     samirweng1979 <samirweng1979@163.com>
Cc:     davem@davemloft.net, alex.dewar90@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 13 Apr 2021 17:45:30 +0800 you wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> in st_nci_spi_write function, first assign a value to a variable then
> goto exit label. return statement just follow the label and exit label
> just used once, so we should directly return and remove exit label.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> 
> [...]

Here is the summary with links:
  - nfc: st-nci: remove unnecessary label
    https://git.kernel.org/netdev/net-next/c/eba43fac8dfa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


