Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEB581623EB
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 10:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgBRJwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 04:52:14 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49001 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726327AbgBRJwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 04:52:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582019533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zvsrL/rJ3m5DxZHCK8x3pAj/hU9zeFpWdJsILNtPNRY=;
        b=hEh0UQ7+W6DRaKS9DNR5QVCERdxVW/gP0HgrfdCjwzap71+v5xf79G2nm0c/VB84ZvTIJr
        BBr+aFZv323ssLsgJaxDJcXN6/KZBGVZvjACfxKCSR7yU4v7xX7n5vJ4mZz6i/2x3wdjBO
        0b6rkwMHftnzl1+6SfpcUeOZ3o3VnkQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-cOSagk7CPtOvwQsbSgY55Q-1; Tue, 18 Feb 2020 04:52:06 -0500
X-MC-Unique: cOSagk7CPtOvwQsbSgY55Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2540107ACC4;
        Tue, 18 Feb 2020 09:52:04 +0000 (UTC)
Received: from localhost (unknown [10.36.118.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 630E51001281;
        Tue, 18 Feb 2020 09:52:04 +0000 (UTC)
Date:   Fri, 14 Feb 2020 19:35:52 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     mtk.manpages@gmail.com, Jorgen Hansen <jhansen@vmware.com>,
        linux-man@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] vsock.7: add VMADDR_CID_LOCAL description
Message-ID: <20200214193552.GA543933@stefanha-x1.localdomain>
References: <20200214130749.126603-1-sgarzare@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20200214130749.126603-1-sgarzare@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2020 at 02:07:49PM +0100, Stefano Garzarella wrote:
> @@ -164,6 +164,16 @@ Consider using
>  .B VMADDR_CID_ANY
>  when binding instead of getting the local CID with
>  .BR IOCTL_VM_SOCKETS_GET_LOCAL_CID .
> +.SS Local communication
> +The

"The" is unnatural here, I don't think native speakers would use it.
Simply saying "VMADDR_CID_LOCAL (1) directs packets ..." is more common.

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl5G9pgACgkQnKSrs4Gr
c8i82gf+K9fzbOqDceR1Nx1a6zEZywNQPaHSVFjjqMRWfewDVDNXBd6EtoAF05to
0/eD5F3Yo2605vNKPorNsrYWjxm5bNtri/UIM9D76Eg8PzusPSiW3DoIXncQjPYk
QPJPraRmUZBGS2+UbIN7PJ/rfSeViAF+OcG5/XUzXI9Hw1MXlI1ihm/YUNKHUEll
RvArBvIcPLJxpUctPPecYm52FxQsK4m+xtEUrdhqeWGWEmCTnUBAqUAxa2i0Lqe+
HzgdEZCHmeIG6/c9JQfXUK1IQmonCMr9PkMvNsUHqtfbieUv1JxLympB7+zxqkgL
DADZU1vuLJBYPY6oF7CCDPqSOBTCsQ==
=UpMZ
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--

