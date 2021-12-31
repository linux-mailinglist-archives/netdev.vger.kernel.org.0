Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA1C48245E
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 15:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhLaOkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 09:40:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58848 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhLaOkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 09:40:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 107FBB81D85
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 14:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9DEAEC36AED;
        Fri, 31 Dec 2021 14:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640961613;
        bh=YRSaV4oTAE0HarzW9psa4YTwVlIPRX5J3VIJuH1j7RA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JyzhvYUDYZ4zjN5cg+ZGKuG6/9b4AeW6TH78C/IgVbNIprB2k/mRj9YkTog5vAklx
         jgy43YnSj0iDdDPOiUM2PhQEl+fJI3MmNxvD3s+qvZZlLcIjVFljQVta6c8ECzj0Xa
         qSX1VfDVJOI5bHt8nh5+2073Fl8lVQt0179KTrpYBcpb6vERGglpFNyXgCI0r8Iv1R
         gqFBFHZ7s8lQJwekGMSHpXnJSK0/OxrFs71Mumjd+0+oRaNo5xeOtrEbuvKxGsdEMR
         gjiGGFb43XuFE+9L3qJWJlXSacnzNM7Tj/hjr5IQkOGWTdNOikvtD3VppFCdaI1fiB
         7HVtPWrFAJYGg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 85AB9C395E6;
        Fri, 31 Dec 2021 14:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/5] net: Length checks for attributes within multipath
 routes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164096161354.2091.4022263623250191113.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Dec 2021 14:40:13 +0000
References: <20211231003635.91219-1-dsahern@kernel.org>
In-Reply-To: <20211231003635.91219-1-dsahern@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, idosch@idosch.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 30 Dec 2021 17:36:30 -0700 you wrote:
> Add length checks for attributes within a multipath route (attributes
> within RTA_MULTIPATH). Motivated by the syzbot report in patch 1 and
> then expanded to other attributes as noted by Ido.
> 
> David Ahern (5):
>   ipv4: Check attribute length for RTA_GATEWAY in multipath route
>   ipv4: Check attribute length for RTA_FLOW in multipath route
>   ipv6: Check attribute length for RTA_GATEWAY in multipath route
>   ipv6: Check attribute length for RTA_GATEWAY when deleting multipath
>     route
>   lwtunnel: Validate RTA_ENCAP_TYPE attribute is at least 2 bytes
> 
> [...]

Here is the summary with links:
  - [net,1/5] ipv4: Check attribute length for RTA_GATEWAY in multipath route
    https://git.kernel.org/netdev/net/c/7a3429bace0e
  - [net,2/5] ipv4: Check attribute length for RTA_FLOW in multipath route
    https://git.kernel.org/netdev/net/c/664b9c4b7392
  - [net,3/5] ipv6: Check attribute length for RTA_GATEWAY in multipath route
    https://git.kernel.org/netdev/net/c/4619bcf91399
  - [net,4/5] ipv6: Check attribute length for RTA_GATEWAY when deleting multipath route
    https://git.kernel.org/netdev/net/c/1ff15a710a86
  - [net,5/5] lwtunnel: Validate RTA_ENCAP_TYPE attribute length
    https://git.kernel.org/netdev/net/c/8bda81a4d400

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


