Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD354F93AB
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 13:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbiDHLWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 07:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbiDHLWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 07:22:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11452BF336;
        Fri,  8 Apr 2022 04:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C648EB82A26;
        Fri,  8 Apr 2022 11:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 719E2C385A8;
        Fri,  8 Apr 2022 11:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649416813;
        bh=VMfqz1PI0SlcPX2wiDSaLUmAvkMioh7K9Yq27Leg+sE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MgEnG/Cn96SvSFO1guc8A4d4YbO6kixpsT/ilSbSsI0h73GNOZO31GKJ3vrs5Fctj
         +ItSr6PDgy83SJ0TzJD7KLrcWFnErwqRWQDyZHBmXXTaMrnuqCRugqp9khoPpvBMqR
         oqoNg7r68U7356Ay8WvUnb6ALrSxf69YBBigwB0xyx2OTjqc1G5fQuLCPnG11GygU3
         pzzZM1TlmPvNTbdQT7pQTQAj5thC1R/goqv0DotrodXtVXCLRzK4VlHFmbsO30Mxjb
         qHaz+ZoThQbullol8Xw1CfzeB7Kx0ZwXnIx/AB+TH+4VkvXQtLoJWZoWl/XrBUVTp1
         HLTsxGSHquVow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 30DDBE6D402;
        Fri,  8 Apr 2022 11:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bonding: Update layer2 and layer2+3 hash formula
 documentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164941681319.25766.222385477532550731.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Apr 2022 11:20:13 +0000
References: <20220406135420.21682-1-gal@nvidia.com>
In-Reply-To: <20220406135420.21682-1-gal@nvidia.com>
To:     Gal Pressman <gal@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 6 Apr 2022 16:54:20 +0300 you wrote:
> When using layer2 or layer2+3 hash, only the 5th byte of the MAC
> addresses is used.
> 
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> ---
>  Documentation/networking/bonding.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - bonding: Update layer2 and layer2+3 hash formula documentation
    https://git.kernel.org/netdev/net/c/2cd1881b9821

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


