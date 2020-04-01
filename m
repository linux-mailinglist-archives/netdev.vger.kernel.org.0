Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9708D19B602
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 20:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732618AbgDASxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 14:53:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57206 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732532AbgDASxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 14:53:42 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 031IXWsX130824
        for <netdev@vger.kernel.org>; Wed, 1 Apr 2020 14:53:40 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 302070q4cx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 14:53:40 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Wed, 1 Apr 2020 19:53:23 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 1 Apr 2020 19:53:15 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 031IqPUl47710512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Apr 2020 18:52:25 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A91C4C04E;
        Wed,  1 Apr 2020 18:53:28 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A59C64C046;
        Wed,  1 Apr 2020 18:53:25 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.71.143])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  1 Apr 2020 18:53:25 +0000 (GMT)
Subject: Re: [PATCH V9 1/9] vhost: refine vhost and vringh kconfig
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, kevin.tian@intel.com, stefanha@redhat.com,
        rdunlap@infradead.org, hch@infradead.org, aadam@redhat.com,
        jiri@mellanox.com, shahafs@mellanox.com, hanand@xilinx.com,
        mhabets@solarflare.com, gdawar@xilinx.com, saugatm@xilinx.com,
        vmireyno@marvell.com, zhangweining@ruijie.com.cn
References: <20200326140125.19794-1-jasowang@redhat.com>
 <20200326140125.19794-2-jasowang@redhat.com>
 <fde312a4-56bd-f11f-799f-8aa952008012@de.ibm.com>
 <41ee1f6a-3124-d44b-bf34-0f26604f9514@redhat.com>
 <4726da4c-11ec-3b6e-1218-6d6d365d5038@de.ibm.com>
 <39b96e3a-9f4e-6e1d-e988-8c4bcfb55879@de.ibm.com>
 <c423c5b1-7817-7417-d7af-e07bef6368e7@redhat.com>
 <20200401102631-mutt-send-email-mst@kernel.org>
 <5e409bb4-2b06-5193-20c3-a9ddaafacf5a@redhat.com>
 <20200401115650-mutt-send-email-mst@kernel.org>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Wed, 1 Apr 2020 20:53:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200401115650-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20040118-4275-0000-0000-000003B7C32C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040118-4276-0000-0000-000038CD1700
Message-Id: <cc3ef7f5-2980-00bf-2534-272b882bb64f@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-01_04:2020-03-31,2020-04-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 spamscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=961 suspectscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004010150
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01.04.20 17:57, Michael S. Tsirkin wrote:
> On Wed, Apr 01, 2020 at 10:50:50PM +0800, Jason Wang wrote:
>>
>> On 2020/4/1 下午10:27, Michael S. Tsirkin wrote:
>>> On Wed, Apr 01, 2020 at 10:13:29PM +0800, Jason Wang wrote:
>>>> On 2020/4/1 下午9:02, Christian Borntraeger wrote:
>>>>> On 01.04.20 14:56, Christian Borntraeger wrote:
>>>>>> On 01.04.20 14:50, Jason Wang wrote:
>>>>>>> On 2020/4/1 下午7:21, Christian Borntraeger wrote:
>>>>>>>> On 26.03.20 15:01, Jason Wang wrote:
>>>>>>>>> Currently, CONFIG_VHOST depends on CONFIG_VIRTUALIZATION. But vhost is
>>>>>>>>> not necessarily for VM since it's a generic userspace and kernel
>>>>>>>>> communication protocol. Such dependency may prevent archs without
>>>>>>>>> virtualization support from using vhost.
>>>>>>>>>
>>>>>>>>> To solve this, a dedicated vhost menu is created under drivers so
>>>>>>>>> CONIFG_VHOST can be decoupled out of CONFIG_VIRTUALIZATION.
>>>>>>>> FWIW, this now results in vhost not being build with defconfig kernels (in todays
>>>>>>>> linux-next).
>>>>>>>>
>>>>>>> Hi Christian:
>>>>>>>
>>>>>>> Did you meet it even with this commit https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=a4be40cbcedba9b5b714f3c95182e8a45176e42d?
>>>>>> I simply used linux-next. The defconfig does NOT contain CONFIG_VHOST and therefore CONFIG_VHOST_NET and friends
>>>>>> can not be selected.
>>>>>>
>>>>>> $ git checkout next-20200401
>>>>>> $ make defconfig
>>>>>>     HOSTCC  scripts/basic/fixdep
>>>>>>     HOSTCC  scripts/kconfig/conf.o
>>>>>>     HOSTCC  scripts/kconfig/confdata.o
>>>>>>     HOSTCC  scripts/kconfig/expr.o
>>>>>>     LEX     scripts/kconfig/lexer.lex.c
>>>>>>     YACC    scripts/kconfig/parser.tab.[ch]
>>>>>>     HOSTCC  scripts/kconfig/lexer.lex.o
>>>>>>     HOSTCC  scripts/kconfig/parser.tab.o
>>>>>>     HOSTCC  scripts/kconfig/preprocess.o
>>>>>>     HOSTCC  scripts/kconfig/symbol.o
>>>>>>     HOSTCC  scripts/kconfig/util.o
>>>>>>     HOSTLD  scripts/kconfig/conf
>>>>>> *** Default configuration is based on 'x86_64_defconfig'
>>>>>> #
>>>>>> # configuration written to .config
>>>>>> #
>>>>>>
>>>>>> $ grep VHOST .config
>>>>>> # CONFIG_VHOST is not set
>>>>>>
>>>>>>> If yes, what's your build config looks like?
>>>>>>>
>>>>>>> Thanks
>>>>> This was x86. Not sure if that did work before.
>>>>> On s390 this is definitely a regression as the defconfig files
>>>>> for s390 do select VHOST_NET
>>>>>
>>>>> grep VHOST arch/s390/configs/*
>>>>> arch/s390/configs/debug_defconfig:CONFIG_VHOST_NET=m
>>>>> arch/s390/configs/debug_defconfig:CONFIG_VHOST_VSOCK=m
>>>>> arch/s390/configs/defconfig:CONFIG_VHOST_NET=m
>>>>> arch/s390/configs/defconfig:CONFIG_VHOST_VSOCK=m
>>>>>
>>>>> and this worked with 5.6, but does not work with next. Just adding
>>>>> CONFIG_VHOST=m to the defconfig solves the issue, something like
>>>>
>>>> Right, I think we probably need
>>>>
>>>> 1) add CONFIG_VHOST=m to all defconfigs that enables
>>>> CONFIG_VHOST_NET/VSOCK/SCSI.
>>>>
>>>> or
>>>>
>>>> 2) don't use menuconfig for CONFIG_VHOST, let NET/SCSI/VDPA just select it.
>>>>
>>>> Thanks
>>> OK I tried this:
>>>
>>> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
>>> index 2523a1d4290a..a314b900d479 100644
>>> --- a/drivers/vhost/Kconfig
>>> +++ b/drivers/vhost/Kconfig
>>> @@ -19,11 +19,10 @@ menuconfig VHOST
>>>   	  This option is selected by any driver which needs to access
>>>   	  the core of vhost.
>>> -if VHOST
>>> -
>>>   config VHOST_NET
>>>   	tristate "Host kernel accelerator for virtio net"
>>>   	depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP)
>>> +	select VHOST
>>>   	---help---
>>>   	  This kernel module can be loaded in host kernel to accelerate
>>>   	  guest networking with virtio_net. Not to be confused with virtio_net
>>> @@ -35,6 +34,7 @@ config VHOST_NET
>>>   config VHOST_SCSI
>>>   	tristate "VHOST_SCSI TCM fabric driver"
>>>   	depends on TARGET_CORE && EVENTFD
>>> +	select VHOST
>>>   	default n
>>>   	---help---
>>>   	Say M here to enable the vhost_scsi TCM fabric module
>>> @@ -44,6 +44,7 @@ config VHOST_VSOCK
>>>   	tristate "vhost virtio-vsock driver"
>>>   	depends on VSOCKETS && EVENTFD
>>>   	select VIRTIO_VSOCKETS_COMMON
>>> +	select VHOST
>>>   	default n
>>>   	---help---
>>>   	This kernel module can be loaded in the host kernel to provide AF_VSOCK
>>> @@ -57,6 +58,7 @@ config VHOST_VDPA
>>>   	tristate "Vhost driver for vDPA-based backend"
>>>   	depends on EVENTFD
>>>   	select VDPA
>>> +	select VHOST
>>>   	help
>>>   	  This kernel module can be loaded in host kernel to accelerate
>>>   	  guest virtio devices with the vDPA-based backends.
>>> @@ -78,5 +80,3 @@ config VHOST_CROSS_ENDIAN_LEGACY
>>>   	  adds some overhead, it is disabled by default.
>>>   	  If unsure, say "N".
>>> -
>>> -endif
>>>
>>>
>>> But now CONFIG_VHOST is always "y", never "m".
>>> Which I think will make it a built-in.
>>> Didn't figure out why yet.
>>
>>
>> Is it because the dependency of EVENTFD for CONFIG_VHOST?
> 
> Oh no, it's because I forgot to change menuconfig to config.
> 
> 
>> Remove that one for this patch, I can get CONFIG_VHOST=m.

FWIW, the current vhost/linux-next branch seems to work again.

