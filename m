Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E582C19AD89
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 16:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732881AbgDAOOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 10:14:00 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52788 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732839AbgDAOOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 10:14:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585750438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SgMHqO/rrpPCHGR8xK4BkGOVi78dVLWaqsGqMgXXbEE=;
        b=hKNDg57VY/EoINZtdh+NdUTkaffFR6FqhOLj+VLZn1AKe3hd2Q0S+5ruvSno0Z1RtXCqt5
        CTimV34echCNTkZrbFCXUE/F3qIBo22h4EjC0Ol2IoljSV4YOaam3N3yhYCHw/qQGmuhFl
        l17vcxr6f6njTiXEO+J2b17Acae4m3Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-m5LNliciMgegU4oo4HtSiA-1; Wed, 01 Apr 2020 10:13:57 -0400
X-MC-Unique: m5LNliciMgegU4oo4HtSiA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA86F107ACC7;
        Wed,  1 Apr 2020 14:13:53 +0000 (UTC)
Received: from [10.72.12.139] (ovpn-12-139.pek2.redhat.com [10.72.12.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4EB4719C70;
        Wed,  1 Apr 2020 14:13:30 +0000 (UTC)
Subject: Re: [PATCH V9 1/9] vhost: refine vhost and vringh kconfig
To:     Christian Borntraeger <borntraeger@de.ibm.com>, mst@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     jgg@mellanox.com, maxime.coquelin@redhat.com,
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c423c5b1-7817-7417-d7af-e07bef6368e7@redhat.com>
Date:   Wed, 1 Apr 2020 22:13:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <39b96e3a-9f4e-6e1d-e988-8c4bcfb55879@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/1 =E4=B8=8B=E5=8D=889:02, Christian Borntraeger wrote:
>
> On 01.04.20 14:56, Christian Borntraeger wrote:
>> On 01.04.20 14:50, Jason Wang wrote:
>>> On 2020/4/1 =E4=B8=8B=E5=8D=887:21, Christian Borntraeger wrote:
>>>> On 26.03.20 15:01, Jason Wang wrote:
>>>>> Currently, CONFIG_VHOST depends on CONFIG_VIRTUALIZATION. But vhost=
 is
>>>>> not necessarily for VM since it's a generic userspace and kernel
>>>>> communication protocol. Such dependency may prevent archs without
>>>>> virtualization support from using vhost.
>>>>>
>>>>> To solve this, a dedicated vhost menu is created under drivers so
>>>>> CONIFG_VHOST can be decoupled out of CONFIG_VIRTUALIZATION.
>>>> FWIW, this now results in vhost not being build with defconfig kerne=
ls (in todays
>>>> linux-next).
>>>>
>>> Hi Christian:
>>>
>>> Did you meet it even with this commit=C2=A0https://git.kernel.org/pub=
/scm/linux/kernel/git/next/linux-next.git/commit/?id=3Da4be40cbcedba9b5b7=
14f3c95182e8a45176e42d?
>> I simply used linux-next. The defconfig does NOT contain CONFIG_VHOST =
and therefore CONFIG_VHOST_NET and friends
>> can not be selected.
>>
>> $ git checkout next-20200401
>> $ make defconfig
>>    HOSTCC  scripts/basic/fixdep
>>    HOSTCC  scripts/kconfig/conf.o
>>    HOSTCC  scripts/kconfig/confdata.o
>>    HOSTCC  scripts/kconfig/expr.o
>>    LEX     scripts/kconfig/lexer.lex.c
>>    YACC    scripts/kconfig/parser.tab.[ch]
>>    HOSTCC  scripts/kconfig/lexer.lex.o
>>    HOSTCC  scripts/kconfig/parser.tab.o
>>    HOSTCC  scripts/kconfig/preprocess.o
>>    HOSTCC  scripts/kconfig/symbol.o
>>    HOSTCC  scripts/kconfig/util.o
>>    HOSTLD  scripts/kconfig/conf
>> *** Default configuration is based on 'x86_64_defconfig'
>> #
>> # configuration written to .config
>> #
>>
>> $ grep VHOST .config
>> # CONFIG_VHOST is not set
>>
>>  =20
>>> If yes, what's your build config looks like?
>>>
>>> Thanks
> This was x86. Not sure if that did work before.
> On s390 this is definitely a regression as the defconfig files
> for s390 do select VHOST_NET
>
> grep VHOST arch/s390/configs/*
> arch/s390/configs/debug_defconfig:CONFIG_VHOST_NET=3Dm
> arch/s390/configs/debug_defconfig:CONFIG_VHOST_VSOCK=3Dm
> arch/s390/configs/defconfig:CONFIG_VHOST_NET=3Dm
> arch/s390/configs/defconfig:CONFIG_VHOST_VSOCK=3Dm
>
> and this worked with 5.6, but does not work with next. Just adding
> CONFIG_VHOST=3Dm to the defconfig solves the issue, something like


Right, I think we probably need

1) add CONFIG_VHOST=3Dm to all defconfigs that enables=20
CONFIG_VHOST_NET/VSOCK/SCSI.

or

2) don't use menuconfig for CONFIG_VHOST, let NET/SCSI/VDPA just select i=
t.

Thanks


>
> ---
>   arch/s390/configs/debug_defconfig | 5 +++--
>   arch/s390/configs/defconfig       | 5 +++--
>   2 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debu=
g_defconfig
> index 46038bc58c9e..0b83274341ce 100644
> --- a/arch/s390/configs/debug_defconfig
> +++ b/arch/s390/configs/debug_defconfig
> @@ -57,8 +57,6 @@ CONFIG_PROTECTED_VIRTUALIZATION_GUEST=3Dy
>   CONFIG_CMM=3Dm
>   CONFIG_APPLDATA_BASE=3Dy
>   CONFIG_KVM=3Dm
> -CONFIG_VHOST_NET=3Dm
> -CONFIG_VHOST_VSOCK=3Dm
>   CONFIG_OPROFILE=3Dm
>   CONFIG_KPROBES=3Dy
>   CONFIG_JUMP_LABEL=3Dy
> @@ -561,6 +559,9 @@ CONFIG_VFIO_MDEV_DEVICE=3Dm
>   CONFIG_VIRTIO_PCI=3Dm
>   CONFIG_VIRTIO_BALLOON=3Dm
>   CONFIG_VIRTIO_INPUT=3Dy
> +CONFIG_VHOST=3Dm
> +CONFIG_VHOST_NET=3Dm
> +CONFIG_VHOST_VSOCK=3Dm
>   CONFIG_S390_CCW_IOMMU=3Dy
>   CONFIG_S390_AP_IOMMU=3Dy
>   CONFIG_EXT4_FS=3Dy
> diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
> index 7cd0648c1f4e..39e69c4e8cf7 100644
> --- a/arch/s390/configs/defconfig
> +++ b/arch/s390/configs/defconfig
> @@ -57,8 +57,6 @@ CONFIG_PROTECTED_VIRTUALIZATION_GUEST=3Dy
>   CONFIG_CMM=3Dm
>   CONFIG_APPLDATA_BASE=3Dy
>   CONFIG_KVM=3Dm
> -CONFIG_VHOST_NET=3Dm
> -CONFIG_VHOST_VSOCK=3Dm
>   CONFIG_OPROFILE=3Dm
>   CONFIG_KPROBES=3Dy
>   CONFIG_JUMP_LABEL=3Dy
> @@ -557,6 +555,9 @@ CONFIG_VFIO_MDEV_DEVICE=3Dm
>   CONFIG_VIRTIO_PCI=3Dm
>   CONFIG_VIRTIO_BALLOON=3Dm
>   CONFIG_VIRTIO_INPUT=3Dy
> +CONFIG_VHOST=3Dm
> +CONFIG_VHOST_NET=3Dm
> +CONFIG_VHOST_VSOCK=3Dm
>   CONFIG_S390_CCW_IOMMU=3Dy
>   CONFIG_S390_AP_IOMMU=3Dy
>   CONFIG_EXT4_FS=3Dy

