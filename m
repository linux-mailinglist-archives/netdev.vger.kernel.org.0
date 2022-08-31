Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 759035A7642
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 08:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiHaGK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 02:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiHaGKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 02:10:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18B94D142
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 23:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6BD1B81EB8
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 781B8C43470;
        Wed, 31 Aug 2022 06:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661926216;
        bh=wW7Hvt6ty/IzpqUCx3lG/ind05kGpqcrapJDpkVGtR8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OT+DaV/d9ejhrQM2GH0md6gsz77bFEZIr8YHewJcfceM/NSxTX05N9xeMDHGKh3z4
         jpIEeU04dm2v+UUrm2+AMpcKAwL5CfETYOeLbrWL6nelrb2TU1kHDuTqW9sSn7hocg
         UoOTgGrCa5sarpa3x/1+J77ly9pLdTrYQ27r6sFkGFQcRUcuj0yD/qY8u+vdCa378W
         EYmdf9SecJd42lbUa4Op9MNMRtmgOOmCK6ToLX3XdLLnK4rkqsdX7edVanKm78Y76y
         jSt37y9fAE65iImMLumntHhosWbFb0OvyWFe8CyDFOoohjaU4LTg4zEf90bjZSS6br
         2B6aZHjnHM/Ag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5BC22E924DB;
        Wed, 31 Aug 2022 06:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] nfp: fix the access to management firmware hanging
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166192621636.25925.13704938533487200393.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 06:10:16 +0000
References: <20220829101651.633840-1-simon.horman@corigine.com>
In-Reply-To: <20220829101651.633840-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com
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

On Mon, 29 Aug 2022 12:16:51 +0200 you wrote:
> From: Gao Xiao <gao.xiao@corigine.com>
> 
> When running `ethtool -p` with the old management firmware,
> the management firmware resource is not correctly released,
> which causes firmware related malfunction: all the access
> to management firmware hangs.
> 
> [...]

Here is the summary with links:
  - [net] nfp: fix the access to management firmware hanging
    https://git.kernel.org/netdev/net/c/642b2122c5df

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


