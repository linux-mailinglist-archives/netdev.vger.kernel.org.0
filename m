Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27986E503C
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 20:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbjDQSay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 14:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjDQSat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 14:30:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0F15FEB;
        Mon, 17 Apr 2023 11:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AF2C62953;
        Mon, 17 Apr 2023 18:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6BB21C433A0;
        Mon, 17 Apr 2023 18:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681756219;
        bh=6WScCE1OMPL2CMAH4/Kpxc0V1mVpC3PJlpTdGR+G3Ow=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LlzLbXHnx1iCXtGnmDNhZMc9eeTyPn6IW50l9Ez/hSqrLPdH1Cj1AL2F/ODMldFDQ
         guMzo/ZR+t/eRILFcq21lhZNTMttHl3vA7U3B7vk0BrzPa4Y9bRRh7nnrdAStomhUW
         V/D+yTzYd0ijl+89ghmq0Lvh0LWeEB/sZup1bx2emE9qHFQm87yPTQlGHWOS9KkKuM
         G6UjNHefG37ECx1VY9XGvBMon9X92FYcmzvUzQcxuub8eMN0wQuwE3DoQR46FbB5dd
         u6ahP26y9kEN8LSynCvh21sskpmbY2I7W0z9Ig+xSlSt/if7DE0L20I1g7gr16lGF/
         OXKZ4Gv4JLIkg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4B5A5C395DC;
        Mon, 17 Apr 2023 18:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1] Bluetooth: Optimize devcoredump API hci_devcd_init()
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <168175621930.2755.16999570767824235209.git-patchwork-notify@kernel.org>
Date:   Mon, 17 Apr 2023 18:30:19 +0000
References: <1681213778-31754-1-git-send-email-quic_zijuhu@quicinc.com>
In-Reply-To: <1681213778-31754-1-git-send-email-quic_zijuhu@quicinc.com>
To:     Zijun Hu <quic_zijuhu@quicinc.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        abhishekpandit@chromium.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Tue, 11 Apr 2023 19:49:38 +0800 you wrote:
> API hci_devcd_init() stores u32 type to memory without specific byte
> order, let us store with little endian in order to be loaded and
> parsed by devcoredump core rightly.
> 
> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
> ---
>  net/bluetooth/coredump.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)

Here is the summary with links:
  - [v1] Bluetooth: Optimize devcoredump API hci_devcd_init()
    https://git.kernel.org/bluetooth/bluetooth-next/c/61cad9af36db

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


