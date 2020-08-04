Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1504B23BF61
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 20:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgHDSbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 14:31:06 -0400
Received: from mga04.intel.com ([192.55.52.120]:8427 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbgHDSbG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 14:31:06 -0400
IronPort-SDR: U8WRma0ZWAJASwI/O/EZAU6iOvIxwCBuYkV3WrNeGKyYPW6ZjVqRZe7ln6nhQTwLdRVrtjInWe
 tjN/88yAiVUw==
X-IronPort-AV: E=McAfee;i="6000,8403,9703"; a="149828462"
X-IronPort-AV: E=Sophos;i="5.75,434,1589266800"; 
   d="scan'208";a="149828462"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2020 11:31:05 -0700
IronPort-SDR: pVwd0BWZxxqxk5kZb553VsADwZLW5oy4KibHVnxBbE+HrCHiRvOJX3xyinjgkMYEs2HjBs6N4d
 3NErqAXrgt0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,434,1589266800"; 
   d="scan'208";a="436899620"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.37.231]) ([10.212.37.231])
  by orsmga004.jf.intel.com with ESMTP; 04 Aug 2020 11:31:04 -0700
Subject: Re: [iproute2-next v2 5/5] devlink: support setting the overwrite
 mask
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20200801002159.3300425-1-jacob.e.keller@intel.com>
 <20200801002159.3300425-6-jacob.e.keller@intel.com>
 <0bb895a2-e233-0426-3e48-d8422fa5b7cf@gmail.com>
 <a7a03137-b3f8-de21-2a05-95f019d63309@intel.com>
 <b22c5b28-71f4-d9c1-f619-783f601dd653@gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <2cea2823-3885-4576-12e9-8c3f58518d2e@intel.com>
Date:   Tue, 4 Aug 2020 11:31:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.1.0
MIME-Version: 1.0
In-Reply-To: <b22c5b28-71f4-d9c1-f619-783f601dd653@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/3/2020 4:54 PM, David Ahern wrote:
> On 8/3/20 5:30 PM, Jacob Keller wrote:
>>
>> Slightly unrelated: but the recent change to using a bitfield32 results
>> in a "GENMASK is undefined".. I'm not sure what the proper way to fix
>> this is, since we'd like to still use GENMASK to define the supported
>> bitfields. I guess we need to pull in more headers? Or define something
>> in include/utils.h?
>>
> 
> I see that include/linux/bits.h has been pulled into the tools directory
> for perf and power tools (ie., works fine in userspace).
> 
> iproute2 is GPL so should be good from a licensing perspective to copy
> into iproute2. Stephen: any objections?
> 


Hmm... Actually, no other uapi header uses GENMASK.. Perhaps its better
to just avoid using it in the uapi/linux/devlink.h header...
