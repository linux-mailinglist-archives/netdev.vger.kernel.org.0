Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA1C2FC637
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 02:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbhATBBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 20:01:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:43740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729313AbhATBAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 20:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A0A5822DD3;
        Wed, 20 Jan 2021 01:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611104408;
        bh=B0ZiTfZPWTWCq1aVfE1y9X/FaPZHIRSbNpuYGgCdVQ4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dQiZv4DPTbHM9JuXDkn1r96joY0KGYk4RbZlR/2vY/AKYvnEQWGCkQ/QcbPHb5iG8
         PaJKdGFC+IrrJvZemhSu+y1PhvQYYVGTfWXda+6jHgbybDU32ex+P/Od9CxYDVjL7O
         d0eh9Remcs9aySq2YRnNDhLZqDBIXQMEH+5UMttJut07HPZfahr7FpHGSwVykQnYL/
         HqGKWVxoEqIvEqQWfXFc2C2UeMh/EbJL7aFFThPHYc0F8r4Gy9dtxQfU+ZPAkfcgV7
         XI5cPqysr4XT1adPTlUmB6/kVnHe7auYS3WM6fwYibRfvuLAS83lASLPZ3ATw/bRem
         1HpZgVRSOhwuQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 956CE6036C;
        Wed, 20 Jan 2021 01:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: nfc: nci: fix the wrong NCI_CORE_INIT parameters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161110440860.4771.13780876306648585886.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jan 2021 01:00:08 +0000
References: <20210118205522.317087-1-bongsu.jeon@samsung.com>
In-Reply-To: <20210118205522.317087-1-bongsu.jeon@samsung.com>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
        bongsu.jeon@samsung.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 19 Jan 2021 05:55:22 +0900 you wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> Fix the code because NCI_CORE_INIT_CMD includes two parameters in NCI2.0
> but there is no parameters in NCI1.x.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> [...]

Here is the summary with links:
  - [net] net: nfc: nci: fix the wrong NCI_CORE_INIT parameters
    https://git.kernel.org/netdev/net/c/4964e5a1e080

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


