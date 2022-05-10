Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C93B1520FBB
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 10:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238000AbiEJIeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 04:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236571AbiEJIeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 04:34:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FDA29BC7D
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 01:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECEE2B81983
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 08:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B9161C385C9;
        Tue, 10 May 2022 08:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652171413;
        bh=G5g0LqLJ2an09Et0AHPHViDhR12BIazQlDWbyrr+mtM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fWKu9cmu8mwbseqnIAiOde+TZQQ7RMywujHe9aAvpZgZK5FWBNk89e/CJTsakUSHk
         V4JtUgCTMv4qliFbA8IV/roAjKds0jdrdwTXtwKkIuEnMNC/aZu//mqI+XCKh4O+yq
         BEgo3kTUAzL8f48BPZ9EOO4WahEkGajdmuY0yQX1hhgF4sEfghLKbdBOYX2sYXT27z
         ezgB6im76zD7ZOdPXFkXPc9WxQH6lDD5t0lhTdUGaTHxd0zBxX231H3y4CzeUDg4Qc
         W63nApOfDYNlBlcTNZubD/XqqfaVtj6jI/X+F4qJS2TWQx9zOInrR9VNDv3q9IJNHq
         3BD1P7dYyvE8g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9A3CCE8DCCE;
        Tue, 10 May 2022 08:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/6] ptp: Support hardware clocks with additional
 free running cycle counter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165217141361.23564.8937296737703783858.git-patchwork-notify@kernel.org>
Date:   Tue, 10 May 2022 08:30:13 +0000
References: <20220506200142.3329-1-gerhard@engleder-embedded.com>
In-Reply-To: <20220506200142.3329-1-gerhard@engleder-embedded.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     richardcochran@gmail.com, vinicius.gomes@intel.com,
        yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org,
        mlichvar@redhat.com, willemb@google.com, kafai@fb.com,
        jonathan.lemon@gmail.com, netdev@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri,  6 May 2022 22:01:36 +0200 you wrote:
> ptp vclocks require a clock with free running time for the timecounter.
> Currently only a physical clock forced to free running is supported.
> If vclocks are used, then the physical clock cannot be synchronized
> anymore. The synchronized time is not available in hardware in this
> case. As a result, timed transmission with TAPRIO hardware support
> is not possible anymore.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/6] ptp: Add cycles support for virtual clocks
    https://git.kernel.org/netdev/net-next/c/42704b26b0f1
  - [net-next,v4,2/6] ptp: Request cycles for TX timestamp
    https://git.kernel.org/netdev/net-next/c/51eb7492af27
  - [net-next,v4,3/6] ptp: Pass hwtstamp to ptp_convert_timestamp()
    https://git.kernel.org/netdev/net-next/c/d58809d854c9
  - [net-next,v4,4/6] ptp: Support late timestamp determination
    https://git.kernel.org/netdev/net-next/c/97dc7cd92ac6
  - [net-next,v4,5/6] ptp: Speed up vclock lookup
    https://git.kernel.org/netdev/net-next/c/fcf308e50928
  - [net-next,v4,6/6] tsnep: Add free running cycle counter support
    https://git.kernel.org/netdev/net-next/c/0abb62b68252

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


