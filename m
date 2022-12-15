Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC4F64E2FD
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 22:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiLOVUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 16:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiLOVUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 16:20:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14D65C763;
        Thu, 15 Dec 2022 13:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F25261DF3;
        Thu, 15 Dec 2022 21:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AE96CC433F1;
        Thu, 15 Dec 2022 21:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671139217;
        bh=hTA0Xhc2b0v2QvH2F1ogKmba78dHaUC/h9xat3cSAAQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UE+aYwats5BEQkJzTkRCOZA5NPpjWXUrzwo8/YDPeqKZxb60XIOmfNo26IqXb52Oq
         va/CdrbELK+HZG7e7pOJcp/7LV4ynNPjdDdcG4giJJvkq1Wj/8p3/bj+NyubqisgAZ
         amhuToqqGHg9l74MkmXDGiX4H1XzPTAVzh6boJLd3LIFZCj5FbaFV/EI0LHYSMalyV
         rWEpB23R2ltE5HvzwYYCRlF50Aan/QyXYoUYKdgw5ZB3EBdWVvb9NT2f+Ku2v3lD2T
         aYrRpLj61SBKHW7O5s53FbnV93LszAHTvzX035JW9sXDtjX4hmS/6JvJ3I1aq83Thf
         RebU6UrOMiqDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8F7A3E4D028;
        Thu, 15 Dec 2022 21:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Bluetooth: Fix a buffer overflow in mgmt_mesh_add()
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <167113921758.15811.17067027797406608637.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Dec 2022 21:20:17 +0000
References: <20221212130828.988528-1-harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20221212130828.988528-1-harshit.m.mogalapalli@oracle.com>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     harshit.m.mogalapalli@gmail.com, error27@gmail.com,
        darren.kenny@oracle.com, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        brian.gix@intel.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Mon, 12 Dec 2022 05:08:28 -0800 you wrote:
> Smatch Warning:
> net/bluetooth/mgmt_util.c:375 mgmt_mesh_add() error: __memcpy()
> 'mesh_tx->param' too small (48 vs 50)
> 
> Analysis:
> 
> 'mesh_tx->param' is array of size 48. This is the destination.
> u8 param[sizeof(struct mgmt_cp_mesh_send) + 29]; // 19 + 29 = 48.
> 
> [...]

Here is the summary with links:
  - Bluetooth: Fix a buffer overflow in mgmt_mesh_add()
    https://git.kernel.org/bluetooth/bluetooth-next/c/becee9f3220c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


