Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917F1664E51
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 22:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbjAJVwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 16:52:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbjAJVwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 16:52:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DB3479D1;
        Tue, 10 Jan 2023 13:52:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99F99B819B2;
        Tue, 10 Jan 2023 21:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F96C433EF;
        Tue, 10 Jan 2023 21:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673387547;
        bh=U577vnktAersop3sE2Vgk2QPf5Dyzg9UCAOJXjKCv14=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rp92ue4CxvqOShsJn15quJzekl0gtNhM3K4qNgqg6VwoZDx1gZceG3XePjto+I3e9
         cTHtJVuff/gWdyr5L7ZjzTlAv3DOM3He4pOMm6GdjnUebBEuqzURkqlKBW+MTtsS8N
         EXQyp/YfBIICIi7YPUq83QJF5MCVq4IU4PkL29FVA7SsjI2oChu1VrYg0ITEWjvqRp
         cutLmdtYH/dnHuv5M408OP60DU+YW+HT90wjY+BwFuYsDD0ob1Xko6WRauC7jJhlfk
         sNU3+kXGgEFSOC+oy/vw2e2n9oV+w1oD8qGk90yyjkQFuDNUxwqaikZoDzK6CxahaD
         FIBl/6ggJg+Cw==
Date:   Tue, 10 Jan 2023 13:52:25 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] net/mlx5e: Replace zero-length array with
 flexible-array member
Message-ID: <Y73eGayohIOnM+sp@x130>
References: <Y7zB7shx/u1zWrbj@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y7zB7shx/u1zWrbj@work>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09 Jan 19:39, Gustavo A. R. Silva wrote:
>Zero-length arrays are deprecated[1] and we are moving towards
>adopting C99 flexible-array members instead. So, replace zero-length
>array declaration in struct mlx5e_flow_meter_aso_obj with flex-array
>member.
>
>This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
>routines on memcpy() and help us make progress towards globally
>enabling -fstrict-flex-arrays=3 [2].
>
>Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays [1]
>Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [2]
>Link: https://github.com/KSPP/linux/issues/78
>Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Applied to net-next-mlx5, Thanks!


