Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A26D2F2671
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 05:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733158AbfKGEQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 23:16:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55556 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1733080AbfKGEQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 23:16:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573100185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k3IbSyGD4qLkNAVSZEuvxBFa8ZkDMuEWAdZpi7gSPzg=;
        b=Do3Igs2tvwS8OTK8hbB7u4ZsqRcVAkIVIUg14UFpmEe4B+9+JqeyLJxNAC1Nw1+YzDeDlC
        fyCofOhZlkeDIGBo0xlhAC9tu+ECYZ235RWfm3U651u2soB6+FL+y6wYAcUU9EL9+bBR/4
        LC7dukr1sDz0p+VtiwMPTnGGZVF84UM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-MQBzENQcOFypmSyLPrCApQ-1; Wed, 06 Nov 2019 23:16:17 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3470800C61;
        Thu,  7 Nov 2019 04:16:15 +0000 (UTC)
Received: from [10.72.12.214] (ovpn-12-214.pek2.redhat.com [10.72.12.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54F865D6B7;
        Thu,  7 Nov 2019 04:16:03 +0000 (UTC)
Subject: Re: [PATCH v5] vhost: introduce mdev based hardware backend
To:     Tiwei Bie <tiwei.bie@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     alex.williamson@redhat.com, maxime.coquelin@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dan.daly@intel.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, lingshan.zhu@intel.com
References: <20191105115332.11026-1-tiwei.bie@intel.com>
 <20191106075733-mutt-send-email-mst@kernel.org> <20191106143907.GA10776@___>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <def13888-c99f-5f59-647b-05a4bb2f8657@redhat.com>
Date:   Thu, 7 Nov 2019 12:16:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191106143907.GA10776@___>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: MQBzENQcOFypmSyLPrCApQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/6 =E4=B8=8B=E5=8D=8810:39, Tiwei Bie wrote:
> On Wed, Nov 06, 2019 at 07:59:02AM -0500, Michael S. Tsirkin wrote:
>> On Tue, Nov 05, 2019 at 07:53:32PM +0800, Tiwei Bie wrote:
>>> This patch introduces a mdev based hardware vhost backend.
>>> This backend is built on top of the same abstraction used
>>> in virtio-mdev and provides a generic vhost interface for
>>> userspace to accelerate the virtio devices in guest.
>>>
>>> This backend is implemented as a mdev device driver on top
>>> of the same mdev device ops used in virtio-mdev but using
>>> a different mdev class id, and it will register the device
>>> as a VFIO device for userspace to use. Userspace can setup
>>> the IOMMU with the existing VFIO container/group APIs and
>>> then get the device fd with the device name. After getting
>>> the device fd, userspace can use vhost ioctls on top of it
>>> to setup the backend.
>>>
>>> Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
>> So at this point, looks like the only thing missing is IFC, and then all
>> these patches can go in.
>> But as IFC is still being worked on anyway, it makes sense to
>> address the minor comments manwhile so we don't need
>> patches on top.
>> Right?
> Yeah, of course.
>
> Thanks,
> Tiwei


Please send V6 and I will ack there.

Thanks

