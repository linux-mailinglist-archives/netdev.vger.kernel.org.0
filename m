Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62BED1424E7
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 09:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgATITl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 03:19:41 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52449 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726752AbgATITk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 03:19:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579508379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jEiSgvaAAQAeTsd3Se/ZuFf+OWr2upYmR4dY+/WXBIE=;
        b=ibL7D0nYBdVAuzgQi1hQ4cGrzNLdMMOedSTC7t+QjxuXTyUh3aPc/std25xZPaGIVNqn6T
        Lc2YbpBakfLwSdIu1X1yH7lMsEPV5HTRRFKzIBE+Lr/AlpQT2tQhTagCxhd6oi0csFDWl1
        sYha7TiRS13k8k+z1EhpjfL6P40Zn/Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-P8KSRlF4PzGBmy91vGOhqQ-1; Mon, 20 Jan 2020 03:19:38 -0500
X-MC-Unique: P8KSRlF4PzGBmy91vGOhqQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E91FADB60;
        Mon, 20 Jan 2020 08:19:34 +0000 (UTC)
Received: from [10.72.12.173] (ovpn-12-173.pek2.redhat.com [10.72.12.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 071CE2857A;
        Mon, 20 Jan 2020 08:19:11 +0000 (UTC)
Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
To:     Rob Miller <rob.miller@broadcom.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        "Bie, Tiwei" <tiwei.bie@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>, maxime.coquelin@redhat.com,
        "Liang, Cunming" <cunming.liang@intel.com>,
        "Wang, Zhihong" <zhihong.wang@intel.com>,
        "Wang, Xiao W" <xiao.w.wang@intel.com>, haotian.wang@sifive.com,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>, eperezma@redhat.com,
        lulu@redhat.com, Parav Pandit <parav@mellanox.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, stefanha@redhat.com,
        rdunlap@infradead.org, hch@infradead.org,
        Ariel Adam <aadam@redhat.com>, jakub.kicinski@netronome.com,
        Jiri Pirko <jiri@mellanox.com>, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-4-jasowang@redhat.com>
 <20200117070324-mutt-send-email-mst@kernel.org>
 <239b042c-2d9e-0eec-a1ef-b03b7e2c5419@redhat.com>
 <CAJPjb1+fG9L3=iKbV4Vn13VwaeDZZdcfBPvarogF_Nzhk+FnKg@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a4573aa4-f0d6-bb7d-763a-96352fc2c86e@redhat.com>
Date:   Mon, 20 Jan 2020 16:19:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAJPjb1+fG9L3=iKbV4Vn13VwaeDZZdcfBPvarogF_Nzhk+FnKg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/1/17 =E4=B8=8B=E5=8D=8810:12, Rob Miller wrote:
>
>
>     >> + * @get_vendor_id:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Get id for=
 the vendor that
>     provides this device
>     >> + *=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 @vdev: vdpa device
>     >> + *=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Returns u32: virtio vendor id
>     > what's the idea behind this? userspace normally doesn't interact
>     with
>     > this ... debugging?
>
>
>     This allows some vendor specific driver on top of vDPA bus. If
>     this is
>     not interested, I can drop this.
>
> RJM>] wouldn't=C2=A0 usage of get_device_id & get_vendor_id, beyond=20
> reporting, tend to possibly leading to vendor specific code in the=20
> framework instead of leaving the framework=C2=A0agnostic and leave the=20
> vendor specific stuff to the vendor's vDPA device driver?


For virtio device id, I think it is needed for kernel/userspace to know=20
which driver to load (e.g loading virtio-net for networking devic).

For virtio vendor id, it was needed by kernel virtio driver, and virtio=20
bus can match driver based on virtio vendor id. So it doesn't prevent=20
3rd vendor specific driver for virtio device.

Maybe we can report VIRTIO_DEV_ANY_ID as vendor id to forbid vendor=20
specific stuffs.

Thanks


