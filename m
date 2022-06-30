Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3089056158F
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 11:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbiF3JAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 05:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiF3JAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 05:00:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A5962FD
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 02:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB1BEB82935
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 09:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 56F36C341C8;
        Thu, 30 Jun 2022 09:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656579614;
        bh=uGPLd+GNtRqI1X/FSMBRRxREcU3wk018SXWIQpTPNRU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mFkiD4nGmL5Tcqcg9/5pt5GVtnMPWyhs7QoDHxVZ/IqXJBOG0rihlEIIOzpuKa1TO
         IQt3GNcwIih9kv3ywBSKyGmpuKMxNCgOojHPca4JAw4lMM0pn5xmW7yHN22sVAjofU
         APCu8cvwzWkfPcsEBix5/ybabw88W2LPhdgKuyRMTHdS5d1a/YYDYy/BhonZTwcyMP
         XmscXF1pgB4vsVgLxGHalm9eAMANSXagw0OL41OXP144qMqcASiqVHhdvvGCBRBLqg
         COhScKqvBHGqZ/T8GX/oGRimwD311QqgBV7TQ6bCihV0GRxJFbtqavgOzhXndIRwSv
         AAc68y7/1GsQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3AB92E49BBF;
        Thu, 30 Jun 2022 09:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: usb: ax88179_178a: Fix packet receiving
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165657961423.14644.11800371284093229709.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Jun 2022 09:00:14 +0000
References: <d6970bb04bf67598af4d316eaeb1792040b18cfd.camel@gmail.com>
In-Reply-To: <d6970bb04bf67598af4d316eaeb1792040b18cfd.camel@gmail.com>
To:     Jose Alonso <joalonsof@gmail.com>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, kuba@kernel.org,
        jannh@google.com, freddy@asix.com.tw
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 28 Jun 2022 12:13:02 -0300 you wrote:
> This patch corrects packet receiving in ax88179_rx_fixup.
> 
> - problem observed:
>   ifconfig shows allways a lot of 'RX Errors' while packets
>   are received normally.
> 
>   This occurs because ax88179_rx_fixup does not recognise properly
>   the usb urb received.
>   The packets are normally processed and at the end, the code exits
>   with 'return 0', generating RX Errors.
>   (pkt_cnt==-2 and ptk_hdr over field rx_hdr trying to identify
>    another packet there)
> 
> [...]

Here is the summary with links:
  - [net] net: usb: ax88179_178a: Fix packet receiving
    https://git.kernel.org/netdev/net/c/f8ebb3ac881b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


