Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44D34557753
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 12:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiFWKAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 06:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbiFWKAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 06:00:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF16349CB7;
        Thu, 23 Jun 2022 03:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7035161DAD;
        Thu, 23 Jun 2022 10:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CA7CEC341C0;
        Thu, 23 Jun 2022 10:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655978412;
        bh=BkUxnJPDhnPu27WSLpY2P7BGcWIQ8/1j1dDbELLIkdg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K4kenSi8J3qXR8EyHxXgSCY2MNWUakjRtbrG8vdHETNVapUi6PiTIqmDKFxEJ0Y1F
         DiRtXf9XlZIJAWNq99QQZ3giPY71kItM7wSAp2R8KfBIf5TSYqRTKIwsWEtX92lJkp
         +/qHMuqJnJD/ZonzIw0MZxUKjLqe0OnHnNQrIdQQv9LhR1F1PDJH8FjidS7qYpQTMS
         hdPsJUnssjuChlTz+b1JQ1EeEpygiuQ6irNjHRI0TfClOG7grbTBA/QHzRsatDyhN0
         q/yIQ+sE4G7b3f7Q6JIafgKtO/IcEMEdsHBZRymzCWGDkpWpQ1/Z2alegWIThkiMhl
         2yvtvcelun2eA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AF68FE737F0;
        Thu, 23 Jun 2022 10:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: openvswitch: fix parsing of nw_proto for IPv6
 fragments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165597841271.22799.14586391448638568362.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Jun 2022 10:00:12 +0000
References: <20220621204845.9721-1-roriorden@redhat.com>
In-Reply-To: <20220621204845.9721-1-roriorden@redhat.com>
To:     Rosemarie O'Riorden <roriorden@redhat.com>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        yihung.wei@gmail.com, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, i.maximets@ovn.org,
        aconole@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 21 Jun 2022 16:48:45 -0400 you wrote:
> When a packet enters the OVS datapath and does not match any existing
> flows installed in the kernel flow cache, the packet will be sent to
> userspace to be parsed, and a new flow will be created. The kernel and
> OVS rely on each other to parse packet fields in the same way so that
> packets will be handled properly.
> 
> As per the design document linked below, OVS expects all later IPv6
> fragments to have nw_proto=44 in the flow key, so they can be correctly
> matched on OpenFlow rules. OpenFlow controllers create pipelines based
> on this design.
> 
> [...]

Here is the summary with links:
  - [net] net: openvswitch: fix parsing of nw_proto for IPv6 fragments
    https://git.kernel.org/netdev/net/c/12378a5a75e3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


