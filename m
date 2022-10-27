Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8960E60F5B9
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 12:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234688AbiJ0KuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 06:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234330AbiJ0KuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 06:50:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC66550B2;
        Thu, 27 Oct 2022 03:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB26CB82585;
        Thu, 27 Oct 2022 10:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 53479C433D6;
        Thu, 27 Oct 2022 10:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666867816;
        bh=Tb9kHPexgDF6ff9yQLmBQ6mN+G6BrGv5fFKnJ4aoyvw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jf21nyjbfaQwVoZl5qPHCw6eq9ymktHvuu6829vDVDiPHR6UiZJlk9xEr3uV7FHBB
         1mEDhJeORIdKO+QdOBj+E02JEo2a+HXVf0aI4XdFddSyR6xI2y/AiypLdonzrVDgGi
         8TGf8m5JlVQY3uGf/eIEadiXJz5jlNAJFrdNPDQjhGvEU36JNcwfXHIAhduGAkRWl4
         2BvyLdBWyJ17uJ9DSgLYpY+Au6EP2heUpVsmpHyuCyA3MGGEild6BFOXHE3HBuW/bM
         e6OuSzmNGy804D909UDob4AJyLBLbgE2V4GQxOr/Gk9Wztp4FrbJa3dkP4vNjmZukj
         L+x7Tt+zXjPaA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 34E9FE270DA;
        Thu, 27 Oct 2022 10:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net 0/2]  openvswitch: syzbot splat fix and introduce
 selftest
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166686781620.26454.9462786042081313490.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 10:50:16 +0000
References: <20221025105018.466157-1-aconole@redhat.com>
In-Reply-To: <20221025105018.466157-1-aconole@redhat.com>
To:     Aaron Conole <aconole@redhat.com>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, kuba@kernel.org,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        tgraf@suug.ch, ksprague0711@gmail.com, dev@openvswitch.org,
        echaudro@redhat.com, i.maximets@ovn.org, shuah@kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 25 Oct 2022 06:50:16 -0400 you wrote:
> Syzbot recently caught a splat when dropping features from
> openvswitch datapaths that are in-use.  The WARN() call is
> definitely too large a hammer for the situation, so change
> to pr_warn.
> 
> Second patch in the series introduces a new selftest suite which
> can help show that an issue is fixed.  This change might be
> more suited to net-next tree, so it has been separated out
> as an additional patch and can be either applied to either tree
> based on preference.
> 
> [...]

Here is the summary with links:
  - [v2,net,1/2] openvswitch: switch from WARN to pr_warn
    https://git.kernel.org/netdev/net/c/fd954cc1919e
  - [v2,net,2/2] selftests: add openvswitch selftest suite
    https://git.kernel.org/netdev/net/c/25f16c873fb1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


