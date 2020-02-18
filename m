Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 906D21623F6
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 10:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgBRJx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 04:53:26 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21488 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726338AbgBRJx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 04:53:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582019605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OVdo3NOzij8aAAUXkSWLWkZWw+3RPCay4xKSpW5yzqk=;
        b=fk+KWd7edGAf0M61UyRxUY5EJW8LD692UFvgEc2Eyv8MShOCQrj9yRes6xs/1hOcS6DzD+
        NIHKTzud7dIT+8fSEmP3Fpn9sPRbY3XRmUJhg5z8Rkk0JAmLv6PKod1euS4B+JIho6HcWZ
        hdq+IcpmAxDk2kuM5OdCfU7E65gtzwE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-IyT8ekwIOiyPG-KXGIN6Og-1; Tue, 18 Feb 2020 04:53:22 -0500
X-MC-Unique: IyT8ekwIOiyPG-KXGIN6Og-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1FBD107B7D4;
        Tue, 18 Feb 2020 09:53:21 +0000 (UTC)
Received: from localhost (unknown [10.36.118.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 00F7710027B2;
        Tue, 18 Feb 2020 09:53:20 +0000 (UTC)
Date:   Tue, 18 Feb 2020 09:53:19 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     mtk.manpages@gmail.com, linux-man@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v3] vsock.7: add VMADDR_CID_LOCAL description
Message-ID: <20200218095319.GB786556@stefanha-x1.localdomain>
References: <20200217173121.159132-1-sgarzare@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20200217173121.159132-1-sgarzare@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gatW/ieO32f1wygP"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 17, 2020 at 06:31:21PM +0100, Stefano Garzarella wrote:
> Linux 5.6 added the new well-known VMADDR_CID_LOCAL for
> local communication.
>=20
> This patch explains how to use it and remove the legacy
> VMADDR_CID_RESERVED no longer available.
>=20
> Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
> v3:
>     * rephrased "Previous versions" part [Jorgen]
> v2:
>     * rephrased "Local communication" description [Stefan]
>     * added a mention of previous versions that supported
>       loopback only in the guest [Stefan]
> ---
>  man7/vsock.7 | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
>=20
> diff --git a/man7/vsock.7 b/man7/vsock.7
> index c5ffcf07d..219e3505f 100644
> --- a/man7/vsock.7
> +++ b/man7/vsock.7
> @@ -127,8 +127,8 @@ There are several special addresses:
>  means any address for binding;
>  .B VMADDR_CID_HYPERVISOR
>  (0) is reserved for services built into the hypervisor;
> -.B VMADDR_CID_RESERVED
> -(1) must not be used;
> +.B VMADDR_CID_LOCAL
> +(1) is the well-known address for local communication (loopback);
>  .B VMADDR_CID_HOST
>  (2)
>  is the well-known address of the host.
> @@ -164,6 +164,16 @@ Consider using
>  .B VMADDR_CID_ANY
>  when binding instead of getting the local CID with
>  .BR IOCTL_VM_SOCKETS_GET_LOCAL_CID .
> +.SS Local communication
> +The
> +.B VMADDR_CID_LOCAL
> +(1) directs packets to the same host that generated them. This is useful

Please see my comment on v2.  "The VMADDR_CID_LOCAL (1) directs packets
..." sounds unnatural.  Please drop "The".

--gatW/ieO32f1wygP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl5LtA8ACgkQnKSrs4Gr
c8gq2AgAhEWJnASHc2ds5BdQYjs+9IK6beCEi/CNM1VkDrlI0tAiKHzQC5sRXvvL
MIC0s10vWtim+1alfZYuAjZydhS2Ek/ZYAKjN9Emi8Cr2UDj0LTZdFiJbltffzKd
R0IAAzBYqT1xLS67zlSWLpCWzXM07gv7A9bCVTwjWAx8aw5frm35ihgANyKDGthi
NQ5089YZvpNKREXNpATSSrwSHJpeKxVyxX6a0MNuMVRSoIoFxljK83mxn7J7bIIJ
mcia2Bu7KvLewuyUu57B9EcSoYxwOq7qYrxryJp4x5wYEmDG+hMjeABtXY84MHQe
gBFhD76daJ38oWQaKPettQWpovQ9CA==
=iidn
-----END PGP SIGNATURE-----

--gatW/ieO32f1wygP--

