Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C6146EC3D
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 16:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240536AbhLIPxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 10:53:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52086 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240513AbhLIPxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 10:53:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED3ACB8252A;
        Thu,  9 Dec 2021 15:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88CA0C341C7;
        Thu,  9 Dec 2021 15:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639065009;
        bh=tZ2ZAb/cPyN7CaJfQInb7ZtSfx6eVNe0/0YWt9bYZho=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q+BojNGGjWbOmhGfCQBOTxjat5KUorhtSxP4hIwxcwWMbcmUbjGNvpnhyDv4DbqrE
         pbIsvifWOU2/7DDWZcQAvbzerL/XHUCQ/pf920urBrcem+fJDNity1VP77oY5AvgOw
         6lnijGXQOsBE59WlQslJsz/9RuA/5qBtNJesXaAy7D/JQss/w6LPI4/B5/fV6p+SxO
         JS0Na+eICx5KNH6pQxg8lLWR2MLDZn6qLDDgsnyJyFhUsTNosfCkr75iAxUPvz4KCa
         MAP0Vggs/+QxDufie5QikcsLshYbtr+uJHSSU9wpw6silgMme5BODedv3TIVorday/
         k3gt+dNWMGATQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 559AD60A3C;
        Thu,  9 Dec 2021 15:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] net: dsa: mv88e6xxx: error handling for serdes_power
 functions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163906500934.10006.3830083843668512578.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 15:50:09 +0000
References: <20211209041552.9810-1-amhamza.mgc@gmail.com>
In-Reply-To: <20211209041552.9810-1-amhamza.mgc@gmail.com>
To:     Ameer Hamza <amhamza.mgc@gmail.com>
Cc:     kabel@kernel.org, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Dec 2021 09:15:52 +0500 you wrote:
> Added default case to handle undefined cmode scenario in
> mv88e6393x_serdes_power() and mv88e6393x_serdes_power() methods.
> 
> Addresses-Coverity: 1494644 ("Uninitialized scalar variable")
> Fixes: 21635d9203e1c (net: dsa: mv88e6xxx: Fix application of erratum 4.8 for 88E6393X)
> Reviewed-by: Marek Behún <kabel@kernel.org>
> Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
> 
> [...]

Here is the summary with links:
  - [v4] net: dsa: mv88e6xxx: error handling for serdes_power functions
    https://git.kernel.org/netdev/net/c/0416e7af2369

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


