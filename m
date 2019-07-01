Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9B8A5BF24
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 17:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729790AbfGAPLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 11:11:17 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38277 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727227AbfGAPLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 11:11:17 -0400
Received: by mail-wm1-f66.google.com with SMTP id s15so16338723wmj.3;
        Mon, 01 Jul 2019 08:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9xME/dQa3QW6saF5XzkO2xPu/1eCliqT/qMLby1c/tY=;
        b=M7oxNk7yb8y0npITu6/6x5XUuAxp5CL/wYMEJocISp1scrqJydrfAFS6U+09TKHr9p
         iIb00LgXaL58BlXvlHPCAjRQHq3BZAajKKjMb4DEJvY1bEYmY+TtUVmEKikHc0ErlFb/
         eDEUAUXSz92o1NvqdmS20RLz/4M3pAar68DgsSZ0ybicz8RPkhd580I81hlJpQQww7zr
         SG5Ogg9c0lYBhO0pL8kJb4+rtvaGmWaa14cZQAQcFFwgfPn0YthNd/jQ49tKSUb8WyFN
         TBMHh4zDoGfPKD9WK2gTW3OQVe077CD9g0GbAZ2IlbOQ20UdQiqX7/I1SfY4h+IRDAUd
         TXWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9xME/dQa3QW6saF5XzkO2xPu/1eCliqT/qMLby1c/tY=;
        b=qw1ZDBi6epSt0jyMOostiAMFL6DpEHmxqZvdYtloffGFvGx5u597ZWaM2Hen2POqzQ
         Oe/pa38xuAn3XjQ/NrCDs1uOJu+x2b7rNPk3MyiP8jxO3yeFpcmf++Zsul/X9yeO44Q/
         2AdZ+Ab02K3K2Y03aPdQeRNLvJd9ufyD9zI0ageI2DIl1TDAoyugxVjxkXx78IAXN113
         PZzUXSqjMja74z5EyLowRM1Kl6m1e7NalPZQ2A+oCpjtqqlUPl1fA3u29Yivb2syeccB
         PzlsvtiEJ14NvWtUog2W6eUb0sRKO2hyk21JqgBQ60glN2kuAmoQBUhKb7/XKYdWC5tc
         /mSA==
X-Gm-Message-State: APjAAAWuVv6DJc1q+P1jcOY4+gFVY/E4gYwC47YAxxaMMaEVM8uDJhxh
        7fKysq7twFWNLsTe+vShzDA=
X-Google-Smtp-Source: APXvYqwEROuH3gF+mKHMz0YaiB4ZhIyZrQHn4ihVqefXGC7rRJLV8rdnBmCcmdWk0wXCogNl81ebSA==
X-Received: by 2002:a1c:cf0b:: with SMTP id f11mr18204962wmg.138.1561993875263;
        Mon, 01 Jul 2019 08:11:15 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id g25sm9155251wmk.39.2019.07.01.08.11.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 08:11:14 -0700 (PDT)
Date:   Mon, 1 Jul 2019 16:11:13 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 0/3] vsock/virtio: several fixes in the .probe() and
 .remove()
Message-ID: <20190701151113.GE11900@stefanha-x1.localdomain>
References: <20190628123659.139576-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7LkOrbQMr4cezO2T"
Content-Disposition: inline
In-Reply-To: <20190628123659.139576-1-sgarzare@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7LkOrbQMr4cezO2T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 28, 2019 at 02:36:56PM +0200, Stefano Garzarella wrote:
> During the review of "[PATCH] vsock/virtio: Initialize core virtio vsock
> before registering the driver", Stefan pointed out some possible issues
> in the .probe() and .remove() callbacks of the virtio-vsock driver.
>=20
> This series tries to solve these issues:
> - Patch 1 adds RCU critical sections to avoid use-after-free of
>   'the_virtio_vsock' pointer.
> - Patch 2 stops workers before to call vdev->config->reset(vdev) to
>   be sure that no one is accessing the device.
> - Patch 3 moves the works flush at the end of the .remove() to avoid
>   use-after-free of 'vsock' object.
>=20
> v2:
> - Patch 1: use RCU to protect 'the_virtio_vsock' pointer
> - Patch 2: no changes
> - Patch 3: flush works only at the end of .remove()
> - Removed patch 4 because virtqueue_detach_unused_buf() returns all the b=
uffers
>   allocated.
>=20
> v1: https://patchwork.kernel.org/cover/10964733/

This looks good to me.

Did you run any stress tests?  For example an SMP guest constantly
connecting and sending packets together with a script that
hotplug/unplugs vhost-vsock-pci from the host side.

Stefan

--7LkOrbQMr4cezO2T
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl0aIpEACgkQnKSrs4Gr
c8g5Jgf9G47hJtpF3hJgsnc8qwgARpo4Lohr/kRFkPTC8LuzDXag2AES8zYJIA9E
R/ceQTEan3skEuPHBJEaRxTq0jpx9nKUL+LET20Z9HjmaCZFAMk/WnpYTAI/AZJj
89qIba5WlL9ba+ykkaW1rTBFKSRucoIdmN1sdE0cPR8S9zHSxLQN3C3WmFORXVMQ
nac3hTkbAr3g2twfAT3mcwKpmoODk2T1E0kyWHVXdTuTCr0KajxlZ/kWLRarbbYH
VucypkcnmbBnJ8rc6UXajx+C25ijyqJteBbBjMD8Z3RdeK43TIpNp7uFCyGDUipS
wwhzu5J3xB8hbhp3YtvK/+BTqfIAHg==
=Dzpp
-----END PGP SIGNATURE-----

--7LkOrbQMr4cezO2T--
