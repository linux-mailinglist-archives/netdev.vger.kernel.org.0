Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F18B3AF80D
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 23:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhFUVwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 17:52:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231530AbhFUVwT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 17:52:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1676361350;
        Mon, 21 Jun 2021 21:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624312205;
        bh=pYKzdEWq5lqJrPUM5kJQfKO/eCRH090FIWPq4DbJ8wE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GuK4DKZkGKW4cudi9MvVz1ix1R2sYFKge+NRyF0hjdJUNTBpZw+KMAQaMQYN5znw1
         POduhlBD1yKgE6LcoFGW6Q9FmhE+m0C4OawTqRrUbthZtKaxFlJzJ87LDr00adi6EV
         fDTAoJafi7OAr88M+hIfcJK8Gvagr8YcgP+fU00Sh4cUg6NA7UXxx5+YI3MGW5VXTz
         5YnJUvznapqFXtrlSQi5vgo6lmRb8H8WFM3xqiJWMosnT416rPRehUOv//ZzWTQ3bw
         beGDMMw0bQC98PoVP+EA3EXXk+6eoQDOrFAJ6GT+4V0LUIzG5TBsxZIWXHE5o8DXM1
         +cRsabxg1k3NA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1078060973;
        Mon, 21 Jun 2021 21:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: add pf_family_names[] for protocol family
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162431220506.17422.14248994634804422574.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 21:50:05 +0000
References: <20210621051225.24018-1-yejune.deng@gmail.com>
In-Reply-To: <20210621051225.24018-1-yejune.deng@gmail.com>
To:     Yejune Deng <yejune.deng@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 21 Jun 2021 13:12:25 +0800 you wrote:
> Modify the pr_info content from int to char * in sock_register() and
> sock_unregister(), this looks more readable.
> 
> Fixed build error in ARCH=sparc64.
> 
> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> Reported-by: kernel test robot <lkp@intel.com>
> 
> [...]

Here is the summary with links:
  - [v2] net: add pf_family_names[] for protocol family
    https://git.kernel.org/netdev/net-next/c/fe0bdbde0756

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


