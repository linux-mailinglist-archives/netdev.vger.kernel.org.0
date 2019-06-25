Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05E9A55005
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 15:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbfFYNPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 09:15:03 -0400
Received: from mga04.intel.com ([192.55.52.120]:64824 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbfFYNPC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 09:15:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jun 2019 06:15:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,416,1557212400"; 
   d="scan'208";a="166673508"
Received: from klaatz-mobl1.ger.corp.intel.com (HELO [10.237.221.70]) ([10.237.221.70])
  by orsmga006.jf.intel.com with ESMTP; 25 Jun 2019 06:14:59 -0700
Subject: Re: [PATCH 03/11] xdp: add offset param to zero_copy_allocator
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com
References: <20190620090958.2135-1-kevin.laatz@intel.com>
 <20190620090958.2135-4-kevin.laatz@intel.com>
 <20190624122342.26c6a9b4@cakuba.netronome.com>
From:   "Laatz, Kevin" <kevin.laatz@intel.com>
Message-ID: <bf3e67de-b23a-fa69-4cbc-c53e9cc5e055@intel.com>
Date:   Tue, 25 Jun 2019 14:14:59 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190624122342.26c6a9b4@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 24/06/2019 20:23, Jakub Kicinski wrote:
> On Thu, 20 Jun 2019 09:09:50 +0000, Kevin Laatz wrote:
>> diff --git a/include/net/xdp.h b/include/net/xdp.h
>> index 0f25b3675c5c..ea801fd2bf98 100644
>> --- a/include/net/xdp.h
>> +++ b/include/net/xdp.h
>> @@ -53,7 +53,8 @@ struct xdp_mem_info {
>>  struct page_pool;
>>
>>  struct zero_copy_allocator {
>> -    void (*free)(struct zero_copy_allocator *zca, unsigned long 
>> handle);
>> +    void (*free)(struct zero_copy_allocator *zca, unsigned long handle,
>> +            off_t off);
>>  };
>
> Please run checkpatch --strict on all your changes.  The code
> formatting is incorrect in many ways in this series.
>
Thanks, will fix in the v2.


> Please include performance measurements proving the slow down
> is negligible in the cover letter.
>
Good suggestion. Will add to the cover letter in the v2!
