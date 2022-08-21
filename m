Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD8559B6BB
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 01:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbiHUXUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 19:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiHUXUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 19:20:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE595140A0
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 16:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE803B80D8F
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 23:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66764C433B5;
        Sun, 21 Aug 2022 23:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661124014;
        bh=9YOjQ81yz6JOxMgzTB7l/onKBTDwwBSMJJG5uFllqII=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PMwC6LLA9dyXhTI43QByicmOwhG4RaZiWdna2+jKXi/6Z7RlEYhnE8bjsWk6oYD7r
         A5AfvBOREJTyOhvE8b9RmkSJsW2qwR9ow8S21evh8bvmclija9DoB+pQuz45zY8m2H
         a/k2rDfTnEqMmFG4x+dlnVA0t8OFaO+h+b/NxEof5iEwQy90efrgPjgo8GsXIstZXp
         ZbQgighYBSMgz/vGJAV5r4JMzbdJZG+k24d8M4HWC83zpZbwIVs58l9OV2peB2A6gG
         720auuDPO0QYwoywbAAHQSw3uGyHbumVIx+SQ+ARsPu2WcS0TiQwBrFwTCaU/9IAtw
         3+3uPNpKzEX1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 46812C43142;
        Sun, 21 Aug 2022 23:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool v2] ethtool: fix EEPROM byte write
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166112401428.18015.17121968963411126665.git-patchwork-notify@kernel.org>
Date:   Sun, 21 Aug 2022 23:20:14 +0000
References: <20220819101049.1939033-1-tomasz.mon@camlingroup.com>
In-Reply-To: <20220819101049.1939033-1-tomasz.mon@camlingroup.com>
To:     =?utf-8?q?Tomasz_Mo=C5=84_=3Ctomasz=2Emon=40camlingroup=2Ecom=3E?=@ci.codeaurora.org
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org, andrew@lunn.ch,
        k.drobinski@camlintechnologies.com
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

This patch was applied to ethtool/ethtool.git (master)
by Michal Kubecek <mkubecek@suse.cz>:

On Fri, 19 Aug 2022 12:10:49 +0200 you wrote:
> ethtool since version 1.8 supports EEPROM byte write:
>   # ethtool -E DEVNAME [ magic N ] [ offset N ] [ value N ]
> 
> ethtool 2.6.33 added EEPROM block write:
>   # ethtool -E ethX [ magic N ] [ offset N ] [ length N ] [ value N ]
> 
> EEPROM block write introduced in 2.6.33 is backwards compatible, i.e.
> when value is specified the length is forced to 1 (commandline length
> value is ignored).
> 
> [...]

Here is the summary with links:
  - [ethtool,v2] ethtool: fix EEPROM byte write
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=95a8d982f159

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


