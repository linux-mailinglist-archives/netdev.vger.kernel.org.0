Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E71E137542
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 18:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbgAJRwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 12:52:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:39133 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727405AbgAJRwU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 12:52:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2020 09:52:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,417,1571727600"; 
   d="scan'208";a="224261650"
Received: from unknown (HELO [134.134.177.84]) ([134.134.177.84])
  by orsmga003.jf.intel.com with ESMTP; 10 Jan 2020 09:52:18 -0800
Subject: Re: [PATCH v2 0/3] devlink region trigger support
To:     Yunsheng Lin <linyunsheng@huawei.com>, netdev@vger.kernel.org
Cc:     valex@mellanox.com, jiri@resnulli.us
References: <20200109193311.1352330-1-jacob.e.keller@intel.com>
 <4d8fe881-8d36-06dd-667a-276a717a0d89@huawei.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <1d00deb9-16fc-b2a5-f8f7-5bb8316dbac2@intel.com>
Date:   Fri, 10 Jan 2020 09:52:18 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <4d8fe881-8d36-06dd-667a-276a717a0d89@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/9/2020 8:10 PM, Yunsheng Lin wrote:
> On 2020/1/10 3:33, Jacob Keller wrote:
>> This series consists of patches to enable devlink to request a snapshot via
>> a new DEVLINK_CMD_REGION_TRIGGER_SNAPSHOT.
>>
>> A reviewer might notice that the devlink health API already has such support
>> for handling a similar case. However, the health API does not make sense in
>> cases where the data is not related to an error condition.
> 
> Maybe we need to specify the usecases for the region trigger as suggested by
> Jacob.
> 
> For example, the orginal usecase is to expose some set of flash/NVM contents.
> But can it be used to dump the register of the bar space? or some binary
> table in the hardware to debug some error that is not detected by hw?
> 


regions can essentially be used to dump arbitrary addressable content. I
think all of the above are great examples.

I have a series of patches to update and convert the devlink
documentation, and I do provide some further detail in the new
devlink-region.rst file.

Perhaps you could review that and provide suggestions on what would make
sense to add there?

https://lore.kernel.org/netdev/20200109224625.1470433-13-jacob.e.keller@intel.com/

Thanks,
Jake
