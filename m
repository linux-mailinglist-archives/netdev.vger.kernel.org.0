Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 223F116570E
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 06:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgBTFko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 00:40:44 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24961 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbgBTFko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 00:40:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582177243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8QbhRAmcBDryazlqaGLXKsumEY3b7rJXFJ1OmDZwn+I=;
        b=d1aOVXOIe/BuJhkAMAzGPFJNgtNQ1dvq3QYY9MLvry5T1eBL/8oyDsZHix83kIQfBV+kxN
        1J5gX8XDeCVt6bf+lQLar9hSzI3BZHt+qze9JCMq1qzpxcdn6YZ2en06ewz3ACHAWy/wJG
        qC6qNEpvos8SaWbMHvRa6RvU43w8Vuc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-X456oni2MnSlkHp90s63Aw-1; Thu, 20 Feb 2020 00:40:41 -0500
X-MC-Unique: X456oni2MnSlkHp90s63Aw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6797DB30;
        Thu, 20 Feb 2020 05:40:38 +0000 (UTC)
Received: from [10.72.12.159] (ovpn-12-159.pek2.redhat.com [10.72.12.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 347FB90774;
        Thu, 20 Feb 2020 05:40:17 +0000 (UTC)
Subject: Re: [PATCH V3 3/5] vDPA: introduce vDPA bus
To:     Randy Dunlap <rdunlap@infradead.org>, mst@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     tiwei.bie@intel.com, jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, hch@infradead.org,
        aadam@redhat.com, jiri@mellanox.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com
References: <20200220035650.7986-1-jasowang@redhat.com>
 <20200220035650.7986-4-jasowang@redhat.com>
 <0a74e918-3b89-2aaf-7855-02db629ce886@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <dab07484-9b31-1942-86bb-92ccf00dff11@redhat.com>
Date:   Thu, 20 Feb 2020 13:40:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <0a74e918-3b89-2aaf-7855-02db629ce886@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/20 =E4=B8=8B=E5=8D=8812:06, Randy Dunlap wrote:
> On 2/19/20 7:56 PM, Jason Wang wrote:
>> diff --git a/drivers/virtio/vdpa/Kconfig b/drivers/virtio/vdpa/Kconfig
>> new file mode 100644
>> index 000000000000..7a99170e6c30
>> --- /dev/null
>> +++ b/drivers/virtio/vdpa/Kconfig
>> @@ -0,0 +1,9 @@
>> +# SPDX-License-Identifier: GPL-2.0-only
>> +config VDPA
>> +	tristate
>> +        default m
> Don't add drivers that are enabled by default, unless they are required
> for a system to boot.
>
> And anything that wants VDPA should just select it, so this is not need=
ed.


Right fixed.

Thanks


>
>> +        help
>> +          Enable this module to support vDPA device that uses a
>> +          datapath which complies with virtio specifications with
>> +          vendor specific control path.
>> +
> thanks.

