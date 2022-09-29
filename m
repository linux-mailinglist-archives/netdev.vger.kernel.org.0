Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2405EEFA1
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbiI2Hs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235418AbiI2Hse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:48:34 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC5313A057;
        Thu, 29 Sep 2022 00:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664437710; x=1695973710;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DtraKiNoEnCe1mKscp4RoQO0XkyyEhr54+DxfkZN4UI=;
  b=TPDmNCpmQQZlfm21d06W4RHytX5mzDQt/E9yJ10rdc6UOVTb6BDh10D/
   zoQTl1Sb1bTGwfpOe5eEl4Bh7GoW3dDcESgflXGdX+1xe0Sw6c4cIja0r
   J4zgzy+KIkhdAGIW3O6uL7okr0aSfv2e9ZfbSN1F9dAav7kaoL4yyKyvP
   Qs3SqOJvQAgWTEzJ9Yu1HP8xT+Q+2B9Jrx0rNjAAGtDeORle4mh0U04d6
   wBC6a02fk0jgq1qd9+2EmmrJ91SEUW4y+rDFha4H6LM94jdK658bLKmMF
   pGA9bTbYIqZ+c6C9Tu/iMuD8OiDDRmj87s+BfAtikUdYlpVFOK+MDVrpF
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="300540929"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="300540929"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 00:48:30 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="617506033"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="617506033"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.168.227]) ([10.249.168.227])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 00:46:20 -0700
Message-ID: <5f1f9928-e1b3-b935-c239-1e887e11181a@intel.com>
Date:   Thu, 29 Sep 2022 15:46:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.3.0
Subject: Re: [PATCH V3 0/6] Conditionally read fields in dev cfg space
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
References: <20220929014555.112323-1-lingshan.zhu@intel.com>
 <896fe0b9-5da2-2bc6-0e46-219aa4b9f44f@intel.com>
 <20220929033805-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20220929033805-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/29/2022 3:38 PM, Michael S. Tsirkin wrote:
> On Thu, Sep 29, 2022 at 03:23:46PM +0800, Zhu, Lingshan wrote:
>> Hi Michael,
>>
>> Jason starts his vacation this afternoon, and next week is our national
>> holiday.
>> He has acked 3 ~ 6 of this series before, and I have made improvements based
>> on his comments.
>> Do you have any comments on patches 1 and 2?
>
> No, I'll merge for next.
Thanks!
>
>> Thanks,
>> Zhu Lingshan
>> On 9/29/2022 9:45 AM, Zhu Lingshan wrote:
>>> This series intends to read the fields in virtio-net device
>>> configuration space conditionally on the feature bits,
>>> this means:
>>>
>>> MTU exists if VIRTIO_NET_F_MTU is set
>>> MAC exists if VIRTIO_NET_F_NET is set
>>> MQ exists if VIRTIO_NET_F_MQ or VIRTIO_NET_F_RSS is set.
>>>
>>> This series report device features to userspace and invokes
>>> vdpa_config_ops.get_config() rather than
>>> vdpa_get_config_unlocked() to read the device config spcae,
>>> so no races in vdpa_set_features_unlocked()
>>>
>>> Thanks!
>>>
>>> Changes form V2:
>>> remove unnacessary checking for vdev->config->get_status (Jason)
>>>
>>> Changes from V1:
>>> 1)Better comments for VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,
>>> only in the header file(Jason)
>>> 2)Split original 3/4 into separate patches(Jason)
>>> 3)Check FEATURES_OK for reporting driver features
>>> in vdpa_dev_config_fill (Jason)
>>> 4) Add iproute2 example for reporting device features
>>>
>>> Zhu Lingshan (6):
>>>     vDPA: allow userspace to query features of a vDPA device
>>>     vDPA: only report driver features if FEATURES_OK is set
>>>     vDPA: check VIRTIO_NET_F_RSS for max_virtqueue_paris's presence
>>>     vDPA: check virtio device features to detect MQ
>>>     vDPA: fix spars cast warning in vdpa_dev_net_mq_config_fill
>>>     vDPA: conditionally read MTU and MAC in dev cfg space
>>>
>>>    drivers/vdpa/vdpa.c       | 68 ++++++++++++++++++++++++++++++---------
>>>    include/uapi/linux/vdpa.h |  4 +++
>>>    2 files changed, 56 insertions(+), 16 deletions(-)
>>>

