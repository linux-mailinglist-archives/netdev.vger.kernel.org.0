Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC114ED6F4
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 11:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233266AbiCaJcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 05:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233161AbiCaJcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 05:32:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6831B1959C4;
        Thu, 31 Mar 2022 02:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 124E8B82014;
        Thu, 31 Mar 2022 09:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B949EC340F3;
        Thu, 31 Mar 2022 09:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648719014;
        bh=FvvM5BIaN0Tlqtjuez0sKOLUrS6aTrHpEXTSTkI/TxI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hqWejYGFzcPZcPvr1BiLXs6bjSUkth294jBUvBLcYg465Slf6qfU5GWPkDwPcO2bu
         2BAbO1I2j75tAf8lgctfbR+QT87PtAnc6C2F6/C2uodCjOOH9FEPvOjTf4D93/LCL7
         312wL6NBCTST7kAHJ33ZVo8XiXz9syo+p2VSbzxAiMFXwvH/9cljE8upKECmDcT1tX
         3+OVfhOtuWjNCgtX81hm1w8Fk6vgnuymLNItt7X3urZYX1CGb6ukrHBGX4x/KfK7n7
         H03k1m3lPWgmniO5Ke2p4omTGqwgHZwMz9vd+yN4HYq12ei6CPieXtEQs3PcBolOZW
         rDN5CVj5oYMeg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9D967F03848;
        Thu, 31 Mar 2022 09:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 00/14] docs: update and move the netdev-FAQ
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164871901464.21222.10495458574563491451.git-patchwork-notify@kernel.org>
Date:   Thu, 31 Mar 2022 09:30:14 +0000
References: <20220330042505.2902770-1-kuba@kernel.org>
In-Reply-To: <20220330042505.2902770-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        corbet@lwn.net, bpf@vger.kernel.org, linux-doc@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com
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

This series was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 29 Mar 2022 21:24:51 -0700 you wrote:
> A section of documentation for tree-specific process quirks had
> been created a while back. There's only one tree in it, so far,
> the tip tree, but the contents seem to answer similar questions
> as we answer in the netdev-FAQ. Move the netdev-FAQ.
> 
> Take this opportunity to touch up and update a few sections.
> 
> [...]

Here is the summary with links:
  - [net,v3,01/14] docs: netdev: replace references to old archives
    https://git.kernel.org/netdev/net/c/50386f7526dd
  - [net,v3,02/14] docs: netdev: minor reword
    https://git.kernel.org/netdev/net/c/30cddd30532a
  - [net,v3,03/14] docs: netdev: move the patch marking section up
    https://git.kernel.org/netdev/net/c/c82d90b14f6c
  - [net,v3,04/14] docs: netdev: turn the net-next closed into a Warning
    https://git.kernel.org/netdev/net/c/2fd4c50dbff1
  - [net,v3,05/14] docs: netdev: note that RFC postings are allowed any time
    https://git.kernel.org/netdev/net/c/0e242e3fb7a7
  - [net,v3,06/14] docs: netdev: shorten the name and mention msgid for patch status
    https://git.kernel.org/netdev/net/c/5d84921ac750
  - [net,v3,07/14] docs: netdev: rephrase the 'Under review' question
    https://git.kernel.org/netdev/net/c/8f785c1bb84f
  - [net,v3,08/14] docs: netdev: rephrase the 'should I update patchwork' question
    https://git.kernel.org/netdev/net/c/724c1a7443c5
  - [net,v3,09/14] docs: netdev: add a question about re-posting frequency
    https://git.kernel.org/netdev/net/c/b8ba106378a0
  - [net,v3,10/14] docs: netdev: make the testing requirement more stringent
    https://git.kernel.org/netdev/net/c/3eca381457ca
  - [net,v3,11/14] docs: netdev: add missing back ticks
    https://git.kernel.org/netdev/net/c/a30059731877
  - [net,v3,12/14] docs: netdev: call out the merge window in tag checking
    https://git.kernel.org/netdev/net/c/99eba4e5cbd4
  - [net,v3,13/14] docs: netdev: broaden the new vs old code formatting guidelines
    https://git.kernel.org/netdev/net/c/08767a26f095
  - [net,v3,14/14] docs: netdev: move the netdev-FAQ to the process pages
    https://git.kernel.org/netdev/net/c/8df0136376dc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


