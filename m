Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF9D2D3ED6
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 10:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbgLIJcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 04:32:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50383 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727505AbgLIJcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 04:32:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607506241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eIdwFldhm6zBa8ine4tHp/RGdsb0WnWCdNxasu3YKbA=;
        b=g8G2Guyz3nAjaNUywmKuqYTQyBYt+RSuEFpQppcYFfVaOeoihiLplanBSn6XK3CiL9C2dN
        SnO6+5Ttoog71TrWC1u2M9+BApHDJGB1Wc9N++gYUpGm9kfRaSAPRuHqCUILgss/g71MXq
        7NCvnwsakTq7KoCOnBv52GopxtDPF7k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-2nC50HvXNnK0BgFAeTUY8w-1; Wed, 09 Dec 2020 04:30:37 -0500
X-MC-Unique: 2nC50HvXNnK0BgFAeTUY8w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C430A107ACF5;
        Wed,  9 Dec 2020 09:30:34 +0000 (UTC)
Received: from [10.72.12.31] (ovpn-12-31.pek2.redhat.com [10.72.12.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 45461100238C;
        Wed,  9 Dec 2020 09:30:25 +0000 (UTC)
Subject: Re: [PATCH net-next] tun: fix ubuf refcount incorrectly on error path
From:   Jason Wang <jasowang@redhat.com>
To:     wangyunjian <wangyunjian@huawei.com>,
        "mst@redhat.com" <mst@redhat.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        xudingke <xudingke@huawei.com>
References: <1606982459-41752-1-git-send-email-wangyunjian@huawei.com>
 <094f1828-9a73-033e-b1ca-43b73588d22b@redhat.com>
 <34EFBCA9F01B0748BEB6B629CE643AE60DB4E07B@dggemm513-mbx.china.huawei.com>
 <e972e42b-4344-31dc-eb4c-d963adb08a5c@redhat.com>
 <34EFBCA9F01B0748BEB6B629CE643AE60DB5CD27@DGGEMM533-MBX.china.huawei.com>
 <b70d75f3-d717-4cd6-4966-299916a223c3@redhat.com>
Message-ID: <c31de6ba-e758-1c42-b662-d1787ea8237c@redhat.com>
Date:   Wed, 9 Dec 2020 17:30:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b70d75f3-d717-4cd6-4966-299916a223c3@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/8 上午10:32, Jason Wang wrote:
>
> On 2020/12/7 下午9:38, wangyunjian wrote:
>> I think the newly added code is easy to miss this problem, so I want to
>> copy ubuf_info until we're sure there's no errors.
>>
>> Thanks,
>> Yunjian
>
>
> But isn't this actually a disabling of zerocopy?
>
> Thanks
>
>

Sorry, I misread the patch.

Please send a formal version, and let's move the discussion there.

Thanks

