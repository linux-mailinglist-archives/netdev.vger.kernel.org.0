Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFDA1626593
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 00:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbiKKXdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 18:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234262AbiKKXdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 18:33:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7DF657F;
        Fri, 11 Nov 2022 15:33:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0C0162155;
        Fri, 11 Nov 2022 23:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE41C433D6;
        Fri, 11 Nov 2022 23:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668209622;
        bh=nDPYiP7VwE1mmawoL5nOdzxHbUQkJEXUMsSs9a+yj90=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J4ggrwe6Tj5JEHFib3mKeDNXS+QHnJh87+hnDb0nVsX33gRqnbMdwz8lcQv/4Iu91
         1mQh+AMhndb3EdVP8GuQ2MKYU+omjnuEiUdyiYL1YSLXEttUxN2IZkvq0CG3c4AhCp
         s2q2hfDmCKLVVlBYUKjqolxlpmvz58QitPjsQrGX9jDMzid3wY4sOO3sfV2kgSHs9/
         /Q6pc61Q1yDcRXzBh0TlaFET5jXSEvlTlhysqy+5hW5UbMDfF+1Q4uF8/Ow53gF7lb
         n29srFkIFLBOn+dTQQcQQ8a7ye6uVXmW40CGJdIKzbkcZIgeiPxG5/0GogoRxorE16
         EXuyzi+7Z/Vkw==
Date:   Fri, 11 Nov 2022 15:33:30 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     YueHaibing <yuehaibing@huawei.com>, borisp@nvidia.com,
        saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lkayal@nvidia.com, tariqt@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net/mlx5e: Use kzalloc() in
 mlx5e_accel_fs_tcp_create()
Message-ID: <Y27bysXT2DeuJduz@x130.lan>
References: <20221110134319.47076-1-yuehaibing@huawei.com>
 <939ca9bb-0207-2b14-8d44-09c47deb72c6@gmail.com>
 <Y27KCjxQmqHe4uSM@x130.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y27KCjxQmqHe4uSM@x130.lan>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11 Nov 14:17, Saeed Mahameed wrote:
>On 10 Nov 17:01, Tariq Toukan wrote:
>>
>>
>>On 11/10/2022 3:43 PM, YueHaibing wrote:
>>>'accel_tcp' is allocted by kvzalloc() now, which is a small chunk.
            typo: ^allocated

I will fix this prior to submission to net-next.

