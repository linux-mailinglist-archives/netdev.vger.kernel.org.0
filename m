Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858AE524045
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 00:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348755AbiEKWaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 18:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348744AbiEKWaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 18:30:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7963227B69;
        Wed, 11 May 2022 15:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 904FDB82642;
        Wed, 11 May 2022 22:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3E2E3C34115;
        Wed, 11 May 2022 22:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652308212;
        bh=VnbSaPk+kszivRoNp4GPhDXYSabMhCwGLVXaPaxYc1M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Vefw7EPrpTHNZjXFQ4qqx5BGYCt+CKScY1ueO4FF/eDPwctqYPlzkvRtiZdlYRYq/
         PCmwTTLnf8+2+AuIwoyXRgJ1g6ifDIrZfn1lX2Ephx9ZnPesn+ezAijiDnCGKz0ZAl
         Rhwf6Wf0zg0FnLVSQar0S+1o+5btK+CTfsBsvQatHVxeiOX/6yVPnR1yn1YFo3fpFC
         fl2G+NzD6b3BvPhL8YJgrzw5P9CP79R7W35FnwrTdkGP6yQg1kA/UKr9jrPuqv/hTr
         dazdjvsRchgTZCV2RC0duJYZHfDopGciNGs2Ea3qku6KVz5k1NV+Lw+nDYuNZVYhLt
         qu9IMFjxXUg7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1678DF03936;
        Wed, 11 May 2022 22:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/1] i40e: i40e_main: fix a missing check on list
 iterator
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165230821208.9762.1319015503253179276.git-patchwork-notify@kernel.org>
Date:   Wed, 11 May 2022 22:30:12 +0000
References: <20220510204846.2166999-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220510204846.2166999-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, xiam0nd.tong@gmail.com,
        netdev@vger.kernel.org, sassmann@redhat.com,
        stable@vger.kernel.org, gurucharanx.g@intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 10 May 2022 13:48:46 -0700 you wrote:
> From: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> 
> The bug is here:
> 	ret = i40e_add_macvlan_filter(hw, ch->seid, vdev->dev_addr, &aq_err);
> 
> The list iterator 'ch' will point to a bogus position containing
> HEAD if the list is empty or no element is found. This case must
> be checked before any use of the iterator, otherwise it will
> lead to a invalid memory access.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/1] i40e: i40e_main: fix a missing check on list iterator
    https://git.kernel.org/netdev/net/c/3f95a7472d14

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


