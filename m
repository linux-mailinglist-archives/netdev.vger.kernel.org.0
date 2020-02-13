Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3386215BB72
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 10:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729629AbgBMJRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 04:17:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23497 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729600AbgBMJRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 04:17:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581585474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bYYLK45KrsynfF+WJWKEwLQF8s9ovAj2Rv7nAOtzJK4=;
        b=P3ML8y1/CwNHmQ+uceHd9+lHbHLqP0UJ8D/G8B29/yLRBD2QdCjX+NgV4fCYj5D9i2ZzJU
        5cki3bfxPy4WJQ3hbYvO3SizociC11KvPi4xdooR0sDUp0+XDcO+yKvztmkXwUYsStsLL2
        7xj9pGfZq3TlmoISRp3Kioq9m8HvqeE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-h0Vb6ZguOcWva0FewJsjbg-1; Thu, 13 Feb 2020 04:17:52 -0500
X-MC-Unique: h0Vb6ZguOcWva0FewJsjbg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA371800D41;
        Thu, 13 Feb 2020 09:17:50 +0000 (UTC)
Received: from localhost (unknown [10.36.118.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C65060499;
        Thu, 13 Feb 2020 09:17:50 +0000 (UTC)
Date:   Thu, 13 Feb 2020 09:17:48 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     mtk.manpages@gmail.com, netdev@vger.kernel.org,
        linux-man@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [PATCH] vsock.7: add VMADDR_CID_LOCAL description
Message-ID: <20200213091748.GB542404@stefanha-x1.localdomain>
References: <20200211102532.56795-1-sgarzare@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20200211102532.56795-1-sgarzare@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 11, 2020 at 11:25:32AM +0100, Stefano Garzarella wrote:

Do you want to mention that loopback works in the guest and on the host
since Linux vX.Y and before that it only worked inside the guest?

> @@ -164,6 +164,16 @@ Consider using
>  .B VMADDR_CID_ANY
>  when binding instead of getting the local CID with
>  .BR IOCTL_VM_SOCKETS_GET_LOCAL_CID .
> +.SS Local communication
> +The
> +.B VMADDR_CID_LOCAL
> +(1) can be used to address itself. In this case all packets are redirected
> +to the same host that generated them. Useful for testing and debugging.

This can be rephrased more naturally:

.B VMADDR_CID_LOCAL
(1) directs packets to the same host that generated them. This is useful
for testing applications on a single host and for debugging.

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl5FFDwACgkQnKSrs4Gr
c8hctQf9GBWEScZZBrfOQK5jCwfkzcJ/oDAmTMxqpxr5e11Uoz00dsxY2XZeDPQo
K7Admu3anX+h8UF3j1T8L8NLn2fYAwpDq8Y5h6INnsooVEzom6ebF4mwDaJhDOUA
vFDb25SFi04qN1J+aDSVUnI8ahvBWBy+6TypH75izDrL8tIJb5qSwSgsrvU4v+g+
EaXLrQXMhELh3olGvX8tpTI6nxutQTdL+OVO34U7mjtxUnxxEbdPxkihDBLB16Q8
HHohCU01QJ+AW5cDYcdTCZW6op7uITS6EOAqYuN4lA81+ghI5eqDYU9q0JLUqmdg
avD9YVHDMeVnBCLDschlSjNd0rvXwA==
=nyGD
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--

