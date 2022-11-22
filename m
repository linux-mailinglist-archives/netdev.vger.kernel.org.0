Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 482A6633CE4
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 13:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbiKVMuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 07:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233276AbiKVMun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 07:50:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DD960EB6;
        Tue, 22 Nov 2022 04:50:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D0E4DCE1C8C;
        Tue, 22 Nov 2022 12:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF69C433C1;
        Tue, 22 Nov 2022 12:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669121435;
        bh=gPiGw4vRC33iKPpfayqibaQp6g5bo+fr0oWzwH7ZzE0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vkrd8/FqPelYrxzfMgg6HuPXAQ+AFOCItv7dL4t/4gXXgj7GzvYB28hkC6lzaN2Br
         agaXFvummz6Jn1rjCouqYvw2OPzra+N9QmF5PhUNSio1FPjw+B9XcixFS+D81fY+iH
         IT15fGJJP0qAxh+M4djZ2zyhPUeTr7ckiM7YuRqw4sFDMQqVKgBUM7kTLBUOV365IS
         KHFrm+7pcFbWxHqTlqeH1G8jpQqCZqw0ltsRAc+cJQCWfF5NcSWDBA8U+yu4D9AJar
         KP4rRDruHMV6tKkIYV2JPyWkh2oj8SIWAIBzH8Syb7+jfu/7no+LbG5KSrQnoTgsaC
         /Pg3hq2hkZuUg==
Date:   Tue, 22 Nov 2022 14:48:31 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] devlink: remove redundant health state set to
 error
Message-ID: <Y3zFH2GJ7pEVu2K+@unreal>
References: <1668933412-5498-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1668933412-5498-1-git-send-email-moshe@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 20, 2022 at 10:36:52AM +0200, Moshe Shemesh wrote:
> Reporter health_state is set twice to error in devlink_health_report().
> Remove second time as it is redundant.
> 
> Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
> ---
>  net/core/devlink.c | 2 --
>  1 file changed, 2 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
