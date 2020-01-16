Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9972413FA3D
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 21:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733211AbgAPUMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 15:12:10 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38396 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730312AbgAPUMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 15:12:10 -0500
Received: by mail-qt1-f195.google.com with SMTP id c24so9186529qtp.5
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 12:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=alotGpZYwlXUu0wz6O4ZnKvcLvweKG52fSItK24TVD4=;
        b=VccVR6C+n8xU2WaZGXLoYfWHwf8LM7fVYtXH7wK4jMwYcFZVw/osv1jHz13bYyzNrR
         akT+kmBaxtv/nYKnLBXWLP50e9BheIiBksy8yWm/QvpwrzoOI7Y/03VEYzfkKwNc6hu0
         kUSWePpbf1AiwqM+e1zWa/srPr91JLz6gnVorpOut+x3FaEm7Z+9Vk8Pec/hXWbg+Trb
         RQw7/oJB8LeWRZzp1QmlXTM2xaOn/rvGmg8labbyVwjEy3uuIswmHbQz4PY97x79f1a4
         ld7ql13Rqt5v6GRJrCc+iESgUptW+M0Ywu6tYG1oBqnLBdw2osrh2NfkfljBXJMEXvld
         WlBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=alotGpZYwlXUu0wz6O4ZnKvcLvweKG52fSItK24TVD4=;
        b=sEpfJGglVwQiYiipKHcQSSQv/chdv2C2Capv5wKHJAWIFXWemynfcA4cu6Lc8ud3DJ
         Rq0YJu59yJQSk7t/biVWlSKvSCULCggzQTfeYj3TBvejo9RLPSOn2o87wPdHWk7X/f2D
         3qdndkngfP8hiD0tVIhdQDn8/jOYXNQHQFKXnZnB3rG92gfbxc+wa5/7yba+eixt9BqJ
         KoR2wby4GYXxKz1QR2uyxXi5QWMUTiRRLf85O2OenWJ/s0jbJqffggNQmRy4I9+CCx3q
         P/lNcOUdiIYaNfE3fex0XOD7TH6qLw7RxZ7VDTdDGLNshizQ0h6yLBvTqxr//xw0Y6gN
         vHLA==
X-Gm-Message-State: APjAAAVAazsDp3WQivlPdgaZSVTpFUuBkgyDGM8Nf69x98xoO1bCu2An
        B+iDcSn4gMC4w8t7bNnUQOJsAQ==
X-Google-Smtp-Source: APXvYqxQo+V/UdImuJnwyZ+95lTBNrK/SAejJARUZli/4cEF6208NJwE1lwRemo562dtfuBdlr7gww==
X-Received: by 2002:ac8:1730:: with SMTP id w45mr4343430qtj.297.1579205529259;
        Thu, 16 Jan 2020 12:12:09 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id b24sm11719685qto.71.2020.01.16.12.12.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 Jan 2020 12:12:08 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1isBUu-0007iz-B6; Thu, 16 Jan 2020 16:12:08 -0400
Date:   Thu, 16 Jan 2020 16:12:08 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Avihai Horon <avihaih@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 0/2] RoCE accelerator counters
Message-ID: <20200116201208.GI10759@ziepe.ca>
References: <20200115145459.83280-1-leon@kernel.org>
 <20200115203929.GA26829@ziepe.ca>
 <20200116091430.GA6853@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116091430.GA6853@unreal>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 11:14:30AM +0200, Leon Romanovsky wrote:
> On Wed, Jan 15, 2020 at 04:39:29PM -0400, Jason Gunthorpe wrote:
> > On Wed, Jan 15, 2020 at 04:54:57PM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@mellanox.com>
> > >
> > > Hi,
> > >
> > > Very small change, separated to two patches due to our shared methodology.
> > >
> > > Thanks
> > >
> > > Avihai Horon (1):
> > >   IB/mlx5: Expose RoCE accelerator counters
> > >
> > > Leon Romanovsky (1):
> > >   net/mlx5: Add RoCE accelerator counters
> >
> > Looks fine to me, can you update the shared branch?
> 
> Thanks, applied
> 8cbf17c14f9b net/mlx5: Add RoCE accelerator counters

Okay, applied to for-next

Thanks,
Jason
