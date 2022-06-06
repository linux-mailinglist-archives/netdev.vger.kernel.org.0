Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C5A53E01E
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 05:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352324AbiFFDd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 23:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233696AbiFFDdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 23:33:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5425237A38;
        Sun,  5 Jun 2022 20:33:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C755C60EDE;
        Mon,  6 Jun 2022 03:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18083C341C0;
        Mon,  6 Jun 2022 03:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654486430;
        bh=TI4P18/3vyoUu1YoM1I93ZEGQv/UWUtMjgpV3is+1kU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tFJZusU1hxG2s1CJAu/uiv0E+bAvVegQhojDIoAHyJhGf2CpfQHdYfd63OYaXP0/3
         tl9nzWxkaafABij8lqsZ5MrgoRiCJkmKhT6mUps3kQJJUcarzBWjvqhX+nnzU7KuuH
         M1sITb9nLev16/CnmDOBLDR9sft1NqYa56mDK6TYh+XhuSxzBGaz00U17pkjsv1ykO
         1xbqro3byn4WFq2ZXjDSp5Mx6gkf+iadKrRgaEInhfU6CUJOoXak/Exda99R6yHsRc
         ZpeQ/WkQ7MtuWXRB2kZKovQ5cRR+ulL6ulkGtXTJWKxLQIUAMOP2Du9HlLMaTPj68u
         6fltf6QTe+EWQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E9551E737F0;
        Mon,  6 Jun 2022 03:33:49 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dt-bindings: Fix properties without any type
From:   patchwork-bot+chrome-platform@kernel.org
Message-Id: <165448642995.20111.10251737230487275413.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Jun 2022 03:33:49 +0000
References: <20220519211411.2200720-1-robh@kernel.org>
In-Reply-To: <20220519211411.2200720-1-robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, krzk+dt@kernel.org,
        thierry.reding@gmail.com, sam@ravnborg.org,
        linus.walleij@linaro.org, brgl@bgdev.pl, dmitry.torokhov@gmail.com,
        bleung@chromium.org, groeck@chromium.org, mchehab@kernel.org,
        peda@axentia.se, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, kvalo@kernel.org, bhelgaas@google.com,
        sre@kernel.org, mpm@selenic.com, herbert@gondor.apana.org.au,
        gregkh@linuxfoundation.org, broonie@kernel.org, mripard@kernel.org,
        dri-devel@lists.freedesktop.org, linux-gpio@vger.kernel.org,
        linux-input@vger.kernel.org, chrome-platform@lists.linux.dev,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-usb@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to chrome-platform/linux.git (for-next)
by Rob Herring <robh@kernel.org>:

On Thu, 19 May 2022 16:14:11 -0500 you wrote:
> Now that the schema tools can extract type information for all
> properties (in order to decode dtb files), finding properties missing
> any type definition is fairly trivial though not yet automated.
> 
> Fix the various property schemas which are missing a type. Most of these
> tend to be device specific properties which don't have a vendor prefix.
> A vendor prefix is how we normally ensure a type is defined.
> 
> [...]

Here is the summary with links:
  - dt-bindings: Fix properties without any type
    https://git.kernel.org/chrome-platform/c/4e71ed985389

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


