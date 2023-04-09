Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01586DBF19
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 09:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjDIHu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 03:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjDIHu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 03:50:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870A14ED4;
        Sun,  9 Apr 2023 00:50:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2263C60B3C;
        Sun,  9 Apr 2023 07:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77B4C433D2;
        Sun,  9 Apr 2023 07:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681026625;
        bh=bWsrm+hZQ2P/p4glp1FYWSKkIxW4tZoe4rXhnAEmkA8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T83EKU+BnmAKh7stoGX3vcEEiEWasGAPfBziN9DSuTfJgWPy3mbzz3GTemVKH/oZT
         xANUz8oSEC6NANnnzjrMEt6ojLfSGKIkWmU0M+hpB9Gzca7W+XAdrCdXp+0Vj5k3wU
         D+lx8jftXgVdoqhiM1jSC1+tgOh/lV429DuzbsWZKAGitLsr0m3tiA6Ih7TOXnpEuy
         s9dmtFm6qPwLAkMIo064IzrFYB92a7xmtxsFuBlkHQqY10KBUCjdxMwu8jmj+7UGDc
         BXChWgACHZDexMpKWFcgCF/q34y4UOfCw+iV6P7K/KjGEIWqnlLjt2S8nbwbg7mqpK
         yui6YmVCcXmaQ==
Date:   Sun, 9 Apr 2023 10:50:21 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [linux-next:master] BUILD REGRESSION
 6a53bda3aaf3de5edeea27d0b1d8781d067640b6
Message-ID: <20230409075021.GB14869@unreal>
References: <642c8ceb.LBEdj8abbmwftu9h%lkp@intel.com>
 <20230404174158.35ea7a71@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404174158.35ea7a71@kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 05:41:58PM -0700, Jakub Kicinski wrote:
> On Wed, 05 Apr 2023 04:47:39 +0800 kernel test robot wrote:
> > drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c:148:31: error: implicit declaration of function 'pci_msix_can_alloc_dyn' [-Werror=implicit-function-declaration]
> 
> CC: Saeed, Leon

https://lore.kernel.org/netdev/33205aa15efbafa9330a00f2f6f8651add551f49.1681026343.git.leonro@nvidia.com/T/#u

Thanks
