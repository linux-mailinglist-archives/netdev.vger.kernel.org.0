Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3581B623B8B
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 06:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbiKJF7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 00:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKJF7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 00:59:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D116C23160;
        Wed,  9 Nov 2022 21:59:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 968C0B820D1;
        Thu, 10 Nov 2022 05:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D535C433C1;
        Thu, 10 Nov 2022 05:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668059942;
        bh=Kxi2OJfvqKxGgAAbiw6Xg1xqi29Pu3qteZH37x0jI/Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=raEaUbXqv2l8wcv7Bbh/M2h7y8Njan2AqT0NTCBKFM8vstAnuN9fyWXo2ZiuCFuuQ
         bk35EucUcBvXDjWKd+JgvjnNwG8NoZyZFnRWZRXYAx/FeuvF98llDvA76zQgYGfWg7
         /RWlg1qFBU7d2nLaVF2X5VkEd/qqDiFNz9pROVNHCSEEv2MdZBJnT3XDk7k9QWANx9
         H6IZENhdnrJXovIbIXTyowONbsOHhMLlfMOMax6evB/M5+zraPD/6iC2riFMq1qhu1
         MHr++NcHHHWpcU8yht0tVD8BT4G6CzuFxXmbhuRakzwJ6g/HJw5atJDIIs1G5ycb5F
         3vMiia8nTE8lQ==
Date:   Thu, 10 Nov 2022 07:58:57 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, edumazet@google.com,
        longli@microsoft.com, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, shiraz.saleem@intel.com,
        Ajay Sharma <sharmaajay@microsoft.com>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [Patch v10 00/12] Introduce Microsoft Azure Network Adapter
 (MANA) RDMA driver
Message-ID: <Y2yTIczYumDTPXpu@unreal>
References: <1667502990-2559-1-git-send-email-longli@linuxonhyperv.com>
 <Y2qqq9/N65tfYyP0@unreal>
 <20221108150529.764b5ab8@kernel.org>
 <Y2v2CGEWC70g+Ot+@unreal>
 <20221109120544.135f2ee2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109120544.135f2ee2@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 12:05:44PM -0800, Jakub Kicinski wrote:
> On Wed, 9 Nov 2022 20:48:40 +0200 Leon Romanovsky wrote:
> > Please pull, I collected everything from ML and created shared branch.
> > 
> > The following changes since commit f0c4d9fc9cc9462659728d168387191387e903cc:
> > 
> >   Linux 6.1-rc4 (2022-11-06 15:07:11 -0800)
> > 
> > are available in the Git repository at:
> > 
> >   https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/ mana-shared-6.2
> > 
> > for you to fetch changes up to 1e6e19c6e1c100be3d6511345842702a24c155b9:
> > 
> >   net: mana: Define data structures for protection domain and memory registration (2022-11-09 20:41:17 +0200)
> 
> 
> It's not on a common base with net-next.
> Could you rebase on something that's at or below git merge-base ?

Done, I downgraded the branch to be based on -rc3.

Thanks
