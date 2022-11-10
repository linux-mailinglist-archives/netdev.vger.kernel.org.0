Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481AC623FA0
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 11:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiKJKUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 05:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiKJKUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 05:20:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7C864E2
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 02:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48BBEB82165
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 10:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BC639C433D7;
        Thu, 10 Nov 2022 10:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668075615;
        bh=3z6WsI7jauxwahxRdtZkIlrG1nyc9Iv/7r8JRo4FaB4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mY3A7asT89NyF1ucFKzAAzhww7Xd6lRrpiOy247+6lz2Q0D6aRtsIm6yZzW8dl/e0
         CbKoFA6RcQ6pqQObEELJc+EjnI6WTuFREv02KYzl0nS+CPO28WLoiGWv6BRNCjA4qT
         p7DEc50mQ+ia7x07DTIF+7UFVZGi9gPlCi2l+s80Vd9N3CVHqgmnk8cIHrUwueBR4C
         Cr+cMa9hZmZaoBp5YoKCfO1on+V0q6rF+X58yEiwegx9ZW6KzglT2AgXEAjRSxlItD
         i9NeuFDQQVZsV4/F/wHLZAue9XlRSv8aUnsyH0OETRnWMLcGhAUq2RXXOjh4h32hYC
         zaD8YirAG4Mdg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A06F0C395F8;
        Thu, 10 Nov 2022 10:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/3] stmmac: dwmac-loongson: fixes three leaks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166807561565.31825.9706152266121029188.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Nov 2022 10:20:15 +0000
References: <20221108114647.4144952-1-yangyingliang@huawei.com>
In-Reply-To: <20221108114647.4144952-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, jiaxun.yang@flygoat.com,
        zhangqing@loongson.cn, liupeibao@loongson.cn, andrew@lunn.ch,
        kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 8 Nov 2022 19:46:44 +0800 you wrote:
> patch #2 fixes missing pci_disable_device() in the error path in probe()
> patch #1 and pach #3 fix missing pci_disable_msi() and of_node_put() in
> error and remove() path.
> 
> v1 -> v2:
>   Make another two error paths 'goto err_disable_msi' in path #1.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/3] stmmac: dwmac-loongson: fix missing pci_disable_msi() while module exiting
    https://git.kernel.org/netdev/net/c/f2d45fdf9a0e
  - [net,v2,2/3] stmmac: dwmac-loongson: fix missing pci_disable_device() in loongson_dwmac_probe()
    https://git.kernel.org/netdev/net/c/fe5b3ce8b437
  - [net,v2,3/3] stmmac: dwmac-loongson: fix missing of_node_put() while module exiting
    https://git.kernel.org/netdev/net/c/7f94d0498f9c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


