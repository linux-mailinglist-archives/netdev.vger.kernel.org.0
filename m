Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C1034A715
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 13:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhCZMXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 08:23:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53460 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229839AbhCZMXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 08:23:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616761384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zcmlc1TwDglAeseCrsYdzjvuQS8rznwGU5p85yQrWSU=;
        b=SpjnBdHNvoT5XpTXypL3wmFNoJE3g5zFZn95snoIPxxfv9wK4mo+4a00HzfvicNBLgmkqU
        7nPAbkvTwDOqaWmFiGb/t5VKUPc8W02VFLkiU7AhgZX1DgrlX/8kkI/+J1xI43d5tOCMSf
        kwzZ05NVjpu/Cyr+ajTmY48JlaK5JM4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-FSOZkozrMaecb2EHl_-a1g-1; Fri, 26 Mar 2021 08:23:00 -0400
X-MC-Unique: FSOZkozrMaecb2EHl_-a1g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02FB080006E;
        Fri, 26 Mar 2021 12:22:59 +0000 (UTC)
Received: from ovpn-115-44.ams2.redhat.com (ovpn-115-44.ams2.redhat.com [10.36.115.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 91B2B1962F;
        Fri, 26 Mar 2021 12:22:57 +0000 (UTC)
Message-ID: <2e667826f183fbef101a62f0ad8ccb4ed253cb75.camel@redhat.com>
Subject: Re: [PATCH] udp: Add support for getsockopt(..., ..., UDP_GRO, ...,
 ...)
From:   Paolo Abeni <pabeni@redhat.com>
To:     Norman Maurer <norman_maurer@apple.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, dsahern@kernel.org
Date:   Fri, 26 Mar 2021 13:22:56 +0100
In-Reply-To: <CF78DCAD-6F2C-46C4-9FF1-61DF66183C76@apple.com>
References: <20210325195614.800687-1-norman_maurer@apple.com>
         <8eadc07055ac1c99bbc55ea10c7b98acc36dde55.camel@redhat.com>
         <CF78DCAD-6F2C-46C4-9FF1-61DF66183C76@apple.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-03-26 at 11:22 +0100, Norman Maurer wrote:
> On 26. Mar 2021, at 10:36, Paolo Abeni <pabeni@redhat.com> wrote:
> > One thing you can do to simplifies the maintainer's life, would be post
> > a v2 with the correct tag (and ev. obsolete this patch in patchwork).
> 
> I am quite new to contribute patches to the kernel so I am not sure
> how I would “obsolete” this patch and make a v2. If you can give me
> some pointers I am happy to do so.

Well, I actually gave you a bad advice about fiddling with patchwork.

The autoritative documentation:

Documentation/networking/netdev-FAQ.rst

(inside the kernel tree) suggests to avoid it.

Just posting a v2 will suffice.

Thanks!

Paolo

