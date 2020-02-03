Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B469150E83
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 18:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbgBCRR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 12:17:27 -0500
Received: from mga14.intel.com ([192.55.52.115]:45848 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728308AbgBCRR1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 12:17:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 09:17:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="278804757"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.86]) ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Feb 2020 09:17:26 -0800
Subject: Re: [PATCH 01/15] devlink: prepare to support region operations
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-2-jacob.e.keller@intel.com>
 <20200203113529.GC2260@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <8b57d9d4-3ecd-f9b5-6925-bf5184c71b84@intel.com>
Date:   Mon, 3 Feb 2020 09:17:26 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200203113529.GC2260@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/3/2020 3:35 AM, Jiri Pirko wrote:
> Thu, Jan 30, 2020 at 11:58:56PM CET, jacob.e.keller@intel.com wrote:
>> +struct devlink_region *
>> +devlink_region_create(struct devlink *devlink,
>> +		      const struct devlink_region_ops *ops,
>> +		      u32 region_max_snapshots,
> 
> No need to wrap here.
> 
> 
>> +		      u64 region_size);

Probably misunderstood your command previously. Will merge the
region_max_snapshots and region_size to one line.

Thanks,
Jake
