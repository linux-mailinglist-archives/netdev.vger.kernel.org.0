Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75653F193E
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 14:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239450AbhHSMao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 08:30:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237873AbhHSMan (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 08:30:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5DA9261153;
        Thu, 19 Aug 2021 12:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629376207;
        bh=anGh5FLsPof2yaYGjPPNFfMzwanLHLltIKFEPMiCmUc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GOhrt7UZxC/xtMme8w44a/wsZqAcebLAmfs4jzqs0N9URWepby8lDpSt6oe5JewHp
         +2DINR/IgkRySNjdj80rCfKN8zSi9J+IkqVENdaBf7mg7/FoDPocjhHa5tPoRE7GrS
         QJVNiXQR/FV48MiYRb52t2jQBu5RrA/m+HMtOAmVXH8Wk8zEnoyJPyFqQMkigv+8nO
         Q9AEuPf5mGDw47bsi2vNo7zi1WQREtR30YaOV8zTpZFSWVC02s8y4MkLXoXgWmhX9K
         vhDe0HRIpvNMu1PRoSgFYS4ZN+/6rQgl3Xaef6dxhgBSyxI2vOf8FTeWCTJJvjrwIj
         jbL1/0CGru0lw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5103260A90;
        Thu, 19 Aug 2021 12:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 net-next 0/2] Indirect dev ingress qdisc creation order
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162937620732.15458.16109884338789671523.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Aug 2021 12:30:07 +0000
References: <20210817170518.378686-1-elic@nvidia.com>
In-Reply-To: <20210817170518.378686-1-elic@nvidia.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 17 Aug 2021 20:05:16 +0300 you wrote:
> The first patch is just a cleanup of the code.
> The second patch is fixing the dependency in ingress qdisc creation
> relative to offloading driver registration to filter configurations.
> 
> v1 -> v2:
> Fix warning - variable set but not used
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net-next,1/2] net/core: Remove unused field from struct flow_indr_dev
    https://git.kernel.org/netdev/net-next/c/c1c5cb3aee05
  - [PATCHv2,net-next,2/2] net: Fix offloading indirect devices dependency on qdisc order creation
    https://git.kernel.org/netdev/net-next/c/74fc4f828769

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


