Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392FA1DAE40
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 11:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgETJCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 05:02:52 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:2412 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgETJCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 05:02:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1589965372; x=1621501372;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=8cIcAxcp+Trh0U6FVJYZV8kWWba8qHeti+FQYohtJNA=;
  b=e4BF0CG5+JQJu31SO1qRYHMCIBKmDV6KaxfexMi7VEkhP7aABcCPwd5P
   73ofQD58lHKu8PlVByMZJGOIOQ+QvpHRTFW1LUf2CcRxSgNwXu3U2hh/J
   pAancfLgjDao4vRXKE6+PwAlIiuZlv0r6YGKxi2ao47oRiJFlXnpZLMbd
   4=;
IronPort-SDR: dCmVcKib1nTJ+S+D12rGz69BOyHQnxFCHcUGjcA//3gGstdPGVboTRNZctCEuKvN/PZAIs/R09
 CZkqREn34kIg==
X-IronPort-AV: E=Sophos;i="5.73,413,1583193600"; 
   d="scan'208";a="36318333"
Received: from sea32-co-svc-lb4-vlan2.sea.corp.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.47.23.34])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 20 May 2020 09:02:50 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id F15B2223539;
        Wed, 20 May 2020 09:02:47 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 20 May 2020 09:02:47 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.160.100) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 20 May 2020 09:02:41 +0000
Subject: Re: [RDMA RFC v6 14/16] RDMA/irdma: Add ABI definitions
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, <dledford@redhat.com>,
        <jgg@mellanox.com>, <davem@davemloft.net>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <nhorman@redhat.com>, <sassmann@redhat.com>, <poswald@suse.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>
References: <20200520070415.3392210-1-jeffrey.t.kirsher@intel.com>
 <20200520070415.3392210-15-jeffrey.t.kirsher@intel.com>
 <34ea2c1d-538c-bcb7-b312-62524f31a8dd@amazon.com>
 <20200520085228.GF2837844@kroah.com>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <a0240054-7a5c-5698-d213-b2070756c846@amazon.com>
Date:   Wed, 20 May 2020 12:02:35 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200520085228.GF2837844@kroah.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.160.100]
X-ClientProxiedBy: EX13D05UWC004.ant.amazon.com (10.43.162.223) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/05/2020 11:52, Greg KH wrote:
> On Wed, May 20, 2020 at 10:54:25AM +0300, Gal Pressman wrote:
>> On 20/05/2020 10:04, Jeff Kirsher wrote:
>>> +struct i40iw_create_qp_resp {
>>> +   __u32 qp_id;
>>> +   __u32 actual_sq_size;
>>> +   __u32 actual_rq_size;
>>> +   __u32 i40iw_drv_opt;
>>> +   __u16 push_idx;
>>> +   __u8 lsmm;
>>> +   __u8 rsvd;
>>> +};
>>
>> This struct size should be 8 bytes aligned.
> 
> Aligned in what way?  Seems sane to me, what would you want it to look
> like instead?

The uverbs ABI structs sizes are assumed to be padded to 8 bytes alignment, I
would expect the reserved field to be an array of 5 bytes as done in other
structs in this file (irdma_modify_qp_req for example).
Jason could correct me if I'm wrong?
