Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97C04C1F8D
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244780AbiBWXVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239454AbiBWXVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:21:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F1A58E60;
        Wed, 23 Feb 2022 15:20:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 414BD619D9;
        Wed, 23 Feb 2022 23:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E1EC340E7;
        Wed, 23 Feb 2022 23:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645658432;
        bh=87dCMONaMgkeCOdFT6GAQCKKy4B19xIWjSEv64NgLG8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AJtZ4sRbsDC5VVaw3gz0y0oy4T4u8CrmF4n/2S7sY2IelePPPmWyLIK7snuE7Oo+7
         R2krwGDBCCCG/L8+KwbEPm2XWpXzpc6Qq0pVF7UYRlRvC0qf8mHafKyXa2bUIja3mq
         5ccqoodSbe+8DvYca0SkKSPV947cU72yli1r7VPRMLHtFCJe7KXbZS2jzVohFVxpnq
         AYKSG0AIl7RGmDntrLT0OSNyMNZjs7ytf9iin6GcApGDBHlYSR8U/1Lr0SXRnnLqO7
         br73eaGVDUE5NSlWLagCxek42jdW258E7/sloUtAQpEbIM4igNJ9fkRZtp/cphGgFb
         hA4NOrklu9Omg==
Date:   Wed, 23 Feb 2022 15:20:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [mlx5-next 13/17] net/mlx5: Use mlx5_cmd_do() in core
 create_{cq,dct}
Message-ID: <20220223152031.283993fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220223050932.244668-14-saeed@kernel.org>
References: <20220223050932.244668-1-saeed@kernel.org>
        <20220223050932.244668-14-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Feb 2022 21:09:28 -0800 Saeed Mahameed wrote:
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

nit: double-signed
