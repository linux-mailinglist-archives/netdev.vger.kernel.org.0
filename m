Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C0B6D37F3
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjDBMuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbjDBMuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:50:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18155BDCB
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 05:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBF2CB80E71
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 12:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 884C5C4339B;
        Sun,  2 Apr 2023 12:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680439817;
        bh=7imZFOpm4rZxXFi0+vNlmYl7gJyekdrPRsbjk2xFDgw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YYYOzoq+tSDjmQJTNHhPQFC3zx46nfpOQ7d6k+WI+6Zwx7HJg80OqPc6l5c7H4f5H
         vMLp7CAHg5HMxpZ+x5j0a5L9VNEqUhJ+9tYc4ZRru6bKuhPcvwSKFDTFrkgWmkbewJ
         aj71lmuATXpzaksZyCgkJD2Z1RpGfztQV65yXYAWUJg8xkGOTP8RRqjvhUS8dCGBi6
         se4m8S6OeY8z0dBjd9dJuvyCYYSov0VN1tSOUi2Rjd6J0ZfCK1leKHSph5OGLtzA0U
         BCK+Qjmql6G/v3afxRORd04XgyHRDK9TjkVwzbq51RzjTUHdUhGjCFVGIxdgPZkNZ5
         G2Sd5J981Jf4Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 73861E21EE4;
        Sun,  2 Apr 2023 12:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] mlxsw: Use static trip points for transceiver
 modules
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168043981747.15620.9570433357439735328.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Apr 2023 12:50:17 +0000
References: <cover.1680272119.git.petrm@nvidia.com>
In-Reply-To: <cover.1680272119.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, rafael@kernel.org,
        daniel.lezcano@linaro.org, idosch@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 31 Mar 2023 16:17:29 +0200 you wrote:
> Ido Schimmel writes:
> 
> See patch #1 for motivation and implementation details.
> 
> Patches #2-#3 are simple cleanups as a result of the changes in the
> first patch.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] mlxsw: core_thermal: Use static trip points for transceiver modules
    https://git.kernel.org/netdev/net-next/c/5601ef91fba8
  - [net-next,2/3] mlxsw: core_thermal: Make mlxsw_thermal_module_init() void
    https://git.kernel.org/netdev/net-next/c/c1536d856e18
  - [net-next,3/3] mlxsw: core_thermal: Simplify transceiver module get_temp() callback
    https://git.kernel.org/netdev/net-next/c/cc19439f703b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


