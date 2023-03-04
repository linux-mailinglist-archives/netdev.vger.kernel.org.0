Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E296AA78B
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 03:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjCDCUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 21:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCDCUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 21:20:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF0165C58
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 18:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19BD66186E
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 02:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7D5BFC433D2;
        Sat,  4 Mar 2023 02:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677896418;
        bh=qXOWwZE8nkoM4ormWShEMXFsOFUpqJNR+urB1qbJ1ok=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bSd6j0FGZokjwd5qfTbFoLw8a2/kUsIDR4ZKWUVaj2gR3BJi5zxJdpzW4dbdgyPjy
         U+B3Qd5Uw0r032HpnoHF6zKQNLOq0vTLrWFBzMH1/0Sc3ZkRQB8BDVGdXvsM5/NKAl
         kf+hrB1S6oX1Cb03M5OMrHYGGNMXgXYGOBVT9PnEvemP+N4A3f8/BGvlh2Jjgz1kfW
         hYgBWNTqjx3/+7e4j4UtiI0AazpTizXucB0CRS+3ChmcePsmhg79AZvrE2AMX1gJfc
         S9ta0FaojPONFC4I3bykYaM0D/dvMSg8Ki+08Uz6KAZ+1osUKgSj4GK+OXR3+Q0hy5
         whZQJzr8F+LcA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5E947C00445;
        Sat,  4 Mar 2023 02:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] man: tc-mqprio: extend prio-tc-queue mapping with
 examples
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167789641838.26474.2747633103367439718.git-patchwork-notify@kernel.org>
Date:   Sat, 04 Mar 2023 02:20:18 +0000
References: <20230220150548.2021-1-peti.antal99@gmail.com>
In-Reply-To: <20230220150548.2021-1-peti.antal99@gmail.com>
To:     =?utf-8?q?P=C3=A9ter_Antal_=3Cpeti=2Eantal99=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com,
        vladimir.oltean@nxp.com, stephen@networkplumber.org,
        fejes@inf.elte.hu, ferenc.fejes@ericsson.com,
        vinicius.gomes@intel.com, antal.peti99@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Mon, 20 Feb 2023 16:05:48 +0100 you wrote:
> The current mqprio manual is not detailed about queue mapping
> and priorities, this patch adds some examples to it.
> 
> Suggested-by: Ferenc Fejes <fejes@inf.elte.hu>
> Signed-off-by: Péter Antal <peti.antal99@gmail.com>
> ---
>  man/man8/tc-mqprio.8 | 96 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 96 insertions(+)

Here is the summary with links:
  - [iproute2] man: tc-mqprio: extend prio-tc-queue mapping with examples
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=ce4068f22db4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


