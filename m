Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 001575A7641
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 08:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiHaGK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 02:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiHaGKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 02:10:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7F53F320;
        Tue, 30 Aug 2022 23:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38BA061732;
        Wed, 31 Aug 2022 06:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8AA7BC433C1;
        Wed, 31 Aug 2022 06:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661926216;
        bh=lQVOUZheKJQxClspjNaQ9uoleC/u8G81Mrwcm9x0NX0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q9Kp+tkseYyA68xfYw+/g2m7M7fK6oyvPYgYMAI9hn36Y0jp6NMuf5hhsgCJn1Iio
         kAdq+pECFeA28/337V/yssqNOFe1dk93vCWMfv0Qq2JCe8Wmo/zur6skSanp9mj9fm
         ZESX2cQ5hxUWf0NPR7k4jghNd3P8fKzPhqwuifmZgTdyvVx1t4efYt/pt278tS5SoL
         2IfvT6IHiV+aPasv413T7OxwozESIKbPbNNaN0yrBOQDy0pSh2XWG1yLig8zebnGQh
         zMlW6GHn1Z7T3jRzT1XmCEycE+ytP3TnjgNOqXl8aNsz76etqTeurkitPzxn2rzuFc
         wDFIaZG+CPjsg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6718BE924DC;
        Wed, 31 Aug 2022 06:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: ieee802154 for net 2022-08-29
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166192621641.25925.4947025410690827202.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 06:10:16 +0000
References: <20220829100308.2802578-1-stefan@datenfreihafen.org>
In-Reply-To: <20220829100308.2802578-1-stefan@datenfreihafen.org>
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

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 29 Aug 2022 12:03:08 +0200 you wrote:
> Hello Dave, Jakub.
> 
> An update from ieee802154 for your *net* tree.
> 
> A repeated word fix from Jilin Yuan.
> A missed return code setting in the cc2520 driver by Li Qiong.
> Fixing a potential race in by defering the workqueue destroy in the adf7242
> driver by Lin Ma.
> Fixing a long standing problem in the mac802154 rx path to match corretcly by
> Miquel Raynal.
> 
> [...]

Here is the summary with links:
  - pull-request: ieee802154 for net 2022-08-29
    https://git.kernel.org/netdev/net/c/613c86977efd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


