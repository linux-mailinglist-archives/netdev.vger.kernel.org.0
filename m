Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD7B9136184
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 21:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbgAIUGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 15:06:16 -0500
Received: from mga17.intel.com ([192.55.52.151]:9403 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgAIUGQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 15:06:16 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 12:06:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="223978859"
Received: from jekeller-mobl.amr.corp.intel.com (HELO [134.134.177.84]) ([134.134.177.84])
  by orsmga003.jf.intel.com with ESMTP; 09 Jan 2020 12:06:15 -0800
Subject: Re: [PATCH 2/2] doc: fix typo of snapshot in documentation
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, jiri@resnulli.us
References: <20200109190821.1335579-1-jacob.e.keller@intel.com>
 <20200109190821.1335579-2-jacob.e.keller@intel.com>
 <20200109120021.66a46535@hermes.lan>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <84ba1b73-aa0c-cce6-5284-6d4badb9bed4@intel.com>
Date:   Thu, 9 Jan 2020 12:06:15 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200109120021.66a46535@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/9/2020 12:00 PM, Stephen Hemminger wrote:
> On Thu,  9 Jan 2020 11:08:21 -0800
> Jacob Keller <jacob.e.keller@intel.com> wrote:
> 
>> A couple of locations accidentally misspelled snapshot as shapshot.
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> ---
>>  Documentation/admin-guide/devices.txt    | 2 +-
>>  Documentation/media/v4l-drivers/meye.rst | 2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/devices.txt b/Documentation/admin-guide/devices.txt
>> index 1c5d2281efc9..2a97aaec8b12 100644
>> --- a/Documentation/admin-guide/devices.txt
>> +++ b/Documentation/admin-guide/devices.txt
>> @@ -319,7 +319,7 @@
>>  		182 = /dev/perfctr	Performance-monitoring counters
>>  		183 = /dev/hwrng	Generic random number generator
>>  		184 = /dev/cpu/microcode CPU microcode update interface
>> -		186 = /dev/atomicps	Atomic shapshot of process state data
>> +		186 = /dev/atomicps	Atomic snapshot of process state data
>>  		187 = /dev/irnet	IrNET device
> 
> Oops, irnet is part of irda which is no longer part of the kernel.
> 

This is probably based on the wrong tree. Will rebase and re-send.

Thanks,
Jake
