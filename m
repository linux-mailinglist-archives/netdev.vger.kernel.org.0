Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52CC69BF51
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 10:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjBSJFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 04:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjBSJFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 04:05:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6365B10404;
        Sun, 19 Feb 2023 01:05:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD5FEB80948;
        Sun, 19 Feb 2023 09:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9776C433D2;
        Sun, 19 Feb 2023 09:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676797541;
        bh=Y5N9kxNzj4mVW9Rmy26WnojrA0MKZejT/CGZYBB4heY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WkwQrWuITrtIqL9MUPosLl8o8wvk/3/mnolrNLlhqkTzASUPLCPAOYIVpEuknHoZg
         lApfg7KOUdw3MUx7RZM9fwddB3Z68+hbB0AKK65fF9YAynrBLlIgy9a28ArN/R+/Cc
         eS99vE+8g2uly48mqhnRyM+JP0kKgByS6NSdzqmTMLsTwzjuSsylrIPMEHu+HDf8ZJ
         7wzYn0vPatllv3dBbX5IYcmzTvqFb4SxI3VnQx76ufw5VGrvNYmLLXkCtTW4yc++Z+
         OFF4odBQ3EEyx9qLnLd8Y0BtMWhXrqR6/FPKk/LG68FuweEdGJtvE5c7mTWfjiSSu7
         akTq16X+3emkg==
Date:   Sun, 19 Feb 2023 11:05:36 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [GIT PULL] Please pull mlx5-next changes
Message-ID: <Y/HmYHgPyCKnTZrp@unreal>
References: <20230215095624.1365200-1-leon@kernel.org>
 <20230216113722.5468c863@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216113722.5468c863@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 11:37:22AM -0800, Jakub Kicinski wrote:
> On Wed, 15 Feb 2023 11:56:24 +0200 Leon Romanovsky wrote:
> > Following previous conversations [1] and our clear commitment to do the TC work [2],
> > please pull mlx5-next shared branch, which includes low-level steering logic to allow
> > RoCEv2 traffic to be encrypted/decrypted through IPsec.
> 
> I wish the assurances could have been given on the list but it is 
> what it is. Pulling to net-next as well, thanks.

Thanks a lot.
