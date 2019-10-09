Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26AD9D0DD4
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 13:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730931AbfJILli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 07:41:38 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41758 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfJILli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 07:41:38 -0400
Received: by mail-wr1-f68.google.com with SMTP id q9so2506543wrm.8;
        Wed, 09 Oct 2019 04:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mMvvYTkM4tkX/zo2Ao0DeJUC7rPkTo80uGcij47czrg=;
        b=TPCovcmHJMC1pvZXwISoRuCV1Sfonuzn0BlRI4oKPe/hzHj3w6Nl8+hnu5qVdPvcBl
         eGA+CYXbem4TVh6WET1EKfA3HwV+lDKzOavXpS2D74h5UWzTp9iQ+4zKkTm4Mbz5ypxg
         9ba2YcuTYX0CqMPqieHUCeefpfHiIFS2Q2AOFAhVQHeDKGZdlZSWKrAqMiHYnAhbcSgf
         GL/99s2KguOl4JzxwCT9LDZEwRZFV7pKOp+1iaZiSYkuZoQ/80MefTf3Ubv8gZD/oeEG
         CS5OLib2PdeApMdcwMiosDnbiSsuNPtD5ls7ElllaEQObVROkac2MzarZ+mJWhrS/z/8
         b68w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mMvvYTkM4tkX/zo2Ao0DeJUC7rPkTo80uGcij47czrg=;
        b=hu4fJ77kK6b4NX/vNtE/NOMjJIfsbLvanxnM6kUMdND4HWxIB85U1t362TYTnlBzxm
         YqWCLBW2m6M0u5rUsxVaDKZW4nU3vtdwYKuuPGZuhU9VD21+ppmVTm5b/WxvkRWd3Yg/
         TWc2M+TyN405mlzOV0doRxP9BLnrGQxF+lVOZH1CBmlG2kfcSdAVi2dFHFQ9bSe5Io54
         lLxsyh8LKObkWCiFjjsPeO6tiCWPAk1LRJqoGOn2OcSy4dEEzj5EUs72YJTzFUd0VPqb
         lPs54zqHNqadA2N9AW6D963fg7nELJhTqEPKPvQlimzPKhcz56DdOfgt7GQB/h31ULzT
         mKuw==
X-Gm-Message-State: APjAAAW1GfXyDmGjjMcOqRcCC9v0IxrJ2TV23zrUKEFRlZbFcAcAPGsi
        8vINSqAXnRZOCp3HE14Z3HQ=
X-Google-Smtp-Source: APXvYqxuonZuaW/TjLvUCvWw0cX8AjeIVxfiHs749gIi+aa0PGQZLcC696dUFWCro0Q5KN+pZ/fRog==
X-Received: by 2002:a05:6000:1190:: with SMTP id g16mr2490550wrx.133.1570621295757;
        Wed, 09 Oct 2019 04:41:35 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id h63sm3844894wmf.15.2019.10.09.04.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 04:41:34 -0700 (PDT)
Date:   Wed, 9 Oct 2019 12:41:33 +0100
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
Subject: Re: [RFC PATCH 01/13] vsock/vmci: remove unused
 VSOCK_DEFAULT_CONNECT_TIMEOUT
Message-ID: <20191009114133.GB5747@stefanha-x1.localdomain>
References: <20190927112703.17745-1-sgarzare@redhat.com>
 <20190927112703.17745-2-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oLBj+sq0vYjzfsbl"
Content-Disposition: inline
In-Reply-To: <20190927112703.17745-2-sgarzare@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2019 at 01:26:51PM +0200, Stefano Garzarella wrote:
> The VSOCK_DEFAULT_CONNECT_TIMEOUT definition was introduced with
> commit d021c344051af ("VSOCK: Introduce VM Sockets"), but it is
> never used in the net/vmw_vsock/vmci_transport.c.
>=20
> VSOCK_DEFAULT_CONNECT_TIMEOUT is used and defined in
> net/vmw_vsock/af_vsock.c
>=20
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/vmci_transport.c | 5 -----
>  1 file changed, 5 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--oLBj+sq0vYjzfsbl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2dx20ACgkQnKSrs4Gr
c8hIqAgAvhL+0GDmzG+IqoyqU4u4zMGfhwqu1Tuctdk+5o6AtyHB9jF8qW0lxKfG
m9BlFbKLMcxjmiirqBXOj24o7GMoko98x8mhqBxofFG0/WTAEqe80ibGyAR8f5/t
jNyonyKpw3UU9kuYwlQBDZoCjh6ZAOofpmKrtCbE63GntiCzX3waJ5mlK/5Dqtcy
l7Ol7BjACIKs7gG7i9kF/TtFcU93EcjC8OJuqJ/1bx0y38wMEfCnlpwBkvh2/hQo
K2Lv1qJHosKW+CqXelAYdeT1YWXmAiE2AYfNTPFzVdStra5QV+O3UDGr536IHmDD
Y7Mo+oe8VRerZV4xgiCKHY+E7FUw/A==
=dBuq
-----END PGP SIGNATURE-----

--oLBj+sq0vYjzfsbl--
