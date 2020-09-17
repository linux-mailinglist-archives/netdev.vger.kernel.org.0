Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A6526E355
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgIQSO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 14:14:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbgIQSN3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 14:13:29 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA29721973;
        Thu, 17 Sep 2020 18:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600366405;
        bh=3KvKp5SPlrlgISKNXW1jdfQK3YdcMBIEkx0JLTJYCNQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rl/kyjpbCSDPTtylICRDZ2YhkVy1eyS9wdBHkPaNpxI6Ut/OpJvl1jSAe3CNGAScd
         IRVDaOHx7GnVbPJHMqZq9glWeqzANWjozAs8rfhQaKIKcPoLfLwyn6Akr5l1Y1WbJF
         UtsvpbRegsFBoipBU0Q1l0g+SEkWPv3YfaE2G4zg=
Date:   Thu, 17 Sep 2020 21:13:21 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Doug Ledford <dledford@redhat.com>, Alex Vesker <valex@nvidia.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next 0/3] Extend mlx5_ib software steering interface
Message-ID: <20200917181321.GO869610@unreal>
References: <20200903073857.1129166-1-leon@kernel.org>
 <20200917181026.GA144224@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917181026.GA144224@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 03:10:26PM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 03, 2020 at 10:38:54AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > This series from Alex extends software steering interface to support
> > devices with extra capability "sw_owner_2" which will replace existing
> > "sw_owner".
> >
> > Thanks
> >
> > Alex Vesker (3):
> >   RDMA/mlx5: Add sw_owner_v2 bit capability
> >   RDMA/mlx5: Allow DM allocation for sw_owner_v2 enabled devices
> >   RDMA/mlx5: Expose TIR and QP ICM address for sw_owner_v2 devices
>
> Ok, can you update the shared branch with the first patch? Thanks

Done, thanks
9d8feb460adb RDMA/mlx5: Add sw_owner_v2 bit capability

>
> Jason
