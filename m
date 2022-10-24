Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4086360B9F8
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 22:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiJXUXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 16:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234274AbiJXUXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 16:23:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1F058E9C
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 11:38:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28896B81AE2
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 13:26:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BE80DC433B5;
        Mon, 24 Oct 2022 13:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666618012;
        bh=DEfN7AD1pjhdw+9oDq8w+n+iiBzkLkTvwSRZEeQ3agg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=quXW08SNJUXcbAxx7WeePYNDrvoLiP9fEFoXqIS0b7qAJIuUAIBMZs5rgVuwXIDQl
         EJXUp8nJdUCnAPydgzAhEp+3MsdEHG3pmxXoDaTrAvzxlCuViFLc7GkLU5zR3mcNja
         AC9uht+zKCRCZdEiOWV+G6OEgZRQFawCiXEi8IRE3pIpCBAFoUmYUIWfvk3pHbcfpB
         X6eo9V/bHdTXHJ4mmUIy5XETge5a5LsNIAnQCD1Q7rTKT7ktcJ5pxWP9arfLQ+Fh/m
         C0esE1GxTnXSo/Ho6GjlZmrkt/QAHYZlo3UmSwUFtzELi7m37L5c+Y23Mr+PFQ6Sr1
         HC+AAYkv7xqww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A5ADAE270DE;
        Mon, 24 Oct 2022 13:26:52 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 0/5] ptp: ocp: add support for Orolia ART-CARD
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166661801267.19025.14395262392620181200.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Oct 2022 13:26:52 +0000
References: <20221020232433.9593-1-vfedorenko@novek.ru>
In-Reply-To: <20221020232433.9593-1-vfedorenko@novek.ru>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     richardcochran@gmail.com, jonathan.lemon@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 21 Oct 2022 02:24:28 +0300 you wrote:
> Orolia company created alternative open source TimeCard. The hardware of
> the card provides similar to OCP's card functions, that's why the support
> is added to current driver.
> 
> The first patch in the series changes the way to store information about
> serial ports and is more like preparation.
> 
> [...]

Here is the summary with links:
  - [net-next,v6,1/5] ptp: ocp: upgrade serial line information
    https://git.kernel.org/netdev/net-next/c/895ac5a51fe2
  - [net-next,v6,2/5] ptp: ocp: add Orolia timecard support
    https://git.kernel.org/netdev/net-next/c/69dbe1079cd0
  - [net-next,v6,3/5] ptp: ocp: add serial port of mRO50 MAC on ART card
    https://git.kernel.org/netdev/net-next/c/9c44a7ac17fb
  - [net-next,v6,4/5] ptp: ocp: expose config and temperature for ART card
    https://git.kernel.org/netdev/net-next/c/ee6439aaad32
  - [net-next,v6,5/5] ptp: ocp: remove flash image header check fallback
    https://git.kernel.org/netdev/net-next/c/c1fd463d571a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


