Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038CE2DEC86
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 01:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgLSAus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 19:50:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:36096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725824AbgLSAus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 19:50:48 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608339007;
        bh=eFA0lGTLrqON8TbcyBTrrUSmqPcf5dsVxTeQPUAr4fQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R8dNHw5nI1dcAs2BnYBL3iTiWNcUJ75srEG+Rm5p2+um7e64aDlc4/8C/omJoxUm3
         OagpMg+p/cVrI0oAe8hbWPEFt2i3kC7/JQI2G03YaCJ8Ttrb5Cf//DfltEC9I+2gyy
         ZxEdumqAojQvYVtIMp3zCCm9pjv/Zq7XLG4xI0pzFLLno9HhIZ6gUZK/1r6yY8WnCV
         G2gGUqJ7DJVjMN21FoqUEiJl0Oxn8g/Mr2R53Ixtqb4WgZ2pH5BPk+Y7Ike817gCBv
         UYba43EbWFeqdJv5rLFhrWfFW+jwzlYFz+m0sYtZSvOKsnwXSratHRW63+I3OJqo25
         SVyXlqvjwlVpg==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 0/2][pull request] Intel Wired LAN Driver Updates 2020-12-17
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160833900749.29545.12385959219441382873.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Dec 2020 00:50:07 +0000
References: <20201217223418.3134992-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20201217223418.3134992-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 17 Dec 2020 14:34:16 -0800 you wrote:
> This series contains updates to i40e and iavf drivers.
> 
> Sylwester fixes an issue where PF was not properly being rebuilt
> following VF removal for i40e.
> 
> Jakub Kicinski fixes a double release of rtnl_lock on
> iavf_lan_add_device() error for iavf.
> 
> [...]

Here is the summary with links:
  - [net,1/2] i40e: Fix Error I40E_AQ_RC_EINVAL when removing VFs
    https://git.kernel.org/netdev/net/c/3ac874fa84d1
  - [net,2/2] iavf: fix double-release of rtnl_lock
    https://git.kernel.org/netdev/net/c/f1340265726e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


