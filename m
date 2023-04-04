Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78AAB6D5695
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 04:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbjDDCKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 22:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjDDCKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 22:10:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001131FEA
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 19:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29EB962537
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 02:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 74626C433D2;
        Tue,  4 Apr 2023 02:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680574218;
        bh=fN1h54zuSVtBu3Au9IktPqjitjG+CLqUk13fbK3wAHM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FtxxwRGNc2T2kUjkJoTW9+17tbGftUK+ws97Q/DJEtP1Mp7hghMeLiFRVRbO3lV8D
         r6H5xushAifnACbS2pRlJ3MQS+RFmJVqoPySJxrM9ffVQyyZCXxaaVSVBN5dD82FQp
         oM8RlLJB5Ia53e9uiTT1j6tLvt1IlGitlXB/NrWBmLdBh6+2bmkXMcMCO6MLPBuz5K
         m5/6UxtmJTM7ZUCJfcK/TG1+dWAB7/HVaW6YFjz9oWGXAfsquPF0aRhoTybhG6TI1S
         cnAxzRdu4CFQnopvUWAZaJDdJ47SFrXETNrz8Rd7G6QAjpMBlAbeT0jA+JTO5ePtUu
         sxA/0xA4VTVhg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 58E3EE5EA89;
        Tue,  4 Apr 2023 02:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 net-next 0/4] sfc: support unicast PTP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168057421836.16500.491456420291343090.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Apr 2023 02:10:18 +0000
References: <20230331111404.17256-1-ihuguet@redhat.com>
In-Reply-To: <20230331111404.17256-1-ihuguet@redhat.com>
To:     =?utf-8?b?w43DsWlnbyBIdWd1ZXQgPGlodWd1ZXRAcmVkaGF0LmNvbT4=?=@ci.codeaurora.org
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, yalli@redhat.com
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

On Fri, 31 Mar 2023 13:14:00 +0200 you wrote:
> Unicast PTP was not working with sfc NICs.
> 
> The reason was that these NICs don't timestamp all incoming packets,
> but instead they only timestamp packets of the queues that are selected
> for that. Currently, only one RX queue is configured for timestamp: the
> RX queue of the PTP channel. The packets that are put in the PTP RX
> queue are selected according to firmware filters configured from the
> driver.
> 
> [...]

Here is the summary with links:
  - [v6,net-next,1/4] sfc: store PTP filters in a list
    https://git.kernel.org/netdev/net-next/c/e790fc15bfbf
  - [v6,net-next,2/4] sfc: allow insertion of filters for unicast PTP
    https://git.kernel.org/netdev/net-next/c/75687cd06620
  - [v6,net-next,3/4] sfc: support unicast PTP
    (no matching commit)
  - [v6,net-next,4/4] sfc: remove expired unicast PTP filters
    https://git.kernel.org/netdev/net-next/c/ad47655eadc8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


