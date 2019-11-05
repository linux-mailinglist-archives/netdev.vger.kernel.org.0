Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6198EFD9A
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 13:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388513AbfKEMsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 07:48:42 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55926 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388431AbfKEMsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 07:48:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572958121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2jEVDWNch/xYgmO6OEN+wbzCxr5VY9dJ1NypSvMkGAk=;
        b=fIAuv1cZUYOU/aNVkKh8EXpfk+GSqlboDP48carROMHXPMM1a1oigzixbWC3ZnqIFQEhX/
        MLHeicy97aHCSFNOHj59HZDVBGKJ0/E4y3VscVJFQa5AFpLdQGTBVKFb81nOYpjfIwG3pG
        dHXSF40eASgF4jtBteb4KL65tMqa5/0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-MXpRGnxXNxOf2pXTLPnBXA-1; Tue, 05 Nov 2019 07:48:38 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EC151005500;
        Tue,  5 Nov 2019 12:48:36 +0000 (UTC)
Received: from [10.72.12.252] (ovpn-12-252.pek2.redhat.com [10.72.12.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 069201001B00;
        Tue,  5 Nov 2019 12:48:04 +0000 (UTC)
Subject: Re: [PATCH 1/2] IFC hardware operation layer
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     alex.williamson@redhat.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com
References: <1572946660-26265-1-git-send-email-lingshan.zhu@intel.com>
 <1572946660-26265-2-git-send-email-lingshan.zhu@intel.com>
 <20191105074309-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9506db6b-ae68-271d-5e13-411715811131@redhat.com>
Date:   Tue, 5 Nov 2019 20:47:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191105074309-mutt-send-email-mst@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: MXpRGnxXNxOf2pXTLPnBXA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/5 =E4=B8=8B=E5=8D=888:45, Michael S. Tsirkin wrote:
>> +
>> +#define IFC_SUPPORTED_FEATURES \
>> +=09=09((1ULL << VIRTIO_NET_F_MAC)=09=09=09| \
>> +=09=09 (1ULL << VIRTIO_F_ANY_LAYOUT)=09=09=09| \
>> +=09=09 (1ULL << VIRTIO_F_VERSION_1)=09=09=09| \
>> +=09=09 (1ULL << VIRTIO_F_ORDER_PLATFORM)=09=09=09| \
> ACCESS_PLATFORM must be enabled for sure?
>
>

I think so, consider vhost-mdev can filter it out right now.

Thanks

