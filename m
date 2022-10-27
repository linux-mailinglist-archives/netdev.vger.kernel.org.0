Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16C660F5D1
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 13:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234918AbiJ0LAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 07:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234869AbiJ0LAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 07:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CE17FFAA
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 04:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB41C62298
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 11:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D1C8C433D7;
        Thu, 27 Oct 2022 11:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666868416;
        bh=j5BPSKwn/rRvFge01++kdP2wGWn0AkGo1aaik9icRng=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JxQP9S3/ujHrkviNIvcRM2k53pR0iZvSeyt4ZPUJm/2DYk0CaEhXlPFHfxGKaecmu
         nxNM+5BxLKkIBhvlTGjfAel672q84aL0sgn8MwsEby4hAxomu2OEyAEwSweDg6nhmR
         v7cMaqDAGKxTVMfwhUQZv7U2JGFr9PSvx4yn6zjf2CZkHcRGkCafQFoJ+e3ziVOGWa
         ACLVCwRES32/dQVz5PdKNwyaLwPG2pZycdfmF1zyC3sRxaX8XPQU7GiykOBdrFqddH
         oqnESG6Bj+rR/rE9flE7gKLgoYDWC40LY5aWMeUSaiZ6bKl5fkwqCNCGcyRxDZ4Fb8
         Zfagl9vzQzmNg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 18C6CC4166D;
        Thu, 27 Oct 2022 11:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: ehea: fix possible memory leak in
 ehea_register_port()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166686841609.31058.17388443239053730574.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 11:00:16 +0000
References: <20221025130011.1071357-1-yangyingliang@huawei.com>
In-Reply-To: <20221025130011.1071357-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, dougmill@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 25 Oct 2022 21:00:11 +0800 you wrote:
> If of_device_register() returns error, the of node and the
> name allocated in dev_set_name() is leaked, call put_device()
> to give up the reference that was set in device_initialize(),
> so that of node is put in logical_port_release() and the name
> is freed in kobject_cleanup().
> 
> Fixes: 1acf2318dd13 ("ehea: dynamic add / remove port")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] net: ehea: fix possible memory leak in ehea_register_port()
    https://git.kernel.org/netdev/net/c/0e7ce23a917a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


