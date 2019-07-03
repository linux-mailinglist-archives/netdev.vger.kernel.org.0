Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 835075E7D7
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 17:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfGCP3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 11:29:05 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41014 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfGCP3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 11:29:05 -0400
Received: by mail-qt1-f195.google.com with SMTP id d17so2464998qtj.8
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 08:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6ITfgvCoSDquYzNHx50rE0eTR8cXMCjfYa33YYyA+tI=;
        b=TnLbUwYle2MzE4+4LC6Y7RdNmlRh1uybKz5e3u1RxNObo1Zsq/k5RndgT1J4A9GGaK
         w3On5jV0RtoKJCMno1sVlHBMKOPoiC89SJNTOPyBxzsEvn9LI87d7KaElhRj7Rg5MuwU
         DvkNM5Q14qVmMv5McIMgU2kfGaRpEle6fPWgmLfTC7zFr2ms2J1h3YGYxiVSGbrB3iRD
         iTVMTP7rc9JGP0v0a6YVA3UWg1LX3U+LQ7j2q1lCqWQHFbDSUGZ8sTPd2sQQiQ7CA4fX
         PZRvV99ljdBDcKYxoyLcmRlm1/PxZzg+/wfuYo3C7553j6suurW15ix8xB/+bfpZPjLn
         sKGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6ITfgvCoSDquYzNHx50rE0eTR8cXMCjfYa33YYyA+tI=;
        b=AAh7l6P9+ebdgi4l8bU1zfr1/T5B/dMlTvzI5j9k6S1OwKePa1g58Kg7K4TiFmUk4N
         MMLwvKh8x9s+rYw49SvkB0dw1UMCnk87em4V0mgm9cbz+RmH8xpSBBMKjRhHkWZCmmh1
         x6VWMlua159kReNmeLzz72xfdzxgC1lawMYQ/ZF+bXrj4Pq2zf7/XBANYhuuklC4UUU7
         1FiapFGcIBkDc9WAsgsMQyCWD2Qnonr2tdi/Sq6zeZjVH3uiwyKY12eWkt6fMzAnBOi3
         CA0m3N3pVi3Wm6JcPPJa2Qry6Bk4b7OyE6enzi3eO661GNFNQy/yfSgEvF0+7yq3RaBW
         PeLw==
X-Gm-Message-State: APjAAAXAXIJ13CKYwUKsQkJU6QgqJACyu3ITV8gMc9Ag+wI1DZLsmo1D
        TnGJ0iKK4brumzo8DIRH+bmSUw==
X-Google-Smtp-Source: APXvYqwAuc7UEfIDHechO/jvBiVuRjhU6so0LdDMnPpFWwShwUOdiDH4g5R1okJt/iH7VGdpNIi2yQ==
X-Received: by 2002:a05:6214:1249:: with SMTP id q9mr32193857qvv.154.1562167744166;
        Wed, 03 Jul 2019 08:29:04 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id b67sm1097108qkd.82.2019.07.03.08.29.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Jul 2019 08:29:03 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hihBv-00009v-0f; Wed, 03 Jul 2019 12:29:03 -0300
Date:   Wed, 3 Jul 2019 12:29:03 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v2 00/13] DEVX asynchronous events
Message-ID: <20190703152902.GA582@ziepe.ca>
References: <20190630162334.22135-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190630162334.22135-1-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 30, 2019 at 07:23:21PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Changelog:
>  v1 -> v2:
>  * Added Saeed's ack to net patches
>  * Patch #2:
>   * Fix to gather user asynchronous events on top of kernel events.
>  * Patch #7:
>   * Fix obj_id to be 32 bits.
>  * Patch #8:
>   * Inline async_event_queue applicable fields into devx_async_event_file.
>   * Move to use bitfields in few places rather than flags.
>   * Shorten name of UAPI attribute.
>  * Patch #10:
>   * Use explicitly 'struct file *' instead of void *
>   * Store struct devx_async_event_file * instead of uobj * on the subscription.
>   * Drop 'is_obj_related' and use list_empty instead.
>   * Drop the temp arrays as part of the subscription API and move to simpler logic.
>   * Revise devx_cleanup_subscription() to be success oriented without
>     the is_close flag.
>   * Leave key level 1 in the tree upon bad flow to prevent a race with IRQ flow.
>   * Fix some styling notes.
>  * Patch #11:
>   * Use rcu read lock also for the un-affiliated event flow.
>   * Improve locking scheme as part of read events.
>   * Return -EIO as soon as destroyed occurred.
>   * Use a better errno as part read event failure when the buffer size
>     was too small.
>   * Upon hot unplug call wake_up_interruptible() unconditionally.
>   * Use eqe->data for affiliated events header.
>   * Fix some styling notes.
>  * Patch #12:
>   * Use rcu read lock also for the first XA layer.
>  * Patch #13:
>   * A new patch to clean up mdev usage from devx code, it can be accessed
>     from ib_dev now.
>  v0 -> v1:
>  * Fix the unbind / hot unplug flows to work properly.
>  * Fix Ref count handling on the eventfd mode in some flow.
>  * Rebased to latest rdma-next
> 
> Thanks
> 
> >From Yishai:
> 
> This series enables RDMA applications that use the DEVX interface to
> subscribe and read device asynchronous events.
> 
> The solution is designed to allow extension of events in the future
> without need to perform any changes in the driver code.
> 
> To enable that few changes had been done in mlx5_core, it includes:
>  * Reading device event capabilities that are user related
>    (affiliated and un-affiliated) and set the matching mask upon
>    creating the matching EQ.
>  * Enable DEVX/mlx5_ib to register for ANY event instead of the option to
>    get some hard-coded ones.
>  * Enable DEVX/mlx5_ib to get the device raw data for CQ completion events.
>  * Enhance mlx5_core_create/destroy CQ to enable DEVX using them so that CQ
>    events will be reported as well.
> 
> In mlx5_ib layer the below changes were done:
>  * A new DEVX API was introduced to allocate an event channel by using
>    the uverbs FD object type.
>  * Implement the FD channel operations to enable read/poo/close over it.
>  * A new DEVX API was introduced to subscribe for specific events over an
>    event channel.
>  * Manage an internal data structure  over XA(s) to subscribe/dispatch events
>    over the different event channels.
>  * Use from DEVX the mlx5_core APIs to create/destroy a CQ to be able to
>    get its relevant events.
> 
> Yishai
> 
> Yishai Hadas (13):
>   net/mlx5: Fix mlx5_core_destroy_cq() error flow
>   net/mlx5: Use event mask based on device capabilities
>   net/mlx5: Expose the API to register for ANY event
>   net/mlx5: mlx5_core_create_cq() enhancements
>   net/mlx5: Report a CQ error event only when a handler was set
>   net/mlx5: Report EQE data upon CQ completion
>   net/mlx5: Expose device definitions for object events
>   IB/mlx5: Introduce MLX5_IB_OBJECT_DEVX_ASYNC_EVENT_FD
>   IB/mlx5: Register DEVX with mlx5_core to get async events
>   IB/mlx5: Enable subscription for device events over DEVX
>   IB/mlx5: Implement DEVX dispatching event
>   IB/mlx5: Add DEVX support for CQ events
>   IB/mlx5: DEVX cleanup mdev

This looks OK now, can you please apply the net patches to the shared
branch

Thanks,
Jason
