Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777661DACA0
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 09:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgETHy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 03:54:58 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:38175 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgETHy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 03:54:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1589961297; x=1621497297;
  h=from:subject:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=OVuL/gr+2PFJGhSd/Q6dWVHNvqpTt2jED+RGUKD01eQ=;
  b=cDj//kyPybOE5EKT+3M3qovVmtXoaB/zPr1jbxaby0T1esEhtnWIqYZB
   1+sX4DOr9W3D0nIoTAnKBsVN5qgPreA8Oxt2A0MrFcT2bo3n+bCw+mg12
   g/5vFlcPsJEgSrlsBIH2ZuD+obuSc8c/YHJPDVAR3YngAgHsmvRhwKXhZ
   U=;
IronPort-SDR: mBHHSQrpqsEGscXgJiOvQD0Q2HbieibP4NdVkoTNYKwXV6cKG2NSzQKZfy7XLJarNZt/ZxUf2h
 wXoYnxcLtmrg==
X-IronPort-AV: E=Sophos;i="5.73,413,1583193600"; 
   d="scan'208";a="31308489"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 20 May 2020 07:54:44 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id 33EC4A1CD6;
        Wed, 20 May 2020 07:54:40 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 20 May 2020 07:54:40 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.160.26) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 20 May 2020 07:54:34 +0000
From:   Gal Pressman <galpress@amazon.com>
Subject: Re: [RDMA RFC v6 14/16] RDMA/irdma: Add ABI definitions
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, <dledford@redhat.com>,
        <jgg@mellanox.com>, <davem@davemloft.net>,
        <gregkh@linuxfoundation.org>
CC:     Mustafa Ismail <mustafa.ismail@intel.com>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <nhorman@redhat.com>, <sassmann@redhat.com>, <poswald@suse.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>
References: <20200520070415.3392210-1-jeffrey.t.kirsher@intel.com>
 <20200520070415.3392210-15-jeffrey.t.kirsher@intel.com>
Message-ID: <34ea2c1d-538c-bcb7-b312-62524f31a8dd@amazon.com>
Date:   Wed, 20 May 2020 10:54:25 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200520070415.3392210-15-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.160.26]
X-ClientProxiedBy: EX13D35UWC001.ant.amazon.com (10.43.162.197) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/05/2020 10:04, Jeff Kirsher wrote:
> +struct i40iw_create_qp_resp {
> +	__u32 qp_id;
> +	__u32 actual_sq_size;
> +	__u32 actual_rq_size;
> +	__u32 i40iw_drv_opt;
> +	__u16 push_idx;
> +	__u8 lsmm;
> +	__u8 rsvd;
> +};

This struct size should be 8 bytes aligned.
