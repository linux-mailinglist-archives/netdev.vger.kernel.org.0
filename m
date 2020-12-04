Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE35A2CF1DD
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 17:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729619AbgLDQ0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 11:26:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:48254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgLDQ0k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 11:26:40 -0500
Date:   Fri, 4 Dec 2020 08:25:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607099160;
        bh=MHHKkmoKjWu0cQa0MJSAx0XzbIRrcNJEsWUXYjQipb8=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=MLvlA35HN4ohV3iZow6D9YHeAHxFSJ3uPa6MbZFLdDwWj7Zyr58H/PSnExYJOqODJ
         EfJWAWip59iY29pTqqNIqPGFXN10Iia11P11c9xb/Ln6SHa9G+Slpdy60vJ2bligCR
         LW7Jh9uEV4sjc0I6m+IJY8uYG4cCeDZrLDhRVK65CeT/lLo3Yq3WouzIdZ25VmIhpK
         63d75Jb50lFlvPYXyXAfZ2Wdgh9YuYPRZM7gr+at0ocFyndIuSyVe6yz+X4ABBG3y7
         gJ+Z27Ur7XalOsKughxN9oyVa4LJLeGZdNlTKCS33IZ1vWueF3VN+GCIir5zUDkw9I
         j6zMFjspjvd3w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, jgg@nvidia.com,
        Dan Williams <dan.j.williams@intel.com>, broonie@kernel.org,
        lgirdwood@gmail.com, davem@davemloft.net,
        Kiran Patil <kiran.patil@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Parav Pandit <parav@mellanox.com>,
        Martin Habets <mhabets@solarflare.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
Message-ID: <20201204082558.4eb8c8c2@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204125455.GI16543@unreal>
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
        <X8os+X515fxeqefg@kroah.com>
        <20201204125455.GI16543@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 14:54:55 +0200 Leon Romanovsky wrote:
> Thanks, pulled to mlx5-next
> 
> Jason, Jakob,
> 
> Can you please pull that mlx5-next branch to your trees?
> git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git

Could you post a PR with a proper description and so on?

Thanks!
