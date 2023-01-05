Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C7B65F7E1
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 00:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbjAEXuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 18:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjAEXuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 18:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5145F8D;
        Thu,  5 Jan 2023 15:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9CAF61C39;
        Thu,  5 Jan 2023 23:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3C83BC433F0;
        Thu,  5 Jan 2023 23:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672962616;
        bh=PrrLFxarYWh5CM+qoMzISrjfCB1Rub1rzIzz5HE0W+A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pY8s+tUlk7VLeh6+pkyslV9p97RwbJHPgUVE6E5GvlrFDYosIfO6Hlz8u8JQcXMZ5
         U1FxahmERg0s3QdYyakvEbghL1P+Q4jkLbPtzF9/w0oEC45hjEI9JmksUaH9Mzxyz1
         7Ku4U7uml8ZgI+YJVyCTu5g2xE40coyTxSXDeinvCgH6aXSlQR+1DtJPlxQ5e466p9
         B5U+gnTjX+OGhJxrY2HGerYFfQltBbIO38wVHTaJe7LwqfBBCgPoImo5hUUM8MAnTn
         lIDx6VMQgdsx1o9GuTsZiLasp8F+JcGyKvtaZmeWfzX4wYjMt/uTlTTsm9W8OROXL7
         fxKU/fLqf/ecA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 21D53E5724A;
        Thu,  5 Jan 2023 23:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Bluetooth: hci_conn: fix memory leak in
 hci_le_terminate_big() and hci_le_big_terminate()
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <167296261613.18068.1679301858190838721.git-patchwork-notify@kernel.org>
Date:   Thu, 05 Jan 2023 23:50:16 +0000
References: <20230104064623.1140644-1-shaozhengchao@huawei.com>
In-Reply-To: <20230104064623.1140644-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
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

On Wed, 4 Jan 2023 14:46:23 +0800 you wrote:
> When hci_cmd_sync_queue() failed in hci_le_terminate_big() or
> hci_le_big_terminate(), the memory pointed by variable d is not freed,
> which will cause memory leak. Add release process to error path.
> 
> Fixes: eca0ae4aea66 ("Bluetooth: Add initial implementation of BIS connections")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> 
> [...]

Here is the summary with links:
  - Bluetooth: hci_conn: fix memory leak in hci_le_terminate_big() and hci_le_big_terminate()
    https://git.kernel.org/bluetooth/bluetooth-next/c/5d043a6a43b6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


