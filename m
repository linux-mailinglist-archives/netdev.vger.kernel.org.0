Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3519A69D7BF
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 01:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbjBUAu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 19:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbjBUAuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 19:50:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFC91DBAE;
        Mon, 20 Feb 2023 16:50:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D53CB80E63;
        Tue, 21 Feb 2023 00:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4773EC433D2;
        Tue, 21 Feb 2023 00:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676940620;
        bh=MwoSQxfPLnH9YB7onuxgug0HlcRKRVch8d4wEjJNgFs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fF2am7vmvM6YmdvttOWxIG7+T2h16r5R537FKRAj2iYqfg0BHtlHxlGWt8wWTkpCp
         ciGjRC9HXo0z2dOvpEQoccpa3JrUbMfVOIspwYTgunCkSD147IgoVVQIpRVQccQ09C
         YrOmLSvsDnyQyDPFDdLfd3Nrlwtlrfw5PJ7M0ihR9udnnV//0bJCfqLfYyl5/Oc+uE
         8xyoRdn84uNvNfQOs2+bIersrcuzJe1zP6PpRL/97GEM/QNjgvlYVCwYRES9QMv8br
         WB93jCWGNaxLhqghpW65/nejP11TNMjUJiidIWmxZ5scLyyVrFRJfEI3kdh8AHNgsR
         Edcv2+iJbXwMA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 267F6E68D20;
        Tue, 21 Feb 2023 00:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request v2: ieee802154-next 2023-02-20
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167694062014.10450.18172421216738783953.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Feb 2023 00:50:20 +0000
References: <20230220213749.386451-1-stefan@datenfreihafen.org>
In-Reply-To: <20230220213749.386451-1-stefan@datenfreihafen.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, miquel.raynal@bootlin.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 20 Feb 2023 22:37:49 +0100 you wrote:
> Hello Dave, Jakub.
> 
> An update from ieee802154 for *net-next*
> 
> Miquel Raynal build upon his earlier work and introduced two new
> features into the ieee802154 stack. Beaconing to announce existing
> PAN's and passive scanning to discover the beacons and associated
> PAN's. The matching changes to the userspace configuration tool
> have been posted as well and will be released together with the
> kernel release.
> 
> [...]

Here is the summary with links:
  - pull-request v2: ieee802154-next 2023-02-20
    https://git.kernel.org/netdev/net-next/c/871489dd01b6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


