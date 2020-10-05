Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C35283F0F
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 20:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbgJESx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 14:53:28 -0400
Received: from mga04.intel.com ([192.55.52.120]:6912 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728361AbgJESx2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 14:53:28 -0400
IronPort-SDR: 0wL5tqXMS5zaENE+iuL7vZdXa0eHgyo8qS+/lSj7vXREAd8XzmGFNwUTl9fP4HlfHnCGDHd9aE
 vBucb0ejm/vg==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="161228548"
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="161228548"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 11:53:07 -0700
IronPort-SDR: I6aHqTtmrdd/fMme/6HGdGLJScBxjqGEkVjcGfRik8ln7xlFXxcwQfS7D/A0ezfbgfczLaC5KR
 Vca7WRG+8m0w==
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="310172362"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.255.65.178]) ([10.255.65.178])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 11:53:05 -0700
Subject: Re: [PATCH net-next 03/16] devlink: Add devlink reload limit option
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
 <1601560759-11030-4-git-send-email-moshe@mellanox.com>
 <20201003075100.GC3159@nanopsycho.orion>
 <20201003080436.40cd8eb5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <1b8cdb1b-ddd9-66f4-f446-e2881649511c@intel.com>
Date:   Mon, 5 Oct 2020 11:53:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201003080436.40cd8eb5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/3/2020 8:04 AM, Jakub Kicinski wrote:
> On Sat, 3 Oct 2020 09:51:00 +0200 Jiri Pirko wrote:
>>> enum devlink_attr {
>>> 	/* don't change the order or add anything between, this is ABI! */
>>> 	DEVLINK_ATTR_UNSPEC,
>>> @@ -507,6 +524,7 @@ enum devlink_attr {
>>>
>>> 	DEVLINK_ATTR_RELOAD_ACTION,		/* u8 */
>>> 	DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED,	/* u64 */
>>> +	DEVLINK_ATTR_RELOAD_LIMIT,	/* u8 */  
>>
>> Hmm, why there could be specified only single "limit"? I believe this
>> should be a bitfield. Same for the internal api to the driver.
> 
> Hm I was expecting limits to be ordered (in maths sense) but you're
> right perhaps that can't be always guaranteed.
> 
> Also - Moshe please double check that there will not be any kdoc
> warnings here - I just learned that W=1 builds don't check headers 
> but I'll fix up my bot by the time you post v2.
> 

I think something like this got missed in one of my patches before...

I don't see anything obvious for this searching through the
Makefile.build... Mind sharing how you plan to fix your bot to check these?

Thanks,
Jake
