Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11043A2D5A
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbfH3Dhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:37:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45134 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727213AbfH3Dhe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 23:37:34 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B2083C050DEC;
        Fri, 30 Aug 2019 03:37:33 +0000 (UTC)
Received: from [10.72.12.92] (ovpn-12-92.pek2.redhat.com [10.72.12.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 09030600CD;
        Fri, 30 Aug 2019 03:37:25 +0000 (UTC)
Subject: Re: [PATCH 1/2] vhost/test: fix build for vhost test
To:     Tiwei Bie <tiwei.bie@intel.com>, mst@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20190828053700.26022-1-tiwei.bie@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f44555de-6a9d-256f-5526-9457607e6a47@redhat.com>
Date:   Fri, 30 Aug 2019 11:37:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190828053700.26022-1-tiwei.bie@intel.com>
Content-Type: multipart/mixed;
 boundary="------------8E2AB2F168E0B8F9B8B7B5E9"
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 30 Aug 2019 03:37:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------8E2AB2F168E0B8F9B8B7B5E9
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On 2019/8/28 =E4=B8=8B=E5=8D=881:36, Tiwei Bie wrote:
> Since below commit, callers need to specify the iov_limit in
> vhost_dev_init() explicitly.
>
> Fixes: b46a0bf78ad7 ("vhost: fix OOB in get_rx_bufs()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
> ---
>  drivers/vhost/test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> index 9e90e969af55..ac4f762c4f65 100644
> --- a/drivers/vhost/test.c
> +++ b/drivers/vhost/test.c
> @@ -115,7 +115,7 @@ static int vhost_test_open(struct inode *inode, str=
uct file *f)
>  	dev =3D &n->dev;
>  	vqs[VHOST_TEST_VQ] =3D &n->vqs[VHOST_TEST_VQ];
>  	n->vqs[VHOST_TEST_VQ].handle_kick =3D handle_vq_kick;
> -	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX);
> +	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV);
> =20
>  	f->private_data =3D n;
> =20


Acked-by: Jason Wang <jasowang@redhat.com>



--------------8E2AB2F168E0B8F9B8B7B5E9
Content-Type: application/pgp-keys;
 name="pEpkey.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="pEpkey.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
JJaQ8I7hEjBpmSTF4uR0ETUJmQbCBynU
=3DCBPY
-----END PGP PUBLIC KEY BLOCK-----

--------------8E2AB2F168E0B8F9B8B7B5E9--
