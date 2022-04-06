Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D144F6655
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238502AbiDFRHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238506AbiDFRGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:06:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B308B2493FE;
        Wed,  6 Apr 2022 07:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ABF6619C2;
        Wed,  6 Apr 2022 14:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 91871C385A9;
        Wed,  6 Apr 2022 14:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649255412;
        bh=jzQGgDHxcsZyxDhbb/BjvyBbxR3qUFsjUhdFsWW7KSI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RF94RMtDsUFAmpuEN92cGKf51LtRXf6gwz+/FHEBnzgr8qOuAX/RfhcHxpuTogfF7
         OLb/tebhFjl0TuQ9F2x6v2UqjTybmGSu2+DTuN3w9JAgOtrHC1Zc/sdtVhOBQDYgBK
         nCkoxzpacus07BKGjBNr2w9LJwU/eFC66T/o9GEjjNcBsW2XU6SkXnfqgu5j5qmi0/
         4pzT5fmtajQjkbMUtB/nkNVi6kCpKxM6CxklmVI8m09H9R/mp5sLTa79YJASpzZgDq
         C4RGs2/jLioOyD86K7liRu3OqIIIRdSofjwaWEjvxorhCyx033hLCH4Szk/IEUGknw
         9Jhklnlr7FLug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6A3FEE8DBDD;
        Wed,  6 Apr 2022 14:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] myri10ge: fix an incorrect free for skb in myri10ge_sw_tso
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164925541243.21938.8143288324519460216.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 14:30:12 +0000
References: <20220406035556.730-1-xiam0nd.tong@gmail.com>
In-Reply-To: <20220406035556.730-1-xiam0nd.tong@gmail.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     christopher.lee@cspi.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  6 Apr 2022 11:55:56 +0800 you wrote:
> All remaining skbs should be released when myri10ge_xmit fails to
> transmit a packet. Fix it within another skb_list_walk_safe.
> 
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
> 
> changes since v2:
>  - free all remaining skbs. (Xiaomeng Tong)
> 
> [...]

Here is the summary with links:
  - [v3] myri10ge: fix an incorrect free for skb in myri10ge_sw_tso
    https://git.kernel.org/netdev/net/c/b423e54ba965

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


