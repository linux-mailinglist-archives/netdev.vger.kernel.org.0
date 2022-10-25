Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B98CF60D7EA
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 01:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbiJYXaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 19:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbiJYXaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 19:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C311CFF5
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 16:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E3B061C14
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 23:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C476DC433D6;
        Tue, 25 Oct 2022 23:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666740618;
        bh=lF1iXT293MQ6S7h274fnJMYGRTfbOMGFNbcN6Qqsqyo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rNC6AcWB6qaFYITJFpzMVVdh0TX7CIzNpWE/xGk1d0fH/ryGEkYfx8FmKyGV3Mllf
         F3ECB4G6AtqhTm+ky/yEXylHXJ3A+HrE6KNO8HEz6UukhS/u7IaTjs62PG3O5iyLKq
         r+WKgKRpdegGtRGsZ4Lj6G6OblJZNR7b6nKgvf4rsO+w3vVYgm97y02fFJD+gOt+Aw
         qXwthDxEbSgG20f5Ntokw8n55yZmM5hnnzUJOi7DEG/MGbvZ3XhjhHRN02Adwc5MK2
         5gHWVISSugUh45UKp3uT91wON/wLaFbY+GDC0Vtz9HSa45ZZRNYqQRID7nzXu+LOo4
         n1jXxyftEIJ8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AE50BE45192;
        Tue, 25 Oct 2022 23:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/3] i40e: Fix ethtool rx-flow-hash setting for X722
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166674061871.7170.13155965061868350102.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Oct 2022 23:30:18 +0000
References: <20221024100526.1874914-1-jacob.e.keller@intel.com>
In-Reply-To: <20221024100526.1874914-1-jacob.e.keller@intel.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        slawomirx.laba@intel.com, michalx.jaron@intel.com,
        mateusz.palczewski@intel.com, gurucharanx.g@intel.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 24 Oct 2022 03:05:24 -0700 you wrote:
> From: Slawomir Laba <slawomirx.laba@intel.com>
> 
> When enabling flow type for RSS hash via ethtool:
> 
> ethtool -N $pf rx-flow-hash tcp4|tcp6|udp4|udp6 s|d
> 
> the driver would fail to setup this setting on X722
> device since it was using the mask on the register
> dedicated for X710 devices.
> 
> [...]

Here is the summary with links:
  - [v2,1/3] i40e: Fix ethtool rx-flow-hash setting for X722
    https://git.kernel.org/netdev/net/c/54b5af5a4380
  - [v2,2/3] i40e: Fix VF hang when reset is triggered on another VF
    https://git.kernel.org/netdev/net/c/52424f974bc5
  - [v2,3/3] i40e: Fix flow-type by setting GL_HASH_INSET registers
    https://git.kernel.org/netdev/net/c/3b32c9932853

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


