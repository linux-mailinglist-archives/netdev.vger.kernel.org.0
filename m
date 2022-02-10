Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43EE44B106E
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 15:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242934AbiBJOaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 09:30:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242945AbiBJOaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 09:30:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7340398;
        Thu, 10 Feb 2022 06:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93C9CB823BD;
        Thu, 10 Feb 2022 14:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16FA0C340EE;
        Thu, 10 Feb 2022 14:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644503409;
        bh=9zCtV3E5T/8WBQZIgDfe8OxjVGfrE/C2n7ASBrNqq18=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XAaCOJDMwMP3y2ztmGtsWzQcrjHT0Hes0UOEVOJ57f691PmjJIyQ5DN5G3W4upEnz
         9QC+mE76l5YhaxajW9aIF/oOyZuPcHfXf0OuegDhZoh1j+vFHB01joHjt0xmJibYrm
         idJinGiTM/6vBrBSC1WwzJqVCf5hhp0YvYsfY+qo6qtNKsZ4nsGW3F6UIvc49M1FCC
         F34IjXDP/LEizLnEwZbzeCJH+MdmqpVblwFxZ0JtVrmrkQD2whLknU7HMQ1BLLSJU/
         D+kYLdM7RJ2/cbRD6K/H7m05fPdMnmZtJiot1UgdL/s/bFP6sZuQaByUEx8G25ediB
         l3NlCNP/k49yg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE79EE6BB38;
        Thu, 10 Feb 2022 14:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: ieee802154-next 2022-02-10
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164450340897.11783.17085414833527774018.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Feb 2022 14:30:08 +0000
References: <20220210110227.3433928-1-stefan@datenfreihafen.org>
In-Reply-To: <20220210110227.3433928-1-stefan@datenfreihafen.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, netdev@vger.kernel.org
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

This pull request was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 10 Feb 2022 12:02:27 +0100 you wrote:
> Hello Dave, Jakub.
> 
> An update from ieee802154 for your *net-next* tree.
> 
> There is more ongoing in ieee802154 than usual. This will be the first pull
> request for this cycle, but I expect one more. Depending on review and rework
> times.
> 
> [...]

Here is the summary with links:
  - pull-request: ieee802154-next 2022-02-10
    https://git.kernel.org/netdev/net-next/c/9557167bc63e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


