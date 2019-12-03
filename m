Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6665E10FABA
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 10:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbfLCJ0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 04:26:55 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43990 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfLCJ0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 04:26:54 -0500
Received: by mail-wr1-f67.google.com with SMTP id n1so2676399wra.10;
        Tue, 03 Dec 2019 01:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SZdfC+gFtVklBpHF7XF3yKS4xbagQBubfYPugqhRugk=;
        b=aDs2YAsOEnOy5MORl6ZJIiOEESJ7SrV+tBNsG7s0DhwI8IAa+WmSS2HHd4QyjWGSJ/
         ldRTToqQ7fQK307trD2DA1pagxWm6spcShdYjO1bCT5zkFNurwT8D0qFsmSSEUBqQVn9
         Z2Zj1HZOONpz9ZI8OlPB6cYCLrisPtiHZPkN+kZ/Qkwrv6OYQdkg4ifUYV0RgQrtxBHy
         Ngqwe37IcYAgs+JB/PBz+qMv8mc+6lkEbD2x5TcMRk7CuL/LFUSdqB1iMLYZ4bG1D9G2
         wj0QR3TKc67oNoo5knJzrwdTSto5TOtorlUqVKc7rBt0YKFHYhH+mW0TIY8+1NlWPXWq
         fHAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SZdfC+gFtVklBpHF7XF3yKS4xbagQBubfYPugqhRugk=;
        b=c1AdemUnx3odErCdLs+LsxlPTyI49QecveN/sDr4pYlv1bTx+tBjxZua0Z+sO6RbkR
         BLqV+rkAx12Pxyo7NHFe0hw7feRtOhOXrr3r+HPD652yaaiP9yDYsbGXom7XxBJeDAT5
         un3YcuudF2Oh84ITlNBGmltQ2TWfNIN6AZD0CNI4i6jhrMCALri4xfo91ZnbETbGwZYV
         mUD3YsxHKGlYJanSXo6M9NWO7v/i/SUpIBsuUh8c+8Mm+/RCjievx+yXCp7r5Hb95dbq
         vBTLJkdffJc4hA2taQ89kJf/mUabLrVoHIh6WWmpq0aOJhnEWVVC03we6SjAoXpTdGeO
         Nxzg==
X-Gm-Message-State: APjAAAX3SAyo34SWOyIVUxxYy27w3qJqh3oSsO6a/BsSCGUETXteo/1x
        TF142FSfwbpTs9ULp4+KQDg=
X-Google-Smtp-Source: APXvYqyWUu9z3na0YvFr46Iqp7ei5QNeidd0TaMx3re4eCOYeNXe9t/Q0pvxheWa/uyUnaKqbmgSNw==
X-Received: by 2002:a5d:43c7:: with SMTP id v7mr3806207wrr.32.1575365212035;
        Tue, 03 Dec 2019 01:26:52 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id v17sm2696979wrt.91.2019.12.03.01.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 01:26:50 -0800 (PST)
Date:   Tue, 3 Dec 2019 09:26:49 +0000
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Dexuan Cui <decui@microsoft.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [RFC PATCH 0/3] vsock: support network namespace
Message-ID: <20191203092649.GB153510@stefanha-x1.localdomain>
References: <20191128171519.203979-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Content-Disposition: inline
In-Reply-To: <20191128171519.203979-1-sgarzare@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 28, 2019 at 06:15:16PM +0100, Stefano Garzarella wrote:
> Hi,
> now that we have multi-transport upstream, I started to take a look to
> support network namespace (netns) in vsock.
>=20
> As we partially discussed in the multi-transport proposal [1], it could
> be nice to support network namespace in vsock to reach the following
> goals:
> - isolate host applications from guest applications using the same ports
>   with CID_ANY
> - assign the same CID of VMs running in different network namespaces
> - partition VMs between VMMs or at finer granularity
>=20
> This preliminary implementation provides the following behavior:
> - packets received from the host (received by G2H transports) are
>   assigned to the default netns (init_net)
> - packets received from the guest (received by H2G - vhost-vsock) are
>   assigned to the netns of the process that opens /dev/vhost-vsock
>   (usually the VMM, qemu in my tests, opens the /dev/vhost-vsock)
>     - for vmci I need some suggestions, because I don't know how to do
>       and test the same in the vmci driver, for now vmci uses the
>       init_net
> - loopback packets are exchanged only in the same netns
>=20
> Questions:
> 1. Should we make configurable the netns (now it is init_net) where
>    packets from the host should be delivered?

Yes, it should be possible to have multiple G2H (e.g. virtio-vsock)
devices and to assign them to different net namespaces.  Something like
net/core/dev.c:dev_change_net_namespace() will eventually be needed.

> 2. Should we provide an ioctl in vhost-vsock to configure the netns
>    to use? (instead of using the netns of the process that opens
>    /dev/vhost-vsock)

Creating the vhost-vsock instance in the process' net namespace makes
sense.  Maybe wait for a use case before adding an ioctl.

> 3. Should we provide a way to disable the netns support in vsock?

The code should follow CONFIG_NET_NS semantics.  I'm not sure what they
are exactly since struct net is always defined, regardless of whether
network namespaces are enabled.

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl3mKlkACgkQnKSrs4Gr
c8h54wf/eNE48AsDKZkZl+68dw3paeS7KLIQEPgUklUhfhqp/IHdX9uG2R88hvCl
rMCQbGHSMQ+yb7gPxN1+0tVXFX7Rf2Cqed4Lwqfq0VvufS80FUk4GiQZKKgk4LRv
/8x4or61TnKGbApxbJnQ+zdj1OirmGwrO8jEt4beMPgsfY80yzl6GcKwYwsOYzeg
w+28vrKtnprab8l8D0DnVIggTtyep72rsGdeOi4KtSmrUoM8GVExUDmwBQtUJ4xo
5+OJJjQ+EzPuKWxGIahFrZAHDGerrVHWyltH/LTq+BU0VNR+Ta726WWzDKVx7v6d
YQm7/TdSAT3l9Id0uVC9+DEM455UIw==
=v5qS
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--
