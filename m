Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A78300EDA
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 22:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbhAVVYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 16:24:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:65011 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729147AbhAVVYV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 16:24:21 -0500
IronPort-SDR: RfEVfPrIAlf0FO/WZaD092rREFP6DjxNF3u2UoV/YYPkboGRuZEKVwGSbur6eF92jqKwl7wsnk
 CL74QOqWvFDw==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="175999808"
X-IronPort-AV: E=Sophos;i="5.79,367,1602572400"; 
   d="scan'208";a="175999808"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 13:23:19 -0800
IronPort-SDR: pZja2btqbcXhJsOvUMw/9unUy+QivBf7IJSQ72yWtbdU3BwKUDQUuHtK0mOJ/T0bZZOenFk9bL
 RuN4kzW4Zp7g==
X-IronPort-AV: E=Sophos;i="5.79,367,1602572400"; 
   d="scan'208";a="404008100"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.213.168.248]) ([10.213.168.248])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 13:23:18 -0800
Subject: Re: [net-next V9 03/14] devlink: Support add and delete devlink port
To:     Parav Pandit <parav@nvidia.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "edwin.peer@broadcom.com" <edwin.peer@broadcom.com>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>,
        "david.m.ertman@intel.com" <david.m.ertman@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20210121085237.137919-1-saeed@kernel.org>
 <20210121085237.137919-4-saeed@kernel.org>
 <0a51e4e2-97f2-a5bc-c9b4-7589882d69d6@intel.com>
 <BY5PR12MB4322C9132AFAF14E00E7B447DCA09@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <39a18d59-308b-f065-992b-0afce857b6c7@intel.com>
Date:   Fri, 22 Jan 2021 13:23:15 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB4322C9132AFAF14E00E7B447DCA09@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/21/2021 7:31 PM, Parav Pandit wrote:
> 
> 
>> From: Samudrala, Sridhar <sridhar.samudrala@intel.com>
>> Sent: Friday, January 22, 2021 2:21 AM
>>
>>> $ devlink port show
>>> pci/0000:06:00.0/65535: type eth netdev ens2f0np0 flavour physical
>>> port 0 splittable false
>>>
>>> $ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88
>>
>> Do we need to specify pfnum when adding a SF port? Isn't this redundant?
>> Isn't there a 1:1 mapping between the pci device and a pfnum?
>>
> No. it's not entirely redundant.
> Currently in most cases today it is same function number as that of PCI device.


> Netronome has one devlink instance that represents multiple PCI devices.

I am curious how this is done. I looked at doing this for ice but it
became incredibly problematic because of interacting across multiple
PCIe drivers.. Hmm. I'll have to go look at how this is handled in the
netronome driver.

Thanks,
Jake
