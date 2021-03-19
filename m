Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B243412C2
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 03:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233427AbhCSCUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 22:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230099AbhCSCUQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 22:20:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 46CC464F1C;
        Fri, 19 Mar 2021 02:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616120412;
        bh=ZMo7kM2CIZZjW5NfsRZikroRoXbNCDmYsYbfm1OgKxo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CjX0XF+gL4g7L+8sZsJ6+MoDiIoWmdpSxHaxEa772T3SBcAEAneegzpi5KpFF3uby
         6raA/AbbQbngeaiPNMVtZ2KlcFy8EIkGzB80M28UWsc4UAsynEpbp94NEyWpbLDcT7
         U684o31TseYS5BCwBA+OsQyD7NqrszPr00kZtlIbuxOeHKrygxVzGQGiX+kHYgVGu+
         iZp6eU9aylx0qLXZV7ougSYUNtY4in8YPKoc/pwakAd9YlIwz4tn5zxuyDxA5N7dDj
         mSpkW8/FYTO97SvcVoGJcEoP5hHb4tIqntCZyVaTe31W18d4dO0WqO1WHApY6q5u3r
         YxrYN6V+uQZ3A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3AC536098E;
        Fri, 19 Mar 2021 02:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: cdc_ncm: drop redundant driver-data assignment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161612041223.22955.5529701998148405700.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 02:20:12 +0000
References: <20210318160142.31801-1-johan@kernel.org>
In-Reply-To: <20210318160142.31801-1-johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     oneukum@suse.com, davem@davemloft.net, kuba@kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 18 Mar 2021 17:01:42 +0100 you wrote:
> The driver data for the data interface has already been set by
> usb_driver_claim_interface() so drop the subsequent redundant
> assignment.
> 
> Note that this also avoids setting the driver data three times in case
> of a combined interface.
> 
> [...]

Here is the summary with links:
  - [net-next] net: cdc_ncm: drop redundant driver-data assignment
    https://git.kernel.org/netdev/net-next/c/269aa0301224

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


