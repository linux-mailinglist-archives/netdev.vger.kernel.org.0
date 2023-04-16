Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02EF86E3770
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 12:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjDPK2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 06:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjDPK2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 06:28:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933D3170D;
        Sun, 16 Apr 2023 03:28:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D95D60EA1;
        Sun, 16 Apr 2023 10:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9A9C4339C;
        Sun, 16 Apr 2023 10:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681640917;
        bh=KR09tN/zeQ96freak080twLbwIvOVWD7467kDgwXVkY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JCI7s4dcyAva5cM9d0Vb2RhN2hJ2ag4m6/S/kqqq2NM6hwdHtmEd6oj2v5DTvPwI0
         7ddTgLJz8PmaIkkt76e4nc7lZYlAwocRaUcAVQTyRnpDCFCmigTpnGLm0UUAcXtGDE
         BopWb1cyo+9glJA/nZG9K1iw+6imWC9HS19E64zt8x0N+1S7Kmw6DgXvqXCP+a3ZgQ
         kCfKir+rTGvXZvq7JG6W6Pf6O1QpBe3OytszzvkIXnehA1Kldm1U4Vffpop/iRKyTA
         EpcRvv8pMiBQ5MAJO9CJQzpt93D6NsX60YEOrPCTTDIfJ1GDqe3J8m7mw7EZV3k0Wb
         U7sF8N8vkvSqA==
Date:   Sun, 16 Apr 2023 13:28:33 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Avihai Horon <avihaih@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Meir Lichtinger <meirl@mellanox.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: Re: [PATCH rdma-next 0/4] Allow relaxed ordering read in VFs and VMs
Message-ID: <20230416102833.GD15386@unreal>
References: <cover.1681131553.git.leon@kernel.org>
 <ZDVoH0W27xo6mAbW@nvidia.com>
 <7c5eb785-0fe7-e0e5-8232-403e1d3538ac@intel.com>
 <20230413124929.GN17993@unreal>
 <ZDgVuIbnTCPYVVpa@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDgVuIbnTCPYVVpa@nvidia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 11:46:16AM -0300, Jason Gunthorpe wrote:
> On Thu, Apr 13, 2023 at 03:49:29PM +0300, Leon Romanovsky wrote:
> 
> > > that it fixes a setup with VF and VM, so I think thats an ok thing to
> > > call out as the goal.
> > 
> > VF or VM came from user perspective of where this behavior is not
> > correct. Avihai saw this in QEMU, so he described it in terms which
> > are more clear to the end user.
> 
> Except it is not clear, the VF/VM issue is more properly solved by
> showing the real relaxed order cap to the VM.

I'm not convinced that patch restructure is really needed for something
so low as fix to problematic FW. I'm applying the series as is and
curious reader will read this discussion through Link tag from the
patch.

Thanks
