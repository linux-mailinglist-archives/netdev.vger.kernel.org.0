Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7B16C76C5
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 06:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbjCXFAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 01:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjCXFAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 01:00:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B6328D3D;
        Thu, 23 Mar 2023 22:00:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32159B822E4;
        Fri, 24 Mar 2023 05:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CA1D7C4339B;
        Fri, 24 Mar 2023 05:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679634026;
        bh=HNqp4bMHg8MzK6ZJ8RLplZhhmKEjCMR4SmjHp/nwIzY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FyZNDn3rNqM5d/BIf/gwdNr6572+nfQdWZBXs4D7Kdb966etz3bPPGdrrIBVIQMfd
         CK5rOqIrS6SCZ+tpnuquS3/IEs3pekeW6hgm3NYPlxTKiHHsSwmjZ1Y7NtAl8BxVP8
         6uQ7vbJH1LGXsCo3L5GK7OmBXRr661JODjqWJY1ku62Lcn0K0O8tj+dyygaDPBVmb8
         tJN4rd5fsYHC9veXSE+IIOGg1NJdYxYaYeZO//le83o1oN86KPkQOq7sW5UTjEshLY
         JHgr15AO2xnMpfg336n5DAlUV4Euby2lfRT1hhdHToqWwoSgWPW2LQxXQMSeItIMgQ
         pH5/WMYOXPAJQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A9A59E21ED4;
        Fri, 24 Mar 2023 05:00:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/5] netfilter: nft_redir: use `struct nf_nat_range2`
 throughout and deduplicate eval call-backs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167963402668.21241.2159344796106558842.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Mar 2023 05:00:26 +0000
References: <20230322210802.6743-2-fw@strlen.de>
In-Reply-To: <20230322210802.6743-2-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, jeremy@azazel.net
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Florian Westphal <fw@strlen.de>:

On Wed, 22 Mar 2023 22:07:58 +0100 you wrote:
> From: Jeremy Sowden <jeremy@azazel.net>
> 
> `nf_nat_redirect_ipv4` takes a `struct nf_nat_ipv4_multi_range_compat`,
> but converts it internally to a `struct nf_nat_range2`.  Change the
> function to take the latter, factor out the code now shared with
> `nf_nat_redirect_ipv6`, move the conversion to the xt_REDIRECT module,
> and update the ipv4 range initialization in the nft_redir module.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] netfilter: nft_redir: use `struct nf_nat_range2` throughout and deduplicate eval call-backs
    https://git.kernel.org/netdev/net-next/c/6f56ad1b9232
  - [net-next,2/5] netfilter: nft_masq: deduplicate eval call-backs
    https://git.kernel.org/netdev/net-next/c/f6ca5d5ed7ec
  - [net-next,3/5] netfilter: xtables: disable 32bit compat interface by default
    https://git.kernel.org/netdev/net-next/c/bde7170a04d6
  - [net-next,4/5] xtables: move icmp/icmpv6 logic to xt_tcpudp
    https://git.kernel.org/netdev/net-next/c/36ce9982ef2f
  - [net-next,5/5] netfilter: keep conntrack reference until IPsecv6 policy checks are done
    https://git.kernel.org/netdev/net-next/c/b0e214d21203

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


