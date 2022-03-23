Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE554E57BB
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 18:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343732AbiCWRlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 13:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343725AbiCWRln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 13:41:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7F466AC7;
        Wed, 23 Mar 2022 10:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFE8AB81FC7;
        Wed, 23 Mar 2022 17:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7B339C340EE;
        Wed, 23 Mar 2022 17:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648057210;
        bh=tf4MfN6g7/j4rdQw/VT1syg7Tg3kdyij/Xcns7Lfv2o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Kc+5Spr3XdEDZfjLlNZqbVX3gr9eqEx2V+x9i8jCAdDGAYn882ciK1ZMh5GBAIG2y
         dc6MlaPN4YdppIGEkc+g1VtmTrc6tPZDcQz2CWPkyD8LhM6yeyryjc3MhrvmAfmeUq
         /4n2STAcrhkdEvCtQQMVn7IJefTtbagoR9jnFc/JugiYFgwixNP1Sb8aj6Vmedp+TB
         grYNn7voR3tKyyKURDZqbExZqM84+xQmDkyX+vWVAe9t/53wXHdKhWRt0E53og2uQr
         v2o5EDUlpXZhI9H1Y2r6zSyQGY8T0MikMau/0gZt/DNOyNnC0iqNG4gTGUhJ4v9YRe
         YBTt/DyxmRYYg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5F7E4EAC081;
        Wed, 23 Mar 2022 17:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] drivers: net: xgene: Fix regression in CRC stripping
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164805721038.18073.13961440765175042448.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Mar 2022 17:40:10 +0000
References: <20220322224205.752795-1-stgraber@ubuntu.com>
In-Reply-To: <20220322224205.752795-1-stgraber@ubuntu.com>
To:     =?utf-8?q?St=C3=A9phane_Graber_=3Cstgraber=40ubuntu=2Ecom=3E?=@ci.codeaurora.org
Cc:     kuba@kernel.org, davem@davemloft.net,
        iyappan@os.amperecomputing.com, keyur@os.amperecomputing.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        quan@os.amperecomputing.com, stable@vger.kernel.org,
        toan@os.amperecomputing.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 22 Mar 2022 18:42:06 -0400 you wrote:
> From: Stephane Graber <stgraber@ubuntu.com>
> 
> All packets on ingress (except for jumbo) are terminated with a 4-bytes
> CRC checksum. It's the responsability of the driver to strip those 4
> bytes. Unfortunately a change dating back to March 2017 re-shuffled some
> code and made the CRC stripping code effectively dead.
> 
> [...]

Here is the summary with links:
  - [v2] drivers: net: xgene: Fix regression in CRC stripping
    https://git.kernel.org/netdev/net-next/c/e9e6faeafaa0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


