Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB22039C29F
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 23:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbhFDVlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 17:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhFDVlu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 17:41:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D98056138C;
        Fri,  4 Jun 2021 21:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622842803;
        bh=gjl4Vvx+6rAx8D9WQhpER3bhVRa28HfMfqEANyvlg9c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s8n7368EZKeoz5af3W50HTtldlgXkkdjvzADtAG5rvPGGaSAqaPZ+5/vmFZjhaDN9
         9VHQpWOmMz2U+6DDorc9juQy2aaCJmJnscfaLklvbHHvYmzQBgZLjNOa+0Nj1sw3H4
         NttjTl21Sq5MEOodWtmYF+hPQeH6YOJu5w9v5T/+eMw36B0ZTmMiaQG0aYLz+qeNT+
         ZSRN7+zEshnL0XUMyIKmyUHvzkbunNISHxM+Awku8jVYMwrfFM54AwF3nVvBTwp1CL
         vLR3J35oBdL/jTv6sy0fBjcWtfFcsCNQ/HWH/mb55Jjb3xTYjzm+1Pl3Q+kagVzQxY
         qM4qLIZ+mRk+A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CFDFE60BFB;
        Fri,  4 Jun 2021 21:40:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/6][pull request] Intel Wired LAN Driver Updates
 2021-06-04
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162284280384.31903.7977034647308504882.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Jun 2021 21:40:03 +0000
References: <20210604160816.3391716-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210604160816.3391716-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri,  4 Jun 2021 09:08:10 -0700 you wrote:
> This series contains updates to virtchnl header file and ice driver.
> 
> Brett fixes VF being unable to request a different number of queues then
> allocated and adds clearing of VF_MBX_ATQLEN register for VF reset.
> 
> Haiyue handles error of rebuilding VF VSI during reset.
> 
> [...]

Here is the summary with links:
  - [net,1/6] ice: Fix allowing VF to request more/less queues via virtchnl
    https://git.kernel.org/netdev/net/c/f0457690af56
  - [net,2/6] ice: Fix VFR issues for AVF drivers that expect ATQLEN cleared
    https://git.kernel.org/netdev/net/c/8679f07a9922
  - [net,3/6] ice: handle the VF VSI rebuild failure
    https://git.kernel.org/netdev/net/c/c7ee6ce1cf60
  - [net,4/6] ice: report supported and advertised autoneg using PHY capabilities
    https://git.kernel.org/netdev/net/c/5cd349c349d6
  - [net,5/6] ice: Allow all LLDP packets from PF to Tx
    https://git.kernel.org/netdev/net/c/f9f83202b726
  - [net,6/6] virtchnl: Add missing padding to virtchnl_proto_hdrs
    https://git.kernel.org/netdev/net/c/519d8ab17682

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


