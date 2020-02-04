Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 738B91520F3
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 20:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbgBDTUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 14:20:42 -0500
Received: from mga05.intel.com ([192.55.52.43]:27426 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727308AbgBDTUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Feb 2020 14:20:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Feb 2020 11:20:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,402,1574150400"; 
   d="scan'208";a="263954092"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.86]) ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 04 Feb 2020 11:20:42 -0800
Subject: Re: [PATCH 03/15] devlink: add operation to take an immediate
 snapshot
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-4-jacob.e.keller@intel.com>
 <20200203115001.GE2260@nanopsycho>
 <6b97b131-65a2-e6d0-779e-d8ab31d5c0ae@intel.com>
 <20200203213057.GJ2260@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <e8a30dca-8ce4-e7f0-e588-eec7144a5e80@intel.com>
Date:   Tue, 4 Feb 2020 11:20:41 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200203213057.GJ2260@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/3/2020 1:30 PM, Jiri Pirko wrote:
> Mon, Feb 03, 2020 at 08:32:36PM CET, jacob.e.keller@intel.com wrote:
> 
> Check out "ida"
> 

Oh, that looks perfect.

Thanks,
Jake

>>
>> Thanks,
>> Jake
