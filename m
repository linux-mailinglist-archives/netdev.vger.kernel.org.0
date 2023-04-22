Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE1566EB709
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 05:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjDVDUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 23:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjDVDUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 23:20:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EFD1BDC
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 20:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEF736534A
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 03:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3E166C433A1;
        Sat, 22 Apr 2023 03:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682133619;
        bh=9XBl6LmYutxsnrrMtjnajCE1W4fXQIhBdALWS4rwYIc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EreKvA8Oc2GSMxgiKIQ2LfYT8/9lmm+limxBd9USOqtFJ7oMRZmRojspuwVy0u3mf
         EL5hWt7p1jEPCaDsVIfK2Kv3ZXqQxbCr2A1prF0iwRtpeBQRAwk3zuwp1RkNQ7oGm1
         bYjCSXfSbbeuobaanaQp3xPcl0Vh3LVgmREkybiroRvfZupfcAYY2NekFXGrjum8iv
         nXME+gCYcunFtm4s/NYiTAGomsF2dL3+3rduMZdkaEzTICK3z2GEK0aDCJDT1IRwm1
         5t75A4POXgAZvVvMa5iIUy44dAJOBNgiLCvLM15EknGb0LnizaLjyY7qaAbj6nvtqM
         tXxOYd81qCxYg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 264F7C395EA;
        Sat, 22 Apr 2023 03:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] ip: bridge_slave: Fix help message indentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168213361915.18367.12224104420601122105.git-patchwork-notify@kernel.org>
Date:   Sat, 22 Apr 2023 03:20:19 +0000
References: <20230419154359.2656173-1-idosch@nvidia.com>
In-Reply-To: <20230419154359.2656173-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com, netdev@kapio-technology.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Wed, 19 Apr 2023 18:43:59 +0300 you wrote:
> Use tabs instead of spaces to be consistent with the rest of the
> options.
> 
> Before:
> 
> $ ip link help bridge_slave
> Usage: ... bridge_slave [ fdb_flush ]
> [...]
>                         [ vlan_tunnel {on | off} ]
>                         [ isolated {on | off} ]
>                         [ locked {on | off} ]
>                        [ mab {on | off} ]
>                         [ backup_port DEVICE ] [ nobackup_port ]
> 
> [...]

Here is the summary with links:
  - [iproute2] ip: bridge_slave: Fix help message indentation
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=ed328120f47a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


