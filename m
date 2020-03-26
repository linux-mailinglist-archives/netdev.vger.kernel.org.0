Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2425B194B96
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 23:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgCZWfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 18:35:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:49623 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgCZWfQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 18:35:16 -0400
IronPort-SDR: v55z3tlfVMIKAgWicOx5/XIMux8MEGLOX6MzGjomAojVfpe+c1SM62KD+DfcX60eRETVNH0aQ/
 pjE0hhqkcBFw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 15:35:15 -0700
IronPort-SDR: ASUkoxmToc1d5UWuoIgXmyQJNKXIsmjDn1JA+S9z9KCv8Jj4mMJpMqKVVzXaVP4n59b9SzgxEc
 WJsliXJUapRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="358306063"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.254.179.43]) ([10.254.179.43])
  by fmsmga001.fm.intel.com with ESMTP; 26 Mar 2020 15:35:15 -0700
Subject: Re: [PATCH net-next v3 11/11] ice: add a devlink region for dumping
 NVM contents
To:     Jiri Pirko <jiri@resnulli.us>, David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
References: <20200326183718.2384349-1-jacob.e.keller@intel.com>
 <20200326183718.2384349-12-jacob.e.keller@intel.com>
 <20200326211908.GG11304@nanopsycho.orion>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <83be9fef-c15e-c32b-7d0f-70c563318fb9@intel.com>
Date:   Thu, 26 Mar 2020 15:35:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326211908.GG11304@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/26/2020 2:19 PM, Jiri Pirko wrote:
> Thu, Mar 26, 2020 at 07:37:18PM CET, jacob.e.keller@intel.com wrote:
>> +Regions
>> +=======
>> +
>> +The ``ice`` driver enables access to the contents of the Non Volatile Memory
>> +flash chip via the ``nvm-flash`` region.
>> +
>> +Users can request an immediate capture of a snapshot via the
>> +``DEVLINK_CMD_REGION_NEW``
>> +
>> +.. code:: shell
>> +
>> +    $ devlink region new pci/0000:01:00.0/nvm-flash snapshot 1
>> +    $ devlink region dump pci/0000:01:00.0/nvm-flash snapshot 1
>> +
>> +    $ devlink region dump pci/0000:01:00.0/nvm-flash snapshot 1
>> +    0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
>> +    0000000000000010 0000 0000 ffff ff04 0029 8c00 0028 8cc8
>> +    0000000000000020 0016 0bb8 0016 1720 0000 0000 c00f 3ffc
>> +    0000000000000030 bada cce5 bada cce5 bada cce5 bada cce5
>> +
>> +    $ devlink region read pci/0000:01:00.0/nvm-flash snapshot 1 address 0
>> +        length 16
> 
> I still think this should be one line. Anyway,
> 
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> 

I'm happy to send a v4 with this fix in, or to send a separate follow-up
patch which cleans up all of the devlink documents to avoid this.

Dave, which would you prefer?

Thanks,
Jake
