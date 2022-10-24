Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60E260BE73
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 01:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbiJXXVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 19:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiJXXVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 19:21:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FB616912C
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 14:42:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCDA9B810B2
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 21:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F35EC433D6;
        Mon, 24 Oct 2022 21:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666647721;
        bh=PFLtKDf9zkaNVs2swoEg7kaPvDfkHSit3kHVVp2t84M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F8y4IPvtbU7m0KO0RBXQlPzDTHePVALalRhUW2g5aUeZtvFa1ZoFtgkDqVM5ShoMv
         muG8Di0loEJfX4+U4PmuiQGI3kFaepXiiolwCEAyKrCEYexfmaVrE73/O0EDiRN/A1
         uNnSWcaTkmkl4di3qxwSLzofbs3gEODgsHgCz5nBHmecy+bDcb0b3XpGHRi/yyJQUW
         EhqhfhxaITfIqHRI1T0T6J0/NfaCMyUdUITYYzxvxKAfMp4qLE6WxfJiBzuEV2fdr8
         iiQGe8/xYi2el+KyUKHd8qWYt+T7e7HWkTOQ06LkZbZ+GR82RRZ6p3CK98W2wYtypO
         AZXE7SxiKw9MQ==
Date:   Mon, 24 Oct 2022 14:42:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [pull request][V2 net 00/16] mlx5 fixes 2022-10-14
Message-ID: <20221024144200.021d5b35@kernel.org>
In-Reply-To: <20221024110816.anp6pxu2tjowizh7@sx1>
References: <20221024061220.81662-1-saeed@kernel.org>
        <20221024110816.anp6pxu2tjowizh7@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Oct 2022 12:08:16 +0100 Saeed Mahameed wrote:
> Please don't pull yet, I will submit V3 since one patch needs to be fixed.
> Sorry about the clutter.

Happens, but the rules are the rules:

https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#tl-dr

please don't repost stuff within 24 hours. You should also start
obeying the series length limit.
