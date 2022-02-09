Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B977D4AEE81
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 10:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbiBIJxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 04:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232713AbiBIJxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 04:53:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC73E0D444D;
        Wed,  9 Feb 2022 01:53:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A4E161A3E;
        Wed,  9 Feb 2022 09:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D284C340EE;
        Wed,  9 Feb 2022 09:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644400241;
        bh=xt1UN8DIjh0yXkIVv7ELaSaFc9ApH6wS1u0GwZOxqrM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m9UrSTB+iWJD43heKg6CAVsiB/p4M/PCx3KxD4t4vQMA5bT94t4ZjfY0jRJiAxyvi
         iLimqTQFN6X1aPURbw6iVQ+EbQnndxJzxuEGdq+J5FBAhGKPyPEDVf6SYqNT/Ak2lN
         S4/Lzks0H/fKc4mckNM8PAFSoEWEp8DXv1G1UYddOacQQAC2iNjZlIAMXYMlHWvCH9
         +rRdg8PO3st6yPkuOZXlTknXXVjMstjrrYM2Y5a5rVwgQYgwBXYxofyAwW2MF2vOug
         AQvjt5IzmMsDe9eDseeM/1RHEZTS7I/94TuAUoaI8xfIY9GiJ8yztpC7cCkWQj1/5q
         4m9dvg+t0BiPQ==
Date:   Wed, 9 Feb 2022 11:50:33 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/1] [pull request] iwl-next Intel Wired LAN
 Driver Updates 2022-02-07
Message-ID: <YgOOaZbP/Jvlbt8Q@unreal>
References: <20220207235921.1303522-1-anthony.l.nguyen@intel.com>
 <20220208170000.GA180855@nvidia.com>
 <6591eabecd1959c1744828dad006860520708e9a.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6591eabecd1959c1744828dad006860520708e9a.camel@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 09:18:36PM +0000, Nguyen, Anthony L wrote:
> On Tue, 2022-02-08 at 13:00 -0400, Jason Gunthorpe wrote:
> > On Mon, Feb 07, 2022 at 03:59:20PM -0800, Tony Nguyen wrote:
> > > This pull request is targeting net-next and rdma-next branches.
> > > RDMA
> > > patches will be sent to RDMA tree following acceptance of this
> > > shared
> > > pull request. These patches have been reviewed by netdev and RDMA
> > > mailing lists[1].
> > > 
> > > Dave adds support for ice driver to provide DSCP QoS mappings to
> > > irdma
> > > driver.
> > > 
> > > [1]
> > > https://lore.kernel.org/netdev/20220202191921.1638-1-shiraz.saleem@intel.com/
> > > The following are changes since commit
> > > e783362eb54cd99b2cac8b3a9aeac942e6f6ac07:
> > >   Linux 5.17-rc1
> > > and are available in the git repository at:
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/linux iwl-
> > > next
> > 
> > No signed tag?
> > 
> > In future can you send these in the standard form so patchworks will
> > pick them up?
> > 
> > Also please add cover letters so there is something to put in the
> > merge
> 
> I'm still trying to figure out how to do the shared pull requests. I'll
> look into resolving these issues you pointed out for next one.
> 
> One of the things I'm still unsure on is whether the shared pull
> request should contain the netdev and RDMA patches or only the netdev
> ones.

Shared PR intends to solve merge conflicts between various subsystems.

It means that sometimes both netdev and RDMA patches will be there,
however such situation is not common flow. Most of the time, you will
put only netdev changes there, because your driver core logic lays
there and it is there the conflicts will be.

However, there are minimal set of rules which you should follow:
1. This branch should be based on clean -rcX. No back merge of net-next
or rdma-next or other -next.
2. Bisectable
3. Possible to pull as a standlone set without extra patches on top
and it won't break compilation and/or working target which pulled this
branch.

Thanks

> 
> Thanks,
> Tony
> 
> > But PR applied along with the matching two RDMA patches.
> > Thanks,
> > Jason
> 
