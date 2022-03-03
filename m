Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2AAE4CB6B8
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 07:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiCCGLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 01:11:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiCCGLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 01:11:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1E1165C02
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 22:10:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C0C4B823ED
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B6D3C340E9;
        Thu,  3 Mar 2022 06:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646287813;
        bh=doMlUs8KuKv2h3VIxLsA1MY3p6UM75oCjL57ofEnjwo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jD0bC5zpKA6w9NEVZY+up6wJ7F98S88YaChY+jVNdcD+RYT5A08OrtvrYTTusWQiq
         64vl9dViHIw2G5bc4QA4Ebbcn6y49QhwatO2bAy64O+OtB6AD1eBn72QRqj/gxxARX
         ThNvqsQXjrOAVpCUfRukk9yE7wP49TkwE3TD7at/dA0hCblQvUTAFdD62jR0jmZWY1
         gzzQOuuC5wV5BOwjAeXXxi0R3Alqmqiw6qcMRj1xxWYhzwplRPAksAB+urtXNjtqE+
         D/z7K+BAC9JAwmPh2kwTpeL9wea7DBh/csS9tW/eopW3eIq1eQZjQ0RJE0hWz/HoY1
         QOx9JRzIon5ow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E1695E7BB08;
        Thu,  3 Mar 2022 06:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: flower: Remove usage of the deprecated
 ida_simple_xxx API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164628781291.31171.5724332509627406521.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 06:10:12 +0000
References: <20220301131212.26348-1-simon.horman@corigine.com>
In-Reply-To: <20220301131212.26348-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, christophe.jaillet@wanadoo.fr
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  1 Mar 2022 14:12:12 +0100 you wrote:
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> Use ida_alloc_xxx()/ida_free() instead to
> ida_simple_get()/ida_simple_remove().
> The latter is deprecated and more verbose.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: flower: Remove usage of the deprecated ida_simple_xxx API
    https://git.kernel.org/netdev/net-next/c/432509013f66

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


