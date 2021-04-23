Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C876369BE5
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 23:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244075AbhDWVKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 17:10:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:58934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243971AbhDWVKx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 17:10:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1C37361409;
        Fri, 23 Apr 2021 21:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619212216;
        bh=+HVYUkEwEyqTHpk4uG05cS+2Bgv6JN7EYepeLkt8Xyc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OQeMQx32pgL3URjAqXsVZNBGYX4AtaIHGPaximZyuaZfC88Sg2iyzg1AIXF+yyQdy
         SEBq0wsm+uWDDuieZAcqe8NwaSHJw70/F3RfLKW40lKXaH0SUGS9FNru3G+jh/ZAGB
         vCcAVpawuJ01XKM5IkD9YYTgQf79vA3cAUV9uMLICp84XLH2hAM0EEZHpNPjaZFuVa
         iaA6Gb5tr/PTHRo3qTwFMfjbVsn94roBK40EQuQbBNWhX/kJ7v0IVylHrPYMLJgV7/
         P5BtPg3jL6m58TxJyAsR2MREZJq4RUDKjIzc8rlNYSdV2zlEJo4AKyBqpn49tHTzy1
         xMlOcQy+TaiCw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 12D3460A53;
        Fri, 23 Apr 2021 21:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8][pull request] 40GbE Intel Wired LAN Driver
 Updates 2021-04-23
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161921221607.24005.5930876616300706773.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Apr 2021 21:10:16 +0000
References: <20210423164247.3252913-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210423164247.3252913-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 23 Apr 2021 09:42:39 -0700 you wrote:
> This series contains updates to i40e and iavf drivers.
> 
> Aleksandr adds support for VIRTCHNL_VF_CAP_ADV_LINK_SPEED in i40e which
> allows for reporting link speed to VF as a value instead of using an
> enum; helper functions are created to remove repeated code.
> 
> Coiby Xu reduces memory use of i40e when using kdump by reducing Tx, Rx,
> and admin queue to minimum values. Current use causes failure of kdump.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] i40e: refactor repeated link state reporting code
    https://git.kernel.org/netdev/net-next/c/6d2c322cce04
  - [net-next,2/8] i40e: use minimal Tx and Rx pairs for kdump
    https://git.kernel.org/netdev/net-next/c/065aa694a76e
  - [net-next,3/8] i40e: use minimal Rx and Tx ring buffers for kdump
    https://git.kernel.org/netdev/net-next/c/dcb75338f6e7
  - [net-next,4/8] i40e: use minimal admin queue for kdump
    https://git.kernel.org/netdev/net-next/c/5c208e9f498e
  - [net-next,5/8] iavf: remove duplicate free resources calls
    https://git.kernel.org/netdev/net-next/c/1a0e880b028f
  - [net-next,6/8] iavf: change the flex-byte support number to macro definition
    https://git.kernel.org/netdev/net-next/c/f995f95af626
  - [net-next,7/8] iavf: enhance the duplicated FDIR list scan handling
    https://git.kernel.org/netdev/net-next/c/f3b9da31f0e3
  - [net-next,8/8] iavf: redefine the magic number for FDIR GTP-U header fields
    https://git.kernel.org/netdev/net-next/c/1f70dfc542e8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


