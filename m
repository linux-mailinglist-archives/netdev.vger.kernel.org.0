Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCD33D68CF
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 23:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbhGZU7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 16:59:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229489AbhGZU7l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 16:59:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9D1CC601FD;
        Mon, 26 Jul 2021 21:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627335609;
        bh=t6dleGlJVRzYCPio42vJV9mUyu5Ah/7RcBjoeV4t1As=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Omn7VZOmAhkEhAzn3I4ZYPr1rq1Th2BNHtH1GbWwzHpoIBL2rRKSnRsoSKDbDtxqy
         diFhunhTo6P86GLxVv49VBPWF9nNeYW9uU+hkUSF7dfpQo4b7nEfqsZmK/dO6z1iT6
         w+tfnMBhjgqAZCwy2na46wbb6ppBNY1khpgvq8afHscOxlWNO5p6ct/v5PtdDBitN2
         HuPouDolul79vC9jJHq9fsnH8sHYx5PjgqReNOm2rhuTJy132Y/qI1EBbWVmzXe26e
         fRild1dO+OUZFnGS5t/rG1U+TVHgraNcKvADNfvAPjh7uY8puqlqaSDu7ohnyQnw0g
         9ZFFrgvGAW0pw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9203460A5B;
        Mon, 26 Jul 2021 21:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] Traffic termination for sja1105 ports under
 VLAN-aware bridge
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162733560959.28049.14840493619856627352.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Jul 2021 21:40:09 +0000
References: <20210726165536.1338471-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210726165536.1338471-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        roopa@nvidia.com, nikolay@nvidia.com, idosch@nvidia.com,
        jiri@nvidia.com, colin.king@canonical.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 26 Jul 2021 19:55:27 +0300 you wrote:
> This set of patches updates the sja1105 DSA driver to be able to send
> and receive network stack packets on behalf of a VLAN-aware upper bridge
> interface.
> 
> The reasons why this has traditionally been a problem are explained in
> the "Traffic support" section of Documentation/networking/dsa/sja1105.rst.
> (the entire documentation will be revised in a separate patch series).
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] net: bridge: update BROPT_VLAN_ENABLED before notifying switchdev in br_vlan_filter_toggle
    https://git.kernel.org/netdev/net-next/c/f7cdb3ecc9b7
  - [net-next,2/9] net: bridge: add a helper for retrieving port VLANs from the data path
    https://git.kernel.org/netdev/net-next/c/ee80dd2e89ec
  - [net-next,3/9] net: dsa: sja1105: remove redundant re-assignment of pointer table
    https://git.kernel.org/netdev/net-next/c/d63f8877c48c
  - [net-next,4/9] net: dsa: sja1105: delete vlan delta save/restore logic
    https://git.kernel.org/netdev/net-next/c/6dfd23d35e75
  - [net-next,5/9] net: dsa: sja1105: deny 8021q uppers on ports
    https://git.kernel.org/netdev/net-next/c/4fbc08bd3665
  - [net-next,6/9] net: dsa: sja1105: deny more than one VLAN-aware bridge
    https://git.kernel.org/netdev/net-next/c/19fa937a391e
  - [net-next,7/9] net: dsa: sja1105: add support for imprecise RX
    https://git.kernel.org/netdev/net-next/c/884be12f8566
  - [net-next,8/9] net: dsa: sja1105: add bridge TX data plane offload based on tag_8021q
    https://git.kernel.org/netdev/net-next/c/b6ad86e6ad6c
  - [net-next,9/9] Revert "net: dsa: Allow drivers to filter packets they can decode source port from"
    https://git.kernel.org/netdev/net-next/c/edac6f6332d9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


