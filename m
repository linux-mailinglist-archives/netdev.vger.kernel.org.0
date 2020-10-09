Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4CC2880E1
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 05:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731635AbgJIDxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 23:53:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20936 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729845AbgJIDxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 23:53:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602215588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FU45aSUQ8dscwhSeXeB5RZOeAkKlMDXRAbcGeFJTPSY=;
        b=hJ0SAcFU7L4PL5D09PEG3KlBSdQeLvpbQQ4ZqUMchiTLOYnLiE18tErojLQ1R9GxTb/6Cz
        ULujzMpZPVXVfzmSv+ocR1I+qrPVLJWBDIIUbHuERd/OYKRoqFV4hFeIXFhG/x3yAKT5n4
        RBoShbaP0cdyDRpUo1KsHZ3dWf+3ff0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-ZXpxE5hfMKO49E23RlPavw-1; Thu, 08 Oct 2020 23:53:06 -0400
X-MC-Unique: ZXpxE5hfMKO49E23RlPavw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19B5F87950B;
        Fri,  9 Oct 2020 03:53:05 +0000 (UTC)
Received: from [10.72.13.133] (ovpn-13-133.pek2.redhat.com [10.72.13.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42A3D6EF58;
        Fri,  9 Oct 2020 03:52:40 +0000 (UTC)
Subject: Re: [RFC PATCH 09/24] vdpa: multiple address spaces support
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
References: <20200924032125.18619-1-jasowang@redhat.com>
 <20200924032125.18619-10-jasowang@redhat.com>
 <20201001132331.GB32363@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <671aa6b3-c26c-d94a-82a7-0d203ef5b409@redhat.com>
Date:   Fri, 9 Oct 2020 11:52:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201001132331.GB32363@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/10/1 下午9:23, Eli Cohen wrote:
>>   
>> +	/* Only support 1 address space */
>> +	if (vdpa->ngroups != 1)
>> +		return -ENOTSUPP;
> Checkpatch warning:  prefer EOPNOTSUPP
>

Will fix.

Thanks

