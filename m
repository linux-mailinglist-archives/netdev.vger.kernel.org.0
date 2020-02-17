Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB2B1618C9
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 18:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgBQR15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 12:27:57 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53838 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726833AbgBQR15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 12:27:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581960476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=08LKzsvnTT9UeWvV9H/+CQOQ29/2RCsQRySdL6stddI=;
        b=XKCBU27TEZAHmLKvGVrzkWyl1ocBy3j23d16OpK9+pvv87fK/kantMM1YbRclUz3gQHy5z
        2RVc9PU18xTbyTX4WqHLv13YyPiGnH22m76Sp35tNQceMRti0GbLKlyjWQvZihul2LGUKz
        A4OgCddTVKGN08ktIbVGx69qrWzIda8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-8jv9Pz_lPVGHCacB_WWnTA-1; Mon, 17 Feb 2020 12:27:55 -0500
X-MC-Unique: 8jv9Pz_lPVGHCacB_WWnTA-1
Received: by mail-wr1-f70.google.com with SMTP id t3so9236163wrm.23
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 09:27:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=08LKzsvnTT9UeWvV9H/+CQOQ29/2RCsQRySdL6stddI=;
        b=IFQ+IbV2twqt2YydcDV3LWMI2bY5GXZ+aSW5TUzCDZsFTaMwCGyA3V9QhqH/Ag7hjn
         ZxXMxHhqWp4WgHjLPDrRdYHtUxwwWy3UmZX8U4DDpXbSx3/etvCbf+wvMJypMLt6IsRP
         siwtLbOh02vNKdZ2KB2bv4T2Vouzfro2HSLRTKVMrkT1QSnMfdpotr5uxTHF8m9IL1nX
         0oflNFEjlgWdPkuin1+Uuop+3vrxtF/D3SlZk3b9XRpg52Sxu8mNA62rs29k0pAx5xBD
         56ybtkzhvWE4PSLAgKZsqu5/u/hhpXDLN4B80o3L4yjgBXCFI3sIwUpDSSxKS2VGucFH
         Z6AA==
X-Gm-Message-State: APjAAAVm1h17D5Zt01WugOCFKuI2hrJBpkZHwAEUkHZqcMZZiO4OfjEj
        OdzivQCljqWGi9trdaM9f+D6KD3cjCBe4sPKxMALEzotBnGPrOBRYLVllg+nHERXVMxQdY8t5In
        JUnd398wX7uqbLzuD
X-Received: by 2002:a7b:cc6a:: with SMTP id n10mr95389wmj.170.1581960473709;
        Mon, 17 Feb 2020 09:27:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqyrZBJx14eS76rtZFXpjmr96XcqNcAkzXnHV/0gN+AeE+JhCkQO9sUw7wCqp0fYXa8gZOmiRQ==
X-Received: by 2002:a7b:cc6a:: with SMTP id n10mr95374wmj.170.1581960473502;
        Mon, 17 Feb 2020 09:27:53 -0800 (PST)
Received: from steredhat (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id o4sm1974222wrx.25.2020.02.17.09.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 09:27:52 -0800 (PST)
Date:   Mon, 17 Feb 2020 18:27:50 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jorgen Hansen <jhansen@vmware.com>
Cc:     "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] vsock.7: add VMADDR_CID_LOCAL description
Message-ID: <20200217172750.lutmlnbtp2rdpiw6@steredhat>
References: <20200214130749.126603-1-sgarzare@redhat.com>
 <MWHPR05MB3376C52124D5BB1835CC3362DA160@MWHPR05MB3376.namprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR05MB3376C52124D5BB1835CC3362DA160@MWHPR05MB3376.namprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 01:55:58PM +0000, Jorgen Hansen wrote:
> > From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> > Sent: Friday, February 14, 2020 2:08 PM
> > To: mtk.manpages@gmail.com
> > Cc: Jorgen Hansen <jhansen@vmware.com>; linux-man@vger.kernel.org;
> > Stefan Hajnoczi <stefanha@redhat.com>; Dexuan Cui
> > <decui@microsoft.com>; netdev@vger.kernel.org
> > Subject: [PATCH v2] vsock.7: add VMADDR_CID_LOCAL description
> > 
> > Linux 5.6 added the new well-known VMADDR_CID_LOCAL for local
> > communication.
> > 
> > This patch explains how to use it and remove the legacy
> > VMADDR_CID_RESERVED no longer available.
> > 
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > ---
> > v2:
> >     * rephrased "Local communication" description [Stefan]
> >     * added a mention of previous versions that supported
> >       loopback only in the guest [Stefan]
> > ---
> 
> 
> > @@ -222,6 +232,11 @@ are valid.
> >  Support for VMware (VMCI) has been available since Linux 3.9.
> >  KVM (virtio) is supported since Linux 4.8.
> >  Hyper-V is supported since Linux 4.14.
> > +.PP
> > +VMADDR_CID_LOCAL is supported since Linux 5.6.
> > +Local communication in the guest and on the host is available since Linux
> > 5.6.
> > +Previous versions partially supported it only in the guest and only
> > +with some transports (VMCI and virtio).
> 
> Maybe rephrase the last part slightly to something like:
> 
> Previous versions only supported local communication within a guest (not on the host),
> and only with some transports (VMCI and virtio).

I think it is better, I'll send a v3 with this part changed :-)

> 
> Otherwise, looks good to me. Thanks for making this update.
> 
> Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
> 

Thanks,
Stefano

