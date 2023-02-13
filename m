Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785466941E7
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 10:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjBMJuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 04:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbjBMJuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 04:50:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3161C40E2;
        Mon, 13 Feb 2023 01:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A967B80EF5;
        Mon, 13 Feb 2023 09:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16306C433A7;
        Mon, 13 Feb 2023 09:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676281817;
        bh=YrME9UZEzJJ0B9tDXhqXuZnTgQukPzBYyOeXz7w+gic=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jyzibJ7kHxn+ghhwDLNmUFu77nEPXonwK2jZHbXToDOJ7ZoLZnkH914zKUsLiJlgp
         8BbQddr2RiWg9+PPTpvfzZ1BFniY54yFAr2AEpozOz4ISPtWBIFfZt1kaxZd2oyhp0
         giEC1x4Yey+Q39ugX5qSjwDRoK66LGlpb5Xa6Hrtni1dM5HyhA5z4WpZIcEUSzGrK9
         TbzqxbSB5ESejTKdzauEpNSeZ4Vhxk7RcNXrIGI4agGnMwHtn9YqJ7CQNuFB6thj9k
         z3njjfDqQCPlrs4i3k7//IPWl1/awFANlIOR6vy38vrYCsXsFYaSIf4ubJMVAiHvmG
         4Qs31Ty3ScuUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EEF08E68D2E;
        Mon, 13 Feb 2023 09:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/usb: kalmia: Don't pass act_len in usb_bulk_msg error
 path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167628181697.13846.4024635767323852589.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Feb 2023 09:50:16 +0000
References: <2f74aab82a40e4c11c91ccba40f5b620f6cb209c.camel@gmail.com>
In-Reply-To: <2f74aab82a40e4c11c91ccba40f5b620f6cb209c.camel@gmail.com>
To:     Miko Larsson <mikoxyzzz@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        jiri@resnulli.us, pabeni@redhat.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 10 Feb 2023 09:13:44 +0100 you wrote:
> syzbot reported that act_len in kalmia_send_init_packet() is
> uninitialized when passing it to the first usb_bulk_msg error path. Jiri
> Pirko noted that it's pointless to pass it in the error path, and that
> the value that would be printed in the second error path would be the
> value of act_len from the first call to usb_bulk_msg.[1]
> 
> With this in mind, let's just not pass act_len to the usb_bulk_msg error
> paths.
> 
> [...]

Here is the summary with links:
  - net/usb: kalmia: Don't pass act_len in usb_bulk_msg error path
    https://git.kernel.org/netdev/net/c/c68f345b7c42

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


