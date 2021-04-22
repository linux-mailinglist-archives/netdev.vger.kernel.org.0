Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389F136886E
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 23:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236949AbhDVVLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 17:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236851AbhDVVLG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 17:11:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DDE6D613D5;
        Thu, 22 Apr 2021 21:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619125830;
        bh=tUZ/AgYMoYyAXOnmuYD1yCXZ3wuyuSPI8VordPPsAXw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TKnGbGcWn6z3vNztGupo2TdJzbam8S412D1kIJWaeOVQgeehbr3cXzk2ZeaflwdNK
         UnRX9sbOR162fzHYNCURkthD5iH+9w2shcuQ8LDgDP8vvG81YSIgaxC3DxuuCTIcRf
         QZ3BHU6dBn0JSnIFnde2FTAqlcGdfAEJcEeULSJHkIoKLejDB6Z5JMXaGJ9ADRcZem
         Ok+C60AyFHthYmmwePRXTZqVWCyVIDPGLgfF40JoC1IbWLs7A1AEH04Q3RuzBywVPe
         WC+Vo1ktJ171WwcK8Iyaa5AHNFAnTe422gBXbFkAAl2ne/eXaUNKdCKI68C3tBisgI
         c5XyoNnJjboDA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D554C60A53;
        Thu, 22 Apr 2021 21:10:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/12][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-04-22
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161912583086.10777.11797731949850793034.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Apr 2021 21:10:30 +0000
References: <20210422173130.1143082-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210422173130.1143082-1-anthony.l.nguyen@intel.com>
To:     Nguyen@ci.codeaurora.org, Anthony L <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 22 Apr 2021 10:31:18 -0700 you wrote:
> This series contains updates to virtchnl header file, ice, and iavf
> drivers.
> 
> Vignesh adds support to warn about potentially malicious VFs; those that
> are overflowing the mailbox for the ice driver.
> 
> Michal adds support for an allowlist/denylist of VF commands based on
> supported capabilities for the ice driver.
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] ice: warn about potentially malicious VFs
    https://git.kernel.org/netdev/net-next/c/0891c89674e8
  - [net-next,02/12] ice: Allow ignoring opcodes on specific VF
    https://git.kernel.org/netdev/net-next/c/c0dcaa55f91d
  - [net-next,03/12] ice: Advertise virtchnl UDP segmentation offload capability
    https://git.kernel.org/netdev/net-next/c/142da08c4dc0
  - [net-next,04/12] iavf: add support for UDP Segmentation Offload
    https://git.kernel.org/netdev/net-next/c/c91a4f9feb67
  - [net-next,05/12] ice: remove redundant assignment to pointer vsi
    https://git.kernel.org/netdev/net-next/c/c9b5f681fe41
  - [net-next,06/12] ice: Add helper function to get the VF's VSI
    https://git.kernel.org/netdev/net-next/c/c5afbe99b778
  - [net-next,07/12] ice: Enable RSS configure for AVF
    https://git.kernel.org/netdev/net-next/c/222a8ab01698
  - [net-next,08/12] ice: Support RSS configure removal for AVF
    https://git.kernel.org/netdev/net-next/c/ddd1f3cfed3f
  - [net-next,09/12] iavf: Add framework to enable ethtool RSS config
    https://git.kernel.org/netdev/net-next/c/0aaeb4fbc842
  - [net-next,10/12] iavf: Support for modifying TCP RSS flow hashing
    https://git.kernel.org/netdev/net-next/c/5ab91e0593a1
  - [net-next,11/12] iavf: Support for modifying UDP RSS flow hashing
    https://git.kernel.org/netdev/net-next/c/7b8f3f957b22
  - [net-next,12/12] iavf: Support for modifying SCTP RSS flow hashing
    https://git.kernel.org/netdev/net-next/c/e41985f0fe8b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


