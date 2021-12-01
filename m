Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F0D4644F1
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 03:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346170AbhLACkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 21:40:11 -0500
Received: from mga14.intel.com ([192.55.52.115]:11386 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241235AbhLACkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 21:40:11 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="236597957"
X-IronPort-AV: E=Sophos;i="5.87,277,1631602800"; 
   d="scan'208";a="236597957"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 18:36:50 -0800
X-IronPort-AV: E=Sophos;i="5.87,277,1631602800"; 
   d="scan'208";a="500047625"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.255.30.163]) ([10.255.30.163])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 18:36:45 -0800
Message-ID: <9957a8be-f93a-5d23-d697-22968f31766f@intel.com>
Date:   Wed, 1 Dec 2021 10:36:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.2.0
Subject: Re: [PATCH] ifcvf/vDPA: fix misuse virtio-net device config size for
 blk dev
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     jasowang@redhat.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
References: <20211129093144.8033-1-lingshan.zhu@intel.com>
 <20211130093228.iiz2r43e7mcgecnk@steredhat>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20211130093228.iiz2r43e7mcgecnk@steredhat>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/30/2021 5:32 PM, Stefano Garzarella wrote:
> On Mon, Nov 29, 2021 at 05:31:44PM +0800, Zhu Lingshan wrote:
>> This commit fixes a misuse of virtio-net device config size issue
>> for virtio-block devices.
>>
>> A new member config_size in struct ifcvf_hw is introduced and would
>> be initialized through vdpa_dev_add() to record correct device
>> config size.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> Reported-and-suggested-by: Stefano Garzarella <sgarzare@redhat.com>
>> Fixes: 6ad31d162a4e ("vDPA/ifcvf: enable Intel C5000X-PL virtio-block 
>> for vDPA")
>> Cc: <stable@vger.kernel.org>
>> ---
>> drivers/vdpa/ifcvf/ifcvf_base.c | 41 +++++++++++++++++++++++++--------
>> drivers/vdpa/ifcvf/ifcvf_base.h |  9 +++++---
>> drivers/vdpa/ifcvf/ifcvf_main.c | 24 ++++---------------
>> 3 files changed, 41 insertions(+), 33 deletions(-)
>
> The patch LGTM. Maybe we could add in the description that we rename 
> some fields and functions in a more generic way.
Sure, Thanks!

Thanks,
Zhu Lingshan
>
> In both cases:
>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
>
> Thanks,
> Stefano
>

