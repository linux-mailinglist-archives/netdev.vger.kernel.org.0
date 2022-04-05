Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94914F3C3D
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 17:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244155AbiDEMGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 08:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347026AbiDELw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 07:52:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73D2119853
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 04:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81F25B81D0B
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 11:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32C01C385A4;
        Tue,  5 Apr 2022 11:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649157012;
        bh=l3d10wkpNbaeGhm9g+vm4kdccVLGd4BmOc55WpAL6GQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VHIGo2tg+5Wt15Y5J6fx8SAej5Zt1mldmpxnEtcqTJxMNOD/WINr/fQnlkMI9p8ay
         aK95fZ3AJy1/rBR5sYG4XYwZXy8DK9TXh/upV0QIHX8EDCx1x7j7U2f4gRXShEkH14
         6rgMLxB2NyZ5FMNlQ6SkisdeuDzBCL1DXzLz2iu2jUSbKBdLmfTTXQENXvhPTmmDNI
         EAs3iQr5MIOAyRXPySghOvQk+EkWROxN9ct7ZCegbwqP1xTjXPIUjL25ZIVV4/pNGB
         kfj3idtwDw9RZ6Ct5DcU2I87ItOq5ZKUEdafMa/PXGPI/wzdY5nvqC/WWMuUKeguAT
         SPNT7dvP3F3FQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 17A43E85D5D;
        Tue,  5 Apr 2022 11:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2][pull request] ice bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164915701209.32004.11359942883010295497.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Apr 2022 11:10:12 +0000
References: <20220404183548.3422851-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220404183548.3422851-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, alice.michael@intel.com
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

On Mon,  4 Apr 2022 11:35:46 -0700 you wrote:
> Alice Michael says:
> 
> There were a couple of bugs that have been found and
> fixed by Anatolii in the ice driver.  First he fixed
> a bug on ring creation by setting the default value
> for the teid.  Anatolli also fixed a bug with deleting
> queues in ice_vc_dis_qs_msg based on their enablement.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] ice: Set txq_teid to ICE_INVAL_TEID on ring creation
    https://git.kernel.org/netdev/net/c/ccfee1822042
  - [net,v2,2/2] ice: Do not skip not enabled queues in ice_vc_dis_qs_msg
    https://git.kernel.org/netdev/net/c/05ef6813b234

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


