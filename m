Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE0A64182D
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 18:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiLCRuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 12:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiLCRuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 12:50:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EC7193C5
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 09:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 94D61CE095B
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 17:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8814DC433C1;
        Sat,  3 Dec 2022 17:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670089815;
        bh=Rel45Ek8BecUJ7DOAV1JzK7C1CtZ8xzQSFW3jsOBnS4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=apZSjmSkkkIuNG/jBYtKqGD4cOX4RI7wGSfa6IKXpyFUZE/TGje9ju7Jup2Wm3WbV
         X7T1lys2A8JPVcgovtdaVHv9YNmrGpB8GqWJwAgrwhEj5p5BMBAWEl7sweFnGtwIPv
         x65omJvBwPw9K8dgJWiDp52xSxb9Nv6I/yubkrdDrJKAv7GytV80FQ3fKnXW8GgGRZ
         HgUqSZYbAbpjOfmcNOE5OSNGHZb3TmrNZKOFZc1Vhu8F6lF6eCLbMdGf5qNIpmqdVj
         TgInT1N+j896YzxBVT1lV8vX1aW5RQVeSS8M9PKQgspQ3PohNw+F9AoyKM8KQsJiGi
         3HzQErcTjWYmQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7162FE21EEF;
        Sat,  3 Dec 2022 17:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v2 0/4] Implement new netlink attributes for
 devlink-rate in iproute2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167008981546.21880.6197753866768235586.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Dec 2022 17:50:15 +0000
References: <20221201102626.56390-1-michal.wilczynski@intel.com>
In-Reply-To: <20221201102626.56390-1-michal.wilczynski@intel.com>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        przemyslaw.kitszel@intel.com, jiri@resnulli.us,
        wojciech.drewek@intel.com, dsahern@gmail.com,
        stephen@networkplumber.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Thu,  1 Dec 2022 11:26:22 +0100 you wrote:
> Patch implementing new netlink attributes for devlink-rate got merged to
> net-next.
> https://lore.kernel.org/netdev/20221115104825.172668-1-michal.wilczynski@intel.com/
> 
> Now there is a need to support these new attributes in the userspace
> tool. Implement tx_priority and tx_weight in devlink userspace tool. Update
> documentation.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v2,1/4] devlink: Add uapi changes for tx_priority and tx_weight
    (no matching commit)
  - [iproute2-next,v2,2/4] devlink: Introduce new attribute 'tx_priority' to devlink-rate
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=a6b9cd50e69a
  - [iproute2-next,v2,3/4] devlink: Introduce new attribute 'tx_weight' to devlink-rate
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=0f71480932f1
  - [iproute2-next,v2,4/4] devlink: Add documentation for tx_prority and tx_weight
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=2e2b53467172

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


