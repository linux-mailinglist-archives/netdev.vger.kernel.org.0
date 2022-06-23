Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E272A556F94
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 02:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376382AbiFWAkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 20:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359064AbiFWAkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 20:40:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F42D4198E
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 17:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C10A61BF8
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 00:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62EEBC341C6;
        Thu, 23 Jun 2022 00:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655944812;
        bh=q1KcuOVjtAmUO9E8hLE+UE05Xe38jn/p4SQ5j1P6AKg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jyMNT12xL70sYFdjrAVL5QUyRhWA9hdOPzZAwx6Zm78/2MTwJnfre3eeGDDnQnkaM
         HKfTViKBpVdCbFlh+pptmcgoQ2cRt1n/NzYwQ9Pp1Q5U8BQHVO/BohdvruDuLv4+SZ
         lOlNMgNpDUjsKphD5cbNKXphBzfFbu+NwS9zCcyM1UgFmSbyTJYTwA0r0UD+8hR7To
         RJdBu8cZq5x7/Cu3naEJSlHiq1J5ZgJBBl0OCnpTHYpjprfnb+29LvTfY8iiM0e/Sq
         rcusZyjfS58Mc/mlnhTpHNf5dX9fFyJfRSFLKaRcnc4VebC/izw0JKmBZTbnudQI/W
         ypbSTbohwJssg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4BDD8E7387A;
        Thu, 23 Jun 2022 00:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: Add a maintainer for OCP Time Card
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165594481230.674.13693584425542697661.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Jun 2022 00:40:12 +0000
References: <20220621233131.21240-1-vfedorenko@novek.ru>
In-Reply-To: <20220621233131.21240-1-vfedorenko@novek.ru>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     kuba@kernel.org, jonathan.lemon@gmail.com, vadfed@fb.com,
        netdev@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Jun 2022 02:31:31 +0300 you wrote:
> From: Vadim Fedorenko <vadfed@fb.com>
> 
> I've been contributing and reviewing patches for ptp_ocp driver for
> some time and I'm taking care of it's github mirror. On Jakub's
> suggestion, I would like to step forward and become a maintainer for
> this driver. This patch adds a dedicated entry to MAINTAINERS.
> 
> [...]

Here is the summary with links:
  - [net] MAINTAINERS: Add a maintainer for OCP Time Card
    https://git.kernel.org/netdev/net/c/13f28c2cf070

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


