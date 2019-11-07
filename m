Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1DB0F2B2E
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 10:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387584AbfKGJsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 04:48:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:61842 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726866AbfKGJsD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 04:48:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Nov 2019 01:48:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,277,1569308400"; 
   d="scan'208";a="201359528"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga007.fm.intel.com with ESMTP; 07 Nov 2019 01:48:02 -0800
Received: from [10.226.38.236] (unknown [10.226.38.236])
        by linux.intel.com (Postfix) with ESMTP id A2C09580517;
        Thu,  7 Nov 2019 01:47:59 -0800 (PST)
Subject: Re: [PATCH v1] staging: intel-dpa: gswip: Introduce Gigabit Ethernet
 Switch (GSWIP) device driver
To:     Greg KH <gregkh@linuxfoundation.org>, Andrew Lunn <andrew@lunn.ch>
References: <03832ecb6a34876ef26a24910816f22694c0e325.1572863013.git.jack.ping.chng@intel.com>
 <20191104122009.GA2126921@kroah.com> <20191104164209.GC16970@lunn.ch>
 <4D649A99D5D6C446954219080E51FB468192606D@BGSMSX103.gar.corp.intel.com>
Cc:     davem@davemloft.net, mallikarjunax.reddy@linux.intel.com,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        "Kim, Cheol Yong" <cheol.yong.kim@intel.com>,
        "Chng, Jack Ping" <jack.ping.chng@intel.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
From:   "Chng, Jack Ping" <jack.ping.chng@linux.intel.com>
Message-ID: <5e7a5410-9797-817d-87c6-61dfce9df739@linux.intel.com>
Date:   Thu, 7 Nov 2019 17:47:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <4D649A99D5D6C446954219080E51FB468192606D@BGSMSX103.gar.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 01:20:09PM +0100, Greg KH wrote:
>> On Mon, Nov 04, 2019 at 07:22:20PM +0800, Jack Ping CHNG wrote:
>>> This driver enables the Intel's LGM SoC GSWIP block.
>>> GSWIP is a core module tailored for L2/L3/L4+ data plane and QoS functions.
>>> It allows CPUs and other accelerators connected to the SoC datapath
>>> to enqueue and dequeue packets through DMAs.
>>> Most configuration values are stored in tables such as Parsing and
>>> Classification Engine tables, Buffer Manager tables and Pseudo MAC
>>> tables.
>> Why is this being submitted to staging?  What is wrong with the "real"
>> part of the kernel for this?
>>
>> Or even, what is wrong with the current driver?
>> drivers/net/dsa/lantiq_gswip.c?
GSWIP (a new HW IP) is part of Intel Datapath Architecture drivers 
design for new Intel network/GW SoC (LGM).
Currently there are few other drivers (for different HW blocks in the 
datapath) which are still under internal code review.
Once it is done we are planning to submit  staging folder.
Since the development is ongoing, we thought it is best to submit GSWIP 
first in drivers/staging/intel-dpa folder.
In the meantime, we will prepare a more detail TODO list for intel-dpa 
folder and a README to introduce the dpa.
>> Jack, your patch does not seem to of made it to any of the lists. So i cannot comment on it contents. If this is a switch driver, please ensure you Cc: the usual suspects for switch drivers.
>>
>>         Andrew

Sure, I will resubmit my patch.

Best regards,
Chng Jack Ping



