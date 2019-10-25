Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7134E4137
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 03:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389292AbfJYBot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 21:44:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32180 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389274AbfJYBot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 21:44:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571967888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qh0akrNYwC0Elz7QBIFcRniueVNDTS2+GYfPxYhIx0c=;
        b=F2sR4ys3CW0SPnhs00iI9LPAVsdidjB+RR1WajZzKb4rZ+JMzNahjeQ+/wJyOcH7embj4O
        1UoFR4oSzOl67RLY+K0g1UgzctpuixHK69VG3py0N9w/27ebIRsaQPyZiCyQ2Ztbjdx9ZO
        0HQaJG8S61sLu7jeT6M27RKWXmEtdpQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-MJT2DVAnPa2BFC_zHXHHbQ-1; Thu, 24 Oct 2019 21:44:44 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73A47476;
        Fri, 25 Oct 2019 01:44:40 +0000 (UTC)
Received: from [10.72.12.158] (ovpn-12-158.pek2.redhat.com [10.72.12.158])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A17835C1D4;
        Fri, 25 Oct 2019 01:44:06 +0000 (UTC)
Subject: Re: [PATCH V5 2/6] modpost: add support for mdev class id
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        mst@redhat.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        cohuck@redhat.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        pasic@linux.ibm.com, sebott@linux.ibm.com, oberpar@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com
References: <20191023130752.18980-1-jasowang@redhat.com>
 <20191023130752.18980-3-jasowang@redhat.com>
 <20191023154245.32e4fa49@x1.home>
 <555a101e-0ed1-2e9d-c1a4-e3b37d76bd18@redhat.com>
 <20191024135441.160daa56@x1.home>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7eb2c515-74a9-7d65-e09c-dee4f952e9c1@redhat.com>
Date:   Fri, 25 Oct 2019 09:44:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191024135441.160daa56@x1.home>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: MJT2DVAnPa2BFC_zHXHHbQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/25 =E4=B8=8A=E5=8D=883:54, Alex Williamson wrote:
> On Thu, 24 Oct 2019 11:31:04 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
>> On 2019/10/24 =E4=B8=8A=E5=8D=885:42, Alex Williamson wrote:
>>> On Wed, 23 Oct 2019 21:07:48 +0800
>>> Jason Wang <jasowang@redhat.com> wrote:
>>>  =20
>>>> Add support to parse mdev class id table.
>>>>
>>>> Reviewed-by: Parav Pandit <parav@mellanox.com>
>>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>>>> ---
>>>>    drivers/vfio/mdev/vfio_mdev.c     |  2 ++
>>>>    scripts/mod/devicetable-offsets.c |  3 +++
>>>>    scripts/mod/file2alias.c          | 10 ++++++++++
>>>>    3 files changed, 15 insertions(+)
>>>>
>>>> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_md=
ev.c
>>>> index 7b24ee9cb8dd..cb701cd646f0 100644
>>>> --- a/drivers/vfio/mdev/vfio_mdev.c
>>>> +++ b/drivers/vfio/mdev/vfio_mdev.c
>>>> @@ -125,6 +125,8 @@ static const struct mdev_class_id id_table[] =3D {
>>>>    =09{ 0 },
>>>>    };
>>>>   =20
>>>> +MODULE_DEVICE_TABLE(mdev, id_table);
>>>> +
>>> Two questions, first we have:
>>>
>>> #define MODULE_DEVICE_TABLE(type, name)                                =
 \
>>> extern typeof(name) __mod_##type##__##name##_device_table              =
 \
>>>     __attribute__ ((unused, alias(__stringify(name))))
>>>
>>> Therefore we're defining __mod_mdev__id_table_device_table with alias
>>> id_table.  When the virtio mdev bus driver is added in 5/6 it uses the
>>> same name value.  I see virtio types all register this way (virtio,
>>> id_table), so I assume there's no conflict, but pci types mostly (not
>>> entirely) seem to use unique names.  Is there a preference to one way
>>> or the other or it simply doesn't matter?
>>
>> It looks to me that those symbol were local, so it doesn't matter. But
>> if you wish I can switch to use unique name.
> I don't have a strong opinion, I'm just trying to make sure we're not
> doing something obviously broken.


Yes, to be more safe I will switch to unique names here.


>
>>>>    static struct mdev_driver vfio_mdev_driver =3D {
>>>>    =09.name=09=3D "vfio_mdev",
>>>>    =09.probe=09=3D vfio_mdev_probe,
>>>> diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetab=
le-offsets.c
>>>> index 054405b90ba4..6cbb1062488a 100644
>>>> --- a/scripts/mod/devicetable-offsets.c
>>>> +++ b/scripts/mod/devicetable-offsets.c
>>>> @@ -231,5 +231,8 @@ int main(void)
>>>>    =09DEVID(wmi_device_id);
>>>>    =09DEVID_FIELD(wmi_device_id, guid_string);
>>>>   =20
>>>> +=09DEVID(mdev_class_id);
>>>> +=09DEVID_FIELD(mdev_class_id, id);
>>>> +
>>>>    =09return 0;
>>>>    }
>>>> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
>>>> index c91eba751804..d365dfe7c718 100644
>>>> --- a/scripts/mod/file2alias.c
>>>> +++ b/scripts/mod/file2alias.c
>>>> @@ -1335,6 +1335,15 @@ static int do_wmi_entry(const char *filename, v=
oid *symval, char *alias)
>>>>    =09return 1;
>>>>    }
>>>>   =20
>>>> +/* looks like: "mdev:cN" */
>>>> +static int do_mdev_entry(const char *filename, void *symval, char *al=
ias)
>>>> +{
>>>> +=09DEF_FIELD(symval, mdev_class_id, id);
>>>> +
>>>> +=09sprintf(alias, "mdev:c%02X", id);
>>> A lot of entries call add_wildcard() here, should we?  Sorry for the
>>> basic questions, I haven't played in this code.  Thanks,
>>
>> It's really good question. My understanding is we won't have a module
>> that can deal with all kinds of classes like CLASS_ID_ANY. So there's
>> probably no need for the wildcard.
> The comment for add_wildcard() indicates future extension, so it's hard
> to know what we might need in the future until we do need it.  The
> majority of modules.alias entries on my laptop (even if I exclude pci
> aliases) end with a wildcard.  Thanks,


Yes, so I will add that for future extension.

Thanks


>
> Alex
>

