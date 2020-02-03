Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 808ED150E73
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 18:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbgBCROa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 12:14:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:9138 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728910AbgBCROa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 12:14:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 09:14:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="278803886"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.86]) ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Feb 2020 09:14:29 -0800
Subject: Re: [PATCH 01/15] devlink: prepare to support region operations
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-2-jacob.e.keller@intel.com>
 <20200203113529.GC2260@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <4400bb91-90d9-0670-8249-675f9732b666@intel.com>
Date:   Mon, 3 Feb 2020 09:14:29 -0800
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

On 2/3/2020 3:35 AM, Jiri Pirko wrot>> +struct devlink_region *
>> +devlink_region_create(struct devlink *devlink,
>> +		      const struct devlink_region_ops *ops,
>> +		      u32 region_max_snapshots,
> 
> No need to wrap here.
> 

So I can do either:

> struct devlink_region *
> devlink_region_create(struct devlink *devlink, const struct devlink_region_ops *ops,
>                       u32 region_max_snapshots,

or

> struct devlink_region *devlink_region_create(struct devlink *devlink,>                                              const struct
devlink_region_ops *ops,
>                                              u32 region_max_snapshots,

Both of which go over the 80-character limit.

Or I can stick with what I've chosen which does not.

Thanks,
Jake
