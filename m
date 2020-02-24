Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C279169ECB
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 07:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgBXGtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 01:49:14 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59033 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727277AbgBXGtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 01:49:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582526952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OFrZl6Sw3yEf+caSATqePnmBvtnNQFZ6PQ2MTTPkWY4=;
        b=ZPUPeHm7W7bYUdLzxTLyCr/4UluFXuIVJj3AewnyRmTYQnCzMb2yOIRCyCEAnXam55Gfxh
        J9JAqxZ6BTpOmeurmPNNDpX8KOqZNoaU67nTlKK+k5p5HnTT6qb2qXzPCkqPuVlMqLkMK6
        pxpXLOoFT3779sf3VvExMkMVmiFliOU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-2pKoJM5WNTO2krrL8cQnhw-1; Mon, 24 Feb 2020 01:49:10 -0500
X-MC-Unique: 2pKoJM5WNTO2krrL8cQnhw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB5E0800D54;
        Mon, 24 Feb 2020 06:49:07 +0000 (UTC)
Received: from [10.72.13.147] (ovpn-13-147.pek2.redhat.com [10.72.13.147])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4035A5C21B;
        Mon, 24 Feb 2020 06:48:49 +0000 (UTC)
Subject: Re: [PATCH V4 3/5] vDPA: introduce vDPA bus
To:     Harpreet Singh Anand <hanand@xilinx.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "tiwei.bie@intel.com" <tiwei.bie@intel.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "xiao.w.wang@intel.com" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "aadam@redhat.com" <aadam@redhat.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
References: <20200220061141.29390-1-jasowang@redhat.com>
 <20200220061141.29390-4-jasowang@redhat.com>
 <BY5PR02MB63714A03B7135F8C4054C1E8BBEC0@BY5PR02MB6371.namprd02.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d6ea5dcb-3933-920b-523e-a494d323ef8a@redhat.com>
Date:   Mon, 24 Feb 2020 14:48:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <BY5PR02MB63714A03B7135F8C4054C1E8BBEC0@BY5PR02MB6371.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/24 =E4=B8=8B=E5=8D=882:14, Harpreet Singh Anand wrote:
> Is there a plan to add an API in vDPA_config_ops for getting the notifi=
cation area from the VDPA device (something similar to get_notify_area in=
 the VDPA DPDK case)? This will make the notifications from the guest  (v=
host_vdpa use case) to the VDPA device more efficient - at least for virt=
io 1.0+ drivers in the VM.
>
> I believe this would require enhancement to the vhost ioctl (something =
similar to the  VHOST_USER_SLAVE_VRING_HOST_NOTIFIER_MSG).


Yes, we plan to add that on top. Basically, here's what we plan to do:=20
(sorted by urgency)

1) direct doorbell mapping as you asked here
2) direct interrupt injection (when platform support, e.g through posted=20
interrupt)
3) control virtqueue support

Thanks


>
>
> Regards,
> Harpreet
>

