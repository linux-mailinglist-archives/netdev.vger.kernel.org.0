Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59DE2635EF1
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 14:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238663AbiKWNHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 08:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238868AbiKWNHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 08:07:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D15AE0B7E
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 04:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3D3DB81F6F
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 12:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 588B3C43470;
        Wed, 23 Nov 2022 12:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207815;
        bh=HYN+usK1I72ACviAJsz4yd6ZItyo6Oe3oPpiKjTQXT8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jOc5vWTytSxcqzyVFxxnIE2Sv3gnX4OqNmdgpPy1guczvcd0TGZvMQo/eHn7AQchs
         /RKSMNrpwQ6m5h1Z7JlkobwzBheT0KcVAm48ewOllsdqIxG35kSpbeEYvuCtK8FQvo
         5Qp2IamPNI0zbDpwizvD67Kt8vqgFXMeL6RHOZNz4G6MCk176rI/hFBWcj+SvpcfD8
         e4pBdnsXhhErxLtuQh8+PeTI75GbjSKVNfsemOyktcpTYHoNSr9Wt9w1mz+Ho6sm2q
         cX4s+J+aoqGd9Trxj12WCQjVTp4TLb3H05hG+BkTZ/DmPmoX1ecsk2atxFzKsmzG3Q
         DYi6Wdq4dBb2g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3CEC6E21EF9;
        Wed, 23 Nov 2022 12:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: qmi_wwan: add u-blox 0x1342 composition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166920781524.7047.14138676184954501269.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Nov 2022 12:50:15 +0000
References: <20221121125455.66307-1-davide.tronchin.94@gmail.com>
In-Reply-To: <20221121125455.66307-1-davide.tronchin.94@gmail.com>
To:     Davide Tronchin <davide.tronchin.94@gmail.com>
Cc:     bjorn@mork.no, netdev@vger.kernel.org, marco.demarco@posteo.net
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

On Mon, 21 Nov 2022 13:54:55 +0100 you wrote:
> Add RmNet support for LARA-L6.
> 
> LARA-L6 module can be configured (by AT interface) in three different
> USB modes:
> * Default mode (Vendor ID: 0x1546 Product ID: 0x1341) with 4 serial
> interfaces
> * RmNet mode (Vendor ID: 0x1546 Product ID: 0x1342) with 4 serial
> interfaces and 1 RmNet virtual network interface
> * CDC-ECM mode (Vendor ID: 0x1546 Product ID: 0x1343) with 4 serial
> interface and 1 CDC-ECM virtual network interface
> 
> [...]

Here is the summary with links:
  - net: usb: qmi_wwan: add u-blox 0x1342 composition
    https://git.kernel.org/netdev/net/c/a487069e11b6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


