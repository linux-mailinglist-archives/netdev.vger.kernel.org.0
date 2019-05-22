Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED4F326920
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 19:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729500AbfEVRbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 13:31:19 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44942 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbfEVRbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 13:31:19 -0400
Received: by mail-qt1-f194.google.com with SMTP id f24so3329149qtk.11
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 10:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=65KMc78WIJ4Efgbf0OwQoH4lZvzbKWf3SvGdMZQZn9k=;
        b=V3Zccg2NYeXex5+zxYNBudeAowNCUm307VB3GnML4usDDi4s+5PqaZfWBJJsBq27nD
         7w8vQdFue3G1Le3K+Dyzyy1b8Y9YbmAhJCJ1I9AAD8n56vLboXhMPuE6PrNRGvdMYJs3
         vEp/gh0C5SvF5IBXbUXDVndu6c1gl35vaTSonemnPJ+SQeBWACBMEApDgnMpuKHoZTDf
         ugNZB4JFBUys9UGWD3yGjXdJhxu9a7FYUjbXV5Q2gjSFj5Q2hmL5BGzMOqamqT3xfB4M
         ji4E1PaIfxt9ofRHbbsHGr2DOKzsHtF7QdHM3cMgmodQ3ev6cWD4TDMOhYLtQ5qpdUZo
         7aFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=65KMc78WIJ4Efgbf0OwQoH4lZvzbKWf3SvGdMZQZn9k=;
        b=DfEuYaxHM/PyCEosxTANlj/2VwDpRA9m9iCeAFJNQhSV/0PBP45EBJ4o18n/skpjy1
         +qc75dNPfOa5D9H55FCUaPh7iZ+0uVh0CWFhnE7MfsbzuUyHOTxb7ZslY3xfoua4mERm
         xGsNJyZJVfAhtDH9uR8gfuA/9DSE4gaQMKAJbD43fVgGgfgpyPquVwnGm/TUFaMSlOYZ
         3oLnxqdZKHK5Dz/b+LjB+CJk+5iX3u0ScyKdybCIsxpslHlyaFc8e8ao6eDrlTRcPehk
         aMgoAeH9xsBLMb5YtkaBdEs4ExQTOynFtAll0HbSIZJNuM34Ld5WY19eLkq7xWp4PfuA
         GHFg==
X-Gm-Message-State: APjAAAV/aYtWC12DqbPwyNzS2ZG0umKyzz/PoMJR1bDLKc6GfPttvtYc
        fsMx1NokDeCLWIAtV8IdTaY+Yg==
X-Google-Smtp-Source: APXvYqylkq6A8f+KrqSU5uMFTPncURlyOC5Yi6LJmt20xTh3bw94ZseLGkCyIUCdGHbuH6a0qT2yDw==
X-Received: by 2002:a0c:93c7:: with SMTP id g7mr59487939qvg.4.1558546278251;
        Wed, 22 May 2019 10:31:18 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-49-251.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.49.251])
        by smtp.gmail.com with ESMTPSA id r129sm12204273qkb.9.2019.05.22.10.31.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 May 2019 10:31:17 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hTV5B-00046Z-Eb; Wed, 22 May 2019 14:31:17 -0300
Date:   Wed, 22 May 2019 14:31:17 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v2 00/17] Statistics counter support
Message-ID: <20190522173117.GH15023@ziepe.ca>
References: <20190429083453.16654-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190429083453.16654-1-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 11:34:36AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Changelog:
>  v1 -> v2:
>  * Rebased to latest rdma-next
>  v0 -> v1:
>  * Changed wording of counter comment
>  * Removed unneeded assignments
>  * Added extra patch to present global counters
> 
>  * I didn't change QP type from int to be enum ib_qp_type,
>    because it caused to cyclic dependency between ib_verbs.h and
>    rdma_counter.h.
> 
> 
> Hi,
> 
> This series from Mark provides dynamic statistics infrastructure.
> He uses netlink interface to configure and retrieve those counters.
> 
> This infrastructure allows to users monitor various objects by binding
> to them counters. As the beginning, we used QP object as target for
> those counters, but future patches will include ODP MR information too.
> 
> Two binding modes are supported:
>  - Auto: This allows a user to build automatic set of objects to a counter
>    according to common criteria. For example in a per-type scheme, where in
>    one process all QPs with same QP type are bound automatically to a single
>    counter.
>  - Manual: This allows a user to manually bind objects on a counter.
> 
> Those two modes are mutual-exclusive with separation between processes,
> objects created by different processes cannot be bound to a same counter.
> 
> For objects which don't support counter binding, we will return
> pre-allocated counters.
> 
> $ rdma statistic qp set link mlx5_2/1 auto type on
> $ rdma statistic qp set link mlx5_2/1 auto off
> $ rdma statistic qp bind link mlx5_2/1 lqpn 178
> $ rdma statistic qp unbind link mlx5_2/1 cntn 4 lqpn 178
> $ rdma statistic show
> $ rdma statistic qp mode

Can you please include the command outputs?

Jason
