Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77F5B164339
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 12:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgBSLVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 06:21:13 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48412 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726484AbgBSLVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 06:21:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582111272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sMIqaLUvxpVpSqHa4cuzfmXnunFFKTWJnGv97+0XuCs=;
        b=cqeTe0b7O1dE6eSf383ic1MxJvh+PiLEdsYFabtiWp8wvTnCicrzW/t83Y84LO5j8ITDrc
        UjK5kX6O5ZA28Rj9XBKkbff47ujt2ciW4UpODvxH//8AVz9KHvUb+ITWnaoOPOIEx6YpL+
        t+izPjDm9sSAwMcaStImYGfTHNbkGDk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-OzzrGXUWN1esjuycgWsxVQ-1; Wed, 19 Feb 2020 06:21:10 -0500
X-MC-Unique: OzzrGXUWN1esjuycgWsxVQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0510A800D4E;
        Wed, 19 Feb 2020 11:21:09 +0000 (UTC)
Received: from localhost (ovpn-117-59.ams2.redhat.com [10.36.117.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C13990F69;
        Wed, 19 Feb 2020 11:21:08 +0000 (UTC)
Date:   Wed, 19 Feb 2020 11:21:07 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     mtk.manpages@gmail.com, Jorgen Hansen <jhansen@vmware.com>,
        netdev@vger.kernel.org, linux-man@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: Re: [PATCH v4] vsock.7: add VMADDR_CID_LOCAL description
Message-ID: <20200219112107.GA1076886@stefanha-x1.localdomain>
References: <20200218155435.172860-1-sgarzare@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20200218155435.172860-1-sgarzare@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2020 at 04:54:35PM +0100, Stefano Garzarella wrote:
> Linux 5.6 added the new well-known VMADDR_CID_LOCAL for
> local communication.
>=20
> This patch explains how to use it and remove the legacy
> VMADDR_CID_RESERVED no longer available.
>=20
> Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
> v4:
>     * removed "The" in the "Local communication" section [Stefan]
> v3:
>     * rephrased "Previous versions" part [Jorgen]
> v2:
>     * rephrased "Local communication" description [Stefan]
>     * added a mention of previous versions that supported
>       loopback only in the guest [Stefan]
> ---
>  man7/vsock.7 | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl5NGiMACgkQnKSrs4Gr
c8gWUAf7BlbHBgjT81elIHhVIO5qzu79d2dXxojAmeZPCL6OHTEieM9FvP9BpZ7I
543FGBQhHETaqkhS0VWlSvapZlFC0ov9ktOCJRgynEMNw3AIUJs7S+9XtELS/QYA
KfwpOaqIGPeEBr6t+yAWDTblnZ22ODUA550mvoVAZDx1eGI/5QsJMtWoOvQTEJhw
Pn9frD6xQyns5w9+AuIIzh+KI1nB8N/1V91Xo8B6BAwKRgQHFeyh/4GC7ItMESA4
wbJBUJDYHyKsmHwNvGrjS2R6oe9xDiIm4dQDpwXpVWAhjxxIwfiVaCqyiM/m/Wtu
Adq5Syc/BFJ8qC8jRxSQ+wyY+FEUkg==
=LKjP
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--

