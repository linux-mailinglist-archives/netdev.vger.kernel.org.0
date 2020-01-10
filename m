Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D502013757B
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 18:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbgAJRyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 12:54:22 -0500
Received: from mga14.intel.com ([192.55.52.115]:3049 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728564AbgAJRyV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 12:54:21 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2020 09:54:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,417,1571727600"; 
   d="scan'208";a="224262115"
Received: from unknown (HELO [134.134.177.84]) ([134.134.177.84])
  by orsmga003.jf.intel.com with ESMTP; 10 Jan 2020 09:54:21 -0800
Subject: Re: [PATCH v2 0/3] devlink region trigger support
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, valex@mellanox.com
References: <20200109193311.1352330-1-jacob.e.keller@intel.com>
 <20200110094027.GL2235@nanopsycho.orion>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <c5fe026b-d29f-7be2-78b5-c54ec6d2f549@intel.com>
Date:   Fri, 10 Jan 2020 09:54:20 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200110094027.GL2235@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/10/2020 1:40 AM, Jiri Pirko wrote:
> Thu, Jan 09, 2020 at 08:33:07PM CET, jacob.e.keller@intel.com wrote:
>> This series consists of patches to enable devlink to request a snapshot via
>> a new DEVLINK_CMD_REGION_TRIGGER_SNAPSHOT.
>>
>> A reviewer might notice that the devlink health API already has such support
>> for handling a similar case. However, the health API does not make sense in
>> cases where the data is not related to an error condition.
>>
>> In this case, using the health API only for the dumping feels incorrect.
>> Regions make sense when the addressable content is not captured
>> automatically on error conditions, but only upon request by the devlink API.
>>
>> The netdevsim driver is modified to support the new trigger_snapshot
>> callback as an example of how this can be used.
> 
> I don't think that the netdevsim usecase is enough to merge this in. You
> need a real-driver user as well.
> 
Sure. But this direction and implementation seems reasonable?

I am making progress on a driver implementation for this, and I am fine
holding onto these patches until I am ready to submit the full series to
the list with the driver..

Mostly I wanted to make sure the direction was looking good earlier than
the time frame for completing that work.

Thanks,
Jake
