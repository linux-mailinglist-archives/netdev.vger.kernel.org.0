Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 823AF5BF1F
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 17:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730082AbfGAPKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 11:10:13 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40648 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727227AbfGAPKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 11:10:13 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so16343337wmj.5;
        Mon, 01 Jul 2019 08:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cKBDkOpvKjLwutZn7sL3J9AG+5UUlt9ecagKzXF/p+A=;
        b=bPdtV88+SHvNgkziID/kz0SH8vs3gkIFHQ3Rtc/Di79qYKHOVFvdS9r6qxRxogVrNb
         L0g0o4A2c/B+8ss7nR1cllYuJIzNG1vYYIcwJcJWOIH8lPRG/ks/wgY5izLZwn+fOnp5
         d/x+J6eaf/ORtIpphHhsLMmbUHx/o7PPhZbT1i343IQTV8W3beKsaoBZ9pgfYwLFuvRm
         T6VrFYiSnAk8dFEGFz7iWLTObbJz7f+SJJLgchXBKArGJBZmN6T6YjcmX3ZpKJRa1nDP
         Gj/jmVFTa0T64rOip2Ig7vxN/OLRNg+nuQS207aXWLTBoPHVwT1UBu3BlKJP4qVwjEU/
         AEfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cKBDkOpvKjLwutZn7sL3J9AG+5UUlt9ecagKzXF/p+A=;
        b=DIWTZ2/K71x7oxA32opyJfPByQ8R11J4pMb/+iQbr7PoJRzmOtnK91tisl25mC79Ho
         voSPk4M89LOAg8AL7Mty8EVh7d3fwg+GNhVcgKj+OOPdPTAohlhlz1uz1HbfQ0HBMzNd
         7ylYpBxxsVAHgOz7M2YMuEbFKYkbezXhRsaoUzm5VFiGVYWRKvIHGGVI5gIzIrQ7fWiC
         qmyu4svn/Xa5wWIDTqXW9L6r2qAKJ/LHK3AyKJydA3sT1DonE+iQtrz4YRQpC0McAYvf
         yKHEAc6MrmSgdjDX0/Ck7A6P1xl5KZvXXShpUbMaMTiDE2+aY39hH9/Xm0VWDpzYCObO
         2Pdw==
X-Gm-Message-State: APjAAAWdVS4cEQnDxFJ58KMKxhD2v/7FXQxREORowyZha58eSDrju3RX
        JN9tJApgvvfI+sxhSKsNetE=
X-Google-Smtp-Source: APXvYqwzdzD/Nu303zbbwC59IVEqcZCYPI3Dlbsg1C2PVErQ5oJuJ9Pi3+8XXCP/FsckTq1J2uQbcA==
X-Received: by 2002:a1c:ddd6:: with SMTP id u205mr16805844wmg.54.1561993810558;
        Mon, 01 Jul 2019 08:10:10 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id w10sm9533163wru.76.2019.07.01.08.10.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 08:10:09 -0700 (PDT)
Date:   Mon, 1 Jul 2019 16:10:08 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 1/3] vsock/virtio: use RCU to avoid use-after-free on
 the_virtio_vsock
Message-ID: <20190701151008.GD11900@stefanha-x1.localdomain>
References: <20190628123659.139576-1-sgarzare@redhat.com>
 <20190628123659.139576-2-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MAH+hnPXVZWQ5cD/"
Content-Disposition: inline
In-Reply-To: <20190628123659.139576-2-sgarzare@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--MAH+hnPXVZWQ5cD/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 28, 2019 at 02:36:57PM +0200, Stefano Garzarella wrote:
> Some callbacks used by the upper layers can run while we are in the
> .remove(). A potential use-after-free can happen, because we free
> the_virtio_vsock without knowing if the callbacks are over or not.
>=20
> To solve this issue we move the assignment of the_virtio_vsock at the
> end of .probe(), when we finished all the initialization, and at the
> beginning of .remove(), before to release resources.
> For the same reason, we do the same also for the vdev->priv.
>=20
> We use RCU to be sure that all callbacks that use the_virtio_vsock
> ended before freeing it. This is not required for callbacks that
> use vdev->priv, because after the vdev->config->del_vqs() we are sure
> that they are ended and will no longer be invoked.

My question is answered in Patch 3.

--MAH+hnPXVZWQ5cD/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl0aIlAACgkQnKSrs4Gr
c8iPgwf9H+ImGI64a81fQKFhYTfBN6jeHcQ+jv0hTEUzxX5RL3sSbhlj2Xy8dW3I
2aoAQdGC6fFfVNN8oQjZ/uW3rQCm6wB6zf2rSNgChnnHl3mkm8whnUwbJJosQOCC
7y1ZIL70zcpqOlpTD7k4sNZs7/isLXyKR41ptEkzWSm/rfDXHLBfIvglUpWhBM3q
gsA2ytSw1/8t74Cm7K+bovYuRJH/A4B9DcoYz6cx1jGlPbIUaNRph/zY1AapqFcT
oWnj+9Pi5ajzg+JUoRtJwgPxCY3CO9V3Xj0w0H36wnoWW16fN1D0l3DTN+vzjUJ2
oSqYzBWzeohwx7QGeHxC26mvLpUnBw==
=jGKr
-----END PGP SIGNATURE-----

--MAH+hnPXVZWQ5cD/--
