Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319F06C0F85
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 11:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbjCTKoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 06:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbjCTKni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 06:43:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C521ADDB;
        Mon, 20 Mar 2023 03:41:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18CE7B80DFD;
        Mon, 20 Mar 2023 10:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9C75DC4339B;
        Mon, 20 Mar 2023 10:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679308817;
        bh=cCwKq5sqMQMhpt5Ys8fwMMhbp9EHQPbFdpaIF6E+n1s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d6YMS56cSPC/RACLpntXNEmjc/f/Rn6iB5zQlg/yIoOHCIWe4NjOH9sqhOh7iORxO
         gwLua8UhfNvbkmlrPoiyyMO3Y0bltJtp7ZTf/UFlG5PtX2OBuinww+W8ZajKdr+rsJ
         3rQik6Py1fnDY9HZvIdf9it5Y2NR41ZPkWTqkWBxDBGWQu0N6hD7fxmbhBNoyICXXr
         DMZPlDBXIMpDJ3IfNsyNvvRoxVFSwAWErZogShdCWFMGYbsDMYCWJy0hPbyJ8qWQ94
         edEEwMkVgaU2qncLjhAdtRjRHNpBa6wvbfqYKfRnImWk32SVStOh+E4PVziwLai32S
         2xwrn8Agl8AQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 790CFC395F4;
        Mon, 20 Mar 2023 10:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: remove file entry in NFC SUBSYSTEM after
 platform_data movement
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167930881749.26915.10914187200483257982.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Mar 2023 10:40:17 +0000
References: <20230320073201.32401-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20230320073201.32401-1-lukas.bulwahn@gmail.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     robh@kernel.org, simon.horman@corigine.com, davem@davemloft.net,
        netdev@vger.kernel.org, krzysztof.kozlowski@linaro.org,
        linux-nfc@lists.01.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 20 Mar 2023 08:32:01 +0100 you wrote:
> Commit 053fdaa841bd ("nfc: mrvl: Move platform_data struct into driver")
> moves the nfcmrvl.h header file from include/linux/platform_data to the
> driver's directory, but misses to adjust MAINTAINERS.
> 
> Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
> broken reference.
> 
> [...]

Here is the summary with links:
  - MAINTAINERS: remove file entry in NFC SUBSYSTEM after platform_data movement
    https://git.kernel.org/netdev/net-next/c/56aecc0a655d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


