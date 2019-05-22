Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24ABE2691E
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 19:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbfEVRaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 13:30:13 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38408 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729059AbfEVRaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 13:30:13 -0400
Received: by mail-qt1-f194.google.com with SMTP id l3so3355437qtj.5
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 10:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=02yHKyZkjPiqn3xW/orvHX3LjN6hQ+UuzSQgIX9gZrg=;
        b=TIREhwoxTgrRvJSAYZUqRd8bCKbzcZKTTXuZgCjD38TObmlTKMkFBRThlxFYwA9SyX
         jFl4wZWQDOVbqaSnCCbqSeefcE+9LQXPa3IqrpRajcoyBjRCwq7nKCgb79lr+/iT+n5n
         cYKBtJ543aVCWdBTqd+/D6RG8yhB5fCKLecE0qmGa1FkE2hYtXeTAB7slIKyz0ZsyhQT
         v4N3lsWSsCPbRS206VQmkuKUH2Vvth36JL3TnibMML2sYNlNEtJihdCCpDAGt98qamay
         C8BwUw5J0gd5rm3YiYLa2cHvH2VlhHVQpvRyv3G3tn0PUm2shgEf+Lt0h/oa967WlJw1
         3GOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=02yHKyZkjPiqn3xW/orvHX3LjN6hQ+UuzSQgIX9gZrg=;
        b=UVwv6x/SIbnlXOVHQ8JzoMVGRF1+fCUld2eHDDMJHanA3ZF1QtMr9h3FavlXNKw14w
         fPTzEDaTRm2eQ7sO8YGcuh/PwZsxKzN/nJla+FyOFHEiqQrLFCfNzN7tPzuio7eJ09TY
         O9D+tJuP+UtTFZHVhRi50ltRjbLv/XJ0D1mdjF4LTEv29AmtPUEgb6CJRdsv4UhKjJPU
         OipsvDEGSHfVkGoixAGuqdXLlaBhCsqBRL4l0/bKx9BOY26+Iz/2um4PwdZcHnfXHnT7
         CCtZyeG6I93migXuC95NrgY6thEY023sJKY+umINazjwh/i1rw+XxC75cbsaXy3gbfQG
         M57g==
X-Gm-Message-State: APjAAAUdcccScSL/xY1OmV/xHP62jIYJQVeLpFIrmtkwe6QV2MkXaCxf
        WRGR0s1hbKNw+moPtAl5iSLGhg==
X-Google-Smtp-Source: APXvYqyNCwTiJFmEIqkvd678u8f1sPvq0ci17YwkNfPCAYlyorWskJfBBWA4TPdGElkrW7up8M8zLA==
X-Received: by 2002:a0c:8a5c:: with SMTP id 28mr33149057qvu.166.1558546212517;
        Wed, 22 May 2019 10:30:12 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-49-251.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.49.251])
        by smtp.gmail.com with ESMTPSA id f10sm6509863qkh.23.2019.05.22.10.30.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 May 2019 10:30:12 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hTV47-000462-IP; Wed, 22 May 2019 14:30:11 -0300
Date:   Wed, 22 May 2019 14:30:11 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v2 17/17] RDMA/nldev: Allow get default counter
 statistics through RDMA netlink
Message-ID: <20190522173011.GG15023@ziepe.ca>
References: <20190429083453.16654-1-leon@kernel.org>
 <20190429083453.16654-18-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190429083453.16654-18-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 11:34:53AM +0300, Leon Romanovsky wrote:
> From: Mark Zhang <markz@mellanox.com>
> 
> This patch adds the ability to return the hwstats of per-port default
> counters (which can also be queried through sysfs nodes).
> 
> Signed-off-by: Mark Zhang <markz@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/core/nldev.c | 101 +++++++++++++++++++++++++++++++-
>  1 file changed, 99 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
> index 53c1d2d82a06..cb2dd38f49f1 100644
> +++ b/drivers/infiniband/core/nldev.c
> @@ -1709,6 +1709,98 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
>  	return ret;
>  }
>  
> +static int nldev_res_get_default_counter_doit(struct sk_buff *skb,
> +					      struct nlmsghdr *nlh,
> +					      struct netlink_ext_ack *extack,
> +					      struct nlattr *tb[])
> +{
> +	struct rdma_hw_stats *stats;
> +	struct nlattr *table_attr;
> +	struct ib_device *device;
> +	int ret, num_cnts, i;
> +	struct sk_buff *msg;
> +	u32 index, port;
> +	u64 v;
> +
> +	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
> +		return -EINVAL;
> +
> +	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
> +	device = ib_device_get_by_index(sock_net(skb->sk), index);
> +	if (!device)
> +		return -EINVAL;
> +
> +	if (!device->ops.alloc_hw_stats || !device->ops.get_hw_stats) {
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
> +	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
> +	if (!rdma_is_port_valid(device, port)) {
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
> +	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!msg) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
> +			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
> +					 RDMA_NLDEV_CMD_STAT_GET),
> +			0, 0);
> +
> +	if (fill_nldev_handle(msg, device) ||
> +	    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port)) {
> +		ret = -EMSGSIZE;
> +		goto err_msg;
> +	}
> +
> +	stats = device->ops.alloc_hw_stats(device, port);
> +	if (!stats) {
> +		ret = -ENOMEM;
> +		goto err_msg;
> +	}

Why do we need yet another one of these to be allocated?

> +	num_cnts = device->ops.get_hw_stats(device, stats, port, 0);

Is '0' right here?

Jason
