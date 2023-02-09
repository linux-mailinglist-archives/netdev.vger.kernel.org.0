Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78B5690427
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 10:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbjBIJu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 04:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjBIJuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 04:50:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE54034C11;
        Thu,  9 Feb 2023 01:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65906B8203F;
        Thu,  9 Feb 2023 09:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D857BC4339C;
        Thu,  9 Feb 2023 09:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675936217;
        bh=v4atgNoTsNUmoDqzVIM4vVANn20Me74SAL8sabFYLGo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ONVwlOBNjwbhpBPfRrKXgXCr3SZSH841rj6Xw5iP2tZnk2Kpytzoe8cLdMIQVRVXx
         uoMk96vEW+NoXQE6HncFrSsul76HpEpClhffNoFqJsAk6rEpSoz6Mru5nw67Ee0Ts7
         oZDz3DMdX6NSwy7lC+FT1dTs+Qbz1sWsj4HOzrc185lu4o/2pnF8R9xXJhMY6TflXB
         SC7eELQ0BJGHAyciqNW8RPurlDB5PDSqnoiBwDlDvj4f+aR7pmdiZIC4PbjI/u9Pjz
         LvQ90Ds260Rxp5Wzpl3BxKtkquSO2xV5MT6hAc9q3etnL2wAWwibk7+YEoTPGPSRDS
         hF2JSy6+EntLA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF1B1E21ECB;
        Thu,  9 Feb 2023 09:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] rds: rds_rm_zerocopy_callback() use
 list_first_entry()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167593621777.24180.14940979671887283840.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Feb 2023 09:50:17 +0000
References: <20230202-rds-zerocopy-v3-1-83b0df974f9a@diag.uniroma1.it>
In-Reply-To: <20230202-rds-zerocopy-v3-1-83b0df974f9a@diag.uniroma1.it>
To:     Pietro Borrello <borrello@diag.uniroma1.it>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        willemb@google.com, c.giuffrida@vu.nl, h.j.bos@vu.nl,
        jkl820.git@gmail.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 07 Feb 2023 18:26:34 +0000 you wrote:
> rds_rm_zerocopy_callback() uses list_entry() on the head of a list
> causing a type confusion.
> Use list_first_entry() to actually access the first element of the
> rs_zcookie_queue list.
> 
> Fixes: 9426bbc6de99 ("rds: use list structure to track information for zerocopy completion notification")
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
> 
> [...]

Here is the summary with links:
  - [net,v3] rds: rds_rm_zerocopy_callback() use list_first_entry()
    https://git.kernel.org/netdev/net/c/f753a68980cf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


