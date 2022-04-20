Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6311350851F
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 11:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350861AbiDTJnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 05:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236879AbiDTJm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 05:42:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34308340DA;
        Wed, 20 Apr 2022 02:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D82E3B81E1C;
        Wed, 20 Apr 2022 09:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 74F12C385A8;
        Wed, 20 Apr 2022 09:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650447611;
        bh=bH0TgcVovdZFNPyE+RQlHrCOteeo4plxQp+8KyshTXQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Is7MgfnkWr50sAPa0MsCufqpdYN89VV0XrwLZlOJqXf86359DYBj1CDJ/djdAxXZt
         YgGgu8xL6dyYkTt2unBIYtAOjY61DOnhplLZ+dv/osGACexllZStayROU/nO2qKWhy
         mpsj1TiWIVqQQw0STQEEgxt3C8ayL2YaI5vqsR1SsXT9vlzWh0F269X1aCJAbVnUcA
         jveq77Gwu3Y75/yFIKi8A1VfTENQHBLckiiuYV7giDDVPtuIWbXRyuG8bL1Y2qNSLE
         ThWA1p+8l92hmO45g2owli3GZBTJKGDkL5dmQIQQFJ1hrnLmF2rYkFd7hO8kzhEHE/
         madzDoeQQLPww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 588ACE8DD85;
        Wed, 20 Apr 2022 09:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] doc/ip-sysctl: add bc_forwarding
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165044761135.27023.9005040852408802876.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Apr 2022 09:40:11 +0000
References: <20220413140000.23648-1-nicolas.dichtel@6wind.com>
In-Reply-To: <20220413140000.23648-1-nicolas.dichtel@6wind.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, lucien.xin@gmail.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 13 Apr 2022 16:00:00 +0200 you wrote:
> Let's describe this sysctl.
> 
> Fixes: 5cbf777cfdf6 ("route: add support for directed broadcast forwarding")
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>  Documentation/networking/ip-sysctl.rst | 7 +++++++
>  1 file changed, 7 insertions(+)

Here is the summary with links:
  - [net] doc/ip-sysctl: add bc_forwarding
    https://git.kernel.org/netdev/net/c/c6a4254c18c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


