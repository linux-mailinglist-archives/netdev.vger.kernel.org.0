Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A231F2E51
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 13:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388568AbfKGMnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 07:43:53 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21580 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727619AbfKGMnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 07:43:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573130632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pATjVuxpgA+rUzNn2lzZ9Qgz3lzYzBUuXos2KOBhUA8=;
        b=V/nFimh8jiR45m70yKJXar3TIbl+K8V+IjUOKa+Ct/GANAshtNranAnmL2N8+hEUIBmX8U
        TX/JuEh53syYtY+5H4QzBFeFX1f3rEbT+QlO5IboW+ElnAsMZR2dpg6v3ewAI+8uXzkxhB
        9p4c+er9tDwi3aBMtvuQXgVMQAsOs0g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-8LDROsBLN-2gMmnotsVoag-1; Thu, 07 Nov 2019 07:43:49 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1CEED477;
        Thu,  7 Nov 2019 12:43:45 +0000 (UTC)
Received: from [10.72.12.21] (ovpn-12-21.pek2.redhat.com [10.72.12.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A587D608AC;
        Thu,  7 Nov 2019 12:43:31 +0000 (UTC)
Subject: Re: [PATCH V10 6/6] docs: sample driver to demonstrate how to
 implement virtio-mdev framework
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, tiwei.bie@intel.com,
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
References: <20191106133531.693-1-jasowang@redhat.com>
 <20191106133531.693-7-jasowang@redhat.com>
 <20191107040700-mutt-send-email-mst@kernel.org>
 <bd2f7796-8d88-0eb3-b55b-3ec062b186b7@redhat.com>
 <20191107061942-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d09229bc-c3e4-8d4b-c28f-565fe150ced2@redhat.com>
Date:   Thu, 7 Nov 2019 20:43:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191107061942-mutt-send-email-mst@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 8LDROsBLN-2gMmnotsVoag-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/7 =E4=B8=8B=E5=8D=887:21, Michael S. Tsirkin wrote:
> On Thu, Nov 07, 2019 at 06:18:45PM +0800, Jason Wang wrote:
>> On 2019/11/7 =E4=B8=8B=E5=8D=885:08, Michael S. Tsirkin wrote:
>>> On Wed, Nov 06, 2019 at 09:35:31PM +0800, Jason Wang wrote:
>>>> This sample driver creates mdev device that simulate virtio net device
>>>> over virtio mdev transport. The device is implemented through vringh
>>>> and workqueue. A device specific dma ops is to make sure HVA is used
>>>> directly as the IOVA. This should be sufficient for kernel virtio
>>>> driver to work.
>>>>
>>>> Only 'virtio' type is supported right now. I plan to add 'vhost' type
>>>> on top which requires some virtual IOMMU implemented in this sample
>>>> driver.
>>>>
>>>> Acked-by: Cornelia Huck<cohuck@redhat.com>
>>>> Signed-off-by: Jason Wang<jasowang@redhat.com>
>>> I'd prefer it that we call this something else, e.g.
>>> mvnet-loopback. Just so people don't expect a fully
>>> functional device somehow. Can be renamed when applying?
>> Actually, I plan to extend it as another standard network interface for
>> kernel. It could be either a standalone pseudo device or a stack device.
>> Does this sounds good to you?
>>
>> Thanks
> That's a big change in an interface so it's a good reason
> to rename the driver at that point right?
> Oherwise users of an old kernel would expect a stacked driver
> and get a loopback instead.
>
> Or did I miss something?


My understanding is that it was a sample driver in /doc. It should not=20
be used in production environment. Otherwise we need to move it to=20
driver/virtio.

But if you insist, I can post a V11.

Thanks

