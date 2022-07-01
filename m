Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4065633DA
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 15:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbiGANAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 09:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiGANAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 09:00:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2165841322;
        Fri,  1 Jul 2022 06:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0A50B8302C;
        Fri,  1 Jul 2022 13:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 76C3EC3411E;
        Fri,  1 Jul 2022 13:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656680414;
        bh=AKwcnmF8srbIFP+/+9Wu9rMqg+tG+FJGIVne+c+pleE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tRLQPYt9LsyY5+PZPDX1EuLflAUEQ/A5ctFSMt11PACPAJ2X/XLeSav5b3K/IGgLa
         IyVMgpcM5dpw46igc4DtisSkIzctOmv+RFliQ8p6D0RTkLiXbxTt//mhBYA4j4CIYs
         GOETyrzFf9JSK1kcR+mANZp9uvdJkUKKqGNnHCX4Euva4c2udlTrK7VYY14XAG5hlX
         6+EQxVHvnkhZKXfSo9QgoTft5ycD7+p8YV1kvz6bHqWaCB74XRQOrjDiOCww4RKx4q
         qBbp6keSaCAXLyny7SY75E0/tbCvZODIReOgM/Q8ngORJTdsjBkdONS7/GP/j2cR1Z
         EkLadC2oCvrQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 59611E49BB8;
        Fri,  1 Jul 2022 13:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: usb: Fix typo in code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165668041436.29442.265206066147576091.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Jul 2022 13:00:14 +0000
References: <20220701064723.2935-1-kunyu@nfschina.com>
In-Reply-To: <20220701064723.2935-1-kunyu@nfschina.com>
To:     Li kunyu <kunyu@nfschina.com>
Cc:     gregkh@linuxfoundation.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri,  1 Jul 2022 14:47:23 +0800 you wrote:
> Remove the repeated ';' from code.
> 
> Signed-off-by: Li kunyu <kunyu@nfschina.com>
> ---
>  drivers/net/usb/catc.c | 2 +-
>  1 file changed, 1 insertions(+), 1 deletions(-)

Here is the summary with links:
  - [v2] net: usb: Fix typo in code
    https://git.kernel.org/netdev/net/c/8dfeee9dc52c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


