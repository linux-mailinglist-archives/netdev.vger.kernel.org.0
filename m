Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660B4653A7E
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 03:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234866AbiLVCKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 21:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiLVCKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 21:10:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2EB23BC5;
        Wed, 21 Dec 2022 18:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 403C9B81CF8;
        Thu, 22 Dec 2022 02:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1126C433EF;
        Thu, 22 Dec 2022 02:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671675016;
        bh=zLPTjpHnlmdiiF4PoDKn+FJXCzmyZxTnoHs6+gtn7u0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B2TZeZGe9NlFPiEQ2obQDBbk/ncU1ZEgje4gnNRkgS/QAyTiEwURhJsllzrt3omL7
         Eoomxt7GG+ppZBfpe6qiJGmbm2qejbqfI984z6VSsTa3VaLFf9qtbOL7YoySZK/HSD
         A0O5zwN/Tpqt/EdsXeX+3fwxoil9BVA+xF3cytn1A5AhPdFN83k4Jv8DkiJmE5FtXX
         UCyJ6Hwch7lGGwmtKBmHgR8aAql2wr9buLFH4cfV9z+svSpzvafcezN8l+Qt7R+GdR
         xXpP9ChALT5lZWEwP52ExeQzm2LcmOc/pJl8ymOiQ6YO+QVRlv0BtEf3nv0+pKbAb2
         XIEgaeN+dFfIQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B81A3C41622;
        Thu, 22 Dec 2022 02:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net ] vmxnet3: correctly report csum_level for encapsulated
 packet
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167167501675.18442.7142485680991762483.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Dec 2022 02:10:16 +0000
References: <20221220202556.24421-1-doshir@vmware.com>
In-Reply-To: <20221220202556.24421-1-doshir@vmware.com>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org,
        pv-drivers@vmware.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org
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

On Tue, 20 Dec 2022 12:25:55 -0800 you wrote:
> Commit dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload
> support") added support for encapsulation offload. However, the
> pathc did not report correctly the csum_level for encapsulated packet.
> 
> This patch fixes this issue by reporting correct csum level for the
> encapsulated packet.
> 
> [...]

Here is the summary with links:
  - [net] vmxnet3: correctly report csum_level for encapsulated packet
    https://git.kernel.org/netdev/net/c/3d8f2c4269d0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


