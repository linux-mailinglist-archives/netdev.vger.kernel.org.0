Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3435126091
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 12:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfLSLLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 06:11:30 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40124 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfLSLL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 06:11:29 -0500
Received: by mail-wm1-f66.google.com with SMTP id t14so5165136wmi.5;
        Thu, 19 Dec 2019 03:11:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YrnybgUoheTzv0oO8IdIe7ptyQE6UeKhluLQtlHkiL4=;
        b=L5jwgvu8SJyXaL7/gM2ue6Gliiu5B28abgkn3MBXlepIvB/3e6eiEFI/xoJx0DWQFm
         Czc1EeAnKsiRfSDoEORA5nGYqKCBTs7YKYQVkJkUdqtpiNBo+35g+6gH2ym8BKM16kRi
         futwiDg6xervRZyvvWdf5vW4X/jRSkUxOl6tWZ0PlvJMSyyqIuIZpg1WEnCb7WQDcOvM
         HtqvwZ47j4yCHXIc3/f8UiWo+bqmUBbsPfkK44q6AjnkcpLwpDmNQV+WYVne+FhJHJ1m
         5W2BQJpVAdLCzCZDZNSuXJqOqDf/LtsZi6CLCgYCkCPzY30fBRFyxyyzwMEpyiwBtrF1
         271A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YrnybgUoheTzv0oO8IdIe7ptyQE6UeKhluLQtlHkiL4=;
        b=Wq5QHylnpilkbnjrOSUiwTl+XOPZS3KUe7XgqmLrW+Tt6sn8BiUjv1rYsG+WyOB6T6
         t1C8o+g4iOhK03hugoOa07F0H3+B8PchxaAwRUNbGUWjufnZWH92v4PREVy4H6YE4901
         zJlvryixjJaUmGf6J98a0KzmQpoexPV0DVyahtOP/f1KxvkG0AnR625pHhfzS5XBergD
         kBKDLfRMXdT/30vvPsXNyWDFdigozvTZ3ILTCXRPd9fufKd4Tuu2hTB5COfdT5xHGHIR
         L7EFypn3plzICl1KOggVDRgK/eUE824lcH0f7E/VrtrlX+vKab9MRp1Vd4VPzkK4BJAS
         Hoag==
X-Gm-Message-State: APjAAAWUAntl8vxx4BOFT2J7hgXmvQRsHwN6qB2BUEWLv+71XaZLkM44
        k4xub5IAOUFhitbFpuv0saI=
X-Google-Smtp-Source: APXvYqzUvVcY3kHWc63gcuoVbKWoG+jj5xTx9pH8lTTdeQpbORs22WGWlPob0aZnv9F0VQt7Oxzvkw==
X-Received: by 2002:a1c:16:: with SMTP id 22mr9647105wma.8.1576753887091;
        Thu, 19 Dec 2019 03:11:27 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id p17sm5975871wmk.30.2019.12.19.03.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 03:11:25 -0800 (PST)
Date:   Thu, 19 Dec 2019 11:11:24 +0000
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     davem@davemloft.net, kvm@vger.kernel.org, netdev@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [PATCH net-next v3 00/11] VSOCK: add vsock_test test suite
Message-ID: <20191219111124.GA1624084@stefanha-x1.localdomain>
References: <20191218180708.120337-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <20191218180708.120337-1-sgarzare@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 18, 2019 at 07:06:57PM +0100, Stefano Garzarella wrote:
> The vsock_diag.ko module already has a test suite but the core AF_VSOCK
> functionality has no tests. This patch series adds several test cases that
> exercise AF_VSOCK SOCK_STREAM socket semantics (send/recv, connect/accept,
> half-closed connections, simultaneous connections).
>=20
> The v1 of this series was originally sent by Stefan.
>=20
> v3:
> - Patch 6:
>   * check the byte received in the recv_byte()
>   * use send(2)/recv(2) instead of write(2)/read(2) to test also flags
>     (e.g. MSG_PEEK)
> - Patch 8:
>   * removed unnecessary control_expectln("CLOSED") [Stefan].
> - removed patches 9,10,11 added in the v2
> - new Patch 9 add parameters to list and skip tests (e.g. useful for vmci
>   that doesn't support half-closed socket in the host)
> - new Patch 10 prints a list of options in the help
> - new Patch 11 tests MSG_PEEK flags of recv(2)
>=20
> v2: https://patchwork.ozlabs.org/cover/1140538/
> v1: https://patchwork.ozlabs.org/cover/847998/
>=20
> Stefan Hajnoczi (7):
>   VSOCK: fix header include in vsock_diag_test
>   VSOCK: add SPDX identifiers to vsock tests
>   VSOCK: extract utility functions from vsock_diag_test.c
>   VSOCK: extract connect/accept functions from vsock_diag_test.c
>   VSOCK: add full barrier between test cases
>   VSOCK: add send_byte()/recv_byte() test utilities
>   VSOCK: add AF_VSOCK test cases
>=20
> Stefano Garzarella (4):
>   vsock_test: wait for the remote to close the connection
>   testing/vsock: add parameters to list and skip tests
>   testing/vsock: print list of options and description
>   vsock_test: add SOCK_STREAM MSG_PEEK test
>=20
>  tools/testing/vsock/.gitignore        |   1 +
>  tools/testing/vsock/Makefile          |   9 +-
>  tools/testing/vsock/README            |   3 +-
>  tools/testing/vsock/control.c         |  15 +-
>  tools/testing/vsock/control.h         |   2 +
>  tools/testing/vsock/timeout.h         |   1 +
>  tools/testing/vsock/util.c            | 376 +++++++++++++++++++++++++
>  tools/testing/vsock/util.h            |  49 ++++
>  tools/testing/vsock/vsock_diag_test.c | 202 ++++----------
>  tools/testing/vsock/vsock_test.c      | 379 ++++++++++++++++++++++++++
>  10 files changed, 883 insertions(+), 154 deletions(-)
>  create mode 100644 tools/testing/vsock/util.c
>  create mode 100644 tools/testing/vsock/util.h
>  create mode 100644 tools/testing/vsock/vsock_test.c
>=20
> --=20
> 2.24.1
>=20
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl37WtwACgkQnKSrs4Gr
c8ghowf8CLQjydPRjm3F7iQ8iS7EhFcrctrj96QbH/gFGwkxcSiXqC0mwtLprUzL
sbzvy6lfKd7nfmXz2O4fJkyKa3qF8/xm3j04fg+6m5WbLNtKMHGE9nyH0NUttTiH
chth84d78ZFP1m+KV0spdJQBoHFi3pHh3eZWdzNaEEkCdEU0sTI37W4CsJjBw1AF
PeJFTmO/sGi8c8f8lvBTb8TipXM7THMhr0O+ypUYXFBG6IuNXsKkXcPOjzd9qKFd
DGr/Ecd6BMIHdNjGgJ707hxsmOooJv9DT4MZQ58KcEzGR9fmtM+E4hnugMt40upL
3ysZQApGZuQOWqxa7oYNLe86Az04uw==
=JzCU
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
