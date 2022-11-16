Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9B862CE71
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 00:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234384AbiKPXBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 18:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbiKPXBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 18:01:18 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C3227167
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 15:01:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2C901CE1C9C
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 23:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582EEC433D6;
        Wed, 16 Nov 2022 23:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668639674;
        bh=Rt59CFl+xPpUzrV/pX4VwvqlUpe9b4ONwmoucnUUq1M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k/a/D2NhpxrQQMZnPQ2Y3+vLSR3I5zo6rhFNM6wc3iTKHb5KW7R2xLjjnseIG+Knq
         twSrIOT4vy2JvV+oQyfzBGpD1/NmW5iEWE2hNoBZYb2R4rhPzDOVqSR6HMgOFqi1RD
         XJvBOQwffT2Qu/viCLM2TrC7xExTX1NeFeQqT8QFnyA9ePxx9pHQzoBauxoASRtA4c
         8W0DUVlh6NuJLwKTy87FBJfcnM4XKdSsHTsblaldOwmNZ7qXzXDl9xrvDwqvr5MrGU
         +6aJgAB3YEqMF8d7tUKsJUbxGKT670oGRCH2FY26NBq9vCqnYmYEsEJRXinXB+EQyU
         Or4kCdN0hnDgw==
Date:   Wed, 16 Nov 2022 15:01:13 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Derek Chickles <dchickles@marvell.com>,
        Eric Dumazet <edumazet@google.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Satanand Burla <sburla@marvell.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>
Subject: Re: [PATCH net] net: liquidio: simplify if expression
Message-ID: <Y3VruaIDzVH7jqPQ@x130.lan>
References: <9845cbd62721437f946035669381a9719240fc89.1668533583.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <9845cbd62721437f946035669381a9719240fc89.1668533583.git.leonro@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15 Nov 19:34, Leon Romanovsky wrote:
>From: Leon Romanovsky <leonro@nvidia.com>
>
>Fix the warning reported by kbuild:
>
>cocci warnings: (new ones prefixed by >>)
>>> drivers/net/ethernet/cavium/liquidio/lio_main.c:1797:54-56: WARNING !A || A && B is equivalent to !A || B
>   drivers/net/ethernet/cavium/liquidio/lio_main.c:1827:54-56: WARNING !A || A && B is equivalent to !A || B
>
>Fixes: 8979f428a4af ("net: liquidio: release resources when liquidio driver open failed")
>Reported-by: kernel test robot <lkp@intel.com>
>Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>---
>The fixed patch was in net, so sending the fix to net too.
>---

I don't follow the above note, but anyway:

Reviewed-by: Saeed Mahameed <saeed@kernel.org>

