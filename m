Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF9B6B86D1
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbjCNAUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCNAUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:20:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796837C3E1;
        Mon, 13 Mar 2023 17:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E54261456;
        Tue, 14 Mar 2023 00:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 68D4FC433A8;
        Tue, 14 Mar 2023 00:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678753217;
        bh=LzloCXzaVU3kKyF5fPhes9BT7D+M8eO0qA4xo+cdyWE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C95zOmp/norwjZ2ajW5u91Z48T1J8khDD4r21amsWZeIs/lQ+twjBv3ix/+JiFaEm
         mw0j9HTxSSWINIxsA4C6oqLhBQyN1PYKT7c2dl5bHeVGYurCxyfD2IbOO1MX0ZZ1Nd
         GNsoLSUrkh5LItI8GEnQdFzo5qRyTWcPgQQbZrQh6GhPhX9WAVgJ4ODYY2cLdurvx0
         Y304tOoqownUvFcX3PE+VdpxZ3YXpoVfYtSoHneuZBQGRrzOW+/vqf5dCikbsWFc9O
         laegWTRnS4N9VyaLLWMU1GfLPqBM9T+XAT+XFBunOz93a38K3EmaURpQPpae24yG6t
         V04jdg8j+ohoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5197FE66CB9;
        Tue, 14 Mar 2023 00:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: Use of_property_present() for testing DT property
 presence
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167875321733.19453.10207654349490121469.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Mar 2023 00:20:17 +0000
References: <20230310144716.1544083-1-robh@kernel.org>
In-Reply-To: <20230310144716.1544083-1-robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 10 Mar 2023 08:47:16 -0600 you wrote:
> It is preferred to use typed property access functions (i.e.
> of_property_read_<type> functions) rather than low-level
> of_get_property/of_find_property functions for reading properties. As
> part of this, convert of_get_property/of_find_property calls to the
> recently added of_property_present() helper when we just want to test
> for presence of a property and nothing more.
> 
> [...]

Here is the summary with links:
  - net: Use of_property_present() for testing DT property presence
    https://git.kernel.org/netdev/net-next/c/bcc858689db5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


