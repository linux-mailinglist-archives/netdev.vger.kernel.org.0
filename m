Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B73766A12F9
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 23:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjBWWtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 17:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjBWWtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 17:49:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF85E59E78;
        Thu, 23 Feb 2023 14:49:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBC04617BF;
        Thu, 23 Feb 2023 22:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A60C433D2;
        Thu, 23 Feb 2023 22:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677192550;
        bh=7Sebkm/rmFbqt0owj0OOQz0b9KIF4oXaS88bTXa/XoY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BfEFPnZVhxC9UHL7gwO3Dn/QoMMNEznvvePFKJvZTmM557seVVonFCi5yjolJIBVc
         iJK01qfnnnC/GojqaiSu+ViqcP8SH5QxGNafCnPkFsnklLMS++jrjNADRVpxr1SLw6
         qKoB4L4+71sb3jsHyrRh/RJ8NMs8VJlMRxqou49m/1KHcYh+DABpYy3PHKFrJcG42Y
         OQg1XJrcdTJnyRZRJeWgy2lohMx/MM1l9BYmvEbOQbBDfnrpMzoa17k9W6hIRAzJwi
         F+DHjJSt01XCNE3r+w/onmgltO066M9N/WmwdVHKsHbazsEJBx9SEWRKIv+Q46yOV4
         2BUBWVJBMCucg==
Date:   Thu, 23 Feb 2023 14:49:09 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Leon Romanovsky <leon@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, phaddad@nvidia.com, edumazet@google.com,
        linux-rdma@vger.kernel.org, markzhang@nvidia.com,
        netdev@vger.kernel.org, pabeni@redhat.com, raeds@nvidia.com,
        saeedm@nvidia.com
Subject: Re: [PATCH net v1] net/mlx5: Fix memory leak in IPsec RoCE creation
Message-ID: <Y/ftZTzCkyW/vn4Z@x130>
References: <a69739482cca7176d3a466f87bbf5af1250b09bb.1677056384.git.leon@kernel.org>
 <167714821660.3301.1148990623254072691.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <167714821660.3301.1148990623254072691.git-patchwork-notify@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23 Feb 10:30, patchwork-bot+netdevbpf@kernel.org wrote:
>Hello:
>
>This patch was applied to netdev/net.git (master)
>by Paolo Abeni <pabeni@redhat.com>:
>
>On Wed, 22 Feb 2023 11:06:40 +0200 you wrote:
>> From: Patrisious Haddad <phaddad@nvidia.com>
>>
>> During IPsec RoCE TX creation a struct for the flow group creation is
>> allocated, but never freed. Free that struct once it is no longer in use.
>>
>> Fixes: 22551e77e550 ("net/mlx5: Configure IPsec steering for egress RoCEv2 traffic")
>> Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>>
>> [...]
>
>Here is the summary with links:
>  - [net,v1] net/mlx5: Fix memory leak in IPsec RoCE creation
>    https://git.kernel.org/netdev/net/c/c749e3f82a15
>

hmm, I don't see this one in net branch, should i resubmit via my queue? 


