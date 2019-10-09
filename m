Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCDA5D0EBC
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 14:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731047AbfJIMab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 08:30:31 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36972 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727029AbfJIMab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 08:30:31 -0400
Received: by mail-wm1-f65.google.com with SMTP id f22so2397133wmc.2;
        Wed, 09 Oct 2019 05:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JsBrinsiopQEUUm24bAkz9SVEpwLdFOJsrWFKLpRzJE=;
        b=JrULy73DX15OeCgSMjqfyjx88hrCHXutwTGT1mJJ4gHrgwUt39rmhxwHqATLcszKYV
         wWp944q4ELIXsilGK4RYnWsC1UWm1XFoWGRxwAGoRT0LCtdtcBkBDJ8nnSxjXs6Epb/U
         VCUo7n1fByG1abHvZ5IKMUpBwIZjMlgol6dRR3YSr2+gs30CTqITmxMGVIs6NhKaLJe7
         5Rr3FjYoAv/pLyPO6LhnwCyprprC5sZli1dlTE6i3ML5d0dK7Lecrnr3OfdmmKBUzuiE
         PAhzfSG7J9rvittRVW0TqyzWHM8rzRMdWaaEINIHTJkRbYSjE5IbQK2+9ZnSwBjChFgb
         fbcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JsBrinsiopQEUUm24bAkz9SVEpwLdFOJsrWFKLpRzJE=;
        b=eHYVmC9qPcGlhIMz1O8lVVA6RHshQ+2OWMeXKjPEcjNj88Grk82Dlfy4WaFznVaMJ6
         tJHSvC8lsuv/X5uPjUvLEaEsoGnzHkMQU61kE8WdSaCiX7nnGp4AUXx2Um+vWkTpmfna
         L6llefeZ0oPzzFprL2GhACRdHdcYDCkVgvVY1m+iDybGybJoI4O+0KTV7m3BJQQsk4/3
         pY1/BYoIZCp2cYM2nsXxnP6hfNKJEePQpuwLMHcL680aQ1NHVHYFmux9ufmwQIb6VpOh
         0OBZpRY4DG82ulACkgyC198c44TeFYbgM8uMg+fqHjUOyNGwkFu2RiUPgCwhao17oMSY
         +6JA==
X-Gm-Message-State: APjAAAXWqh3EZsll++Yd4J4Fcv8h+giJr5grySoTYUNZ5Bn6nw6a1pHR
        GpYUm/lhUPxujqeTcc0v0YdRzin2E6o=
X-Google-Smtp-Source: APXvYqyQ4gOX9BIMzOCrasN3y1goWMZiXWlXJRypG8Y+tR9ot0Jnye3Rvg7XGvSHkh52aCJgOsP+VQ==
X-Received: by 2002:a1c:2681:: with SMTP id m123mr2617367wmm.92.1570624228303;
        Wed, 09 Oct 2019 05:30:28 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id r2sm4292179wma.1.2019.10.09.05.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 05:30:27 -0700 (PDT)
Date:   Wed, 9 Oct 2019 13:30:26 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [RFC PATCH 07/13] vsock: handle buffer_size sockopts in the core
Message-ID: <20191009123026.GH5747@stefanha-x1.localdomain>
References: <20190927112703.17745-1-sgarzare@redhat.com>
 <20190927112703.17745-8-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0XhtP95kHFp3KGBe"
Content-Disposition: inline
In-Reply-To: <20190927112703.17745-8-sgarzare@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--0XhtP95kHFp3KGBe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2019 at 01:26:57PM +0200, Stefano Garzarella wrote:
> @@ -140,18 +145,11 @@ struct vsock_transport {
>  		struct vsock_transport_send_notify_data *);
>  	int (*notify_send_post_enqueue)(struct vsock_sock *, ssize_t,
>  		struct vsock_transport_send_notify_data *);
> +	int (*notify_buffer_size)(struct vsock_sock *, u64 *);

Is ->notify_buffer_size() called under lock_sock(sk)?  If yes, please
document it.

> +static void vsock_update_buffer_size(struct vsock_sock *vsk,
> +				     const struct vsock_transport *transport,
> +				     u64 val)
> +{
> +	if (val > vsk->buffer_max_size)
> +		val =3D vsk->buffer_max_size;
> +
> +	if (val < vsk->buffer_min_size)
> +		val =3D vsk->buffer_min_size;
> +
> +	if (val !=3D vsk->buffer_size &&
> +	    transport && transport->notify_buffer_size)
> +		transport->notify_buffer_size(vsk, &val);

Why does this function return an int if we don't check the return value?

> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virt=
io_transport_common.c
> index fc046c071178..bac9e7430a2e 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -403,17 +403,13 @@ int virtio_transport_do_socket_init(struct vsock_so=
ck *vsk,
>  	if (psk) {
>  		struct virtio_vsock_sock *ptrans =3D psk->trans;
> =20
> -		vvs->buf_size	=3D ptrans->buf_size;
> -		vvs->buf_size_min =3D ptrans->buf_size_min;
> -		vvs->buf_size_max =3D ptrans->buf_size_max;
>  		vvs->peer_buf_alloc =3D ptrans->peer_buf_alloc;
> -	} else {
> -		vvs->buf_size =3D VIRTIO_VSOCK_DEFAULT_BUF_SIZE;
> -		vvs->buf_size_min =3D VIRTIO_VSOCK_DEFAULT_MIN_BUF_SIZE;
> -		vvs->buf_size_max =3D VIRTIO_VSOCK_DEFAULT_MAX_BUF_SIZE;
>  	}
> =20
> -	vvs->buf_alloc =3D vvs->buf_size;
> +	if (vsk->buffer_size > VIRTIO_VSOCK_MAX_BUF_SIZE)
> +		vsk->buffer_size =3D VIRTIO_VSOCK_MAX_BUF_SIZE;

Hmm...this could be outside the [min, max] range.  I'm not sure how much
it matters.

Another issue is that this patch drops the VIRTIO_VSOCK_MAX_BUF_SIZE
limit that used to be enforced by virtio_transport_set_buffer_size().
Now the limit is only applied at socket init time.  If the buffer size
is changed later then VIRTIO_VSOCK_MAX_BUF_SIZE can be exceeded.  If
that doesn't matter, why even bother with VIRTIO_VSOCK_MAX_BUF_SIZE
here?


--0XhtP95kHFp3KGBe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2d0uEACgkQnKSrs4Gr
c8gO1gf/Vraalf45FT85Jz4M4KTdl8jmHbCz4Q+gxBtfD8s3Wzm9XCdztbebJ5lD
OmU/wCuporLHCeVao4GUpQzpN25FoSogf5cH8jHIGU3pJOkLd7pF0KNMvpWjcETw
KwF3Kl5HHrayPHagzXF5JGb/B31pXZOpLBhs4KasERFqwOeZDDvBgsgVhrt936Jj
/w6KEb1J0i8dJ7KgM6VLynvT2gudUhmp4BFFChNacJnk1xduOIAK/rBPVL4FDKPg
pTwuT0zC8zGmmMGnnTRCmAOupCnMo8KRfkrydiJ6v093blyJ7N8sRDbKPDdU/4AD
K76VCRMrxnjuOnWPRlo2ERDIH/67qw==
=DYWp
-----END PGP SIGNATURE-----

--0XhtP95kHFp3KGBe--
