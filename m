Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFD5D21608
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 11:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbfEQJK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 05:10:58 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40777 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727620AbfEQJK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 05:10:58 -0400
Received: by mail-wr1-f65.google.com with SMTP id h4so6287969wre.7;
        Fri, 17 May 2019 02:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uQP6UNBIuUPV1AZ1CoOW9AZlPGtgb8rjFjKOBI0fJng=;
        b=MK7l06K/5p1djD0GO7FMR5hUiraiIDATcpZ/TXE0SqO3vXLhBq+yLai+CCX3FgzlWo
         813DJmO1DOtdeNYPVD3e3cvs8+xEuhHYmcOzmMu4krLuLoVwQRSvpNGvoKqCKeWqtttD
         ahb/XQdbQZvQpm3XLp1fkRokLCL2zMGhAT+wC8LXIcT2dC8dD0jJfu/o6dfzhUjlG/Gu
         qVWeafdYi/FvTLSACg7rCkSBvj3qkziXsjwusmYqqPheTg3nZZrKOIdVi2mLV5iBMmvF
         ZlgtBbL1ryWttAUlQm+vG3QyHxcI6C255vFXf/zmbDebolGxZTPUEjquagUWkkzlIrve
         UVPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uQP6UNBIuUPV1AZ1CoOW9AZlPGtgb8rjFjKOBI0fJng=;
        b=Taae7ZBPMVqLqWI9X4XPIjdUKKG+jhYXMNKiuNDvTgmbEL3IEAie2TF8unN5OiBKqD
         iMBWr8jwnd2G/p8w0PdXnsIWAM8nrzBm40marRZXDiOATD0k/5Dk6S30hK7hHD3mfJ1C
         oAs+XqA2vmStgScaXXeYs2iAtNIlE/ODtu9Ykpx+N07AAb2oeAyt17v4uSYfFfHimNkm
         pTtRlijUeczIJFBefdkTxLZhaR6raSBIHI4sV5cWPBlYNpdZ6tC4M8/74QFA2/N+WkT5
         bJnKlEGurXfetaOZvLo6dewXC47JU408+uKX9ZrWoddc6wGcwpMQ9LI721yJetyGHrms
         Pc1A==
X-Gm-Message-State: APjAAAXdzP3Tz5ePlxIFjlPvWmSbfExblwpd+FbalxusEfQ18iOfU12D
        UNkkvzAX2nMxJgoqTuxeTH9y6bLR/e8=
X-Google-Smtp-Source: APXvYqynhf+F/VtAp3WICJenqlGOUtcwqDHIX042FUWZUXsuXf49AXeMdg+LfCNqZaZUCPolt9fLdA==
X-Received: by 2002:adf:eb84:: with SMTP id t4mr4431385wrn.43.1558084256073;
        Fri, 17 May 2019 02:10:56 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id k67sm8663482wmb.34.2019.05.17.02.10.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 May 2019 02:10:55 -0700 (PDT)
Date:   Fri, 17 May 2019 10:10:54 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        stefanha@redhat.com
Subject: Re: [PATCH V2 0/4] Prevent vhost kthread from hogging CPU
Message-ID: <20190517091054.GE3679@stefanha-x1.localdomain>
References: <1558067392-11740-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ytoMbUMiTKPMT3hY"
Content-Disposition: inline
In-Reply-To: <1558067392-11740-1-git-send-email-jasowang@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ytoMbUMiTKPMT3hY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 17, 2019 at 12:29:48AM -0400, Jason Wang wrote:
> Hi:
>=20
> This series try to prevent a guest triggerable CPU hogging through
> vhost kthread. This is done by introducing and checking the weight
> after each requrest. The patch has been tested with reproducer of
> vsock and virtio-net. Only compile test is done for vhost-scsi.
>=20
> Please review.
>=20
> This addresses CVE-2019-3900.
>=20
> Changs from V1:
> - fix user-ater-free in vosck patch
>=20
> Jason Wang (4):
>   vhost: introduce vhost_exceeds_weight()
>   vhost_net: fix possible infinite loop
>   vhost: vsock: add weight support
>   vhost: scsi: add weight support
>=20
>  drivers/vhost/net.c   | 41 ++++++++++++++---------------------------
>  drivers/vhost/scsi.c  | 21 ++++++++++++++-------
>  drivers/vhost/vhost.c | 20 +++++++++++++++++++-
>  drivers/vhost/vhost.h |  5 ++++-
>  drivers/vhost/vsock.c | 28 +++++++++++++++++++++-------
>  5 files changed, 72 insertions(+), 43 deletions(-)
>=20
> --=20
> 1.8.3.1
>=20
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--ytoMbUMiTKPMT3hY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAlzeep4ACgkQnKSrs4Gr
c8iNjggAneRqHvB02eyRBli2HesL5fARqNFQbAFYGE3ABJtYfF1NDOnIwXI1t5Bt
BassfyZocyhGcUX5kzLujRenaH0Yponx/sp7aDcA3EzH8gwyjdFAlozMSO5Mo/1M
Tq48N/3dHRew7HDCyR83slVKuuaYch4HBtn/K8XAe+HaDAEcdGx8tGAoieeBd1fH
jt7U2G0upIpOGhR1HOtHIZJ6llJU888Xj/l9EySxcXcoApQgaTV1Ta3oR2Sml3ts
WrSc06MuGo/2kKevVAW+qWvqLWk01rIhUWF1IH8+FGUkrPY/QZQDay+muNVXrD7m
/Zp2SmuE+tdA+yhwHfGEWgMsIDspGA==
=Dchs
-----END PGP SIGNATURE-----

--ytoMbUMiTKPMT3hY--
