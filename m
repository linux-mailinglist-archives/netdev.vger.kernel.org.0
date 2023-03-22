Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 118C36C59F6
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 00:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjCVXAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 19:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCVXAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 19:00:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04CF6588;
        Wed, 22 Mar 2023 16:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7906B622FF;
        Wed, 22 Mar 2023 23:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BE444C4339B;
        Wed, 22 Mar 2023 23:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679526018;
        bh=EB2DTbZFfHdmyXLnaK3jdMbvbLGX7OrJ7RFf0PO0gMo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iTg6OT41QInqtve2alpugcL962zy0p79bxUAarxE5jUjgUCaIQeFtOSouLNBb8ttT
         jV2euYk6VIdHoPiRbQT91Kjfa0iDKf/FkRk1QU7KZBjpmA+1raix6JhKwot+OwBfj1
         BeuPTjSPMGQxdnGCVc7Jr2L+hJEIo1Yfv5YLMuJQlSdsmsKpItrR4vhiG3L2q4Sr5i
         9gkKmmjQnIHvmx1+CKYXYBxaB4wV624JjF1Vl0WSaJYchnmzOyOkBoWhN5C6zLm1kX
         9xQMvR4V+y/EQkUE+uXv8v2QH7cbXOnnpSeD/9D+bSgzSayvL9J9Ykflkoy7tFkA8h
         ZLeBQCb62Z/vA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 92D38E4F0DA;
        Wed, 22 Mar 2023 23:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Bluetooth: HCI: Fix global-out-of-bounds
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <167952601859.12488.10811735256631144106.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Mar 2023 23:00:18 +0000
References: <20230321015018.1759683-1-iam@sung-woo.kim>
In-Reply-To: <20230321015018.1759683-1-iam@sung-woo.kim>
To:     Sungwoo Kim <iam@sung-woo.kim>
Cc:     wuruoyu@me.com, benquike@gmail.com, daveti@purdue.edu,
        marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Mon, 20 Mar 2023 21:50:18 -0400 you wrote:
> To loop a variable-length array, hci_init_stage_sync(stage) considers
> that stage[i] is valid as long as stage[i-1].func is valid.
> Thus, the last element of stage[].func should be intentionally invalid
> as hci_init0[], le_init2[], and others did.
> However, amp_init1[] and amp_init2[] have no invalid element, letting
> hci_init_stage_sync() keep accessing amp_init1[] over its valid range.
> This patch fixes this by adding {} in the last of amp_init1[] and
> amp_init2[].
> 
> [...]

Here is the summary with links:
  - Bluetooth: HCI: Fix global-out-of-bounds
    https://git.kernel.org/bluetooth/bluetooth-next/c/95084403f8c0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


