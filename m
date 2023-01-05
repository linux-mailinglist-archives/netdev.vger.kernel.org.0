Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846B265F3DC
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 19:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235071AbjAESiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 13:38:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235067AbjAESit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 13:38:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0525F48A;
        Thu,  5 Jan 2023 10:38:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8592461C0C;
        Thu,  5 Jan 2023 18:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8614C433D2;
        Thu,  5 Jan 2023 18:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672943928;
        bh=7+bWYVXXFoTfipedHJ1MTP78Af73jqK6zESp17eTROA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O3ec/P1GS3UNdqiHXMK2TJZon0/+nniBjp5J1HjefebtQ208+jUrP/1mSuyrR/3H/
         DhKU0I6UED+ZUx3NaPrRWxelPn/qtTheBAfXsyNyUHBfU6J6qfUaIrZ3W+U19BQP0s
         Jd4CNHCKtIjtLxCdxllTlSZlzdGlGczvNOV+tk75NccWV4MN+zKMLYM+2PAzyFF5h0
         BYs19+yNdwuCqiWURmTJrGNHWYVQAD4jvJKxL5uDegQ0XLJ6YVaHw14Spc88Tzx7R/
         20dl6VjR1AGKktFcaxSo5Vh88mepnrV6gHe24E9B7ZRpVca99eJiJEp53if5wouV6w
         A+iAafvx5Qqcw==
Date:   Thu, 5 Jan 2023 10:38:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH mlx5-next 0/8] mlx5 IPsec RoCEv2 support and netdev
 events fixes in RDMA
Message-ID: <20230105103846.6dc776a3@kernel.org>
In-Reply-To: <20230105041756.677120-1-saeed@kernel.org>
References: <20230105041756.677120-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Jan 2023 20:17:48 -0800 Saeed Mahameed wrote:
>   net/mlx5: Configure IPsec steering for ingress RoCEv2 traffic
>   net/mlx5: Configure IPsec steering for egress RoCEv2 traffic

How is the TC forwarding coming along?
