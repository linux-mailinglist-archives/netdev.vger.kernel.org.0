Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFA554B11DE
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243715AbiBJPkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:40:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243710AbiBJPkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:40:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDAEFA;
        Thu, 10 Feb 2022 07:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9C64B825F2;
        Thu, 10 Feb 2022 15:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C08CC340F1;
        Thu, 10 Feb 2022 15:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644507609;
        bh=AaqjMuFouSdzKFwODG2Aum1nuvWWCv1FvX+jzvj5r1o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aIx4/QpyF5jrN3+oe8/isiLYViMOV46awALuzmIgPjmGYG3YWpzcRenronBiX83Ja
         pM7b2GwdNdq/ZvVoyng4o86DcUTM4bgyKqLyYbXhLIzGTQ+IO803RkFofm4v+tn/N5
         zCGqT7uIbrsWyv+h8YJInMld7cBJeKawAhAtaN91fco5CLS6Qc/6Gg7TODbYYgQJOE
         zJVpLHHotNdHmSZGQKaEj5e1UaQWwuyhiK119LHUXvluyJitpoG9kCXi1cHJYpcibz
         RmTYaBZf2CzPclwtLVzr/U+DV7NQeXqLMBIiFk/zaRoE2LH6kIj6BYcLlPhKI//w19
         BZXTke8mQdeiA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6340AE5D084;
        Thu, 10 Feb 2022 15:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2] net/switchdev: use struct_size over open coded arithmetic
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164450760940.15967.16503585232355616916.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Feb 2022 15:40:09 +0000
References: <20220210061008.1608468-1-chi.minghao@zte.com.cn>
In-Reply-To: <20220210061008.1608468-1-chi.minghao@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     jiri@resnulli.us, ivecera@redhat.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, chi.minghao@zte.com.cn,
        zealci@zte.com.cn
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 10 Feb 2022 06:10:08 +0000 you wrote:
> From: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
> 
> Replace zero-length array with flexible-array member and make use
> of the struct_size() helper in kmalloc(). For example:
> 
> struct switchdev_deferred_item {
>     ...
>     unsigned long data[];
> };
> 
> [...]

Here is the summary with links:
  - [V2] net/switchdev: use struct_size over open coded arithmetic
    https://git.kernel.org/netdev/net-next/c/d8c2858181cc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


