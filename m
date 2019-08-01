Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2A67DB95
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 14:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730881AbfHAMei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 08:34:38 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:36440 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfHAMeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 08:34:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1564662877; x=1596198877;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=tYN+raWvEtm9iqYNBIilIYriDvWTG2lMO3S+lWaVKY0=;
  b=JT5B4m5bxNwEwAVhX7bBalARnSisFAMafaXRpZlePFWZyXnyjnajpBD2
   ookh+a2cQxq+YjupLVZPgFd+LzkiSdKZeMNxJRlBmgF134p10oF+ZPW7N
   WuYyZ6/XLq9PRr0smAxRQ+ryti7ybd0r0u/DcnvbEdW8AkfK2CBBnfRno
   k=;
X-IronPort-AV: E=Sophos;i="5.64,334,1559520000"; 
   d="scan'208";a="815689842"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 01 Aug 2019 12:34:34 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id 56995A20D3;
        Thu,  1 Aug 2019 12:34:34 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 1 Aug 2019 12:34:33 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.162.191) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 1 Aug 2019 12:34:29 +0000
Subject: Re: [PATCH rdma-next 2/3] IB/mlx5: Expose ODP for DC capabilities to
 user
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
CC:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
References: <20190801122139.25224-1-leon@kernel.org>
 <20190801122139.25224-3-leon@kernel.org>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <12331110-ecfd-fb2f-460a-be41be13b2d3@amazon.com>
Date:   Thu, 1 Aug 2019 15:34:24 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190801122139.25224-3-leon@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.162.191]
X-ClientProxiedBy: EX13D22UWB004.ant.amazon.com (10.43.161.165) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/08/2019 15:21, Leon Romanovsky wrote:
>  enum mlx5_user_cmds_supp_uhw {
> @@ -147,6 +148,7 @@ struct mlx5_ib_alloc_ucontext_resp {
>  	__u32	num_uars_per_page;
>  	__u32	num_dyn_bfregs;
>  	__u32	dump_fill_mkey;
> +	__u32	dc_odp_caps;

This should be padded to 64 bits.

>  };
>  
>  struct mlx5_ib_alloc_pd_resp {
> 
