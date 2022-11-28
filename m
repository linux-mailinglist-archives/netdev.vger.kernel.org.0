Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C643563B299
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 20:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbiK1T4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 14:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232931AbiK1T4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 14:56:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16982CDD2
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 11:55:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D9F261374
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 19:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B84C433D6;
        Mon, 28 Nov 2022 19:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669665358;
        bh=5pAAqgucWmZwaxI3Czew9/kFWeWcPacMykeGnJ1HBT4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SY+e5/C/uT3qB6PkugblzWxwoK1CyeZlaZwcW6AapM1rDc6vVKjsidE8rzt3bAdWg
         hQGEwmu7ml/lAv5h7DfPojYNp4YKy/Sl0KBmxEIl4m0ebLc0l5y6NmFXcaAxnTqOqj
         f46MZFtgUg77K5Z2/A5j8FEqXZkSiGfy+xonEn3lObSBq2mBvskWCSWPFaVpFlo7Ce
         w6iVTsWx1WhEBBdEZlwYnZbb/J15R1TkncGq9uOmV7WUkOeLjOIdatBRbjtCgZ+KFh
         mfFRZwU9e++17inASO8qJQcsp+IBwoHPMoq1SstR/RMQ0Arckh8Ddvoz1sra657Pxq
         0BSoXOSSR6k+Q==
Date:   Mon, 28 Nov 2022 11:55:57 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [net 07/15] net/mlx5e: Use kvfree() in
 mlx5e_accel_fs_tcp_create()
Message-ID: <Y4USTZyzqENumz9J@fedora>
References: <20221124081040.171790-1-saeed@kernel.org>
 <20221124081040.171790-8-saeed@kernel.org>
 <822ae1fd-c059-d834-60a0-af0dc944ff9f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <822ae1fd-c059-d834-60a0-af0dc944ff9f@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24 Nov 10:32, Tariq Toukan wrote:
>
>
>On 11/24/2022 10:10 AM, Saeed Mahameed wrote:
>>From: YueHaibing <yuehaibing@huawei.com>
>>
>>'accel_tcp' is allocated by kvzalloc(), which should freed by kvfree().
>>
>>Fixes: f52f2faee581 ("net/mlx5e: Introduce flow steering API")
>>Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>>Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>>Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>>---
>
>Hi Saeed,
>There was a v3 of this, that changes the alloc side instead.
>
Thanks Tariq, that patch was Marked for -next for some reason,
and it's in my net-next queue, i think it's ok if this went to net and the
other to net-next.
