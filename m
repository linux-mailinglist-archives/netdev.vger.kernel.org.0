Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D413151618
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 07:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgBDGqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 01:46:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24030 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726898AbgBDGqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 01:46:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580798794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lRmh1aVKkLxdGY5o4e9g8sJUX2Z2AYQmtRAb6n2qp1c=;
        b=VnYCn+j6NcOkVwEKyfrJyFkQwg3GAB14N9jAMAHNuZlssCm9ioDy5J9xr0CfYh//W5VTIq
        BDbHcUvteW1d+0qk3GeVSMW6ed/ds60p0d7TqbRnbtr+CsxlUBkIR1cSWGqTXbx9xMje43
        k3xDBTVH3npTc6kugs0hwkGwikZrG/4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-FSR9JKk9NNGNNcjsuyGcpA-1; Tue, 04 Feb 2020 01:46:33 -0500
X-MC-Unique: FSR9JKk9NNGNNcjsuyGcpA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36F508010E6;
        Tue,  4 Feb 2020 06:46:30 +0000 (UTC)
Received: from [10.72.12.170] (ovpn-12-170.pek2.redhat.com [10.72.12.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21E881001B23;
        Tue,  4 Feb 2020 06:46:17 +0000 (UTC)
Subject: Re: [PATCH] vhost: introduce vDPA based backend
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Tiwei Bie <tiwei.bie@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, shahafs@mellanox.com, jgg@mellanox.com,
        rob.miller@broadcom.com, haotian.wang@sifive.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        rdunlap@infradead.org, hch@infradead.org, jiri@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com,
        maxime.coquelin@redhat.com, lingshan.zhu@intel.com,
        dan.daly@intel.com, cunming.liang@intel.com, zhihong.wang@intel.com
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
 <20200204005306-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <cf485e7f-46e3-20d3-8452-e3058b885d0a@redhat.com>
Date:   Tue, 4 Feb 2020 14:46:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200204005306-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/4 =E4=B8=8B=E5=8D=882:01, Michael S. Tsirkin wrote:
> On Tue, Feb 04, 2020 at 11:30:11AM +0800, Jason Wang wrote:
>> 5) generate diffs of memory table and using IOMMU API to setup the dma
>> mapping in this method
> Frankly I think that's a bunch of work. Why not a MAP/UNMAP interface?
>

Sure, so that basically VHOST_IOTLB_UPDATE/INVALIDATE I think?

Thanks


