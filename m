Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD57819E99A
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 08:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgDEGqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 02:46:32 -0400
Received: from mga18.intel.com ([134.134.136.126]:20787 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbgDEGqc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Apr 2020 02:46:32 -0400
IronPort-SDR: s7qtdsbKb6wDpeXw+Uh39JtnroHpLm6F13fLsIkyyXWG/cmsic9eDQxUDIxOK7oT1/CTTAT48f
 UEdxkFvFNcBQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2020 23:46:30 -0700
IronPort-SDR: GJD9An3CSZgngnvVbIve/eYsdh2/bOf/U9TVWHjqKxIZ8jfq6ZCsfqOXdGhMZF20eYTi3tX6wO
 Z9nyb/HjljsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,346,1580803200"; 
   d="scan'208";a="243210075"
Received: from sneftin-mobl1.ger.corp.intel.com (HELO [10.214.203.6]) ([10.214.203.6])
  by fmsmga008.fm.intel.com with ESMTP; 04 Apr 2020 23:46:27 -0700
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: bump up timeout to wait when ME
 un-configure ULP mode
To:     Aaron Ma <aaron.ma@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        jeffrey.t.kirsher@intel.com, davem@davemloft.net,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Tsai, Rex" <rex.tsai@intel.com>
References: <20200323191639.48826-1-aaron.ma@canonical.com>
 <4f9f1ad0-e66a-d3c8-b152-209e9595e5d7@redhat.com>
 <1c0e602f-1fe7-62b1-2283-b98783782e87@canonical.com>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
Message-ID: <00b477c9-ef20-be95-1748-44efba18ebd3@intel.com>
Date:   Sun, 5 Apr 2020 09:46:26 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1c0e602f-1fe7-62b1-2283-b98783782e87@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/3/2020 06:15, Aaron Ma wrote:
> Hi Jeffrey:
> 
> I have received the email that you apply this patch to next-queue branch
> dev-queue.
> 
> But after this branch is rebased to v5.6, I can't find it.
> 
> Will you apply again?
Aaron, Kai,
S0ix flow supported only on none ME system. Our PAE works to communicate 
this to OS vendors. You should get BIOS option to disable ME on your system.
This fix just will mask real problem on specific system - won't be solve 
the problem. I suggest recall this patch and Lenovo Carbon in DMI black 
list.
> 
> Thanks,
> Aaron
> 
> On 4/2/20 8:31 PM, Hans de Goede wrote:
>>
>> This fix fixes a real problem, on a popular model laptop
>> and since it just extends a timeout it is a pretty harmless
>> (no chance of regressions) fix. As such since there seems
>> to be no other solution in sight, can we please move forward
>> with this fix for now ?
Thanks,
Sasha
