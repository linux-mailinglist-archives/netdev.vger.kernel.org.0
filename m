Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DC64550E2
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 00:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235949AbhKQXDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 18:03:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:54434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233251AbhKQXDH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 18:03:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A3E5061B7D;
        Wed, 17 Nov 2021 23:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637190008;
        bh=+eElzqY0MFPyWgbK7U6Qw1XnKLcOKjN6aQm9wofWo40=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UXcVjx++FVvdQhpnW94MuHKVNlvOnxeixeXPBdpvzVt4MKwZ6M/ECB5ukpY/rtyrk
         gPLsnNtJyQDAdrcdilQcq+fZI+OQCNUxJxpn99du5G+mIqxMNcv7dKd7zgMagE0uzR
         ZUG6Shjuu5S1/vUjJDuLMAwVXAodyM9RqT9eAOkfaZNESgj9FKEPWqld/zy/w4oVWf
         inOLwMlhQgUgnPkh5EHjDOfH2cTl7+OGMciGmpf68JrEaRs0D/O5clCtXXRrkIS78w
         SdcLeuaaZElTJgXZkgggVn9MyDrltU+h6olLCD1x0NySy+phv3rh5Iru09WAcIvVTj
         clgAs4bzHXPSw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9612260A0C;
        Wed, 17 Nov 2021 23:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests/bpf: fix xdpxceiver failures for no
 hugepages
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163719000860.13585.18146715018097538560.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 23:00:08 +0000
References: <20211117123613.22288-1-tirthendu.sarkar@intel.com>
In-Reply-To: <20211117123613.22288-1-tirthendu.sarkar@intel.com>
To:     Tirthendu Sarkar <tirthendu.sarkar@intel.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Wed, 17 Nov 2021 18:06:13 +0530 you wrote:
> xsk_configure_umem() needs hugepages to work in unaligned mode. So when
> hugepages are not configured, 'unaligned' tests should be skipped which
> is determined by the helper function hugepages_present(). This function
> erroneously returns true with MAP_NORESERVE flag even when no hugepages
> are configured. The removal of this flag fixes the issue.
> 
> The test TEST_TYPE_UNALIGNED_INV_DESC also needs to be skipped when
> there are no hugepages. However, this was not skipped as there was no
> check for presence of hugepages and hence was failing. The check to skip
> the test has now been added.
> 
> [...]

Here is the summary with links:
  - [bpf-next] selftests/bpf: fix xdpxceiver failures for no hugepages
    https://git.kernel.org/bpf/bpf-next/c/dd7f091fd22b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


