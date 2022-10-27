Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448F460EE74
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 05:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbiJ0DUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 23:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbiJ0DUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 23:20:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E42330F73
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 20:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 036F162119
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 03:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4CBE5C433C1;
        Thu, 27 Oct 2022 03:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666840816;
        bh=nlqTtFxFoaCA6N5ce2A9IKefPhmPcnbEUzyb9ri7Djk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mhg0OFgRaemP1i66Iq3yIok2MlziXKLRLfmBfzSp2OntWdJEdlZpnDqj5WEDpkdOR
         K/eaEgVVzdAnQB/hxvBvMrW+kS7nGif3dJZ0yu8GYYOrC73LIOa5fZB932Ucjy2rvF
         yQe+hAegB3WxE96PMYvRtUTLX6SMisJUJSL68JBAIjgNMq+ILRD6rBM7B546PfxNlQ
         y/WN978g3SqPBB/od2OLIrss5Hx1FJpBlnrPg2V9b84DN0O82r1IkrokA3R2k/YG0o
         422EG494SZh4b9J2aV12SQGFnVCENDdvwWVrtM5pERfEdEr9CWpNcP3Jr1DkofMjpd
         RGBZgJqg+ot3w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 306ADE4D003;
        Thu, 27 Oct 2022 03:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] phylink: require valid state argument to
 phylink_validate_mask_caps()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166684081618.26512.17388597585796658555.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 03:20:16 +0000
References: <20221025185126.1720553-1-kuba@kernel.org>
In-Reply-To: <20221025185126.1720553-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, linux@armlinux.org.uk, andrew@lunn.ch,
        hkallweit1@gmail.com, sean.anderson@seco.com,
        rmk+kernel@armlinux.org.uk
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 25 Oct 2022 11:51:26 -0700 you wrote:
> state is deferenced earlier in the function, the NULL check
> is pointless. Since we don't have any crash reports presumably
> it's safe to assume state is not NULL.
> 
> Fixes: f392a1846489 ("net: phylink: provide phylink_validate_mask_caps() helper")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] phylink: require valid state argument to phylink_validate_mask_caps()
    https://git.kernel.org/netdev/net-next/c/e0b3ef17f45e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


