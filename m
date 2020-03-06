Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C797D17B313
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 01:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgCFAoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 19:44:19 -0500
Received: from mga14.intel.com ([192.55.52.115]:56047 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbgCFAoT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 19:44:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 16:44:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,520,1574150400"; 
   d="scan'208";a="413720256"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.106]) ([134.134.177.106])
  by orsmga005.jf.intel.com with ESMTP; 05 Mar 2020 16:44:17 -0800
Subject: Re: [PATCH net-next iproute2 1/2] Update devlink kernel header
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Parav Pandit <parav@mellanox.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org, jiri@mellanox.com
References: <20200304040626.26320-1-parav@mellanox.com>
 <20200304040626.26320-2-parav@mellanox.com>
 <bfef88f7-c888-04b0-7d7d-dc1bb184d168@intel.com>
Organization: Intel Corporation
Message-ID: <7cf54485-4757-7140-1b57-264144622b6c@intel.com>
Date:   Thu, 5 Mar 2020 16:44:17 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <bfef88f7-c888-04b0-7d7d-dc1bb184d168@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/5/2020 4:42 PM, Jacob Keller wrote:
> 
> 
> On 3/3/2020 8:06 PM, Parav Pandit wrote:
>> Update devlink kernel header to commit:
>> acf1ee44ca5d ("devlink: Introduce devlink port flavour virtual")
>>
>> Signed-off-by: Parav Pandit <parav@mellanox.com>
>> ---
>>  include/uapi/linux/devlink.h | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>> index 3f82dedd..1b412281 100644
>> --- a/include/uapi/linux/devlink.h
>> +++ b/include/uapi/linux/devlink.h
>> @@ -187,6 +187,7 @@ enum devlink_port_flavour {
>>  				      * for the PCI VF. It is an internal
>>  				      * port that faces the PCI VF.
>>  				      */
>> +	DEVLINK_PORT_FLAVOUR_VIRTUAL, /* Any virtual port facing the user. */
>>  };
>>  
>>  enum devlink_param_cmode {
>> @@ -252,6 +253,8 @@ enum devlink_trap_type {
>>  enum {
>>  	/* Trap can report input port as metadata */
>>  	DEVLINK_ATTR_TRAP_METADATA_TYPE_IN_PORT,
>> +	/* Trap can report flow action cookie as metadata */
>> +	DEVLINK_ATTR_TRAP_METADATA_TYPE_FA_COOKIE,
>>  };
>>  
> 
> This hunk doesn't seem relevant to the patch and isn't mentioned in the
> subject or description.
> 
> Thanks,
> Jake

Oops, disregard this. This is just the kernel header update, which is
fine. Just hadn't expected to see it, and it didn't grok the first time
I looked at this.

Thanks,
Jake
