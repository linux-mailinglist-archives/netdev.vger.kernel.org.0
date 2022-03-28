Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A564EA3AB
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 01:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbiC1Xb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 19:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiC1Xb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 19:31:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC41B3C711;
        Mon, 28 Mar 2022 16:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 811E1B8115C;
        Mon, 28 Mar 2022 23:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 20297C34110;
        Mon, 28 Mar 2022 23:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648510212;
        bh=jfLEW8Shh94IpRP5NsFyGBrC0Ur4xy9XSQg9OBesm5w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GMaMR//pqJ0XsxFuwy3IazWa8tfk0X3VL3piygIXOEBJaD+kPwqrTOsnTTG7Nc5So
         Tt99HAd2NrMP3E4tvK2Jul+H1Qggk6YejjZSlmfvhA/7+D0TCPbQZvkiLcwTlwLONK
         9THnnc2dwk1IxdhXDWHmXRAdrRoiAYvY4woQeTlsM9i0h97QLzf1So7y8hZGmWsICd
         rEMNQfuowVaORQ4v6AY3HHBDUWpv8lG5HooV57RFK2z9KqCS7/CdnjyHgIEbP7Zfo4
         DxsO6qrt6ZjsZc0SK1H5ag8uJxrK0qmjEiJJzQ0DzETgNuQDRO9m2Y8K/9NAeQSOle
         GMAIDQRFQvDfQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0213BE7BB0B;
        Mon, 28 Mar 2022 23:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: bcm_sf2_cfp: fix an incorrect NULL check on list
 iterator
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164851021200.6043.5974433550480970783.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Mar 2022 23:30:12 +0000
References: <20220328032431.22538-1-xiam0nd.tong@gmail.com>
In-Reply-To: <20220328032431.22538-1-xiam0nd.tong@gmail.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 28 Mar 2022 11:24:31 +0800 you wrote:
> The bug is here:
> 	return rule;
> 
> The list iterator value 'rule' will *always* be set and non-NULL
> by list_for_each_entry(), so it is incorrect to assume that the
> iterator value will be NULL if the list is empty or no element
> is found.
> 
> [...]

Here is the summary with links:
  - net: dsa: bcm_sf2_cfp: fix an incorrect NULL check on list iterator
    https://git.kernel.org/netdev/net/c/6da69b1da130

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


