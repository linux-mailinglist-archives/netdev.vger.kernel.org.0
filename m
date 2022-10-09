Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F435F8DCD
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 22:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiJIUAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 16:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiJIUAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 16:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7B11A208
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 13:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E4BD60C4F
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 20:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2804C433D7;
        Sun,  9 Oct 2022 20:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665345614;
        bh=fqMK/v5774VvPqVU0GX0ApEctdxDlz/A2OwMsmpDylc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KB7lsYlgltZpRuPlQtWkVOK0i5Jh6eeWK91ZbjvsR/XakAu5fDZmmBvFihlIoIUgw
         WzgH6yidO0gEHbdOtpFK4BGGyNQYq5T3EAMFJlIEkDARcmxws6dAQUelWUd3K0r5mP
         dZHQPhuXjd7Lu09pJ3/WaitYtUZSW4/9aGaLp4uSU9z+Vb+KpzYLfOXJ+oy05ooUJO
         ljNSEiM61EkzMYmQBouy6ykcJvcSDHa26T8lH4v9nI97I6tXZ7PFT8UjUhao30UH0r
         G6cG1oOkRvzPHsJ6zshssN7RweWTEpVPG3F0oqegCfSaws6up1Y8U4HBrGGBVPAAtj
         TyG5AqAFNMF+g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 97751C73FE7;
        Sun,  9 Oct 2022 20:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v3] f_flower: Introduce L2TPv3 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166534561461.2296.7807640996111601388.git-patchwork-notify@kernel.org>
Date:   Sun, 09 Oct 2022 20:00:14 +0000
References: <20221007075101.478055-1-wojciech.drewek@intel.com>
In-Reply-To: <20221007075101.478055-1-wojciech.drewek@intel.com>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, gnault@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Fri,  7 Oct 2022 09:51:01 +0200 you wrote:
> Add support for matching on L2TPv3 session ID.
> Session ID can be specified only when ip proto was
> set to IPPROTO_L2TP.
> 
> L2TPv3 might be transported over IP or over UDP,
> this implementation is only about L2TPv3 over IP.
> IPv6 is also supported, in this case next header
> is set to IPPROTO_L2TP.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v3] f_flower: Introduce L2TPv3 support
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=9313ba541f79

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


