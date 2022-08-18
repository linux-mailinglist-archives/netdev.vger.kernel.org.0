Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F78A598C8D
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 21:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344624AbiHRTaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 15:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345503AbiHRTaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 15:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EDD13F08;
        Thu, 18 Aug 2022 12:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BA7C6101B;
        Thu, 18 Aug 2022 19:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1DD78C433C1;
        Thu, 18 Aug 2022 19:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660851016;
        bh=XW9J5MmssDKYeqRtWcLVorEVgFK2/YMId+ExwOQQ5EA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tel+14iMYp+ZQaTxdnFvGBRSxx/qw6oMMdLpK358D1ESMgBSPXz1AABJvDmEx6vtI
         88vuAXzUnnr1KMwAmTsGDeZd+N5Ga4VIAbrEFdNXi57xRP4RsaGrIr3XDppi5U2ID3
         R34SpqzflxV+0wcl0UrrrLoag7lVqsmSFg9vPnVYCpJNBH9A+DVTtIv1n4kPK06zDy
         h0qjCytAarfAY1NCna+ZjrEqrx0F1or6kxqMpKByuDsfBLuWSGxa8SV1aq7szmvdQF
         tNQvKBiAU4lCb8jTfo/jDdzR/BQI6ymlsOIrmZ0po8mUnBMS1Ag+uZV/fYmIme4Dcb
         xauryLNRDzLPg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E4859E2A057;
        Thu, 18 Aug 2022 19:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] ip_tunnel: respect tunnel key's "flow_flags" in IP
 tunnels
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166085101592.25726.9692530431777521512.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Aug 2022 19:30:15 +0000
References: <20220818074118.726639-1-eyal.birger@gmail.com>
In-Reply-To: <20220818074118.726639-1-eyal.birger@gmail.com>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     idosch@nvidia.com, petrm@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, razor@blackwall.org,
        daniel@iogearbox.net, kafai@fb.com, paul@isovalent.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu, 18 Aug 2022 10:41:18 +0300 you wrote:
> Commit 451ef36bd229 ("ip_tunnels: Add new flow flags field to ip_tunnel_key")
> added a "flow_flags" member to struct ip_tunnel_key which was later used by
> the commit in the fixes tag to avoid dropping packets with sources that
> aren't locally configured when set in bpf_set_tunnel_key().
> 
> VXLAN and GENEVE were made to respect this flag, ip tunnels like IPIP and GRE
> were not.
> 
> [...]

Here is the summary with links:
  - [bpf] ip_tunnel: respect tunnel key's "flow_flags" in IP tunnels
    https://git.kernel.org/bpf/bpf/c/7ec9fce4b316

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


