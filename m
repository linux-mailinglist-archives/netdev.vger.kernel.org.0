Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37EAD23AB01
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 18:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgHCQ4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 12:56:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:48924 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726356AbgHCQ4n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 12:56:43 -0400
IronPort-SDR: xCPB3nTmAnecP5n94u6pQV/Zqnm27yL6JnaePqiUHU2oChZoKFIngxJEg6aSpJ6NunD01hL3Ts
 WnTrh10UiI7Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9702"; a="149960138"
X-IronPort-AV: E=Sophos;i="5.75,430,1589266800"; 
   d="scan'208";a="149960138"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2020 09:56:42 -0700
IronPort-SDR: gCifT/ICpdHURbe8y5mgjFS2zvxSj8Om7cJbJlAtzC37w/HXxFSZqckNtUJdakGEjAEzCTQiO4
 b2fjwdvYKEvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,430,1589266800"; 
   d="scan'208";a="366448248"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.196.183]) ([10.212.196.183])
  by orsmga001.jf.intel.com with ESMTP; 03 Aug 2020 09:56:42 -0700
Subject: Re: [iproute2-next v2 5/5] devlink: support setting the overwrite
 mask
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
References: <20200801002159.3300425-1-jacob.e.keller@intel.com>
 <20200801002159.3300425-6-jacob.e.keller@intel.com>
 <0bb895a2-e233-0426-3e48-d8422fa5b7cf@gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <c317a649-59f4-82a2-5617-0f6209964b8e@intel.com>
Date:   Mon, 3 Aug 2020 09:56:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <0bb895a2-e233-0426-3e48-d8422fa5b7cf@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/3/2020 8:53 AM, David Ahern wrote:
> On 7/31/20 6:21 PM, Jacob Keller wrote:
>> Add support for specifying the overwrite sections to allow in the flash
>> update command. This is done by adding a new "overwrite" option which
>> can take either "settings" or "identifiers" passing the overwrite mode
>> multiple times will combine the fields using bitwise-OR.
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> ---
>>  devlink/devlink.c | 37 +++++++++++++++++++++++++++++++++++--
>>  1 file changed, 35 insertions(+), 2 deletions(-)
>>
> 
> 5/5? I only see 2 - 4/5 and 5/5. Please re-send against latest
> iproute2-next.
> 

Sorry for the confusion here. I sent both the iproute2 and net-next
changes to implement it in the kernel.
