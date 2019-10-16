Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D34ADD8ADC
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 10:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391607AbfJPI0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 04:26:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbfJPI0l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 04:26:41 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4E3E081F07;
        Wed, 16 Oct 2019 08:26:41 +0000 (UTC)
Received: from [10.72.12.53] (ovpn-12-53.pek2.redhat.com [10.72.12.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C2FC5C1B5;
        Wed, 16 Oct 2019 08:26:15 +0000 (UTC)
Subject: Re: [RFC 0/2] Intel IFC VF driver for vdpa
To:     Zhu Lingshan <lingshan.zhu@linux.intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com,
        zhiyuan.lv@intel.com
References: <20191016013050.3918-1-lingshan.zhu@intel.com>
 <37503c7d-c07d-e584-0b6f-3733d2ad1dc7@linux.intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <47befa11-c943-42f7-85c9-01b12f497182@redhat.com>
Date:   Wed, 16 Oct 2019 16:26:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <37503c7d-c07d-e584-0b6f-3733d2ad1dc7@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 16 Oct 2019 08:26:41 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/16 上午9:36, Zhu Lingshan wrote:
> failed to send to kvm list, resend, sorry for the inconvenience.
>
> THanks,
> BR
> Zhu Lingshan
>
> On 10/16/2019 9:30 AM, Zhu Lingshan wrote:
>> Hi all:
>>   This series intends to introduce Intel IFC VF NIC driver for Vhost
>> Data Plane Acceleration.
>>   Here comes two main parts, one is ifcvf_base layer, which handles
>> hardware operations. The other is ifcvf_main layer handles VF
>> initialization, configuration and removal, which depends on
>> and complys to vhost_mdev https://lkml.org/lkml/2019/9/26/15
>>   This is a first RFC try, please help review.


It would be helpful if yon can describe which kinds of test that has 
been done for this series.

Thanks


>>   Thanks!
>> BR
>> Zhu Lingshan
>>
>>
>> Zhu Lingshan (2):
>>    vhost: IFC VF hardware operation layer
>>    vhost: IFC VF vdpa layer
>>
>>   drivers/vhost/ifcvf/ifcvf_base.c | 390 ++++++++++++++++++++++++++++
>>   drivers/vhost/ifcvf/ifcvf_base.h | 137 ++++++++++
>>   drivers/vhost/ifcvf/ifcvf_main.c | 541 
>> +++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 1068 insertions(+)
>>   create mode 100644 drivers/vhost/ifcvf/ifcvf_base.c
>>   create mode 100644 drivers/vhost/ifcvf/ifcvf_base.h
>>   create mode 100644 drivers/vhost/ifcvf/ifcvf_main.c
>>
