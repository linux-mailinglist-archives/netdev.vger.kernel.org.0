Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCAD5B149D
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 08:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiIHGbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 02:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiIHGbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 02:31:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415E7B2DB8;
        Wed,  7 Sep 2022 23:31:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDE81B81FBA;
        Thu,  8 Sep 2022 06:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F962C433C1;
        Thu,  8 Sep 2022 06:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662618677;
        bh=MBH435JPjpt+WHkcoE7e01pCYkEVfqhuVsiQaVjilJM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e9g1RAbnE9ZHqwJnbsVPG+fT+aWopa+6PBzkHkAuJ8iahOxUTKNG3r6WBF1jP+C1K
         fcbahjNjQNUQV9PeAILx27zE2QT1o1ThcVM5JII/R8JY7P1pnEn+gRw3DiMrkOrMWy
         rOlMXflla7lal70jmVvgzNOuqLoUGy9uiADi3jKHk9zIbOMrkFirxDUd9JkDG6pSt/
         UyJC7EZzykltlNjUXNBvUJemDIW6YxqKHKkjvs4BlR9ArS0rtgTNCMaLJ28IYpXmtl
         n93wMMrUQzAbHYo1wS2SCTcEYMHNnydLHPloD1/NmuER/YLLLg0KAavGvlfApAd7z7
         4tYdoEAl/AHtg==
Date:   Thu, 8 Sep 2022 09:31:13 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, kevin.tian@intel.com, joao.m.martins@oracle.com,
        yishaih@nvidia.com, maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [GIT PULL] Please pull mlx5 vfio changes
Message-ID: <YxmMMR3u1VRedWdK@unreal>
References: <20220907094344.381661-1-leon@kernel.org>
 <20220907132119.447b9219.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220907132119.447b9219.alex.williamson@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 01:21:19PM -0600, Alex Williamson wrote:
> On Wed,  7 Sep 2022 12:43:44 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
> 
> > Hi Alex,
> > 
> > This series is based on clean 6.0-rc4 as such it causes to two small merge
> > conficts whis vfio-next. One is in thrird patch where you should take whole
> > chunk for include/uapi/linux/vfio.h as is. Another is in vfio_main.c around
> > header includes, which you should take too.
> 
> Is there any reason you can't provide a topic branch for the two
> net/mlx5 patches and the remainder are rebased and committed through
> the vfio tree?  

You added your Acked-by to vfio/mlx5 patches and for me it is a sign to
prepare clean PR with whole series.

I reset mlx5-vfio topic to have only two net/mlx5 commits without
special tag.

https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git topic/mlx5-vfio
Everything else can go directly to your tree without my intervention.

Thanks
