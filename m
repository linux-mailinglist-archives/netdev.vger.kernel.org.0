Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995354591A3
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239999AbhKVPxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:53:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:43574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239850AbhKVPxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 10:53:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 63AF360232;
        Mon, 22 Nov 2021 15:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637596210;
        bh=E0ZIcTgQTF4uA66kD7n2bNvUJTP6AnjWQnN8APTWepw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TEHK8PUXox5PGANewt9N1ApCdwfZeY7GJ/YhcxuoqCDx3tgbcyqLsSTSL/RcdL+fw
         YmkDKGojdzf+EWWDYyNqvvsttqhbCuuSIH41GJUda6Zmu7A9i2vWUb3l52l5Ch8dWq
         dfA/NaxsimVrRWTBLy3DDJzcZ75hqkoWTtcjfQEztAn/gnF6stw1w3Gp722t5lsLKw
         5ruSJntWiUonY16/SW4qrigd0hyCOaqJ/+KTNahWaEUoJEaJJVoGxrf3+aIzrLnEHS
         Lp8v0E7b9VSwIl/1VMEjInR8ZJhOCZ0J0UahgtZeR8VR6ww0x5oGjz+mlAVAlfsl5p
         VUzaywF2AYnDQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 57A4760A94;
        Mon, 22 Nov 2021 15:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v3 0/9] Multiple cleanup and feature for qca8k
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163759621035.3677.10769025675490049511.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 15:50:10 +0000
References: <20211122152348.6634-1-ansuelsmth@gmail.com>
In-Reply-To: <20211122152348.6634-1-ansuelsmth@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 22 Nov 2021 16:23:39 +0100 you wrote:
> This is a reduced version of the old massive series.
> Refer to the changelog to know what is removed from this.
> 
> We clean and convert the driver to GENMASK FIELD_PREP to clean multiple
> use of various naming scheme. (example we have a mix of _MASK, _S _M,
> and various name) The idea is to ""simplify"" and remove some shift and
> data handling by using FIELD API.
> The patch contains various checkpatch warning and are ignored to not
> create more mess in the header file. (fixing the too long line warning
> would results in regs definition less readable)
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/9] net: dsa: qca8k: remove redundant check in parse_port_config
    https://git.kernel.org/netdev/net-next/c/b9133f3ef5a2
  - [net-next,v3,2/9] net: dsa: qca8k: convert to GENMASK/FIELD_PREP/FIELD_GET
    https://git.kernel.org/netdev/net-next/c/90ae68bfc2ff
  - [net-next,v3,3/9] net: dsa: qca8k: remove extra mutex_init in qca8k_setup
    https://git.kernel.org/netdev/net-next/c/994c28b6f971
  - [net-next,v3,4/9] net: dsa: qca8k: move regmap init in probe and set it mandatory
    https://git.kernel.org/netdev/net-next/c/36b8af12f424
  - [net-next,v3,5/9] net: dsa: qca8k: initial conversion to regmap helper
    https://git.kernel.org/netdev/net-next/c/8b5f3f29a81a
  - [net-next,v3,6/9] net: dsa: qca8k: add additional MIB counter and make it dynamic
    https://git.kernel.org/netdev/net-next/c/c126f118b330
  - [net-next,v3,7/9] net: dsa: qca8k: add support for port fast aging
    https://git.kernel.org/netdev/net-next/c/4592538bfb0d
  - [net-next,v3,8/9] net: dsa: qca8k: add set_ageing_time support
    https://git.kernel.org/netdev/net-next/c/6a3bdc5209f4
  - [net-next,v3,9/9] net: dsa: qca8k: add support for mdb_add/del
    https://git.kernel.org/netdev/net-next/c/ba8f870dfa63

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


