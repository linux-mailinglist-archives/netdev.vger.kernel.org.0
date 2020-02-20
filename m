Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6A6166542
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 18:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgBTRqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 12:46:14 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:40290 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbgBTRqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 12:46:14 -0500
Received: by mail-il1-f196.google.com with SMTP id i7so24437505ilr.7;
        Thu, 20 Feb 2020 09:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qBBNMKUcNm8T4fpRai/rl5UhQq4ga4evC5tXW6MhA84=;
        b=rL6BVLn7dSEFFP00LXXOAomv82PjKRVHK3vNGPqMO4tDrX/4+wcrbjO5q8HpGT+MQ/
         xe4XDd4iOaWZr9v31UiFOVPA12cjXAVQgTnDAxsArJ/fuBMtMOWx9nXQoBQ6pGhcFsJa
         GNWy0G8THhFP+6YqkFFOLJwBBdQDnucv169yzZdxy3K2PlOVOBhiwLkfxLUedI+KHxoe
         wEwyjTc7wmQGSqfc7quN+07sWzugiqoqr0nXpSgOQ33ezq4eTpnBSl/h+cIbDdP0Rbec
         onS2k5AE7YJREjeqkZ3Q1EMy5i07bLK1QX/bC3TtD4bJTV1sw+Mz5GWvSevi0LNomNKC
         GcNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qBBNMKUcNm8T4fpRai/rl5UhQq4ga4evC5tXW6MhA84=;
        b=QhryWf31F8cbhwOlLVaxC8uNn0h6lO9cTBFr5RbOTxwh8eSQN71IdzFWCKIeTQPDSE
         vlvzQ2IQUbYjniEPGuq42+ORrAgY7iexJsEwdbivkyYPwmWx3o/WR9V4YZRiYtXxjyK2
         RJyU/ZUsii3jchFmBDucTcScn55cUXiKOhZtJxh/yKLY24wHw82RhiMHBHLeK3tQmBgs
         a4niPFo87M5uE4hbKajKhtJL+Vd+CbNsqj69tUqLScGUY/oERd9hyN3h02aHwR4NMQEv
         zlgpteNweCfaLndgDy77vLVdh0JKHp+n7XHcnF7CSR2dGfBzp221gRDReVB+mpyjBBFp
         ljiQ==
X-Gm-Message-State: APjAAAXnMbEcb9iSTlbSgsx++Feg0QeE/AV7SeZqBlXCO4cqzRkQmKFU
        e+NSZUXjqQsRVyH9O3R6kqWq2m+cbMwx5eWjIEw=
X-Google-Smtp-Source: APXvYqwOeMGw8evFb77jExmVuuGDGQpf5MNYOXARvEIvuro4NRouKU15AJznoNLZzokfO5ubGALRQtHHkQ+U/VyOoDI=
X-Received: by 2002:a92:d608:: with SMTP id w8mr29184626ilm.95.1582220773769;
 Thu, 20 Feb 2020 09:46:13 -0800 (PST)
MIME-Version: 1.0
References: <1581996935-46507-1-git-send-email-chenglang@huawei.com>
 <20200218153156.GD31668@ziepe.ca> <212eda31-cc86-5487-051b-cb51c368b6fe@huawei.com>
 <20200219064507.GC15239@unreal> <1155d15f-4188-e5cd-3e4a-6e0c52e9b1eb@huawei.com>
In-Reply-To: <1155d15f-4188-e5cd-3e4a-6e0c52e9b1eb@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 20 Feb 2020 09:46:02 -0800
Message-ID: <CAKgT0Uems7Y0hhFmXYcE0Pf2-ZNih=rm6DDALXdwib7de5wqhA@mail.gmail.com>
Subject: Re: [RFC rdma-next] RDMA/core: Add attribute WQ_MEM_RECLAIM to
 workqueue "infiniband"
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Lang Cheng <chenglang@huawei.com>,
        Doug Ledford <dledford@redhat.com>,
        David Miller <davem@davemloft.net>,
        Salil Mehta <salil.mehta@huawei.com>, yisen.zhuang@huawei.com,
        LinuxArm <linuxarm@huawei.com>, Netdev <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        bhaktipriya96@gmail.com, Tejun Heo <tj@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 11:42 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:

> Ok, I may be wrong about the above usecase.
> but the below commit explicitly state that network devices may be used in
> memory reclaim path.
>
> 0a38c17a21a0 ("fm10k: Remove create_workqueue"):
>
> fm10k: Remove create_workqueue
>
> alloc_workqueue replaces deprecated create_workqueue().
>
> A dedicated workqueue has been used since the workitem (viz
> fm10k_service_task, which manages and runs other subtasks) is involved in
> normal device operation and requires forward progress under memory
> pressure.
>
> create_workqueue has been replaced with alloc_workqueue with max_active
> as 0 since there is no need for throttling the number of active work
> items.
>
> Since network devices may be used in memory reclaim path,
> WQ_MEM_RECLAIM has been set to guarantee forward progress.
>
> flush_workqueue is unnecessary since destroy_workqueue() itself calls
> drain_workqueue() which flushes repeatedly till the workqueue
> becomes empty. Hence the call to flush_workqueue() has been dropped.
>
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>
> So:
> 1. Maybe the above commit log is misleading, and network device driver's
>    wq does not need the WQ_MEM_RECLAIM flag, then maybe document what can
>    not be done in the work queued to wq marked with WQ_MEM_RECLAIM, and
>    remove the WQ_MEM_RECLAIM flag for the wq of network device driver.

I am not sure why they added WQ_MEM_RECLAIM to the fm10k service task
thread. It has nothing to do with memory reclaim. If a memory
allocation fails then it will just run to the end and bring the
interface down. The service task is related to dealing with various
one-off events like link up and link down, sorting out hangs, and
updating statistics. The only memory allocation it is involved with is
if it has to reset the interface in which case I believe there may
even be a few GFP_KERNEL calls in there since it is freeing and
reallocating several port related structures.

> 2. If the network device driver's wq does need the WQ_MEM_RECLAIM flag, then
>    hns3 may have tow problems here: WQ_MEM_RECLAIM wq flushing !WQ_MEM_RECLAIM
>    wq problem and GFP_KERNEL allocations in the work queued to WQ_MEM_RECLAIM wq.

It seems like you could solve this by going the other way and dropping
the WQ_MEM_RECLAIM from the original patch you mentioned in your fixes
tag. I'm not seeing anything in hclge_periodic_service_task that
justifies the use of the WQ_MEM_RECLAIM flag. It claims to be involved
with memory reclaim but I don't see where that could be the case.

- Alex
