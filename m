Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 241A2D0EEB
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 14:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731267AbfJIMe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 08:34:28 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43834 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731229AbfJIMe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 08:34:28 -0400
Received: by mail-wr1-f66.google.com with SMTP id j18so2732000wrq.10;
        Wed, 09 Oct 2019 05:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=M4DGzZVz3C9CsIT3+orcem5mC7xRelRKri3ygcgFcYg=;
        b=Z6Vl8jzwQZv1XXQ8Mh9He/cTpu97fQsfQ1cBmapxrThVkgpqVmy7iiglrNrsC5cwvA
         6IBWyUGhvzVd5dfOS6+lL1zTXjc4zliF5u8ROdz7wF+d4iNr9lc+3q+kGVj91ZHEOJCU
         KWEBZTD6ETHecKoRnKjnjDsrMTsfHZXE4IasyxVGusXKO6jWu7i2N62HMTD3W1mTxpUt
         aIEBA3zVKnhpy140JOHqe+f8Tq0cE/s4Enn5W0O54FTnsp1Jvvw1Q5tB7FkVnOsNisXr
         7mme3cylQ/y7LAc4TxD/ZIps/GWHqcE/hGZ/tggDg4aWu/kUBfnDGjUZtYpFbe2CjSc6
         Y0mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=M4DGzZVz3C9CsIT3+orcem5mC7xRelRKri3ygcgFcYg=;
        b=GxkxmNJYLoEOrb1HJ7jBuSDj1avHb8+wALE6IOuaxHu+zPyB1GWQk7Rf94X/KVzeTU
         zWdBI3bC2Urlbnq/2dbtEMQeG5U6yWPfj8ICQBf3XRBwyfnKCjRXv0bVLtReYELIxX+x
         0+nGSIEFHr2I9iWy+k4pUyCjUc49ffxLqOwmp5p7nRDPX0vY6gTGHA6UKzl+jWu1moXH
         IRxnavb+4Q/NYUMtgOthDRutfsl8oIkvp3jp55rOJa6LEjS7U4nflh8b0u61D+G3uBdG
         oIJWMKKs7hhN9QoJMM01YNozxseUYftnz6NGdx/t1ThbclRxCmDVAgMm5WxFgETeYAJH
         xhcw==
X-Gm-Message-State: APjAAAU8ELRbfMtD6aNa2FYUNADY6lvd7PYAEd20ZVSldr5JURAbmcKs
        yu9uRJGM5BLE/XdLFhOAbCY=
X-Google-Smtp-Source: APXvYqwApF/DZjfteDasDL2Kkb76g7OqjJVm+JG00dcX3k7i+hz7lkgviUk2SMygweyq2OJ7IZaCyQ==
X-Received: by 2002:adf:e284:: with SMTP id v4mr2653792wri.21.1570624466138;
        Wed, 09 Oct 2019 05:34:26 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id t13sm4438023wra.70.2019.10.09.05.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 05:34:25 -0700 (PDT)
Date:   Wed, 9 Oct 2019 13:34:23 +0100
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
Subject: Re: [RFC PATCH 08/13] vsock: move vsock_insert_unbound() in the
 vsock_create()
Message-ID: <20191009123423.GI5747@stefanha-x1.localdomain>
References: <20190927112703.17745-1-sgarzare@redhat.com>
 <20190927112703.17745-9-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+PbGPm1eXpwOoWkI"
Content-Disposition: inline
In-Reply-To: <20190927112703.17745-9-sgarzare@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--+PbGPm1eXpwOoWkI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2019 at 01:26:58PM +0200, Stefano Garzarella wrote:
> vsock_insert_unbound() was called only when 'sock' parameter of
> __vsock_create() was not null. This only happened when
> __vsock_create() was called by vsock_create().
>=20
> In order to simplify the multi-transports support, this patch
> moves vsock_insert_unbound() at the end of vsock_create().
>=20
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/af_vsock.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)

Maybe transports shouldn't call __vsock_create() directly.  They always
pass NULL as the parent socket, so we could have a more specific
function that transports call without a parent sock argument.  This
would eliminate any concern over moving vsock_insert_unbound() out of
this function.  In any case, I've checked the code and this patch is
correct.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--+PbGPm1eXpwOoWkI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2d088ACgkQnKSrs4Gr
c8jGUgf/flGT/To2png0jPgQV5oe1jDDk+0D39ubcCGjdMLuOwLdwey4BUbOWK3I
KFEzw7U6CmXNnW15vqqckacUNgL6OXgHKrOxKpiwYvonz2/C0JNLMaTIbsSfcR8u
sXWnnoihq8NTRIJhSxHFaWgqBLWFW8G3sAfFA2oCIiNI8HQhewIy0Sfh2vfuyypU
SjCHAwlodeIMuEmeIlTUEd4RKWqZ3dDAOs5xnl87OWUdzTtgmKEccQLZSvJ/t2Qi
QVVO07S3r7ASe2bpjmTgQuV1ZZ3iz/jyFOYAD3WmE6D6a+afcU+4gUTa9Tbu1TL4
en7c7jB5XF98CqjwO5kjMLozykqVWg==
=Fgki
-----END PGP SIGNATURE-----

--+PbGPm1eXpwOoWkI--
