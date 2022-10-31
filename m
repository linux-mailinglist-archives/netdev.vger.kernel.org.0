Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B32A6133F1
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 11:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiJaKuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 06:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiJaKuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 06:50:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315DF273D
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 03:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C469E6114F
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 10:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29CA0C433C1;
        Mon, 31 Oct 2022 10:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667213416;
        bh=21sK2syFuXjLLsGMfNBtwOtlnVGd/H/kKIY6ZZ5GSRQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sqEJeTB/Nv2jyiFRPJKjgkMvmBAnddRm5NTGXwvzXsujGDz3DQVIqQH2Z07+9qobM
         5ewwr7hTlLmgQFiwEi6J1O5y/j/loQ5VjmL3au1YP8uEynUgY0qjsNMauLQBmhROjO
         T7EtrLc1jMjQ6r1cFVNfSBIfV2Qmzv0YOzJODv0Y+RaZpYB83jJ7OghlWvIJZOC7Km
         knozGcX/+JFRAAE28tABTKQlDBo9s0zo8QUCOVjjHgolAY5u3sMBTWxJmxva+exCTo
         KIkni6+TBxcd+Ynito5IFMMWBwqyLXTIIYMyMJPHAip960syMWKDU2lFdVFv3I2QdF
         aTjMc2qCn146Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0FEBAC41621;
        Mon, 31 Oct 2022 10:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: microchip: sparx5: kunit test: change
 test_callbacks and test_vctrl to static
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166721341606.30467.1026322139471317146.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Oct 2022 10:50:16 +0000
References: <20221028081106.3595875-1-yangyingliang@huawei.com>
In-Reply-To: <20221028081106.3595875-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, Steen.Hegelund@microchip.com,
        davem@davemloft.net
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Oct 2022 16:11:06 +0800 you wrote:
> test_callbacks and test_vctrl are only used in vcap_api_kunit.c now,
> change them to static.
> 
> Fixes: 67d637516fa9 ("net: microchip: sparx5: Adding KUNIT test for the VCAP API")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] net: microchip: sparx5: kunit test: change test_callbacks and test_vctrl to static
    https://git.kernel.org/netdev/net-next/c/e8572f038a52

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


