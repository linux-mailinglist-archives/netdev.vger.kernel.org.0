Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49D78D0DE2
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 13:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731078AbfJILnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 07:43:18 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37465 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728054AbfJILnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 07:43:17 -0400
Received: by mail-wm1-f68.google.com with SMTP id f22so2221617wmc.2;
        Wed, 09 Oct 2019 04:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=un54BHtF8/awpbVtp/5g79CNHp0Pmiod9UP21TSYdIs=;
        b=cfMf0bjET/C22i1LZv7PCr+g/yJ9RnLl9uGwurRAvBjn0NYDYYQRs1gIqnv8uGj/NQ
         2Ozi08WMklKmYKIPAf0vzXFyxKPSgIafOdCfrdUleJ2gUGUb6MJH6HcG8XJMt/RRG06q
         11xh9mP1omeOfOR6xBznOdBhuMdMnBHXRiFst9dWjXoGXrFGac1aZkQTzLEhjWTaPrGd
         PfjV15f9vGdTf1YzNGJXq9etjhmNZTgUobdSaBSJsxR+SD9HMh7vIayhHEEHrnE+GmCs
         7hk0FM1Dfus0zIN+FBYhTTmtYRVThG5Pqqm4nHAXqKvQKl/P94MG+RlM26LTQr+OOGKX
         LmPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=un54BHtF8/awpbVtp/5g79CNHp0Pmiod9UP21TSYdIs=;
        b=mBHMpttoI6QE90++lB6YGUc3I8Y8zgovqXdb1dvYfP4WTI7J1JGoi580KHMaagPk6d
         TDYFGrcAZavGS9cD7ebSFFdsoAhFxh4EIJ1unhyp3s4oksrS7mcCC6EJZWn+qOl7I8He
         EpyF4633fe1FKICx6h3e6NzM0vHVfomLt4mA+pHyS3n6ErcpEfKkdABdJ27CLGYIZoax
         4JOrZPTypb1aP+HZq8XKiQM+oLa6Xhbq9ow4kayU4hVyba+k4taVEVH2xwH2Xdwa+Z22
         VZwm8vvrHThTO1tklm7Z2mGaSE5yZw83wlMt1eGcNW6h0V3q9mLNrLeNQelgXzDz8FJ2
         MuMg==
X-Gm-Message-State: APjAAAUP4jKMrZKMnUEqrNHv1NzPSPXTwermKJh3ZuTgWCwFDHo+qo3g
        1inVRLMzRsKSyras9Vt/ZhY=
X-Google-Smtp-Source: APXvYqwLwyMkVEpNNJPRSOBI4ea7XjQ9JE2cU8KiTuH7Of7THeIGHSWgXddwJKHY1bi+w7iTxsprIQ==
X-Received: by 2002:a7b:c8d9:: with SMTP id f25mr2332753wml.153.1570621393615;
        Wed, 09 Oct 2019 04:43:13 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id p5sm2915817wmi.4.2019.10.09.04.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 04:43:12 -0700 (PDT)
Date:   Wed, 9 Oct 2019 12:43:11 +0100
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
Subject: Re: [RFC PATCH 03/13] vsock: remove include/linux/vm_sockets.h file
Message-ID: <20191009114311.GD5747@stefanha-x1.localdomain>
References: <20190927112703.17745-1-sgarzare@redhat.com>
 <20190927112703.17745-4-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/unnNtmY43mpUSKx"
Content-Disposition: inline
In-Reply-To: <20190927112703.17745-4-sgarzare@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--/unnNtmY43mpUSKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2019 at 01:26:53PM +0200, Stefano Garzarella wrote:
> This header file now only includes the "uapi/linux/vm_sockets.h".
> We can include directly it when needed.
>=20
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  include/linux/vm_sockets.h            | 13 -------------
>  include/net/af_vsock.h                |  2 +-
>  include/net/vsock_addr.h              |  2 +-
>  net/vmw_vsock/vmci_transport_notify.h |  1 -
>  4 files changed, 2 insertions(+), 16 deletions(-)
>  delete mode 100644 include/linux/vm_sockets.h

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--/unnNtmY43mpUSKx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2dx88ACgkQnKSrs4Gr
c8g54wf+PL7xAZ3eI74ytwJozmNe/9DWAw5l7bnOPC5lh3yi3O6H/afVtuNy65xz
NYAwGHyFqaMtLm4reJeETuun6duQ7+ZKHr8NJHdUkQJFCQIfHJLI7JXfjDD2VSbp
xn9tbLC2eFnCvlnT7Ke8Er9e1KOI2IBGggkOVvn4HbowDVF8/aeCh0aoPt6bYBVf
FXFaWL0WeGoaalzf14LEf3uDMQptQaMFfcXudbWsv4Xfdmtu9EULADXwa2o4rNVx
1c7Iiu7NOXS7jiD/2NzveQvH0lxrPvUQtgNth9abPF1XA+6yJev9DrLnlYTKCn5q
rmIv4DoNGcc8wrcQ6ZB+Quid23UtAg==
=13TI
-----END PGP SIGNATURE-----

--/unnNtmY43mpUSKx--
