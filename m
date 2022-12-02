Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C25D640A12
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 17:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbiLBQCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 11:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233938AbiLBQBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 11:01:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BA5862D3
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 08:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA77862324
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 16:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0EEB3C433C1;
        Fri,  2 Dec 2022 16:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669996818;
        bh=w0kL5MHm2FLheTc7+ZGj4kkwgrVuLNKVYZYBwJr3zq0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kPxNtHnJA8gdIliB56C9WLqdtb01ibHw/4AxGXu1sWzq3u7q+HhorasoR/Uw4cpUW
         ssrIU+kcRN+Zakfi3xpp8bwYVZD/ocf04OIY+bwKABQGE6KL3y4nwzdMzLs/7V/MVf
         z/ReIu4q+l1feutmpBwAWH2pwb/CS5Ebbqmj8qHzL9oPj+W6tlBO5AAKtFVxbR7Syg
         bwWpQ//Zxyc1LuTqc3FwmjXCRIPwvRzmsq3q+03VC2gosNsn6fe/8ObJVrLO9lVMgH
         0k/1fr2Cp/QOYn929cR87BnQ52843HlfIvsk5B5jeNaCXMp+LNjFpkilSXf/t2WWHm
         7LdzypFLOQIJQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E9352E21EEF;
        Fri,  2 Dec 2022 16:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V3] vdpa: allow provisioning device features
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166999681795.3415.16149034965040121210.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Dec 2022 16:00:17 +0000
References: <20221129042816.10346-1-jasowang@redhat.com>
In-Reply-To: <20221129042816.10346-1-jasowang@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, si-wei.liu@oracle.com,
        mst@redhat.com, eperezma@redhat.com, lingshan.zhu@intel.com,
        elic@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Tue, 29 Nov 2022 12:28:16 +0800 you wrote:
> This patch allows device features to be provisioned via vdpa. This
> will be useful for preserving migration compatibility between source
> and destination:
> 
> # vdpa dev add name dev1 mgmtdev pci/0000:02:00.0 device_features 0x300020000
> # vdpa dev config show dev1
> # dev1: mac 52:54:00:12:34:56 link up link_announce false mtu 65535
>       negotiated_features CTRL_VQ VERSION_1 ACCESS_PLATFORM
> 
> [...]

Here is the summary with links:
  - [V3] vdpa: allow provisioning device features
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=a4442ce58ebb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


