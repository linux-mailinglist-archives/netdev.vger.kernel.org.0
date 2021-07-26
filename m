Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962C73D587D
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 13:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbhGZKtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 06:49:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233113AbhGZKth (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 06:49:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C545460EB2;
        Mon, 26 Jul 2021 11:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627299006;
        bh=19EHDtXlPhm04tG26D534pkZVVMgC4QDSNa8xAj8x/8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Or+id8doc24XLIHs6Lqs0a5ANvcmY+464LYuq55nu8H/ESbs3SZFsSPTvN1KipbDF
         TZVI50O30o4LFe171K35b63IXJm5LA46HVWsVFQSBU7Z+ia3WM9IA8QaHYgQBn1Eo9
         oHHvSfiSJ58mqhHyphgRo0IT7cgWboELkLj9Qbvoo0cDcYgqZ+bGy3o/s1Rbeztd4T
         euuUcZqtSijrpjzgR/GZPwIRIfgVtU+xzBQ/g/TJQ5falVrzEWdV+HxqJfN7YJbj6F
         HHHofodl8NWGGF6zZRpZxXtgxOHZVvoRES0o0esLmoTMH2MOwdZEz4tyv5b0DfqZYJ
         yG2uAUXITj5ng==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BAE2A60A56;
        Mon, 26 Jul 2021 11:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V3 net-next 0/7] net: hns3: add support devlink
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162729900676.28679.13330728353268825912.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Jul 2021 11:30:06 +0000
References: <1627267627-38467-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1627267627-38467-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, moyufeng@huawei.com, chenhao288@hisilicon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 26 Jul 2021 10:47:00 +0800 you wrote:
> This series adds devlink support for the HNS3 ethernet driver.
> 
> change log:
> V2 -> V3:
> 1. remove two patches of setting rx/tx buffer size by devlink param.
> 
> V1 -> V2:
> 1. add more detailed descriptions of parameters in document hns3.rst.
> 
> [...]

Here is the summary with links:
  - [V3,net-next,1/7] devlink: add documentation for hns3 driver
    https://git.kernel.org/netdev/net-next/c/6149ab604c80
  - [V3,net-next,2/7] net: hns3: add support for registering devlink for PF
    https://git.kernel.org/netdev/net-next/c/b741269b2759
  - [V3,net-next,3/7] net: hns3: add support for registering devlink for VF
    https://git.kernel.org/netdev/net-next/c/cd6242991d2e
  - [V3,net-next,4/7] net: hns3: add support for devlink get info for PF
    https://git.kernel.org/netdev/net-next/c/26fbf511693e
  - [V3,net-next,5/7] net: hns3: add support for devlink get info for VF
    https://git.kernel.org/netdev/net-next/c/bd85e55bfb95
  - [V3,net-next,6/7] net: hns3: add devlink reload support for PF
    https://git.kernel.org/netdev/net-next/c/98fa7525d360
  - [V3,net-next,7/7] net: hns3: add devlink reload support for VF
    https://git.kernel.org/netdev/net-next/c/f2b67226c3a8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


