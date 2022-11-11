Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F10606264A3
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 23:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbiKKWb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 17:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234337AbiKKWbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 17:31:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB1B56EC8;
        Fri, 11 Nov 2022 14:31:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DED0B8281D;
        Fri, 11 Nov 2022 22:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036FBC433D7;
        Fri, 11 Nov 2022 22:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668205878;
        bh=RRxaeTg8Mv/o5Iwk8msvrvuRmEkkCophftg8hfGQADc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WSY7yio6XCWk01QsWkv3y29TpD9vTryvMLmoEcCdX7nR33x1GfeKBuzj6zQu2B5Rx
         qLD8lsydoH88UswF5ajnIx/HBQej59HtSz9Aqphb0C5xsso8IoEgeKkyQ+fPDZmuQE
         fFnaGIYZr8NG5I2z1+aKGtNQ0IrbtOwfzIohH3r8fXGWW1sfzNgK4XupJQVPaBAbW1
         hyL0eotYbYZZ3gCS4dN/kwhzhQ4GhFNbCF4zakTpQGdty5iLjlBwLwKArciJuJEMoc
         2sRpBlWxgz7UGDFpvlZ6dTKp06uLAE497D2UHNJ1Lo2EVlG3WBc36MRachFuvv3WTi
         +GB5Nvb0DJJhw==
Date:   Fri, 11 Nov 2022 14:31:17 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     zhang.songyi@zte.com.cn, saeedm@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        kliteyn@nvidia.com, shunh@nvidia.com, rongweil@nvidia.com,
        valex@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiang.xuexin@zte.com.cn, xue.zhihong@zte.com.cn
Subject: Re: [PATCH linux-next] net/mlx5: remove redundant ret variable
Message-ID: <Y27NNTSc3N222DWK@x130.lan>
References: <202211022150403300510@zte.com.cn>
 <Y2gDaRc3t7WiWoTT@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y2gDaRc3t7WiWoTT@unreal>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06 Nov 20:56, Leon Romanovsky wrote:
>On Wed, Nov 02, 2022 at 09:50:40PM +0800, zhang.songyi@zte.com.cn wrote:
>> From 74562e313cf9a1b96c7030f27964f826a0c2572d Mon Sep 17 00:00:00 2001
>> From: zhang songyi <zhang.songyi@zte.com.cn>
>> Date: Wed, 2 Nov 2022 20:48:08 +0800
>> Subject: [PATCH linux-next] net/mlx5: remove redundant ret variable
>
>Subject line should be "[PATCH net-next] ..." for all net patches.
>And please use git send-email utility to send the patches.
>
>Thanks

Also this patch doesn't apply to net-next.

