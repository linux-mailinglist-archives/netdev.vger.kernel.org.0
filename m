Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC54431578B
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 21:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbhBIUNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 15:13:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:33230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233284AbhBITyl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 14:54:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D75D64E8C;
        Tue,  9 Feb 2021 19:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612900375;
        bh=ek97BP+xOjhIU7iF7kplNODnTgRoWDz8r6pathXFJFM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yt2zXD2D5aNutEV+u1Fyr8Hpg/VrR7nJkrsWgf/jorplQ8r4DDajqdvK7FLcEruae
         WtNySN1yUfuC83cp+FV+do7SFzVHZvsDpGQ2soDA2oE+eU4VXsz/7nl8nFjrmUkTrr
         CUYGN0BVIRHLIc0OsysUB1if+60jDW60CuikLoMeAC/Od+Paz/FyfONnU5TczCUopQ
         g0jo1TPHZ0dgsY3bC1SapwoxG+9266GT93JuyTirrWgbCdrp46MKlBHNEkFQLBawbz
         9aDw7h0VDF3GJis4Qix5YlNFhlg/jrPEHCaPlR1aXDFQON20tHwxKQwGyQEIqpf417
         tVT9rrujk6pyA==
Date:   Tue, 9 Feb 2021 11:52:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH mlx5-next 1/2] net/mlx5: Add new timestamp mode bits
Message-ID: <20210209115254.283fbb71@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210209191424.GE139298@unreal>
References: <20210209131107.698833-1-leon@kernel.org>
        <20210209131107.698833-2-leon@kernel.org>
        <20210209102825.6ede1bd4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210209191424.GE139298@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Feb 2021 21:14:24 +0200 Leon Romanovsky wrote:
> On Tue, Feb 09, 2021 at 10:28:25AM -0800, Jakub Kicinski wrote:
> > On Tue,  9 Feb 2021 15:11:06 +0200 Leon Romanovsky wrote:  
> > You also need to CC Richard.  
> 
> We are not talking about PTP, but about specific to RDMA timestamp mechanism
> which is added to the CQE (completion queue entry) per-user request when
> he/she creates CQ (completion queue). User has an option to choose the format
> of it for every QP/RQ/SQ.

I see. Perhaps Richard won't be interested then but best to give him 
a chance.

Not directly related to series at hand but how is the clock synchronized
between system and device for the real time option?
