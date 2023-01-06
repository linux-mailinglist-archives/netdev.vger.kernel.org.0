Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4920565F822
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 01:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235766AbjAFAbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 19:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbjAFAbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 19:31:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8634F11B;
        Thu,  5 Jan 2023 16:31:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDE4761C39;
        Fri,  6 Jan 2023 00:31:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7ABC433F0;
        Fri,  6 Jan 2023 00:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672965097;
        bh=5sPcNTTpdIVeKW/g5OL+4jdrXAFxMOLsmvOjpB4ROvg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hFgVLTFlYZBRPstI1b8sRVuTgIRQxnLm1s/7CSJGGwW/G2z6sxh5feBoISJyflT0a
         IOwO6wqSpDzeJIq3K4Lfl2FHi0PzPJZLXFF9LEmUaH41NvdAIY8/J76EeVbSJTVCuK
         Li7r4gTe8d0xomgY0ib7HJ976Yd5zzejL+9EUQbiJURwc5B0atLKOz9jut1/gpNTi5
         oumgVAIVEAWH4rQfVJmCoFfr7PycJxxRtMDXTKM35Z4Srj9z7W1mno+PnlGZphdRpM
         qVRQ+kzWDIPxIttlZUq2SJICO4Iid/cl2AFO8yPU6NW6i5MHES+GX52DHM5F7gkU4O
         mmSRmoei7+zXQ==
Date:   Thu, 5 Jan 2023 16:31:36 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Patrisious Haddad <phaddad@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Mark Zhang <markzhang@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH mlx5-next v1 2/3] net/mlx5: Introduce CQE error syndrome
Message-ID: <Y7dr6IDkQzIsFDpY@x130>
References: <cover.1672821186.git.leonro@nvidia.com>
 <f8359315f8130f6d2abe4b94409ac7802f54bce3.1672821186.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f8359315f8130f6d2abe4b94409ac7802f54bce3.1672821186.git.leonro@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04 Jan 11:43, Leon Romanovsky wrote:
>From: Patrisious Haddad <phaddad@nvidia.com>
>
>Introduces CQE error syndrome bits which are inside qp_context_extension
>and are used to report the reason the QP was moved to error state.
>Useful for cases in which a CQE isn't generated, such as remote write
>rkey violation.
>
>Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
>Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Saeed Mahameed <saeed@kernel.org>
