Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91011ADA10
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 11:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbgDQJeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 05:34:19 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56394 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730225AbgDQJeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 05:34:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587116057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Nf4mx1Q48p/GPxnpmj6YDUYrbnnZDvMi6tbZSve7oY=;
        b=dADWCXCScaS9JoqLUJsBwscMQcrW29zGyQtYc7DpBkdk4mQSBheHnY6E5+3SWv2feYxKgY
        7xb/PFmGWP9ZogvecKvaXb5iJAwlmacG83mB3B8S0uYB8jlw9EwJlou2rZw1dBPKnrEfsj
        zn1dAdBorkNlZW0jPpZhidsHHtm0Qrg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-45Ak_4WMOIGtSbuBaMmdUg-1; Fri, 17 Apr 2020 05:34:13 -0400
X-MC-Unique: 45Ak_4WMOIGtSbuBaMmdUg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5593107B0E1;
        Fri, 17 Apr 2020 09:34:11 +0000 (UTC)
Received: from [10.72.13.157] (ovpn-13-157.pek2.redhat.com [10.72.13.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C510E60BE0;
        Fri, 17 Apr 2020 09:33:57 +0000 (UTC)
Subject: Re: [PATCH V2] vhost: do not enable VHOST_MENU by default
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, geert@linux-m68k.org,
        tsbogend@alpha.franken.de, benh@kernel.crashing.org,
        paulus@samba.org, heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, Michael Ellerman <mpe@ellerman.id.au>
References: <20200415024356.23751-1-jasowang@redhat.com>
 <20200416185426-mutt-send-email-mst@kernel.org>
 <b7e2deb7-cb64-b625-aeb4-760c7b28c0c8@redhat.com>
 <20200417022929-mutt-send-email-mst@kernel.org>
 <4274625d-6feb-81b6-5b0a-695229e7c33d@redhat.com>
 <20200417042912-mutt-send-email-mst@kernel.org>
 <fdb555a6-4b8d-15b6-0849-3fe0e0786038@redhat.com>
 <20200417044230-mutt-send-email-mst@kernel.org>
 <73843240-3040-655d-baa9-683341ed4786@redhat.com>
 <20200417050029-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ce8a18e5-3c74-73cc-57c5-10c40af838a3@redhat.com>
Date:   Fri, 17 Apr 2020 17:33:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200417050029-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/17 =E4=B8=8B=E5=8D=885:01, Michael S. Tsirkin wrote:
>> There could be some misunderstanding here. I thought it's somehow simi=
lar: a
>> CONFIG_VHOST_MENU=3Dy will be left in the defconfigs even if CONFIG_VH=
OST is
>> not set.
>>
>> Thanks
>>
> BTW do entries with no prompt actually appear in defconfig?
>

Yes. I can see CONFIG_VHOST_DPN=3Dy after make ARCH=3Dm68k defconfig

Thanks

