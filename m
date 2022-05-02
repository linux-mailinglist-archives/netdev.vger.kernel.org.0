Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95945178D9
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 23:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235806AbiEBVNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 17:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbiEBVNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 17:13:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA1ECF3;
        Mon,  2 May 2022 14:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B90D610A2;
        Mon,  2 May 2022 21:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C0485C385AF;
        Mon,  2 May 2022 21:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651525813;
        bh=aZRclJB3S+w41OpLeywT0IH3DkszK0qCj7mVr/7Kw9Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DCkal/JGdf5/2oNOS9TmQXdh/ZWEwWCcR7Bqww7fCyKxeKO9qdWmghyPPSwZwC/Me
         zXeLfs/3iegdIkEy0MkCuTHQnSI72d+ajNyawLvNP99Php2FI9N+7nnakQvZKjK/Xp
         8wC9nuxkNHygdCxAfVM9Dc+6TbrRWJoR/yU+7tKqwH1O9NW4kX8TeUCO2UOjGcdCv4
         dhKzcap5UzPpA4feCux2t8jtjS2XGhignNCGf0rTOcBfRCkmyKtvojKaNo0Q6hu7OM
         OH0eLjFbNmuicGTXJf3Rtpqt85OGmtI1bDW5JFOUU+dLIyA/UnSe9CvokYO0kDPDYr
         9YN29cnEg+dSg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A1E25E8DBDA;
        Mon,  2 May 2022 21:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: ieee802154-next 2022-05-01
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165152581365.3052.12540257995357978934.git-patchwork-notify@kernel.org>
Date:   Mon, 02 May 2022 21:10:13 +0000
References: <20220501194614.1198325-1-stefan@datenfreihafen.org>
In-Reply-To: <20220501194614.1198325-1-stefan@datenfreihafen.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  1 May 2022 21:46:14 +0200 you wrote:
> Hello Dave, Jakub.
> 
> An update from ieee802154 for your *net-next* tree.
> For the merge conflict resolution please see below.
> 
> Miquel Raynal landed two patch series bundled in this pull request.
> 
> [...]

Here is the summary with links:
  - pull-request: ieee802154-next 2022-05-01
    https://git.kernel.org/netdev/net-next/c/c5f50500a027

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


