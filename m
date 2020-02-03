Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B00D150D9F
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 17:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730391AbgBCQpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 11:45:12 -0500
Received: from mga18.intel.com ([134.134.136.126]:38670 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730706AbgBCQpL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 11:45:11 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 08:45:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="278796388"
Received: from unknown (HELO [134.134.177.86]) ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Feb 2020 08:45:06 -0800
Subject: Re: [PATCH 02/15] devlink: add functions to take snapshot while
 locked
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-3-jacob.e.keller@intel.com>
 <20200203113956.GD2260@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <356f9f89-5069-4853-a273-49913ba8fc5a@intel.com>
Date:   Mon, 3 Feb 2020 08:45:06 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200203113956.GD2260@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/2020 3:39 AM, Jiri Pirko wrote:
> Thu, Jan 30, 2020 at 11:58:57PM CET, jacob.e.keller@intel.com wrote:
>> + */
>> +static int
>> +devlink_region_snapshot_create_locked(struct devlink_region *region,
> 
> __devlink_region_snapshot_create()
> 

Yep, was pointed out earlier, will clean up in v2.

>> 	return id;
>> @@ -7622,7 +7679,7 @@ EXPORT_SYMBOL_GPL(devlink_region_snapshot_id_get);
>>  *	devlink_region_snapshot_create - create a new snapshot
>>  *	This will add a new snapshot of a region. The snapshot
>>  *	will be stored on the region struct and can be accessed
>> - *	from devlink. This is useful for future	analyses of snapshots.
>> + *	from devlink. This is useful for future analyses of snapshots.
> 
> What this hunk is about? :O
> 
> 

Not sure, but if I had to guess it was a stray space vs. tab thing that
accidentally got changed without reason.

Thanks,
Jake
