Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D911EB648
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 09:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgFBHMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 03:12:55 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41473 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725835AbgFBHMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 03:12:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591081973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P0Hsyk/buplzmPpjkWUnfP95pA3HShavyi16EwRZaII=;
        b=XwncqOxWi4oJMWxzisL1O39dD2rk8ZrZleFl1bZXw76qiWPPpSDJtv/tPOH7oZXnyEbbsK
        ML8DNwRG0twCEbtzxFrXDwgyb4ADIjkLlBEIyBh0Z7LTxaKkyouFBZdwK6qymGasfQ5rks
        no17zfkzbaiOc0AYG5fillkmmunBnc8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-6a247yFiPJyTotLRLcin1w-1; Tue, 02 Jun 2020 03:12:52 -0400
X-MC-Unique: 6a247yFiPJyTotLRLcin1w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66269835B40;
        Tue,  2 Jun 2020 07:12:50 +0000 (UTC)
Received: from [10.72.12.102] (ovpn-12-102.pek2.redhat.com [10.72.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3CF860F8D;
        Tue,  2 Jun 2020 07:12:31 +0000 (UTC)
Subject: Re: [PATCH 5/6] vdpa: introduce virtio pci driver
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.miller@broadcom.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, eli@mellanox.com
References: <20200529080303.15449-1-jasowang@redhat.com>
 <20200529080303.15449-6-jasowang@redhat.com>
 <20200602010809-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e722bb62-2a72-779a-f542-1096e8f609b8@redhat.com>
Date:   Tue, 2 Jun 2020 15:12:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200602010809-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/2 下午1:09, Michael S. Tsirkin wrote:
> On Fri, May 29, 2020 at 04:03:02PM +0800, Jason Wang wrote:
>> Note that since virtio specification does not support get/restore
>> virtqueue state. So we can not use this driver for VM. This can be
>> addressed by extending the virtio specification.
> Looks like exactly the kind of hardware limitation VDPA is supposed to
> paper over within guest. So I suggest we use this as
> a litmus test, and find ways for VDPA to handle this without
> spec changes.


Yes, and just to confirm, do you think it's beneficial to extend virtio 
specification to support state get/set?

Thanks


>

