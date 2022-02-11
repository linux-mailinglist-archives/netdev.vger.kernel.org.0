Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFBD84B2516
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 13:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349808AbiBKMAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 07:00:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238581AbiBKMAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 07:00:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7098F4E;
        Fri, 11 Feb 2022 04:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84A1261B89;
        Fri, 11 Feb 2022 12:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6B18C340F4;
        Fri, 11 Feb 2022 12:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644580814;
        bh=0VdonfbRz7kDzpgZxBbaGA9mjhW3l7cDHUJh9KdKhO4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a70mBf3lGD/zPthwhecOw7CbmL6jv4NiabJGYXbEuyZi5E42dJDmWCkj54+3eT1cJ
         jFxxmrxD+Ci6hmlN9GkQBZaitoe2N7cAZFN/fG6noEdn3cw2HKL1wUNug6kZuYAr70
         Xv11QRJAUl9GFxRsv/CIEzAncmvCknLfVWj937RZmw2pqyurgZxI+k1Mh16JYaObMA
         XlPU5CuhhfY6Vs4YaxDe6A34ivynat9ez3kV1Fl8DltT7nagbhyiNhgvXm1QdMz63e
         O3jR6xdX53WciH4iKX5hpFw4m1r1B7YyIvZXE84gHawSsn6YFjC7TqozFF8C6IPHUJ
         hHiDO3ZOF8Xyw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C724DE6D4A1;
        Fri, 11 Feb 2022 12:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] dt-bindings: net: dsa: realtek: convert to YAML schema,
 add MDIO
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164458081381.17283.252539054046225452.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Feb 2022 12:00:13 +0000
References: <20220209184116.18094-1-luizluca@gmail.com>
In-Reply-To: <20220209184116.18094-1-luizluca@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     devicetree@vger.kernel.org, arnd@arndb.de, olof@lixom.net,
        arinc.unal@arinc9.com, f.fainelli@gmail.com, sfr@canb.auug.org.au,
        linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  9 Feb 2022 15:41:16 -0300 you wrote:
> Schema changes:
> 
> - support for mdio-connected switches (mdio driver), recognized by
>   checking the presence of property "reg"
> - new compatible strings for rtl8367s and rtl8367rb
> - "interrupt-controller" was not added as a required property. It might
>   still work polling the ports when missing.
> 
> [...]

Here is the summary with links:
  - [v2] dt-bindings: net: dsa: realtek: convert to YAML schema, add MDIO
    https://git.kernel.org/netdev/net-next/c/429c83c78ab2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


