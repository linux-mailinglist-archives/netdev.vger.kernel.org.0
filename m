Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2A54D9A08
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 12:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347852AbiCOLLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 07:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237946AbiCOLLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 07:11:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F69434B7;
        Tue, 15 Mar 2022 04:10:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B78346145E;
        Tue, 15 Mar 2022 11:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 19B87C340ED;
        Tue, 15 Mar 2022 11:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647342610;
        bh=fyncz9knArlPVdM2eNnFsxp1qMHErh9T5x3IgawobFQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CBp0dd4mOYGoVeRdK5hl0ZRgEbLtlLIDg5tu6xCZI56lJrnHGqt3qgJFdK8A4AVad
         Oz5om8EaKuraYZovk4wK+y2KYKMBGkWmnNFy5f12rw3uqTwdWJaXWKyGUYY+AGnRge
         gqS4x/+yKGOzjY38lJtGPS50AmUwpcwj8eGBEQ1ozNltWj13vWLwmIdorX1Iww5vNN
         M/Ze5vJdLhNPODLh2TQEHJyHz4+34+iBdcBdbEIlrp7K1VyVOlg2qcAK05HkH9AKZ5
         FGI7H0gw5aUipu0CxTnNM30MsOoUrTGHbsFMjZvKwMWgj9JTknhqEi5dUNG8kSG4+z
         VRXcboSf+bYiw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE3D5E8DD5B;
        Tue, 15 Mar 2022 11:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] atm: eni: Add check for dma_map_single
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164734260997.13207.6190809851379875722.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Mar 2022 11:10:09 +0000
References: <20220314013448.2340361-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20220314013448.2340361-1-jiasheng@iscas.ac.cn>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     kuba@kernel.org, 3chas3@gmail.com,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 14 Mar 2022 09:34:48 +0800 you wrote:
> As the potential failure of the dma_map_single(),
> it should be better to check it and return error
> if fails.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> 
> [...]

Here is the summary with links:
  - [v2] atm: eni: Add check for dma_map_single
    https://git.kernel.org/netdev/net/c/0f74b29a4f53

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


