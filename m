Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906B02B8922
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 01:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgKSAln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 19:41:43 -0500
Received: from mga12.intel.com ([192.55.52.136]:57655 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbgKSAlm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 19:41:42 -0500
IronPort-SDR: QVasj0CuM5JclvUFc1bm/GlRWG20bQq72UGsSjI8zeGrPScbZL3/DefmpC2l1rmFZZ5SsZgP7+
 Antut0zKBaAg==
X-IronPort-AV: E=McAfee;i="6000,8403,9809"; a="150479136"
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="150479136"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 16:41:42 -0800
IronPort-SDR: Y8rTmHCtB7/sn2V4taDUYDFv3fbt2XLk3lVUpAW3YPpGFl/PJFmkLEcE0znizQStUbrqozMmL9
 /axsBdMD4ulg==
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="330725949"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.247.114]) ([10.212.247.114])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 16:41:41 -0800
Subject: Re: [PATCH net-next 03/13] devlink: Support add and delete devlink
 port
To:     Parav Pandit <parav@nvidia.com>, David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Jiri Pirko <jiri@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vu Pham <vuhuong@nvidia.com>
References: <20201112192424.2742-1-parav@nvidia.com>
 <20201112192424.2742-4-parav@nvidia.com>
 <e7b2b21f-b7d0-edd5-1af0-a52e2fc542ce@gmail.com>
 <BY5PR12MB43222AB94ED279AF9B710FF1DCE10@BY5PR12MB4322.namprd12.prod.outlook.com>
 <b34d8427-51c0-0bbd-471e-1af30375c702@gmail.com>
 <BY5PR12MB4322863EA236F30C9E542F00DCE10@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <c409964b-3f07-cac9-937c-4062f879cb85@intel.com>
Date:   Wed, 18 Nov 2020 16:41:38 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB4322863EA236F30C9E542F00DCE10@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/2020 11:22 AM, Parav Pandit wrote:
> 
> 
>> From: David Ahern <dsahern@gmail.com>
>> Sent: Wednesday, November 18, 2020 11:33 PM
>>
>>
>> With Connectx-4 Lx for example the netdev can have at most 63 queues
>> leaving 96 cpu servers a bit short - as an example of the limited number of
>> queues that a nic can handle (or currently exposes to the OS not sure which).
>> If I create a subfunction for ethernet traffic, how many queues are allocated
>> to it by default, is it managed via ethtool like the pf and is there an impact to
>> the resources used by / available to the primary device?
> 
> Jason already answered it with details.
> Thanks a lot Jason.
> 
> Short answer to ethtool question, yes, ethtool can change num queues for subfunction like PF.
> Default is same number of queues for subfunction as that of PF in this patchset.
> 

But what is the mechanism for partitioning the global resources of the
device into each sub function?

Is it just evenly divided into the subfunctions? is there some maximum
limit per sub function?
