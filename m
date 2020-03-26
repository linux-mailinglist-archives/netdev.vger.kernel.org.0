Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12D0E194430
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 17:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgCZQXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 12:23:40 -0400
Received: from mga18.intel.com ([134.134.136.126]:31530 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727056AbgCZQXk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 12:23:40 -0400
IronPort-SDR: I+O6Jzyz2GWnirasQN4rnNGbYPfglZ3YLT3UWZdfWbkWv+W/FMrNT2jlf3rp1e4Mu/JiZssi0h
 Wkykvt0Ldbvw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 09:23:39 -0700
IronPort-SDR: bwQNB1Jhnq0Sa3oXU/W2PaPSckUesfmat37DhmcztYkaYoH9RdSrMQYVqWdbT6/TUGchd7h2GD
 PlJQATMQriOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="282555108"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.254.179.43]) ([10.254.179.43])
  by fmsmga002.fm.intel.com with ESMTP; 26 Mar 2020 09:23:39 -0700
Subject: Re: [net-next v2 11/11] ice: add a devlink region for dumping NVM
 contents
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
 <20200326035157.2211090-12-jacob.e.keller@intel.com>
 <20200326090250.GQ11304@nanopsycho.orion>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <47d38183-dc6b-bbe6-110a-8c870ec01769@intel.com>
Date:   Thu, 26 Mar 2020 09:23:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326090250.GQ11304@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/26/2020 2:02 AM, Jiri Pirko wrote:
> Thu, Mar 26, 2020 at 04:51:57AM CET, jacob.e.keller@intel.com wrote:
>> +
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
> Don't wrap the cmdline.

The devlink-region.rst file wrapped it like this..
