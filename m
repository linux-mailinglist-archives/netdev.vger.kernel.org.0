Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB4B21D2CD
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 11:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbgGMJ37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 05:29:59 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58021 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726380AbgGMJ36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 05:29:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594632597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FkdClRISCLaiArFjVxkA+fHx1NW3jZ3pECNBcgR6TSM=;
        b=KHA9Q1HXbcVDP+jdS3LTDUkV26jNrcabe/JiBTQdwJgN7Q3RiWHuEod1xP2tJlG7KbSC89
        gx/cJsmynV7xB7kNdxYiDszTF5De8e9KNf7GgVnJhJxQhi8XRfV3fnRdH50Un8WOjfqjUZ
        BDun3XPL4EG1cahYpqmmb6JePLlBYcU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-wUIIf35hMS-KCLeMBOln2Q-1; Mon, 13 Jul 2020 05:29:55 -0400
X-MC-Unique: wUIIf35hMS-KCLeMBOln2Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5AF5107ACCA;
        Mon, 13 Jul 2020 09:29:53 +0000 (UTC)
Received: from localhost (ovpn-114-66.ams2.redhat.com [10.36.114.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37CDD74F44;
        Mon, 13 Jul 2020 09:29:50 +0000 (UTC)
Date:   Mon, 13 Jul 2020 10:29:49 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] vhost/scsi: fix up req type endian-ness
Message-ID: <20200713092949.GE28639@stefanha-x1.localdomain>
References: <20200710104849.406023-1-mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20200710104849.406023-1-mst@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="n+lFg1Zro7sl44OB"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--n+lFg1Zro7sl44OB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 10, 2020 at 06:48:51AM -0400, Michael S. Tsirkin wrote:
> vhost/scsi doesn't handle type conversion correctly
> for request type when using virtio 1.0 and up for BE,
> or cross-endian platforms.
>=20
> Fix it up using vhost_32_to_cpu.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/vhost/scsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--n+lFg1Zro7sl44OB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8MKY0ACgkQnKSrs4Gr
c8gQOQf+KmgjzVnEXU62hGmZBNsGZ9+2r2VBviBdhlBL0AB0927CK0A8v4HXZ/5+
8Y6UwKNT0GZnj67/+PBXAVvJm4Jny+4TTgTafuZY0gnlNZKS6PpmSoztnzwjqtgI
ddm2TVEWDF/lDZNRcWZ1a0cURg8If2ZQPxNepxT3uqa5LnbYXiwuIlnFG6eetsHV
Cl751SmdjCSXzCDBvEE6eboXtzt3ok1TWIx3L2jU034AyexssehBz6C0G9LVQhau
pVJs0q2BfsF95xxX6k2Bo/8Paj4EqzUKxG4jEXteR9SIHwZH3anw0PKPygh96FWF
XrsnZG1MAaXY8ybmuVlQkaJofLFlMA==
=4fi+
-----END PGP SIGNATURE-----

--n+lFg1Zro7sl44OB--

