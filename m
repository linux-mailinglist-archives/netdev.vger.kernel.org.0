Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE29C19DBC
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 15:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbfEJNCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 09:02:24 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39043 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727258AbfEJNCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 09:02:24 -0400
Received: by mail-qt1-f195.google.com with SMTP id y42so6431752qtk.6
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 06:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=hD5rcq5M6MZBdMm/3C86VJcbwEUEv5Pz4Zi1spwrC5U=;
        b=lnZceYZFfEDq6v9mmP4lJr4TvlXyv9H4bWxtEzv8D7LyWeGxTnkI5BbS2ApFELqd0q
         1Lfinv3JIR0zohV/2FkktOYc4c88fxBm4K5+2OJ+oIuGVevl4gt2W9LjGkJ54W3l5Lq5
         Ft9zmv7TMlYSeOWOkP4PDkvEoBcFjtv4h/hbIaXzeHrG6br1VAy4frgvc3sPlj8iBQxt
         CoI4yzI+ujxS//9pQlfbpKaaJfkcvMW1MmO+OTugQUkAw4P4kQ/hVyf8UhrSvEGVKrcG
         F8L3+ZgMy9dT6pxOkm+jplvGD+vaFADA85rMKopOBLgWVYJIeKj7IEEg52RYLvA+fHzO
         g2eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=hD5rcq5M6MZBdMm/3C86VJcbwEUEv5Pz4Zi1spwrC5U=;
        b=QiDvxdgLIVg2VKtaoXcckqdjf3F+RjVUHJlBkQMjiBKCbmYgGjwwFofDD/kIxuEbOP
         yZtTFo697jmg2kkYG2vjgO/pd4so1bJjQKqRaEwRc3L8/xPkpVu3LoMkfJftnHjofGV9
         YRaqlgqc/tXqRmtTUX8yZpBIw5uJ94Zs0nx16EWRRnbqCijCovSy/OLEtw+YZGhfHP0+
         bbzFoUF3QB9/uhu2wVAjfPrhDyEeKS27X7dUp168CAs3OOK0qY/mamkJRCv69c7+djjs
         BYhXK2gwp4aPzTTfCCBQN/g/VNQNRLH1zpfbbKPRUPJiOeyMSfWkPU/0JW0+O9xSb+r7
         P/aQ==
X-Gm-Message-State: APjAAAX6PbP2E5GUqNmiuy4pc+rJJj6a/YdsL6CjdO1K8nLqJnxfvs+w
        JACD+wW5/Jad8uafne8IqfAlXw==
X-Google-Smtp-Source: APXvYqxU9Nf6eJ8rXDlPae5caWNzcuSy8QYJ5c2TXHzDys9U5GHQkMV5B2TFsf1p0SbkutIi+EQ1bg==
X-Received: by 2002:a0c:c91b:: with SMTP id r27mr8919472qvj.101.1557493343563;
        Fri, 10 May 2019 06:02:23 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-49-251.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.49.251])
        by smtp.gmail.com with ESMTPSA id r47sm3858379qtc.14.2019.05.10.06.02.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 10 May 2019 06:02:23 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hP5AM-0004Fq-B2; Fri, 10 May 2019 10:02:22 -0300
Date:   Fri, 10 May 2019 10:02:22 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [net-next][PATCH v2 2/2] rds: add sysctl for rds support of
 On-Demand-Paging
Message-ID: <20190510130222.GA16285@ziepe.ca>
References: <1556581040-4812-1-git-send-email-santosh.shilimkar@oracle.com>
 <1556581040-4812-3-git-send-email-santosh.shilimkar@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1556581040-4812-3-git-send-email-santosh.shilimkar@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 04:37:20PM -0700, Santosh Shilimkar wrote:
> RDS doesn't support RDMA on memory apertures that require On Demand
> Paging (ODP), such as FS DAX memory. A sysctl is added to indicate
> whether RDMA requiring ODP is supported.
> 
> Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
> Reviewed-tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
>  net/rds/ib.h        | 1 +
>  net/rds/ib_sysctl.c | 8 ++++++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/net/rds/ib.h b/net/rds/ib.h
> index 67a715b..80e11ef 100644
> +++ b/net/rds/ib.h
> @@ -457,5 +457,6 @@ unsigned int rds_ib_stats_info_copy(struct rds_info_iterator *iter,
>  extern unsigned long rds_ib_sysctl_max_unsig_bytes;
>  extern unsigned long rds_ib_sysctl_max_recv_allocation;
>  extern unsigned int rds_ib_sysctl_flow_control;
> +extern unsigned int rds_ib_sysctl_odp_support;
>  
>  #endif
> diff --git a/net/rds/ib_sysctl.c b/net/rds/ib_sysctl.c
> index e4e41b3..7cc02cd 100644
> +++ b/net/rds/ib_sysctl.c
> @@ -60,6 +60,7 @@
>   * will cause credits to be added before protocol negotiation.
>   */
>  unsigned int rds_ib_sysctl_flow_control = 0;
> +unsigned int rds_ib_sysctl_odp_support;
>  
>  static struct ctl_table rds_ib_sysctl_table[] = {
>  	{
> @@ -103,6 +104,13 @@
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec,
>  	},
> +	{
> +		.procname       = "odp_support",
> +		.data           = &rds_ib_sysctl_odp_support,
> +		.maxlen         = sizeof(rds_ib_sysctl_odp_support),
> +		.mode           = 0444,
> +		.proc_handler   = proc_dointvec,
> +	},
>  	{ }
>  };

using a read-only sysctl as a capability negotiation scheme seems
horrible to me

Jason  
