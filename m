Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D592E75F0
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 05:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgL3EGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 23:06:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55642 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726168AbgL3EGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 23:06:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609301086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=87Z6ci1v2zuVojOQC2txx0MeUSow10QAvJKJUecJndQ=;
        b=GNrcHHKe987kQVZhFDw0VTIZMl5baf6QB56Lzx26+vhqXeBgJpF6KzeSTYrIhL4wLoZZog
        Yt0eo0R5v1Y/O23IoWHECCaJ+1AweHfbGOk6g7+lsZCeNOnR4wmywX2kH0K2vhRLGxnjVu
        TKEe8gFxNKHAIfgo8gvQL1o8E5TtXvw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-JamB0Jt2P9y1nW7cSEysxg-1; Tue, 29 Dec 2020 23:04:45 -0500
X-MC-Unique: JamB0Jt2P9y1nW7cSEysxg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CCAD107ACE3;
        Wed, 30 Dec 2020 04:04:43 +0000 (UTC)
Received: from [10.72.13.30] (ovpn-13-30.pek2.redhat.com [10.72.13.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B1B565C8AA;
        Wed, 30 Dec 2020 04:04:31 +0000 (UTC)
Subject: Re: [PATCH 07/21] vdpa: multiple address spaces support
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, eperezma@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com, eli@mellanox.com,
        lingshan.zhu@intel.com, rob.miller@broadcom.com,
        stefanha@redhat.com, sgarzare@redhat.com
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20201216064818.48239-8-jasowang@redhat.com>
 <20201229072832.GA195479@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e8b9dabb-ae78-1c84-b5f3-409bec3e8255@redhat.com>
Date:   Wed, 30 Dec 2020 12:04:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201229072832.GA195479@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/29 下午3:28, Eli Cohen wrote:
>> @@ -43,6 +43,8 @@ struct vdpa_vq_state {
>>    * @index: device index
>>    * @features_valid: were features initialized? for legacy guests
>>    * @nvqs: the number of virtqueues
>> + * @ngroups: the number of virtqueue groups
>> + * @nas: the number of address spaces
> I am not sure these can be categorised as part of the state of the VQ.
> It's more of a property so maybe we can have a callback to get the
> properties of the VQ?


Or maybe there's a misunderstanding of the patch.

Those two attributes belongs to vdpa_device instead of vdpa_vq_state 
actually.

Thanks

