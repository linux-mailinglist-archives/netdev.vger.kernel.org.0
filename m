Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0148D1014
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 15:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731529AbfJIN2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 09:28:39 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36536 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731138AbfJIN2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 09:28:38 -0400
Received: by mail-wm1-f65.google.com with SMTP id m18so2627268wmc.1;
        Wed, 09 Oct 2019 06:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=I7jMF/Qy1gpLzvR/kN34jEJdNQ3gvhWQW+1n1B3riaI=;
        b=LMKtmy8hlP943Yo/NfDhtwq/wBaNOX0zpKbxyEeVZyrNN1kGf7yoo+/6R2c9OZNEZs
         k/fQbrQhamPPC4uKg8s4ic+2Hm3gLRfw7nwlsDdVUc5CYMtR9mFFosPvhv2gPkBu0q5j
         Fr31uCccDz26FsVg/EeINyhgyvEWsKjCIfZzCsr4gTkbWHo6YOJoG9pWmGWtCX+QVEqc
         9X4bhfhfHqfVOamQ3hFW4xhq1sG8HU9vDQhFlzc7Aya/VFqeKTNlgFtCKSBIIbVXu3dx
         /+IUVX6MghDY4n+V08lebyJDwIdWQeCzV72IK8gWQWEf5Sq2ff1Bb5ZhhXVk41uvhGvm
         HrEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=I7jMF/Qy1gpLzvR/kN34jEJdNQ3gvhWQW+1n1B3riaI=;
        b=S4gm70sEgfUhZIWkKEDWe4IqGmcJJ84YK1G8D8XvK4BTMgE+GbLHgrm/ENV5VaF081
         X1k6HsYWmB8iC9HzbaUMBp8wb8WJ/bbOaIrf/urgm6D3Xl1I0EGawgqWbbm6WIqQ85dN
         tp2AzlNjTwh8AzJSf+jdEQp3e4Ub3WL+UouAIILZ+ork+LVCuzKVdK7x/geY3BS4s0dl
         tuiUPGKsRJdqDSV+0AGIhcerW0IKsR3gZgSKzyPxnGKh8/py3ZPfmeoesyUPUxZ4lz+T
         +ehHNVWUyKu9JRKUkGI1+paO2pVWHdSdkOkI64z7y9QwSiGum/dgv0savoAXWC3XNZeQ
         Y53w==
X-Gm-Message-State: APjAAAX/zkc2IbWRF+DRZXAZZfXlQbxFlJqdYAbgIOf7IZSK828ctOIv
        c5fJuZRyN08TihoK/VNt05g=
X-Google-Smtp-Source: APXvYqxKwJu6lkxS1KK3M8WqeAE93yjTEj4R/WrVk3k/UcBmQ2RJXQeaqdeRl98n5f6etP6D+PHErw==
X-Received: by 2002:a1c:658a:: with SMTP id z132mr2596866wmb.174.1570627715977;
        Wed, 09 Oct 2019 06:28:35 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id b7sm2763342wrx.56.2019.10.09.06.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 06:28:35 -0700 (PDT)
Date:   Wed, 9 Oct 2019 14:28:33 +0100
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
Subject: Re: [RFC PATCH 12/13] vsock: prevent transport modules unloading
Message-ID: <20191009132833.GM5747@stefanha-x1.localdomain>
References: <20190927112703.17745-1-sgarzare@redhat.com>
 <20190927112703.17745-13-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kunpHVz1op/+13PW"
Content-Disposition: inline
In-Reply-To: <20190927112703.17745-13-sgarzare@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--kunpHVz1op/+13PW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2019 at 01:27:02PM +0200, Stefano Garzarella wrote:
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index c5f46b8242ce..750b62711b01 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -416,13 +416,28 @@ int vsock_assign_transport(struct vsock_sock *vsk, =
struct vsock_sock *psk)
>  		return -ESOCKTNOSUPPORT;
>  	}
> =20
> -	if (!vsk->transport)
> +	/* We increase the module refcnt to prevent the tranport unloading

s/tranport/transport/

Otherwise:

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--kunpHVz1op/+13PW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2d4IEACgkQnKSrs4Gr
c8gJ2gf/fEP3ucMouPO/fhEeGplHc1JeWTI82mmjT2/LiJgxHaNqylqpIMASW19q
7nn9yxlVS1rBu7D/Os+q4CtQwAc3ea5KvmwwHgFa4v/N1Sm25jklsw/zWMyus6gw
0xc5zcifHOfttIiSKldJuRCc1nYYUnUrakwm1MJjlzB+LEIYUm2/264mLBbyxWqa
TxQBVZSI0BlpISSAry9LKNQIqZU/3gWBa1sIHT3PElSZQ5Z9be7XQciuLi84Hfag
uOky8F3zdmzG2REAu8mKuF0thOyFpPP05O2qo6GML9+ERqf1PwR2qenlTO/cMBzS
KwNQ3ydpast9dLj7idIKHuiQgTIxcQ==
=qIxu
-----END PGP SIGNATURE-----

--kunpHVz1op/+13PW--
