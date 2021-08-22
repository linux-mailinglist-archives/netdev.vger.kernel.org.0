Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293E53F417F
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 22:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbhHVUau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 16:30:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232800AbhHVUar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 16:30:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E09AF61357;
        Sun, 22 Aug 2021 20:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629664205;
        bh=+uRrcqQ2uHG1jAcmqMaDsggZuO6D/DaEprDkTz+7lm4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Kvt0oGh27x6jOJSPhWRK4K0Glj5Fc4Pg8P/+YbQuU6gXT9P4/D/uN75HwQGFXTRVV
         igOQ7ByBZKo/GHKQybo8WnJOsJnDuwK7UN+YxHymLpSDnAzkQWp8bkQON3YAyBCPxG
         uJpE/cPsXnydvxMHKC0KCHe2Glr3iQCmKmCge4gkv9UPWdj8y2FFSlrYps9OcJ9rBl
         9UHMXwJlF+Zc+gC/4XfyIYxF+BEbBTaEurD6KCiJRp5Q6mCYIHFLcTnjM0AHF1XbWn
         VdUTWe6i6+TLDqfaLWPHudUkhVrfwHMfx0S63K0h0eyHleoDmEe9w+aGybITK009k/
         MRN7d5lpE41nQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DA2CE60A4F;
        Sun, 22 Aug 2021 20:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2] dt-bindings: net: brcm,unimac-mdio: convert to the
 json-schema
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162966420588.25599.3282676124626431278.git-patchwork-notify@kernel.org>
Date:   Sun, 22 Aug 2021 20:30:05 +0000
References: <20210820161533.20611-1-zajec5@gmail.com>
In-Reply-To: <20210820161533.20611-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tpIDx6YWplYzVAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        opendmb@gmail.com, f.fainelli@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        rafal@milecki.pl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 20 Aug 2021 18:15:33 +0200 you wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This helps validating DTS files.
> 
> Introduced example binding changes:
> 1. Fixed reg formatting
> 2. Swapped #address-cells and #size-cells incorrect values
> 3. Renamed node: s/phy/ethernet-phy/
> 
> [...]

Here is the summary with links:
  - [V2] dt-bindings: net: brcm,unimac-mdio: convert to the json-schema
    https://git.kernel.org/netdev/net-next/c/5d1c5594b646

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


