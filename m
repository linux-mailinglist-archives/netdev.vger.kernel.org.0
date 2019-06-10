Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8514A3B638
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 15:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390446AbfFJNoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 09:44:11 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38108 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390156AbfFJNoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 09:44:11 -0400
Received: by mail-wm1-f67.google.com with SMTP id s15so5780437wmj.3;
        Mon, 10 Jun 2019 06:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sNvG9YY7XPCNYQ2UBNpiCWdd5MhYb4kt+Gf0IbU8IOo=;
        b=flinDNZKnjs6s4ma5tdG2A0oUJSPW8EfGrulHAaE8+83iieBVEkBJSrRiseB4+Zaf/
         wnra9k5DaOXkMUS6B9CQLATnNz9AzAN1IzxiNiHuqrI14zKJVZbZRVe7KcbWmLQKZWQi
         tq7N/UIQM63jeVb8UkApaACWxG57FihRIf/udOZLFnSOXMbw13LCYFpByQnswx/igX70
         6P6U3ya9H5Wk0DLccjmca/xlX4HguUTNC31cMoAa70gNnIjeVlmgBaBs5WhwovedVJwl
         boaWUBTMhgZJt0mKGfracDo3a+Q5D9n8p7ZSyj5KsPsAePnJcuGnQ7kCEMi8Z31V2zxa
         asUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sNvG9YY7XPCNYQ2UBNpiCWdd5MhYb4kt+Gf0IbU8IOo=;
        b=B54hFjZjM1tEIGmqHmX/tvpRxNrEhkSnHH4+SowHtmJORy19k9gD4S9KutfmF9nPZ6
         MC+BTgz/3YxCKjHI49D6b+8SyWOqEf9dQEv8j1O6RX9EJPWdBmDbTQ6XouULytUpNLvc
         bH8MqC63FK9C2CRw0ai/51yt9xB7MejSmKw8Oaawana7jm0mVXQDXEk7P0F6C14WKwA9
         1rfcISZIf2ARBvGr97JwaFc8cbrQdZabn6FkaLBIklzd9W3EPavP2+ZKA12GD3XUSXgY
         NX50TMs0NcdUh4XTrVcwKAxYVaI6cC3/0/coqIbRjBls8sr4+T+vX6bX3IVQXbLY3UKi
         1zdQ==
X-Gm-Message-State: APjAAAXiAgyf61nd5NvlMhMBVQSk9YElhXpN5tuyOeqHFpwTHDUu6UOw
        GCnkhwqd9pWtpOEt08IXIco=
X-Google-Smtp-Source: APXvYqxEibZ8BSB7QvrWbXPInpARHLL3QAUyPrZGR1ruT7xW5dTaQbkJ7lPpm57kOWpII+bEypnqJA==
X-Received: by 2002:a1c:7a01:: with SMTP id v1mr14178337wmc.10.1560174249089;
        Mon, 10 Jun 2019 06:44:09 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id w6sm16045904wro.71.2019.06.10.06.44.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 06:44:08 -0700 (PDT)
Date:   Mon, 10 Jun 2019 14:44:07 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 1/5] vsock/virtio: limit the memory used per-socket
Message-ID: <20190610134407.GM14257@stefanha-x1.localdomain>
References: <20190531133954.122567-1-sgarzare@redhat.com>
 <20190531133954.122567-2-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hdhkc9EpVJoq6PQ6"
Content-Disposition: inline
In-Reply-To: <20190531133954.122567-2-sgarzare@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hdhkc9EpVJoq6PQ6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 31, 2019 at 03:39:50PM +0200, Stefano Garzarella wrote:
> Since virtio-vsock was introduced, the buffers filled by the host
> and pushed to the guest using the vring, are directly queued in
> a per-socket list. These buffers are preallocated by the guest
> with a fixed size (4 KB).
>=20
> The maximum amount of memory used by each socket should be
> controlled by the credit mechanism.
> The default credit available per-socket is 256 KB, but if we use
> only 1 byte per packet, the guest can queue up to 262144 of 4 KB
> buffers, using up to 1 GB of memory per-socket. In addition, the
> guest will continue to fill the vring with new 4 KB free buffers
> to avoid starvation of other sockets.
>=20
> This patch mitigates this issue copying the payload of small
> packets (< 128 bytes) into the buffer of last packet queued, in
> order to avoid wasting memory.
>=20
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  drivers/vhost/vsock.c                   |  2 +
>  include/linux/virtio_vsock.h            |  1 +
>  net/vmw_vsock/virtio_transport.c        |  1 +
>  net/vmw_vsock/virtio_transport_common.c | 60 +++++++++++++++++++++----
>  4 files changed, 55 insertions(+), 9 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--hdhkc9EpVJoq6PQ6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAlz+XqcACgkQnKSrs4Gr
c8i67gf+IaHwIE70u0NAFbNbt2B8lH5vRZt1H3I0PmFUqoxPIhZ6wFj4rL1mPDD8
W6mT6mla/sDPZQpeYKNJKg1tZ0N4rsl1hH/bW3huwjAGBlk7x9mP0LWUWailXE5P
efL35fpqoiaVvqMDFCwwZFkoba7gB1jcYzzQJfbMz9k1UNRkypvhJyVD4Hs3JI+O
C23eoQb5zO+9Z6aeFnsEj29zR4Abyw+f4kRVKPaJIETKUiMhK3x7fTaEXAkyW4R+
bl1D7xPH+VCInPAbSdkGKp7xbWTAzASEfEPrq14jRNwt6mDAKY3Q51l3Ia0l19NY
DMP6ErcemmdNksPZvxl0YWYTOD9pCg==
=Jzyw
-----END PGP SIGNATURE-----

--hdhkc9EpVJoq6PQ6--
