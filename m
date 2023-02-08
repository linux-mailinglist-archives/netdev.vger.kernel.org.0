Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9491368E72A
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 05:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbjBHEbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 23:31:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbjBHEaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 23:30:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC4342DCB
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 20:30:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2429B81C11
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 04:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1C695C433A1;
        Wed,  8 Feb 2023 04:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675830619;
        bh=UvvhHTfBLF7KVLXV0Y/FkdtPssuYngFV8e4xRjAjg8Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lZoiclOCKm41AKfFD8GvVhHAPrtUgnJYQXdns5wN1AaKU1ucvf6SSLeERBGmxncJW
         mw/0VWe6jgS8JNNpF+wj9MrrWQKftze22FSJVYkNNOvkRB8w7YfpZTxYYU+DqHQHSr
         UCBsMMYsQpQakmRka+g016eh3kaP2kPVv4DGVfFBqn9ZACxKCbrNvhIWXc8c3j1ScD
         jckiOowGNtKspbh2i67LDi5spjO9p5RFJIP9H0CEXN9d51UaCrAaP5aQgazpRVf4By
         0ia68Q8/mbQ5LOeRQF+AoOCsIb49IOlH9lYEihwGUenbooiotWnCndyK9YbWCaSo81
         WYN75/gbhRivA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 074FDE50D62;
        Wed,  8 Feb 2023 04:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: flower: add check for flower VF netdevs for
 get/set_eeprom
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167583061902.23427.17472231121984158578.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Feb 2023 04:30:19 +0000
References: <20230206154836.2803995-1-simon.horman@corigine.com>
In-Reply-To: <20230206154836.2803995-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        james.hershaw@corigine.com, louis.peens@corigine.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 Feb 2023 16:48:36 +0100 you wrote:
> From: James Hershaw <james.hershaw@corigine.com>
> 
> Move the nfp_net_get_port_mac_by_hwinfo() check to ahead in the
> get/set_eeprom() functions to in order to check for a VF netdev, which
> this function does not support.
> 
> It is debatable if this is a fix or an enhancement, and we have chosen
> to go for the latter. It does address a problem introduced by
> commit 74b4f1739d4e ("nfp: flower: change get/set_eeprom logic and enable for flower reps").
> However, the ethtool->len == 0 check avoids the problem manifesting as a
> run-time bug (NULL pointer dereference of app).
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: flower: add check for flower VF netdevs for get/set_eeprom
    https://git.kernel.org/netdev/net-next/c/f817554786dd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


