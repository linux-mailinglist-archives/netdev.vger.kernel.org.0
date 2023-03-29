Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDFAA6CD26C
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 09:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjC2HAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 03:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjC2HA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 03:00:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CE5268B;
        Wed, 29 Mar 2023 00:00:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2D18B81A93;
        Wed, 29 Mar 2023 07:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D094C433EF;
        Wed, 29 Mar 2023 07:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680073226;
        bh=lGSmi0b2PlgkNBEB47nzo6rd+Wkk5p0nuDR5QM0kWO8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hDqnzMozm+QfHNaiSGurFhJKdxs/1nLY6D1NR+9M/4gCKa/mk+PlC/OJZ5bPG0bSG
         A6o8h8q/6N0GOBGNIRZ1JciQoAVjO1QhwBhkSjlAqnLBIcKH1Ql4ZpXWA1XGya5HTv
         CYp023znZtwbuyIK4CbRU1jbNSPoBvEZATVjkFyimRwKbACOGL2yMy0Ns4OxEHXDnG
         C7ybsYirqGivA3VyviwueuW2GJKLbDuAGsHl96ov1Sd9WInaVOf8F71VdLhMNvEDix
         OPEkRmSo/7jymWG5w81xbovqS+CZZSpMZVm2wcJxjHbLbwpBGfYNw18q3AbztMnW0D
         HQaiRWM1Ta2tQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5302DE4F0DB;
        Wed, 29 Mar 2023 07:00:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 0/7] ynl: add support for user headers and struct
 attrs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168007322633.11543.18104473489328578879.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Mar 2023 07:00:26 +0000
References: <20230327083138.96044-1-donald.hunter@gmail.com>
In-Reply-To: <20230327083138.96044-1-donald.hunter@gmail.com>
To:     Donald Hunter <donald.hunter@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, donald.hunter@redhat.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 27 Mar 2023 09:31:31 +0100 you wrote:
> Add support for user headers and struct attrs to YNL. This patchset adds
> features to ynl and add a partial spec for openvswitch that demonstrates
> use of the features.
> 
> Patch 1-4 add features to ynl
> Patch 5 adds partial openvswitch specs that demonstrate the new features
> Patch 6-7 add documentation for legacy structs and for sub-type
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/7] tools: ynl: Add struct parsing to nlspec
    https://git.kernel.org/netdev/net-next/c/bec0b7a2db35
  - [net-next,v5,2/7] tools: ynl: Add C array attribute decoding to ynl
    https://git.kernel.org/netdev/net-next/c/b423c3c86325
  - [net-next,v5,3/7] tools: ynl: Add struct attr decoding to ynl
    https://git.kernel.org/netdev/net-next/c/2607191395bd
  - [net-next,v5,4/7] tools: ynl: Add fixed-header support to ynl
    https://git.kernel.org/netdev/net-next/c/f036d936ca57
  - [net-next,v5,5/7] netlink: specs: add partial specification for openvswitch
    https://git.kernel.org/netdev/net-next/c/643ef4a676e3
  - [net-next,v5,6/7] docs: netlink: document struct support for genetlink-legacy
    https://git.kernel.org/netdev/net-next/c/88e288968412
  - [net-next,v5,7/7] docs: netlink: document the sub-type attribute property
    https://git.kernel.org/netdev/net-next/c/04eac39361d3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


