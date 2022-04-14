Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7B1501222
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 17:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244932AbiDNNgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 09:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344564AbiDNNck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 09:32:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9413D222BD;
        Thu, 14 Apr 2022 06:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BD47B82985;
        Thu, 14 Apr 2022 13:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E790EC385A9;
        Thu, 14 Apr 2022 13:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649943012;
        bh=Y5Tn9KUwQUFjOffJSFfc+RNj34LfCXTO2iXHDljVs5o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ePDHqcOQ6lyzXfRwh2wuFljr+M6CrYJw11FBeSqaV5JYWPFGgQzGPbojHi6ksi4lC
         inxcH8OLdJ9uN+8wAkbtEpcujXzAjh8UZcaGtyLCgNdOfrOGg6vvZwm3Kr8yzHS8Z/
         6Wh1najk/TQdupZwzr+Uof3FXaH08Aci4nF1PTLmyGt8s9GbmlSRCur6RCn8R96b8i
         NApKw3fKNfKIiKRJQDHNgl1ytRjav5uv4udNPpviI48yotsVvbfoZaVmlITFzpm2Xz
         KsdTPqV5oAR1+yVe1fMzoBJGftXAbMJeASWmwXJ8DjuBo/ltu0F4MUemXv6fw5tfPI
         kDO/rBvuHhIgw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CE7C7E8DD6A;
        Thu, 14 Apr 2022 13:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/3] rndis_host: handle bogus MAC addresses in ZTE RNDIS
 devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164994301284.18558.14694469738162324311.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Apr 2022 13:30:12 +0000
References: <20220413014416.2306843-1-lech.perczak@gmail.com>
In-Reply-To: <20220413014416.2306843-1-lech.perczak@gmail.com>
To:     Lech Perczak <lech.perczak@gmail.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org, bjorn@mork.no,
        kristian.evensen@gmail.com, oliver@neukum.org
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

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 13 Apr 2022 03:44:13 +0200 you wrote:
> When porting support of ZTE MF286R to OpenWrt [1], it was discovered,
> that its built-in LTE modem fails to adjust its target MAC address,
> when a random MAC address is assigned to the interface, due to detection of
> "locally-administered address" bit. This leads to dropping of ingress
> trafficat the host. The modem uses RNDIS as its primary interface,
> with some variants exposing both of them simultaneously.
> 
> [...]

Here is the summary with links:
  - [v3,1/3] cdc_ether: export usbnet_cdc_zte_rx_fixup
    https://git.kernel.org/netdev/net-next/c/64b97df995f0
  - [v3,2/3] rndis_host: enable the bogus MAC fixup for ZTE devices from cdc_ether
    https://git.kernel.org/netdev/net-next/c/36e747972d8b
  - [v3,3/3] rndis_host: limit scope of bogus MAC address detection to ZTE devices
    https://git.kernel.org/netdev/net-next/c/171cfae6b78c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


