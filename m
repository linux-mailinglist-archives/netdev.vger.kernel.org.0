Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340DB68A38D
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 21:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbjBCUaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 15:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjBCUaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 15:30:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014946534E;
        Fri,  3 Feb 2023 12:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C19561FD5;
        Fri,  3 Feb 2023 20:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4CAFC433EF;
        Fri,  3 Feb 2023 20:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675456218;
        bh=AB+FyipJR28p5jq3VzSfWTFIyqXsXwjK8aCEe3IMVEo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f+L4Vo/jHYws1CpYKCJ1iM9QULfukt7AykUnt5AdFqoDlEAAuyWmwTjPD1iLy+QE6
         Lj5VwzRlqcy1szy/x5QSUvFFZ3278nCCLpoGQpGEs2SXvo7A4se1KImDbVlf/H3/am
         /z9uZ/TylqleQt+NLXCWRfcpJOZLK1lwOKo1KdHsMIQTKpRq35nfOX7KY3xzJ08FX+
         lJn9fKuoj3bYT5QsoKZAmzi+UuJsBrMW2yMghTLrOcDn0+2yote2nFJGEEreNM+VyN
         GfGRb8/u65rZQ8S3ekKB5c4wuqQsKd8Oafr/uFLz2kXvCvbLVDXjMff8/cwt7jwFb5
         brP/osejL6Rvw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C0BC0E21ED0;
        Fri,  3 Feb 2023 20:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Bluetooth: Make sure LE create conn cancel is sent when
 timeout
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <167545621778.19489.5003184316361485728.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Feb 2023 20:30:17 +0000
References: <20230203173900.1.I9ca803e2f809e339da43c103860118e7381e4871@changeid>
In-Reply-To: <20230203173900.1.I9ca803e2f809e339da43c103860118e7381e4871@changeid>
To:     Archie Pusaka <apusaka@google.com>
Cc:     linux-bluetooth@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, chromeos-bluetooth-upstreaming@chromium.org,
        apusaka@chromium.org, yinghsu@chromium.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, johan.hedberg@gmail.com,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Fri,  3 Feb 2023 17:39:36 +0800 you wrote:
> From: Archie Pusaka <apusaka@chromium.org>
> 
> When sending LE create conn command, we set a timer with a duration of
> HCI_LE_CONN_TIMEOUT before timing out and calling
> create_le_conn_complete. Additionally, when receiving the command
> complete, we also set a timer with the same duration to call
> le_conn_timeout.
> 
> [...]

Here is the summary with links:
  - Bluetooth: Make sure LE create conn cancel is sent when timeout
    https://git.kernel.org/bluetooth/bluetooth-next/c/edda34a2348f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


