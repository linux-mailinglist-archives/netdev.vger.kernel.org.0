Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E406C9C75
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 09:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbjC0HlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 03:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbjC0Hkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 03:40:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84760C7;
        Mon, 27 Mar 2023 00:40:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41C6CB80E68;
        Mon, 27 Mar 2023 07:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E04A8C433D2;
        Mon, 27 Mar 2023 07:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679902839;
        bh=9LjIPBq9toXuTJxAnKHZwT1LmvINtBkrGpiSjOfYvbo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t4BmoWbIJ2XoMzISMOo0Z+PL69voM/J93N4BppCcOfeS8tcA/9GazIcfPogC2X0oa
         U/+njEvB2yQe655AVMVOc/v5laIAsWcOcr9ALX1NO/PK2A2VOoWDhxi8wnYRYNOFgR
         dpzGMXp82v6ZKmbldw1MrEwrwrt9X0I2CxAOXUidJrUw9rL3NmNkIXtxiRMs2OQ7os
         6EP1ie9NYqMX7mvBKhEskZfnxDdPDmNbdbwA0tolx3IAT3OvucHuYNCn6mPX+9cB7I
         nNdD9+dbpdx1FExSa5nq7LQ2qd3g1LQaVCj5AU1UNWtu7zrNzZ2Ys0xSn+H2yEHLc/
         lTg/vNzLO0Byw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C1FC3E2A038;
        Mon, 27 Mar 2023 07:40:39 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/2] net: dsa: b53: mdio: add support for BCM53134
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167990283979.16393.5675896346341604175.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Mar 2023 07:40:39 +0000
References: <20230324084138.664285-1-noltari@gmail.com>
In-Reply-To: <20230324084138.664285-1-noltari@gmail.com>
To:     =?utf-8?q?=C3=81lvaro_Fern=C3=A1ndez_Rojas_=3Cnoltari=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     paul.geurts@prodrive-technologies.com, f.fainelli@gmail.com,
        jonas.gorski@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 24 Mar 2023 09:41:36 +0100 you wrote:
> This is based on the initial work from Paul Geurts that was sent to the
> incorrect linux development lists and recipients.
> I've simplified his patches by adding BCM53134 to the is531x5() block since it
> seems that the switch doesn't need a special RGMII config.
> 
> Paul Geurts (1):
>   net: dsa: b53: mdio: add support for BCM53134
> 
> [...]

Here is the summary with links:
  - [v2,1/2] dt-bindings: net: dsa: b53: add BCM53134 support
    https://git.kernel.org/netdev/net-next/c/a20869b3a785
  - [v2,2/2] net: dsa: b53: mdio: add support for BCM53134
    https://git.kernel.org/netdev/net-next/c/f927e8ef1e93

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


