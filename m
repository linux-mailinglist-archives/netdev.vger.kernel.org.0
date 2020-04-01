Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC36419AE48
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 16:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733062AbgDAOvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 10:51:18 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47249 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732587AbgDAOvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 10:51:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585752676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5n1TpAtrCmO/OxJ7W2yFz2Sp/6yT7ouLorwkqMfl51s=;
        b=Yub8mjC4FnLy3UWZawBaOh4tRD3oQFFXbr60wcO43qUnNxo5RYI+5KpRfmJVfsKZsHGC8J
        FwFJ41Fj/RGMM0ct/nlD6cL22WTVxrITv5PeVIicrCG2sLL23/iUjZPYQzsb2C4tvNiYu+
        aKQMaSWfrJ/+6RWqXsX0UfS2XHQr5Wk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-6pRfZq5iMh24YqoQc1E2ag-1; Wed, 01 Apr 2020 10:51:14 -0400
X-MC-Unique: 6pRfZq5iMh24YqoQc1E2ag-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20A95477;
        Wed,  1 Apr 2020 14:51:11 +0000 (UTC)
Received: from [10.72.12.139] (ovpn-12-139.pek2.redhat.com [10.72.12.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC87D98A53;
        Wed,  1 Apr 2020 14:50:52 +0000 (UTC)
Subject: Re: [PATCH V9 1/9] vhost: refine vhost and vringh kconfig
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5e409bb4-2b06-5193-20c3-a9ddaafacf5a@redhat.com>
Date:   Wed, 1 Apr 2020 22:50:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200401102631-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/1 =E4=B8=8B=E5=8D=8810:27, Michael S. Tsirkin wrote:
> On Wed, Apr 01, 2020 at 10:13:29PM +0800, Jason Wang wrote:
>> On 2020/4/1 =E4=B8=8B=E5=8D=889:02, Christian Borntraeger wrote:
>>> On 01.04.20 14:56, Christian Borntraeger wrote:
>>>> On 01.04.20 14:50, Jason Wang wrote:
>>>>> On 2020/4/1 =E4=B8=8B=E5=8D=887:21, Christian Borntraeger wrote:
>>>>>> On 26.03.20 15:01, Jason Wang wrote:
>>>>>>> Currently, CONFIG_VHOST depends on CONFIG_VIRTUALIZATION. But vho=
st is
>>>>>>> not necessarily for VM since it's a generic userspace and kernel
>>>>>>> communication protocol. Such dependency may prevent archs without
>>>>>>> virtualization support from using vhost.
>>>>>>>
>>>>>>> To solve this, a dedicated vhost menu is created under drivers so
>>>>>>> CONIFG_VHOST can be decoupled out of CONFIG_VIRTUALIZATION.
>>>>>> FWIW, this now results in vhost not being build with defconfig ker=
nels (in todays
>>>>>> linux-next).
>>>>>>
>>>>> Hi Christian:
>>>>>
>>>>> Did you meet it even with this commit=C2=A0https://git.kernel.org/p=
ub/scm/linux/kernel/git/next/linux-next.git/commit/?id=3Da4be40cbcedba9b5=
b714f3c95182e8a45176e42d?
>>>> I simply used linux-next. The defconfig does NOT contain CONFIG_VHOS=
T and therefore CONFIG_VHOST_NET and friends
>>>> can not be selected.
>>>>
>>>> $ git checkout next-20200401
>>>> $ make defconfig
>>>>     HOSTCC  scripts/basic/fixdep
>>>>     HOSTCC  scripts/kconfig/conf.o
>>>>     HOSTCC  scripts/kconfig/confdata.o
>>>>     HOSTCC  scripts/kconfig/expr.o
>>>>     LEX     scripts/kconfig/lexer.lex.c
>>>>     YACC    scripts/kconfig/parser.tab.[ch]
>>>>     HOSTCC  scripts/kconfig/lexer.lex.o
>>>>     HOSTCC  scripts/kconfig/parser.tab.o
>>>>     HOSTCC  scripts/kconfig/preprocess.o
>>>>     HOSTCC  scripts/kconfig/symbol.o
>>>>     HOSTCC  scripts/kconfig/util.o
>>>>     HOSTLD  scripts/kconfig/conf
>>>> *** Default configuration is based on 'x86_64_defconfig'
>>>> #
>>>> # configuration written to .config
>>>> #
>>>>
>>>> $ grep VHOST .config
>>>> # CONFIG_VHOST is not set
>>>>
>>>>> If yes, what's your build config looks like?
>>>>>
>>>>> Thanks
>>> This was x86. Not sure if that did work before.
>>> On s390 this is definitely a regression as the defconfig files
>>> for s390 do select VHOST_NET
>>>
>>> grep VHOST arch/s390/configs/*
>>> arch/s390/configs/debug_defconfig:CONFIG_VHOST_NET=3Dm
>>> arch/s390/configs/debug_defconfig:CONFIG_VHOST_VSOCK=3Dm
>>> arch/s390/configs/defconfig:CONFIG_VHOST_NET=3Dm
>>> arch/s390/configs/defconfig:CONFIG_VHOST_VSOCK=3Dm
>>>
>>> and this worked with 5.6, but does not work with next. Just adding
>>> CONFIG_VHOST=3Dm to the defconfig solves the issue, something like
>>
>> Right, I think we probably need
>>
>> 1) add CONFIG_VHOST=3Dm to all defconfigs that enables
>> CONFIG_VHOST_NET/VSOCK/SCSI.
>>
>> or
>>
>> 2) don't use menuconfig for CONFIG_VHOST, let NET/SCSI/VDPA just selec=
t it.
>>
>> Thanks
> OK I tried this:
>
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index 2523a1d4290a..a314b900d479 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -19,11 +19,10 @@ menuconfig VHOST
>   	  This option is selected by any driver which needs to access
>   	  the core of vhost.
>  =20
> -if VHOST
> -
>   config VHOST_NET
>   	tristate "Host kernel accelerator for virtio net"
>   	depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP)
> +	select VHOST
>   	---help---
>   	  This kernel module can be loaded in host kernel to accelerate
>   	  guest networking with virtio_net. Not to be confused with virtio_n=
et
> @@ -35,6 +34,7 @@ config VHOST_NET
>   config VHOST_SCSI
>   	tristate "VHOST_SCSI TCM fabric driver"
>   	depends on TARGET_CORE && EVENTFD
> +	select VHOST
>   	default n
>   	---help---
>   	Say M here to enable the vhost_scsi TCM fabric module
> @@ -44,6 +44,7 @@ config VHOST_VSOCK
>   	tristate "vhost virtio-vsock driver"
>   	depends on VSOCKETS && EVENTFD
>   	select VIRTIO_VSOCKETS_COMMON
> +	select VHOST
>   	default n
>   	---help---
>   	This kernel module can be loaded in the host kernel to provide AF_VS=
OCK
> @@ -57,6 +58,7 @@ config VHOST_VDPA
>   	tristate "Vhost driver for vDPA-based backend"
>   	depends on EVENTFD
>   	select VDPA
> +	select VHOST
>   	help
>   	  This kernel module can be loaded in host kernel to accelerate
>   	  guest virtio devices with the vDPA-based backends.
> @@ -78,5 +80,3 @@ config VHOST_CROSS_ENDIAN_LEGACY
>   	  adds some overhead, it is disabled by default.
>  =20
>   	  If unsure, say "N".
> -
> -endif
>
>
> But now CONFIG_VHOST is always "y", never "m".
> Which I think will make it a built-in.
> Didn't figure out why yet.


Is it because the dependency of EVENTFD for CONFIG_VHOST?

Remove that one for this patch, I can get CONFIG_VHOST=3Dm.

But according to documentation/kbuild/kconfig.rst, select is used for=20
option without prompt.

Thanks


>

