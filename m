Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D74953ABE6
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 19:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356316AbiFARap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 13:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353270AbiFARan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 13:30:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A63278EE5;
        Wed,  1 Jun 2022 10:30:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 931FD61620;
        Wed,  1 Jun 2022 17:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DAFC385B8;
        Wed,  1 Jun 2022 17:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654104642;
        bh=a832ioUaOSVyFBNhG9K7AC4xRHm+qbPB40MM4S/Ef8Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GQIRltCOp2k1iwbnHyMeFDWf7WcH0VPl8mUGVu0/TbFkRHOM04WRQpLKUBESCh4jg
         jbvXBSGS3CStqWYw+GzLF0FFdNFF9uosuTAL1jz1VglRgSQ1ku+dJ14BWOqcGJ6rLf
         haZ655juMOHscCGULm6IgMCwUCko7554zya8s02ItrR7d8SqPAqSG1Iwf5cSvH4mxO
         Fau8dPJy+U6fEiVzwmhe3urlaazA9MQgKKROn6p/ltlMAlmUBKiu2lh/29iMp3P5QY
         2yuFhV+7HzoXl91BH9ktix88E6Xg3x4a4N0OTIzABdXyLGuNMhB7WRjnqwX2xQBk++
         10iaIM+JCjYYA==
Date:   Wed, 1 Jun 2022 10:30:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: Re: [PATCH] MAINTAINERS: adjust MELLANOX ETHERNET INNOVA DRIVERS to
 TLS support removal
Message-ID: <20220601103032.28d14fc4@kicinski-fedora-PC1C0HJN>
In-Reply-To: <Ypc85O47YoNzUTr5@unreal>
References: <20220601045738.19608-1-lukas.bulwahn@gmail.com>
        <Ypc85O47YoNzUTr5@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Jun 2022 13:18:12 +0300 Leon Romanovsky wrote:
> On Wed, Jun 01, 2022 at 06:57:38AM +0200, Lukas Bulwahn wrote:
> > Commit 40379a0084c2 ("net/mlx5_fpga: Drop INNOVA TLS support") removes all
> > files in the directory drivers/net/ethernet/mellanox/mlx5/core/accel/, but
> > misses to adjust its reference in MAINTAINERS.
> > 
> > Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
> > broken reference.
> > 
> > Remove the file entry to the removed directory in MELLANOX ETHERNET INNOVA
> > DRIVERS.
> > 
> > Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> > ---
> > Leon, please pick this minor non-urgent clean-up patch on top of the commit
> > above.  
> 
> Thanks, we will submit it once net-next will be open.

It should go via net FWIW.
