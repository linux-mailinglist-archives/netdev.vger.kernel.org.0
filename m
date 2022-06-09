Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F0054420D
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 05:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237625AbiFIDkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 23:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234669AbiFIDkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 23:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0560262E00
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 20:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 838C2B82ACA
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 03:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 395A1C341C0;
        Thu,  9 Jun 2022 03:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654746013;
        bh=JQYN99ToDjWnEZBxuvNPebwUqI5SW1QFi7MYUlCpX6Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ey/0PHVCpwaTcAwPFZMJigCjiJ9sx8gsaA91guqoOfTpTDWzyDRIHlNt8APgDujL0
         RHLdKr0hooBpQu+2IzzUkzrkDSYIYjuleZBo/TfD1svz2NySbBS1G0VdmvwH3+GOcg
         1CgOYh4blrBl19gp5bcF0cGBSRPJEN/2L6h5dEvuK6BudJ774WA1/UfIGGE2rwOB+7
         oIU5kqVhVnXdWllOwAyiSmAbnaESKZSlVr5/0/nBA3fcZsFnkBdbIdkDkcAp+5EW1l
         dsc2DCREs6UUjEoToSQEN/0PZFN/RNsMKouDaNGogJCaBQJGWvB6U6jOcA13tYvnlO
         mIngYEtyeFpgg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1DF6CE737FE;
        Thu,  9 Jun 2022 03:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ip_gre: test csum_start instead of transport header
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165474601311.17710.6115601837597015158.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Jun 2022 03:40:13 +0000
References: <20220606132107.3582565-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20220606132107.3582565-1-willemdebruijn.kernel@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, willemb@google.com,
        syzkaller@googlegroups.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 Jun 2022 09:21:07 -0400 you wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> GRE with TUNNEL_CSUM will apply local checksum offload on
> CHECKSUM_PARTIAL packets.
> 
> ipgre_xmit must validate csum_start after an optional skb_pull,
> else lco_csum may trigger an overflow. The original check was
> 
> [...]

Here is the summary with links:
  - [net] ip_gre: test csum_start instead of transport header
    https://git.kernel.org/netdev/net/c/8d21e9963bec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


