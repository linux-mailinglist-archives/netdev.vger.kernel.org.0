Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58B03DDA5D
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235768AbhHBONl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:13:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28289 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238422AbhHBOLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 10:11:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627913465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J4C0U+pM/BB5pINNKlvVxFq0xxru50bjtUc013h1JAw=;
        b=ALzzmSercie2K10K6U2TYffgwS4k3Zh9ip+/GBJOe6/ZTEoaDI5DhB9nfrJCzR0qbuBCFv
        optr4TkKMTMABoC461gINQ/ny4QWBv6NUwIExSgBH02SBOF1AgET7OnetVd0z7DsmfNO6J
        O6lHpCF8PRdddhZEmdBTmMcwfiN4648=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-xU6Wnk8VOWOW0CzRsHZ3uw-1; Mon, 02 Aug 2021 10:11:04 -0400
X-MC-Unique: xU6Wnk8VOWOW0CzRsHZ3uw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10910100E434;
        Mon,  2 Aug 2021 14:10:59 +0000 (UTC)
Received: from localhost (unknown [10.39.193.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E55C19C44;
        Mon,  2 Aug 2021 14:10:58 +0000 (UTC)
Date:   Mon, 2 Aug 2021 15:10:57 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        sgarzare@redhat.com, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vhost: Fix typo in comments
Message-ID: <YQf88cCiee8E5Td4@stefanha-x1.localdomain>
References: <20210729121828.2029-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Ff651RZib3bRTq8N"
Content-Disposition: inline
In-Reply-To: <20210729121828.2029-1-caihuoqing@baidu.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Ff651RZib3bRTq8N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 29, 2021 at 08:18:28PM +0800, Cai Huoqing wrote:
> fix typo for vhost
>=20
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>  drivers/vhost/scsi.c   |  4 ++--
>  drivers/vhost/vhost.c  |  2 +-
>  drivers/vhost/vringh.c | 18 +++++++++---------
>  drivers/vhost/vsock.c  |  6 +++---
>  4 files changed, 15 insertions(+), 15 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--Ff651RZib3bRTq8N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmEH/PEACgkQnKSrs4Gr
c8jkAAf/Xy/uH++s86coEHn2OXj5qEu0qgmmK+GhsNTsRHTdrE7qkBsQwCMxc9O0
NRHpc/4/+fqQwF1uuJO6TkOT6LtgdaGoH2XGx99ftJHvvcZVt0ElqtPECAB9K/Lc
DDpQfbPckfvJFl3kkZsAQ8dr7nQUGhXTRxlBawIo2BOwLwnCGO3jEwaNi32sSeAh
1gTBxCFQHF7viYp5KPACeBRNad6qZKgKbuhA5UtpCDzoYNJOL1RjySibsLLatApX
AUmvUILoOE/uYIe+xOaqTD2+JajYsLBY5KX7Dgc8bBVDs0I404EkrG0WUd0dlyqT
KVzXV008GqWSAYtbx33tOrb3S02X2A==
=6XOS
-----END PGP SIGNATURE-----

--Ff651RZib3bRTq8N--

