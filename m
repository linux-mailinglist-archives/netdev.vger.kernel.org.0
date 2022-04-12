Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11CD04FE1F8
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355252AbiDLNOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356720AbiDLNOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:14:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910AE335;
        Tue, 12 Apr 2022 06:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E5AAB81D3D;
        Tue, 12 Apr 2022 13:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B42BC385A5;
        Tue, 12 Apr 2022 13:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649768412;
        bh=ESUcJvVr53FsTPegL5NpJ6kZpa24F+Vcjhrz7L2oT9s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BJ/PeCKo/1Tjfj72OE/2d6N7t+LWTIEGeOtXtyknaRqGUvI1ibEVAqeeHsAsuYZWM
         qMF4PrE0T0bZGz+IazE1K++sxPYeOsUkdH+TzUAdoo0VrwGS3qRA9nN3lnFDDx4fwg
         LOdwNrRbYPMLLcAE9KIap6gqXGBp1zBGVdZ7WnUrFAZfTUEcBnaVHdGCbQKaRFwL+e
         H8iSouma79kl5hgcQYTOWme6VmnzthnMDGaWg1W65EI8hufk/DuLsXQULiiLUuKrt5
         +cHcLF8NkYm5Nr7QlqQNttXQ44POP8oU3WwncOEDJvkfM/VCB/XEykc4plZI6rJDyp
         K7JS9xlyVM/9w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E0A34E85D15;
        Tue, 12 Apr 2022 13:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] net: usb: qmi_wwan: add Telit 0x1057 composition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164976841191.21016.15540278724038825554.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Apr 2022 13:00:11 +0000
References: <20220411135943.4067264-1-dnlplm@gmail.com>
In-Reply-To: <20220411135943.4067264-1-dnlplm@gmail.com>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     bjorn@mork.no, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 11 Apr 2022 15:59:43 +0200 you wrote:
> Add the following Telit FN980 composition:
> 
> 0x1057: tty, adb, rmnet, tty, tty, tty, tty, tty
> 
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
> ---
> Hello Bjørn and all,
> 
> [...]

Here is the summary with links:
  - [net,1/1] net: usb: qmi_wwan: add Telit 0x1057 composition
    https://git.kernel.org/netdev/net-next/c/f01598090048

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


