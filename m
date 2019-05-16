Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 612DF2029E
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 11:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbfEPJd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 05:33:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46164 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbfEPJd4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 05:33:56 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C61E8307D945;
        Thu, 16 May 2019 09:33:56 +0000 (UTC)
Received: from localhost (ovpn-117-183.ams2.redhat.com [10.36.117.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC6A9608A6;
        Thu, 16 May 2019 09:33:53 +0000 (UTC)
Date:   Thu, 16 May 2019 10:33:52 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH net 3/4] vhost: vsock: add weight support
Message-ID: <20190516093352.GQ29507@stefanha-x1.localdomain>
References: <1557992862-27320-1-git-send-email-jasowang@redhat.com>
 <1557992862-27320-4-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AFQGHouA0VN8Ovbt"
Content-Disposition: inline
In-Reply-To: <1557992862-27320-4-git-send-email-jasowang@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 16 May 2019 09:33:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--AFQGHouA0VN8Ovbt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 16, 2019 at 03:47:41AM -0400, Jason Wang wrote:
> @@ -183,7 +184,8 @@ static struct vhost_vsock *vhost_vsock_get(u32 guest_=
cid)
>  		virtio_transport_deliver_tap_pkt(pkt);
> =20
>  		virtio_transport_free_pkt(pkt);
> -	}
> +		total_len +=3D pkt->len;

Please increment total_len before virtio_transport_free_pkt(pkt) to
avoid use-after-free.

--AFQGHouA0VN8Ovbt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAlzdLoAACgkQnKSrs4Gr
c8garggAkwbbSkEoposz2FA5FIKLYtHjdQpn8NA8HSvaFqi/DcE0ejKYtN/BImRo
9Sed+GFqfzmP9ZIQni5Sh0boykMdrp8ZqK4JcFS4tTXZ4Ac0Smob4EA15WxIFX+p
H35N34MvKnfTivYZKoezEXqFiiz8re5znN+PgUWWz1u/gOqK1XfmPayal3nP/c4v
D3EYs+vIa4zOUsNI7g7Mn/KUG6z7kpMFsCKLzWWuInPsdFzKX3tE+xo907y8vlVX
vympegUH07yJlISmuaTfKi2r2AmGOJEXq6nh1L4mIkHRVconV0GcU+Q33OT546Mq
putACagRBiMVZtgw3+Fppx1fb9SvfA==
=mlka
-----END PGP SIGNATURE-----

--AFQGHouA0VN8Ovbt--
