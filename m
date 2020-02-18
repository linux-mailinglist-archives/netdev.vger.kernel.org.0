Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9238C162411
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 10:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgBRJ7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 04:59:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58372 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726327AbgBRJ7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 04:59:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582019985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t8eyLEjJkU8sIdEC16q3jhFcx07tfSetwgj0/6SmRN8=;
        b=AIuVuXetjKeukSFV7QTiSS9IRpF8MjHRIgqeXH/7GWZ0XZ6F7QZUzIna+qQjZ6GS5VNRl3
        87Re5Wm8W+m/CIEDtX4f7l4iQBcwwgHmhJKBxeQgpGAfJ0BwR2DA9ZYDmIQCx4nd1zMqbI
        3FEmkwEAK0QEnFg/cwlZuIwnISyjcIw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-mFg2yYs7PMOtjpYYHhy3LQ-1; Tue, 18 Feb 2020 04:59:43 -0500
X-MC-Unique: mFg2yYs7PMOtjpYYHhy3LQ-1
Received: by mail-wm1-f71.google.com with SMTP id u11so807472wmb.4
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 01:59:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t8eyLEjJkU8sIdEC16q3jhFcx07tfSetwgj0/6SmRN8=;
        b=UsB87KxVvDCAzwfZaU6gctxZgxilGJfnifCrxUYqH7rCx5wB/8a6Yy0WDjGUCeADaj
         hv24eqvXvg+19rvexvPlVuzmgVgLUNH9b7HB5vKl77HoJEJtog/4fjigQsr2lHQyh09E
         5w/G/JdFBAczrIZfNVZ1MBSyBwI2LmTmu3HaMcNNEsH6lK7Slif65p1n0B2IChTzgm85
         DQUyz+8IWgo7t21aEQEkTwWotz0x7jSp0Th3oarX34zNKzCBkAG+3cssSjh/fI97L9k5
         NrRvoablXJLO3cQvHl7lyhW0mhh9CfZt7suMGPEZfxbgdMuUG7j2wSVaUcOAlR8wsGJt
         1/rQ==
X-Gm-Message-State: APjAAAUJsed7DpBmxa9qJv3gQffYQLW0WZlWsrlIF9egJAkcoYvbn63q
        gLgKiuvmvFZ4pLqE4Ha5POym+OG/qdSJrKcRXNad+tkR7+pt1iOUHUbBas4c361HicKsHirQPpt
        p7a2A2wdZHJnL5jfk
X-Received: by 2002:a5d:540f:: with SMTP id g15mr26951316wrv.86.1582019982642;
        Tue, 18 Feb 2020 01:59:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqwePfeSJTNnPPtdjW1ezHXtYzYsxnhdZ7k4RJxR+fpByDcCmLltpiM3YK/9gTUXEXBHAuTVow==
X-Received: by 2002:a5d:540f:: with SMTP id g15mr26951293wrv.86.1582019982380;
        Tue, 18 Feb 2020 01:59:42 -0800 (PST)
Received: from steredhat (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id 21sm2913906wmo.8.2020.02.18.01.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 01:59:41 -0800 (PST)
Date:   Tue, 18 Feb 2020 10:59:40 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     mtk.manpages@gmail.com, linux-man@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v3] vsock.7: add VMADDR_CID_LOCAL description
Message-ID: <20200218095940.vnyva3lknsfsxxs5@steredhat>
References: <20200217173121.159132-1-sgarzare@redhat.com>
 <20200218095319.GB786556@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218095319.GB786556@stefanha-x1.localdomain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 09:53:19AM +0000, Stefan Hajnoczi wrote:
> On Mon, Feb 17, 2020 at 06:31:21PM +0100, Stefano Garzarella wrote:
> > Linux 5.6 added the new well-known VMADDR_CID_LOCAL for
> > local communication.
> > 
> > This patch explains how to use it and remove the legacy
> > VMADDR_CID_RESERVED no longer available.
> > 
> > Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > ---
> > v3:
> >     * rephrased "Previous versions" part [Jorgen]
> > v2:
> >     * rephrased "Local communication" description [Stefan]
> >     * added a mention of previous versions that supported
> >       loopback only in the guest [Stefan]
> > ---
> >  man7/vsock.7 | 19 +++++++++++++++++--
> >  1 file changed, 17 insertions(+), 2 deletions(-)
> > 
> > diff --git a/man7/vsock.7 b/man7/vsock.7
> > index c5ffcf07d..219e3505f 100644
> > --- a/man7/vsock.7
> > +++ b/man7/vsock.7
> > @@ -127,8 +127,8 @@ There are several special addresses:
> >  means any address for binding;
> >  .B VMADDR_CID_HYPERVISOR
> >  (0) is reserved for services built into the hypervisor;
> > -.B VMADDR_CID_RESERVED
> > -(1) must not be used;
> > +.B VMADDR_CID_LOCAL
> > +(1) is the well-known address for local communication (loopback);
> >  .B VMADDR_CID_HOST
> >  (2)
> >  is the well-known address of the host.
> > @@ -164,6 +164,16 @@ Consider using
> >  .B VMADDR_CID_ANY
> >  when binding instead of getting the local CID with
> >  .BR IOCTL_VM_SOCKETS_GET_LOCAL_CID .
> > +.SS Local communication
> > +The
> > +.B VMADDR_CID_LOCAL
> > +(1) directs packets to the same host that generated them. This is useful
> 
> Please see my comment on v2.  "The VMADDR_CID_LOCAL (1) directs packets
> ..." sounds unnatural.  Please drop "The".

I received it just now :O but you sent it 4 days ago!
Sorry for that!

I'll send v4 dropping "The".

Thanks,
Stefano

