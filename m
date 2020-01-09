Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27E7B136183
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 21:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgAIUFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 15:05:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:36818 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgAIUFo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 15:05:44 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 12:05:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="223978655"
Received: from jekeller-mobl.amr.corp.intel.com (HELO [134.134.177.84]) ([134.134.177.84])
  by orsmga003.jf.intel.com with ESMTP; 09 Jan 2020 12:05:43 -0800
Subject: Re: [question] About triggering a region snapshot through the devlink
 cmd
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Alex Vesker <valex@mellanox.com>, davem@davemloft.net,
        Jiri Pirko <jiri@mellanox.com>, linuxarm@huawei.com,
        linyunsheng@huawei.com, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>
References: <02874ECE860811409154E81DA85FBB58B26FA36F@fmsmsx101.amr.corp.intel.com>
 <HE1PR0502MB3771BD83B728249E6C21967AC33E0@HE1PR0502MB3771.eurprd05.prod.outlook.com>
 <HE1PR0502MB3771D512C2D23F551EB922F4C33E0@HE1PR0502MB3771.eurprd05.prod.outlook.com>
 <18867ab8-6200-20c6-6ce0-8c123609622f@intel.com>
 <20200109114105.142dc3dd@cakuba.netronome.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <b6fcf0db-1767-51fa-6783-3975ed238d85@intel.com>
Date:   Thu, 9 Jan 2020 12:05:43 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200109114105.142dc3dd@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/9/2020 11:41 AM, Jakub Kicinski wrote:
> On Wed, 8 Jan 2020 11:14:38 -0800, Jacob Keller wrote:
>> On 1/8/2020 4:15 AM, Alex Vesker wrote:
>>> I am a biased here but, devlink trigger can be useful... I am not aware
>>> of other alternatives,
>>> devlink health has it`s benefits but it is not devlink region. If you
>>> will decide to implement I can
>>> review the design, if Jiri is ok with the idea.
>>>   
>>
>> Sure. I am not quite sure how long it will be till patches are on the
>> list, as I'm currently in the process of implementing devlink support
>> for one of the Intel drivers, and would be using that driver as an example.
>>
>> Actually, come to think of it, I may just implement the region trigger
>> and use netdevsim as the example. That should enable those patches to
>> hit the list sooner than the patches for implementing devlink for the
>> ice driver.
> 
> Just to be clear - you mean implement triggering the dump over netlink?
> FWIW that seems fairly reasonable to me, but please do explain the use
> case clearly in the patches.
> 

Yes. See the patches I just sent and let me know if the explanation
isn't totally clear.

> netdevsim is a driver mock up, and debugfs is its control interface.
> The trigger there is to simulate an async device error, this trigger
> should not be used as example or justification for anything real driver
> may need.
> 

The only two drivers that currently use regions at all are the mlx4 and
the netdevsim driver. In order to have some example of how the new
.trigger_snapshot and DEVLINK_CMD_REGION_TRIGGER work, (and so I could
test them out easily) I chose to implement it in netdevsim.

I'm working on patches for the ice driver that will implement devlink
support, but that is still in progress and isn't really yet at a point
where I can send it to the list. I wanted to get feedback on the
implementation of the triggering earlier.

Thanks,
Jake
