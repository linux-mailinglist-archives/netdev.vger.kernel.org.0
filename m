Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3692DA6E9
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 04:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgLODlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 22:41:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:47036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgLODk4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 22:40:56 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608003608;
        bh=AqPwIZHWsdYJUD36gvowxOXqZ3+JDD73X7E8ij57d1w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kOr01pI4vTXzrxbvMsO2oHCwvsw+bPitnaUGfjcjFVK+/+MTap2rxZohIl7y0CjCM
         oujiqwzUC/ID7f/BvnuVk+fjvFl0J5A91gkYltiHKzBp7y4Prp6NTtOC9VecDcdLuX
         SP86Y+Tfe+pSrJ1odDulBXGVYF0JKKSaouY5NKhUqzZyzuz6AJU+4Dl6wm1K5VSFbt
         htmEOlc+yh2yYQ9xPYew/K5fqznC5UvLcki4H9d1d7bJtBz2VRhhZjMW+ijLc81KSR
         rCqlEDxlUCpp8LH6oxgfdx+dgqCv9x1vDPemIihPdO0e7rSG9aAv/aWaXzHhgfaVcl
         AHXFVdUQY2Xbw==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/5] vsock: Add flags field in the vsock address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160800360863.3580.11859617867656861413.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Dec 2020 03:40:08 +0000
References: <20201214161122.37717-1-andraprs@amazon.com>
In-Reply-To: <20201214161122.37717-1-andraprs@amazon.com>
To:     Paraschiv@ci.codeaurora.org, Andra-Irina <andraprs@amazon.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, davdunc@amazon.com, decui@microsoft.com,
        graf@amazon.de, jhansen@vmware.com, kuba@kernel.org,
        sgarzare@redhat.com, stefanha@redhat.com, vkuznets@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 14 Dec 2020 18:11:17 +0200 you wrote:
> vsock enables communication between virtual machines and the host they are
> running on. Nested VMs can be setup to use vsock channels, as the multi
> transport support has been available in the mainline since the v5.5 Linux kernel
> has been released.
> 
> Implicitly, if no host->guest vsock transport is loaded, all the vsock packets
> are forwarded to the host. This behavior can be used to setup communication
> channels between sibling VMs that are running on the same host. One example can
> be the vsock channels that can be established within AWS Nitro Enclaves
> (see Documentation/virt/ne_overview.rst).
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/5] vm_sockets: Add flags field in the vsock address data structure
    https://git.kernel.org/netdev/net-next/c/dc8eeef73b63
  - [net-next,v4,2/5] vm_sockets: Add VMADDR_FLAG_TO_HOST vsock flag
    https://git.kernel.org/netdev/net-next/c/caaf95e0f23f
  - [net-next,v4,3/5] vsock_addr: Check for supported flag values
    https://git.kernel.org/netdev/net-next/c/cada7ccd9dc7
  - [net-next,v4,4/5] af_vsock: Set VMADDR_FLAG_TO_HOST flag on the receive path
    https://git.kernel.org/netdev/net-next/c/1b5f2ab98e7f
  - [net-next,v4,5/5] af_vsock: Assign the vsock transport considering the vsock address flags
    https://git.kernel.org/netdev/net-next/c/7f816984f439

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


