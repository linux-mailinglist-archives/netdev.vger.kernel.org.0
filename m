Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0188C38F466
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 22:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbhEXUbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 16:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233353AbhEXUbj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 16:31:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A9EF361414;
        Mon, 24 May 2021 20:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621888210;
        bh=5NcMnjflQ0AJJ4gf5dtltNcb3I8P7HnCelMTkPXay4I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s6A5g1w5L7IhL4NZA+i3vpImiQIdvzENM3rqo0SIBOrZzVr7lswrEAKh+Yf3b9ZWy
         rW4VA6ignAAflaGsmVBvfuV4CuPHPYyA0vEbd9Rb5c4r2boKd+wTjGSlPy2gfSDXrH
         5FUJyrGytQRNVsIlDSP+SAFkh8d2NAHBhVDHbPy06d2HzEHFCIgh6GKCDWw8D0EKp2
         HqIijOmTKvoTEheCo4euMCSPb67DBE4XcQ5Ppri8klC3IgBZvOJrNuprCC13WWEkWP
         F1RiqtJqEVj1gBpaldag9wTYPpFb5mLQEtqPzczarFdh49xOG1CkqNGz/Dl2h48Wcn
         LsxM0OARWp7Rw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A4C0A60A56;
        Mon, 24 May 2021 20:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: hns3: add two promisc mode updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162188821067.23443.13861638200984980870.git-patchwork-notify@kernel.org>
Date:   Mon, 24 May 2021 20:30:10 +0000
References: <1621848643-18567-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1621848643-18567-1-git-send-email-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 24 May 2021 17:30:41 +0800 you wrote:
> This series includes two updates related to promisc mode for the HNS3
> ethernet driver.
> 
> Jian Shen (2):
>   net: hns3: configure promisc mode for VF asynchronously
>   net: hns3: use HCLGE_VPORT_STATE_PROMISC_CHANGE to replace
>     HCLGE_STATE_PROMISC_CHANGED
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: hns3: configure promisc mode for VF asynchronously
    https://git.kernel.org/netdev/net-next/c/1e6e76101fd9
  - [net-next,2/2] net: hns3: use HCLGE_VPORT_STATE_PROMISC_CHANGE to replace HCLGE_STATE_PROMISC_CHANGED
    https://git.kernel.org/netdev/net-next/c/4e2471f7b6ef

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


