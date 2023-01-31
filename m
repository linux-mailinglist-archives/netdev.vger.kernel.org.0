Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214C868284B
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 10:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbjAaJLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 04:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbjAaJKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 04:10:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E6246B5;
        Tue, 31 Jan 2023 01:07:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EECC61473;
        Tue, 31 Jan 2023 09:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DE8C433D2;
        Tue, 31 Jan 2023 09:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675155989;
        bh=VgOCJ07Dd8zN5MILdSU+srahv9mFd77g63NUieWwfDs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mTKfA1KP9bsrQLG8UbUq5P6dq3Md6E9yb9U8YuS0AAKe6MhU0xOg+iRb1mCp0VMPW
         H50BIRvoDfpw5ehYcmeOrBIiLcafMn5n78Un0I7T+e61GR8O7FZIvknM6nPwLxQ7uN
         VoJNXhy9YwUqksQ9ts0mmnMiFcQ9p+VWiSpj+pM7449KW2zskHqO8q9QIP1E0/o0yF
         HfX8RcIYZEXcR59TnDH5YQv3/gxNwO3j8M67SgL/mq73B+vw6lxk7IIpNEu2B+vlQk
         iGK3CeVIsHFvhPwmx2kNt1WYuTv/lL7wrefaGC/nno4/unugFCbeYk67h6YQhT21of
         gAC9ke17VfvGQ==
Date:   Tue, 31 Jan 2023 09:06:22 +0000
From:   Lee Jones <lee@kernel.org>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        richardcochran@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Subject: Re: [PATCH v5 net-next 00/13] add support for the the vsc7512
 internal copper phys
Message-ID: <Y9jaDvtvzPxIrgFi@google.com>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
 <167514242005.16180.6859220313239539967.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <167514242005.16180.6859220313239539967.git-patchwork-notify@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Jan 2023, patchwork-bot+netdevbpf@kernel.org wrote:

> Hello:
> 
> This series was applied to netdev/net-next.git (master)
> by Jakub Kicinski <kuba@kernel.org>:

Please don't do that.  The commits do not have proper Acked-by tags.

The plan is to merge these via MFD and send out a pull-request to an
immutable branch.  However, if you're prepared to convert all of the:

  Acked-for-MFD-by: Lee Jones <lee@kernel.org>

to

  Acked-by: Lee Jones <lee@kernel.org>

... and send out a pull request to a succinct (only these patches) and
immutable branch then that is also an acceptable solution.

Please let me know what works best for you.

Thanks.

> > This patch series is a continuation to add support for the VSC7512:
> > https://patchwork.kernel.org/project/netdevbpf/list/?series=674168&state=*
> > 
> > That series added the framework and initial functionality for the
> > VSC7512 chip. Several of these patches grew during the initial
> > development of the framework, which is why v1 will include changelogs.
> > It was during v9 of that original MFD patch set that these were dropped.
> > 
> > [...]
> 
> Here is the summary with links:
>   - [v5,net-next,01/13] net: mscc: ocelot: expose ocelot wm functions
>     https://git.kernel.org/netdev/net-next/c/c6a9321b0811
>   - [v5,net-next,02/13] net: mscc: ocelot: expose regfield definition to be used by other drivers
>     https://git.kernel.org/netdev/net-next/c/728d8019f1a3
>   - [v5,net-next,03/13] net: mscc: ocelot: expose vcap_props structure
>     https://git.kernel.org/netdev/net-next/c/beb9a74e0bf7
>   - [v5,net-next,04/13] net: mscc: ocelot: expose ocelot_reset routine
>     https://git.kernel.org/netdev/net-next/c/b67f5502136f
>   - [v5,net-next,05/13] net: mscc: ocelot: expose vsc7514_regmap definition
>     https://git.kernel.org/netdev/net-next/c/2efaca411c96
>   - [v5,net-next,06/13] net: dsa: felix: add configurable device quirks
>     https://git.kernel.org/netdev/net-next/c/1dc6a2a02320
>   - [v5,net-next,07/13] net: dsa: felix: add support for MFD configurations
>     https://git.kernel.org/netdev/net-next/c/dc454fa4b764
>   - [v5,net-next,08/13] net: dsa: felix: add functionality when not all ports are supported
>     https://git.kernel.org/netdev/net-next/c/de879a016a94
>   - [v5,net-next,09/13] mfd: ocelot: prepend resource size macros to be 32-bit
>     https://git.kernel.org/netdev/net-next/c/fde0b6ced8ed
>   - [v5,net-next,10/13] dt-bindings: net: mscc,vsc7514-switch: add dsa binding for the vsc7512
>     https://git.kernel.org/netdev/net-next/c/dd43f5e7684c
>   - [v5,net-next,11/13] dt-bindings: mfd: ocelot: add ethernet-switch hardware support
>     https://git.kernel.org/netdev/net-next/c/11fc80cbb225
>   - [v5,net-next,12/13] net: dsa: ocelot: add external ocelot switch control
>     https://git.kernel.org/netdev/net-next/c/3d7316ac81ac
>   - [v5,net-next,13/13] mfd: ocelot: add external ocelot switch control
>     https://git.kernel.org/netdev/net-next/c/8dccdd277e0b
> 
> You are awesome, thank you!
> -- 
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
> 
> 

-- 
Lee Jones [李琼斯]
