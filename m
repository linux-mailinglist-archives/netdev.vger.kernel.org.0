Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E34945FCB7
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 20:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbfGDSJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 14:09:25 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35805 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726978AbfGDSJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 14:09:25 -0400
Received: by mail-qt1-f194.google.com with SMTP id d23so8818216qto.2
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 11:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jdGpfeBvSLIUSv4SWY60s3IcV/TCFzpZhLcU3Os+HvE=;
        b=fF+60+UI+VkXU0cMTk25qB4ilIQ3KXpJWtNMMxJe+eI264u3hxUwra4vXbldow27jH
         V7MYWT6ZGZVU6bdIesR1HVbqdcjZwOZdPZCVYt/tovg7oS72T3vugB6AbYDc+bxkz+2p
         pHlDQikJGWjojBsInGSrEduIvGs0QiZLQZAPBQMH5aVzUkqhIL26LkpwCZ4A0lvKKTKT
         6VMuS+Vyw7IscUeuhq7Pd8LCRIB2A8YR8+sLI+Ta803coVIiSun3pxtzWuUDoj9uqmCN
         OO3r5PJ45H5CUWSP12FioWGeNm9WbONdlhDyh7IZ1nWY53Sb6XxXUADJtlL0JJjAjimT
         MqoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jdGpfeBvSLIUSv4SWY60s3IcV/TCFzpZhLcU3Os+HvE=;
        b=MGlWTy03ofIj6y757EWM8yq7z0OsPfYull8wajM3ujobIC3Y993uqE0M9xJPRtoHQX
         PfQCxcn8nEFgHOBnWFkZLXW94RYdh5Ic/hO8VRi2JNL0ct38M2Qmymjt+z292L59G96a
         0mk0Nn/Edye818sJQZhgXx1Wgg+GSDpWI4+34iSpN1KPTYrFvnlcFkObgHYyqv1NLJTw
         dmGFG+aF09nURBeEglC4Woz/tXrjqIzbVLbUeWyaN6rzlMiDH4c+YTDXQvNBLNczDfC6
         wC90lZrMIIjffqq7UGLVwLaL7mQLumjfOqVt1UxuAOvYL5qVhzT5Zn86L1bKR1VhriF0
         xU6g==
X-Gm-Message-State: APjAAAUOoP6ZMypx9L/XuPLTO9g8yEJCVNrELd3KR/8cG8ydJ1xHVHZX
        3HuObJQdePzIg879rwy7jvcYOQ==
X-Google-Smtp-Source: APXvYqwHn2utmDIgUPQtRrRQlBXxAtsZ6AeJzT1Bwfbuh4+hTxVBFTaLS3rwbAfvG6uxZ1W34UKR3w==
X-Received: by 2002:ac8:354d:: with SMTP id z13mr37723850qtb.340.1562263764004;
        Thu, 04 Jul 2019 11:09:24 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id d12sm1377888qtj.50.2019.07.04.11.09.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Jul 2019 11:09:23 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hj6Ad-0001MD-4p; Thu, 04 Jul 2019 15:09:23 -0300
Date:   Thu, 4 Jul 2019 15:09:23 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v5 06/17] RDMA/counter: Add "auto"
 configuration mode support
Message-ID: <20190704180923.GA2700@ziepe.ca>
References: <20190702100246.17382-1-leon@kernel.org>
 <20190702100246.17382-7-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702100246.17382-7-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 02, 2019 at 01:02:35PM +0300, Leon Romanovsky wrote:
> From: Mark Zhang <markz@mellanox.com>
> 
> In auto mode all QPs belong to one category are bind automatically to
> a single counter set. Currently only "qp type" is supported.
> 
> In this mode the qp counter is set in RST2INIT modification, and when
> a qp is destroyed the counter is unbound.
> 
> Signed-off-by: Mark Zhang <markz@mellanox.com>
> Reviewed-by: Majd Dibbiny <majd@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/core/counters.c | 221 +++++++++++++++++++++++++++++
>  drivers/infiniband/core/device.c   |   3 +
>  drivers/infiniband/core/verbs.c    |   9 ++
>  include/rdma/ib_verbs.h            |  18 +++
>  include/rdma/rdma_counter.h        |   8 ++
>  5 files changed, 259 insertions(+)
> 
> diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
> index 6167914fba06..60639452669c 100644
> +++ b/drivers/infiniband/core/counters.c
> @@ -54,6 +54,227 @@ int rdma_counter_set_auto_mode(struct ib_device *dev, u8 port,
>  	return ret;
>  }
>  
> +static struct rdma_counter *rdma_counter_alloc(struct ib_device *dev, u8 port,
> +					       enum rdma_nl_counter_mode mode)
> +{
> +	struct rdma_counter *counter;
> +
> +	if (!dev->ops.counter_dealloc)
> +		return NULL;
> +
> +	counter = kzalloc(sizeof(*counter), GFP_KERNEL);
> +	if (!counter)
> +		return NULL;
> +
> +	counter->device    = dev;
> +	counter->port      = port;
> +	counter->res.type  = RDMA_RESTRACK_COUNTER;
> +	counter->mode.mode = mode;
> +	kref_init(&counter->kref);
> +	mutex_init(&counter->lock);
> +
> +	return counter;
> +}
> +
> +static void rdma_counter_free(struct rdma_counter *counter)
> +{
> +	rdma_restrack_del(&counter->res);
> +	kfree(counter);
> +}
> +
> +static void auto_mode_init_counter(struct rdma_counter *counter,
> +				   const struct ib_qp *qp,
> +				   enum rdma_nl_counter_mask new_mask)
> +{
> +	struct auto_mode_param *param = &counter->mode.param;
> +
> +	counter->mode.mode = RDMA_COUNTER_MODE_AUTO;
> +	counter->mode.mask = new_mask;
> +
> +	if (new_mask & RDMA_COUNTER_MASK_QP_TYPE)
> +		param->qp_type = qp->qp_type;
> +}
> +
> +static bool auto_mode_match(struct ib_qp *qp, struct rdma_counter *counter,
> +			    enum rdma_nl_counter_mask auto_mask)
> +{
> +	struct auto_mode_param *param = &counter->mode.param;
> +	bool match = true;
> +
> +	if (rdma_is_kernel_res(&counter->res) != rdma_is_kernel_res(&qp->res))
> +		return false;
> +
> +	/* Ensure that counter belong to right PID */
> +	if (!rdma_is_kernel_res(&counter->res) &&
> +	    !rdma_is_kernel_res(&qp->res) &&
> +	    (task_pid_vnr(counter->res.task) != current->pid))
> +		return false;
> +
> +	if (auto_mask & RDMA_COUNTER_MASK_QP_TYPE)
> +		match &= (param->qp_type == qp->qp_type);
> +
> +	return match;
> +}
> +
> +static int __rdma_counter_bind_qp(struct rdma_counter *counter,
> +				  struct ib_qp *qp)
> +{
> +	int ret;
> +
> +	if (qp->counter)
> +		return -EINVAL;
> +
> +	if (!qp->device->ops.counter_bind_qp)
> +		return -EOPNOTSUPP;
> +
> +	mutex_lock(&counter->lock);
> +	ret = qp->device->ops.counter_bind_qp(counter, qp);
> +	mutex_unlock(&counter->lock);
> +
> +	return ret;
> +}
> +
> +static int __rdma_counter_unbind_qp(struct ib_qp *qp)
> +{
> +	struct rdma_counter *counter = qp->counter;
> +	int ret;
> +
> +	if (!qp->device->ops.counter_unbind_qp)
> +		return -EOPNOTSUPP;
> +
> +	mutex_lock(&counter->lock);
> +	ret = qp->device->ops.counter_unbind_qp(qp);
> +	mutex_unlock(&counter->lock);
> +
> +	return ret;
> +}
> +
> +/**
> + * rdma_get_counter_auto_mode - Find the counter that @qp should be bound
> + *     with in auto mode
> + *
> + * Return: The counter (with ref-count increased) if found
> + */
> +static struct rdma_counter *rdma_get_counter_auto_mode(struct ib_qp *qp,
> +						       u8 port)
> +{
> +	struct rdma_port_counter *port_counter;
> +	struct rdma_counter *counter = NULL;
> +	struct ib_device *dev = qp->device;
> +	struct rdma_restrack_entry *res;
> +	struct rdma_restrack_root *rt;
> +	unsigned long id = 0;
> +
> +	port_counter = &dev->port_data[port].port_counter;
> +	rt = &dev->res[RDMA_RESTRACK_COUNTER];
> +	xa_lock(&rt->xa);
> +	xa_for_each(&rt->xa, id, res) {
> +		if (!rdma_is_visible_in_pid_ns(res))
> +			continue;
> +
> +		counter = container_of(res, struct rdma_counter, res);
> +		if ((counter->device != qp->device) || (counter->port != port))
> +			goto next;
> +
> +		if (auto_mode_match(qp, counter, port_counter->mode.mask))
> +			break;
> +next:
> +		counter = NULL;
> +	}
> +
> +	if (counter)
> +		kref_get(&counter->kref);

This still needs to be kref_get_unless_zero:

	if (counter && !kref_get_unless_zero(&counter->kref))
		counter = NULL;

Jason
