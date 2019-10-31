Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0A5FEA8F7
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 02:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfJaBqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 21:46:43 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43126 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726359AbfJaBqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 21:46:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572486397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OIhA3h+F3B7b1YDj7xFASdzKWfp17j0nfrAmTNbsOig=;
        b=aP5orx4zJ4rE44+Tr1pslHxkuSgMR2He6h2ZyVD2cmNK9FcasktZgILo9Jomw+Gol6vQ86
        Gk8K45SD4uuWC6VFFOXXnM8kZSuAVT/GFmuMkc/vqYMDGT4Mq4Lx70Agu3e7UsjuVG3344
        kfLrrKZ3SKIvqClUfN444doVLNxy1oc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-Lo1Jpa2NM_aZjD_2oVi__A-1; Wed, 30 Oct 2019 21:46:33 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93F2C800D49;
        Thu, 31 Oct 2019 01:46:28 +0000 (UTC)
Received: from [10.72.12.100] (ovpn-12-100.pek2.redhat.com [10.72.12.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 07CE960870;
        Thu, 31 Oct 2019 01:46:03 +0000 (UTC)
Subject: Re: [PATCH V6 6/6] docs: sample driver to demonstrate how to
 implement virtio-mdev framework
To:     Christoph Hellwig <hch@infradead.org>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com,
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
References: <20191030064444.21166-1-jasowang@redhat.com>
 <20191030064444.21166-7-jasowang@redhat.com>
 <20191030212312.GA4251@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d8266abb-391a-27d0-59ab-3e1412fe73da@redhat.com>
Date:   Thu, 31 Oct 2019 09:46:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191030212312.GA4251@infradead.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: Lo1Jpa2NM_aZjD_2oVi__A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/31 =E4=B8=8A=E5=8D=885:23, Christoph Hellwig wrote:
> On Wed, Oct 30, 2019 at 02:44:44PM +0800, Jason Wang wrote:
>> This sample driver creates mdev device that simulate virtio net device
>> over virtio mdev transport. The device is implemented through vringh
>> and workqueue. A device specific dma ops is to make sure HVA is used
>> directly as the IOVA. This should be sufficient for kernel virtio
>> driver to work.
>>
>> Only 'virtio' type is supported right now. I plan to add 'vhost' type
>> on top which requires some virtual IOMMU implemented in this sample
>> driver.
> Can we please submit a real driver for it?  A more or less useless
> sample driver doesn't really qualify for our normal kernel requirements
> that infrastructure should have a real user.


Intel posted a real driver here: https://lkml.org/lkml/2019/10/15/1226.

I plan to post another driver that wire virito-pci back to mdev bus on=20
top of this series as well.

Thanks


