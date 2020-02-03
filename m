Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32B01150DF6
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 17:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729977AbgBCQsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 11:48:15 -0500
Received: from mga18.intel.com ([134.134.136.126]:38946 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729187AbgBCQsO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 11:48:14 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 08:48:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="278797111"
Received: from unknown (HELO [134.134.177.86]) ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Feb 2020 08:48:13 -0800
Subject: Re: [PATCH 01/15] devlink: prepare to support region operations
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-2-jacob.e.keller@intel.com>
 <20200203113529.GC2260@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <2f8dc1b2-b384-a5b6-5a3b-82b4e9a98ec5@intel.com>
Date:   Mon, 3 Feb 2020 08:48:13 -0800
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
>> -static const char *region_cr_space_str = "cr-space";
>> -static const char *region_fw_health_str = "fw-health";
> 
> Just leave these as are and use in ops and messages. It is odd to use
> ops.name in the message.
> 

If I recall, I tried this and it produced some issues with const. Will
confirm that and fix or explain in the commit message next round.

Thanks,
Jake
