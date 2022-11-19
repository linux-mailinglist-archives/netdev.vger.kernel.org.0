Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D53630B93
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 04:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbiKSDyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 22:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbiKSDx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 22:53:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0718BC721C
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 19:50:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86D1162850
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 03:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7754EC4314D;
        Sat, 19 Nov 2022 03:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668829818;
        bh=ampjT3294iTES5XXuF4tqf4SKl45Msy4AotnlQbYEo8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R+vEagUiLMSFwO5GPwsjdd93IHZQi+1YLBAuIunoGKlhdPO2aIxP49DF6OMQkzdfE
         jgt4JefHaF5n6GiraFvC4h9kLyT8w5WPc/4aIS2mNIwN+AVL5cpTQ+9Q0uu6nkCx3m
         S4Yy4aTSlLiP6+wzILxzE87yJSHEjaewlHtFhqVJXRbABxHvXOK2l7BT3sHvDlEMnY
         iWRxO8zPLBQVfhwnj8uJ3bOW8mHtlL8WueqrN21ctHUpiVgkrhOC6vR+mFEyTlgKgp
         NPQRxSzNQvG4cGJiRMz95dFaXnY/UYdOHzlORv4OkoKTwoizqQX8MP+fhNXAuKXePx
         wHcbwkYn0o6Vg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 57C4FC395F6;
        Sat, 19 Nov 2022 03:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] octeontx2-af: debugsfs: fix pci device refcount leak
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166882981833.27279.3095568126234174981.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Nov 2022 03:50:18 +0000
References: <20221117124658.162409-1-yangyingliang@huawei.com>
In-Reply-To: <20221117124658.162409-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, sgoutham@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, rsaladi2@marvell.com, kuba@kernel.org,
        davem@davemloft.net
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 17 Nov 2022 20:46:58 +0800 you wrote:
> As comment of pci_get_domain_bus_and_slot() says, it returns
> a pci device with refcount increment, when finish using it,
> the caller must decrement the reference count by calling
> pci_dev_put().
> 
> So before returning from rvu_dbg_rvu_pf_cgx_map_display() or
> cgx_print_dmac_flt(), pci_dev_put() is called to avoid refcount
> leak.
> 
> [...]

Here is the summary with links:
  - [net] octeontx2-af: debugsfs: fix pci device refcount leak
    https://git.kernel.org/netdev/net/c/d66608803aa2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


