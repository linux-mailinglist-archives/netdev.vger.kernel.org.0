Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29CC5479ABD
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 13:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbhLRMaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 07:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbhLRMaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 07:30:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16EEFC061574
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 04:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A85ED60B24
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 12:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16D4FC36AE1;
        Sat, 18 Dec 2021 12:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639830612;
        bh=aDjng90IAKinJTv1rOabUMIhZRxglg1B451XJv0aMSQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G0z0aVCzTNeqo2J1jx4HbwphlB8Fvm5O5qBbDAs7kq06LQf1UopMAobkqs/EE/mrt
         5BW5+thaJqpbdj1awv96u1qhCkB+nklCHTrCPfTrNm/XaN0RL753cO94/J+rlO8GyH
         9RalzM0qFfio3mMYDPu5zRy0AglmqtsCjv+zvQv8uUkyo9XQRJhLOKmFQGYBfhh3+e
         Xcy41BPycGqBC3YhjmMe7iRsSLbpTPKYEBiP4p+bM86dfinftdkIylIx9YATR3hLV6
         RWdlt9FnrNgD+5BfsqMFlLe1TvWOnFYnEhqjeQNsaTy6vaicgTuteF4fDh3Fb/19tH
         dM5dXorjMW6hA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0729360A4F;
        Sat, 18 Dec 2021 12:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6][pull request] 40GbE Intel Wired LAN Driver
 Updates 2021-12-17
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163983061202.29880.2842460179258873960.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Dec 2021 12:30:12 +0000
References: <20211217220647.875246-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211217220647.875246-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Fri, 17 Dec 2021 14:06:41 -0800 you wrote:
> Brett Creeley says:
> 
> This patch series adds support in the iavf driver for communicating and
> using VIRTCHNL_VF_OFFLOAD_VLAN_V2. The current VIRTCHNL_VF_OFFLOAD_VLAN
> is very limited and covers all 802.1Q VLAN offloads and filtering with
> no granularity.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] virtchnl: Add support for new VLAN capabilities
    https://git.kernel.org/netdev/net-next/c/bd0b536dc2e1
  - [net-next,2/6] iavf: Add support for VIRTCHNL_VF_OFFLOAD_VLAN_V2 negotiation
    https://git.kernel.org/netdev/net-next/c/209f2f9c7181
  - [net-next,3/6] iavf: Add support VIRTCHNL_VF_OFFLOAD_VLAN_V2 during netdev config
    https://git.kernel.org/netdev/net-next/c/48ccc43ecf10
  - [net-next,4/6] iavf: Add support for VIRTCHNL_VF_OFFLOAD_VLAN_V2 hotpath
    https://git.kernel.org/netdev/net-next/c/ccd219d2ea13
  - [net-next,5/6] iavf: Add support for VIRTCHNL_VF_OFFLOAD_VLAN_V2 offload enable/disable
    https://git.kernel.org/netdev/net-next/c/8afadd1cd8ba
  - [net-next,6/6] iavf: Restrict maximum VLAN filters for VIRTCHNL_VF_OFFLOAD_VLAN_V2
    https://git.kernel.org/netdev/net-next/c/92fc50859872

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


