Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 945D7628BD0
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 23:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237646AbiKNWKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 17:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237575AbiKNWKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 17:10:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AB12DD0;
        Mon, 14 Nov 2022 14:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D164B815B1;
        Mon, 14 Nov 2022 22:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1EC57C433D7;
        Mon, 14 Nov 2022 22:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668463816;
        bh=jUddgJaMBj9FCpBsH9Gi4hbvnilmdz5aOFVchQmIZVE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ViKiubqyvcAmSPUaT+SFepH9/x6uURG51///3zQLf90ZEllyE2IG5pKLhu5vJlFjL
         uLMo07QtOr8kLGfXtciBqP+bQKazl8K5jQ3PogaCKRf2U3Avzh9apDlXcuS7WFpEwT
         SK+OWxZsQcLSWZ/gnPbX1qmph1Dn0AojG2IORJA/k44M1Rk7rgTA9h//2HYzy1dbeK
         jwijrTGLadbCyTbr8mlXg5PbysJ0JAjBF1csiiSW7TTcBabKRjJblRnro7Q5Wz1arB
         RKAfkjrxZIDizhxoC038cjVNMYcWapezt3RSBHsbSuX5xeXZ/RS0B8rzHigJCTArV+
         tdCq8aM11t//Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 04E76E270EF;
        Mon, 14 Nov 2022 22:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Bluetooth: 6LoWPAN: add missing hci_dev_put() in
 get_l2cap_conn()
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <166846381601.12666.4347949300429852469.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Nov 2022 22:10:16 +0000
References: <20221109093726.3132203-1-bobo.shaobowang@huawei.com>
In-Reply-To: <20221109093726.3132203-1-bobo.shaobowang@huawei.com>
To:     Wang ShaoBo <bobo.shaobowang@huawei.com>
Cc:     marcel@holtmann.org, kuba@kernel.org, liwei391@huawei.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Wed, 9 Nov 2022 17:37:26 +0800 you wrote:
> hci_get_route() takes reference, we should use hci_dev_put() to release
> it when not need anymore.
> 
> Fixes: 6b8d4a6a0314 ("Bluetooth: 6LoWPAN: Use connected oriented channel instead of fixed one")
> Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
> ---
>  net/bluetooth/6lowpan.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - Bluetooth: 6LoWPAN: add missing hci_dev_put() in get_l2cap_conn()
    https://git.kernel.org/bluetooth/bluetooth-next/c/190ea3c3a8d5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


