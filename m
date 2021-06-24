Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAB13B5EA2
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 15:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbhF1NFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 09:05:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59066 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233159AbhF1NFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 09:05:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624885354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fndY61EcgfzsXcmaCK7BMnLfNMbphujT+QMr+Pswt68=;
        b=PGfmTACvAqpUJzwPjJ5xCRO9N3+up85oL8AVWjBsFYsbkaG0rXjH3Fxumk5HSF2FuxPtl5
        YMW1Ah4dD5pKCIUOOCu/rYnE/v7OvKkULjsoOBCiVFgrrRHGP/csbA5REN7lmaNHjX08y7
        CI24pan6AQxIIpG8WllqSTz7KeyXw3E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-lJbSiAWjOGCgZVrmUVHPPA-1; Mon, 28 Jun 2021 09:02:28 -0400
X-MC-Unique: lJbSiAWjOGCgZVrmUVHPPA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88C80800C78;
        Mon, 28 Jun 2021 13:02:25 +0000 (UTC)
Received: from localhost (ovpn-112-170.ams2.redhat.com [10.36.112.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7AFA969CB6;
        Mon, 28 Jun 2021 13:02:03 +0000 (UTC)
Date:   Thu, 24 Jun 2021 16:12:09 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, jasowang@redhat.com, sgarzare@redhat.com,
        parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 00/10] Introduce VDUSE - vDPA Device in Userspace
Message-ID: <YNSgyTHpNjxdKLLR@stefanha-x1.localdomain>
References: <20210615141331.407-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Bv+EGssEb3iM6ws2"
Content-Disposition: inline
In-Reply-To: <20210615141331.407-1-xieyongji@bytedance.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Bv+EGssEb3iM6ws2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 15, 2021 at 10:13:21PM +0800, Xie Yongji wrote:
> This series introduces a framework that makes it possible to implement
> software-emulated vDPA devices in userspace. And to make it simple, the
> emulated vDPA device's control path is handled in the kernel and only the
> data path is implemented in the userspace.

This looks interesting. Unfortunately I don't have enough time to do a
full review, but I looked at the documentation and uapi header file to
give feedback on the userspace ABI.

Stefan

--Bv+EGssEb3iM6ws2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmDUoMkACgkQnKSrs4Gr
c8i9mAf/TQBs0m0AVmZZD8+mPJMwfeWR4pxCS+XbMMUr1xqCc7eSxhjMY6H1LNO6
3r+wPajMdIuXEW16AsGRAplQmvTNAdUMjcDnSeS/Y1LBecoKKAnKOYuvRZ1HCaqk
Ye3vT+jpDz+X/+miO5LiIenkJB9bouoqAxeNXIXQL5jOMw+pW7R2CD3YUK0k4AMn
+X179rAMEOsPG+jyOlWDU1MDbdy1vZEIRQ7MoqrMqsHq/O+AnBXFyZISDwrUttZw
HoXWFEeLdyh0mKaniHbsEvSQaAXrG+UBg5xqpYw9RNmbJ7ax+qQ4sUZHbkZlsXXe
p++cvUCG1Xk7kOv1o28B3KBn/lyQQA==
=Kg3j
-----END PGP SIGNATURE-----

--Bv+EGssEb3iM6ws2--

