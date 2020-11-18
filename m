Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DE32B7628
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 07:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgKRGIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 01:08:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24698 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726068AbgKRGIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 01:08:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605679711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sz/m+8Uq0tqcNbVPs1/yM0jQdLFpgRv+8LG/piLjalw=;
        b=HjdidHs3zgma6Y1nUQIfoSUYqwQLo8mUNQBL3NgoGvN5xdzbaGeYJMD5pEZsbC/vtsp9OU
        Zm8pjjQHCtxSNUyNEPvjKL3RES9GmxXNR1Bw9R/29hYFtlolWqAwSfTn3IJUJ3yZluaiJw
        DmynXdKO3DQ3to3wvY5eY5PsYAqwbfE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-eUvEClr4PgO9a3DPlib2SQ-1; Wed, 18 Nov 2020 01:08:26 -0500
X-MC-Unique: eUvEClr4PgO9a3DPlib2SQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E287764082;
        Wed, 18 Nov 2020 06:08:24 +0000 (UTC)
Received: from [10.72.13.172] (ovpn-13-172.pek2.redhat.com [10.72.13.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72A7D19C59;
        Wed, 18 Nov 2020 06:08:19 +0000 (UTC)
Subject: Re: [PATCH net] vhost_vdpa: Return -EFUALT if copy_from_user() fails
From:   Jason Wang <jasowang@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        kuba@kernel.org
References: <20201023120853.GI282278@mwanda>
 <20201023113326-mutt-send-email-mst@kernel.org>
 <4485cc8d-ac69-c725-8493-eda120e29c41@redhat.com>
Message-ID: <e7242333-b364-c2d8-53f5-1f688fc4d0b5@redhat.com>
Date:   Wed, 18 Nov 2020 14:08:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4485cc8d-ac69-c725-8493-eda120e29c41@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/10/26 上午10:59, Jason Wang wrote:
>
> On 2020/10/23 下午11:34, Michael S. Tsirkin wrote:
>> On Fri, Oct 23, 2020 at 03:08:53PM +0300, Dan Carpenter wrote:
>>> The copy_to/from_user() functions return the number of bytes which we
>>> weren't able to copy but the ioctl should return -EFAULT if they fail.
>>>
>>> Fixes: a127c5bbb6a8 ("vhost-vdpa: fix backend feature ioctls")
>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>> Needed for stable I guess.
>
>
> Agree.
>
> Acked-by: Jason Wang <jasowang@redhat.com>


Hi Michael.

I don't see this in your tree, please consider to merge.

Thanks



