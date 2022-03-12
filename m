Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36A24D6D3D
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 08:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbiCLHl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 02:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbiCLHlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 02:41:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A508E0CA;
        Fri, 11 Mar 2022 23:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9D0DB82E1A;
        Sat, 12 Mar 2022 07:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 568EBC340ED;
        Sat, 12 Mar 2022 07:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647070813;
        bh=fqGDsrVs1RmDl1vTbTkS8swP3batv9lzALsm6v4pEpo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dvu05tVX5YG1mqABYeZvouMR1x5MzxLMMpiLiuk1u87nlrhVenLjCyEfBxiGUHVM1
         chGMrC2DwFSZguZ1DO0IdEsFZZPXdnxHnY8av4TakozmpXYZe2SJ1ySCju/c5Ndg/H
         AZPRKVSNQVRvIp0Dn9V4Yv7wI1ioqrE6c837TQ5zJbeXJ5tSllPbUua4FbjRjENQF4
         /6+o+PGeDpKXVhmEwMJiFGipxSUUT6cmTIqFRu7q7O+R5SRsQAlNXM1A96us8LHVrg
         ekFuau5f1BO/7eWKPzipqt7hKJcoDdUUU6oW2YE9ZzfweT2BKKQ9ZnsoKuQIzsHrxW
         mO+76rCTep60g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3D75BF0383D;
        Sat, 12 Mar 2022 07:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 resend] vsock: each transport cycles only on its own
 sockets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164707081324.11016.12108323329246547130.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Mar 2022 07:40:13 +0000
References: <20220311020017.1509316-1-jiyong@google.com>
In-Reply-To: <20220311020017.1509316-1-jiyong@google.com>
To:     Jiyong Park <jiyong@google.com>
Cc:     stefanha@redhat.com, sgarzare@redhat.com, mst@redhat.com,
        jasowang@redhat.com, davem@davemloft.net, kuba@kernel.org,
        adelva@google.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 11 Mar 2022 11:00:16 +0900 you wrote:
> When iterating over sockets using vsock_for_each_connected_socket, make
> sure that a transport filters out sockets that don't belong to the
> transport.
> 
> There actually was an issue caused by this; in a nested VM
> configuration, destroying the nested VM (which often involves the
> closing of /dev/vhost-vsock if there was h2g connections to the nested
> VM) kills not only the h2g connections, but also all existing g2h
> connections to the (outmost) host which are totally unrelated.
> 
> [...]

Here is the summary with links:
  - [net,v3,resend] vsock: each transport cycles only on its own sockets
    https://git.kernel.org/netdev/net/c/8e6ed963763f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


