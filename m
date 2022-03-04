Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8BC4CD922
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 17:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240799AbiCDQbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 11:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234137AbiCDQbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 11:31:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874451CBAAC
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 08:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 284A9B82A72
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 16:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CAA09C340EF;
        Fri,  4 Mar 2022 16:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646411410;
        bh=susnEfiPxeDkXfHWmuTIs3GxROo0rGOfFYjTuSYAKTU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ioNygAH1mTUfas26MJ7jvB4EIFHU8xF88l9QwIPhk25JCuXmzJZF+/9r7MRNtUZPC
         1ftvSqNh8fZzFmUujTrpKIDLfEHwSyaijMza2+0aHqIf4SKIh/B8lsqUrfjH0jWTi0
         5ymtXUzfWBH7DstrlaAY68Qk/WNIV8VUQ/x16c7ZU/BdNgXLsgw64nUoOZMAn87Q/w
         g0ykGUwy1EUotepUYkThwY3ojDaxLDsJ2hqJykBwSeICEgiF90ryolpFOqmwJczxqO
         HFhoubZQ8CbazubNgSVAFB7tieATW1ojfwD3u0imJntVMZoOvF1UVsGWpCqCVotj8g
         LddgzTzyYzRKQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B2635E6D4BB;
        Fri,  4 Mar 2022 16:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 0/2] lib: add profinet and ethercat as link
 layer protocol
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164641141072.22555.6447367535289527766.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Mar 2022 16:30:10 +0000
References: <20220228134520.118589-1-daniel@braunwarth.dev>
In-Reply-To: <20220228134520.118589-1-daniel@braunwarth.dev>
To:     Daniel Braunwarth <daniel@braunwarth.dev>
Cc:     netdev@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Mon, 28 Feb 2022 14:45:18 +0100 you wrote:
> Update the llproto_names array to allow users to reference the PROFINET
> and EtherCAT protocols with the names 'profinet' and 'ethercat'.
> 
> These patches depends on the below referenced patch, which extends if_ether.h
> with the used ETH_P_xxx defines.
> 
> Link: https://lore.kernel.org/netdev/20220228133029.100913-1-daniel@braunwarth.dev/
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/2] lib: add profinet and ethercat as link layer protocol names
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=75061b357f06
  - [iproute2-next,2/2] tc: bash-completion: Add profinet and ethercat to procotol completion list
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=712ec66e6f3e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


