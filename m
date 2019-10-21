Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C576DE51D
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 09:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbfJUHKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 03:10:12 -0400
Received: from mga07.intel.com ([134.134.136.100]:63002 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbfJUHKL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 03:10:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 00:10:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,322,1566889200"; 
   d="scan'208";a="200345721"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.238.129.136]) ([10.238.129.136])
  by orsmga003.jf.intel.com with ESMTP; 21 Oct 2019 00:10:07 -0700
Subject: Re: [RFC 0/2] Intel IFC VF driver for vdpa
To:     Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@linux.intel.com>, mst@redhat.com,
        alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com,
        zhiyuan.lv@intel.com
References: <20191016013050.3918-1-lingshan.zhu@intel.com>
 <37503c7d-c07d-e584-0b6f-3733d2ad1dc7@linux.intel.com>
 <47befa11-c943-42f7-85c9-01b12f497182@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <7a6bc3bf-000c-72de-d2cb-05779de9a7ec@intel.com>
Date:   Mon, 21 Oct 2019 15:10:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
In-Reply-To: <47befa11-c943-42f7-85c9-01b12f497182@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/16/2019 4:26 PM, Jason Wang wrote:
>
> On 2019/10/16 上午9:36, Zhu Lingshan wrote:
>> failed to send to kvm list, resend, sorry for the inconvenience.
>>
>> THanks,
>> BR
>> Zhu Lingshan
>>
>> On 10/16/2019 9:30 AM, Zhu Lingshan wrote:
>>> Hi all:
>>>   This series intends to introduce Intel IFC VF NIC driver for Vhost
>>> Data Plane Acceleration.
>>>   Here comes two main parts, one is ifcvf_base layer, which handles
>>> hardware operations. The other is ifcvf_main layer handles VF
>>> initialization, configuration and removal, which depends on
>>> and complys to vhost_mdev https://lkml.org/lkml/2019/9/26/15
>>>   This is a first RFC try, please help review.
>
>
> It would be helpful if yon can describe which kinds of test that has 
> been done for this series.
>
> Thanks
>
Hi Jason,

It passed ping and netperf tests（two VMs, each has one ifc vf backed 
mdev nic）, I will mention this in next cover letter Thanks!

BR
Zhu Lingshan
>>>   Thanks!
>>> BR
>>> Zhu Lingshan
>>>
>>>
>>> Zhu Lingshan (2):
>>>    vhost: IFC VF hardware operation layer
>>>    vhost: IFC VF vdpa layer
>>>
>>>   drivers/vhost/ifcvf/ifcvf_base.c | 390 ++++++++++++++++++++++++++++
>>>   drivers/vhost/ifcvf/ifcvf_base.h | 137 ++++++++++
>>>   drivers/vhost/ifcvf/ifcvf_main.c | 541 
>>> +++++++++++++++++++++++++++++++++++++++
>>>   3 files changed, 1068 insertions(+)
>>>   create mode 100644 drivers/vhost/ifcvf/ifcvf_base.c
>>>   create mode 100644 drivers/vhost/ifcvf/ifcvf_base.h
>>>   create mode 100644 drivers/vhost/ifcvf/ifcvf_main.c
>>>
