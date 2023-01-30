Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0191681A92
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 20:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238006AbjA3TeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 14:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237960AbjA3TeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 14:34:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C47CC3E
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 11:33:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675107204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B3zRnSLp2ynUX7qdmnYkoyQsTORE3q5pAz8/tYex2W8=;
        b=NNCqSXwizRw2qbNnILSYPiu2lLgRkmeY6ysFkbNEHuTFK/BkDlHqmb/RABC4yEGsUEPTJr
        Cu3hVQppXVSyGgiwEvLMT2PTuyGwH9hMk7iho2UP6OvbBH0j1tMTJ8pJbAaURXQARj4cU4
        BW8CA+STg+h5/BcGOip2Rpl5xQ8ByTM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-x27mjU13MBiDmS4SpAKpeg-1; Mon, 30 Jan 2023 14:33:18 -0500
X-MC-Unique: x27mjU13MBiDmS4SpAKpeg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5481E1C07548;
        Mon, 30 Jan 2023 19:33:18 +0000 (UTC)
Received: from localhost (unknown [10.39.195.80])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC7EE2026D4B;
        Mon, 30 Jan 2023 19:33:17 +0000 (UTC)
Date:   Mon, 30 Jan 2023 14:33:15 -0500
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Bo Liu <liubo03@inspur.com>
Cc:     mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-scsi: convert sysfs snprintf and sprintf to
 sysfs_emit
Message-ID: <Y9gbe+Pr5AcGbcta@fedora>
References: <20230129091145.2837-1-liubo03@inspur.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zXZMPvM7BUyVfKwq"
Content-Disposition: inline
In-Reply-To: <20230129091145.2837-1-liubo03@inspur.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zXZMPvM7BUyVfKwq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 29, 2023 at 04:11:45AM -0500, Bo Liu wrote:
> Follow the advice of the Documentation/filesystems/sysfs.rst
> and show() should only use sysfs_emit() or sysfs_emit_at()
> when formatting the value to be returned to user space.
>=20
> Signed-off-by: Bo Liu <liubo03@inspur.com>
> ---
>  drivers/vhost/scsi.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--zXZMPvM7BUyVfKwq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmPYG3sACgkQnKSrs4Gr
c8hxvwf7B5Mbqo82xgBpjBde9q1dmi1tzl28i35KjgqCpyf6DNJNI7r+MrkPyIuw
mGOZjZ3icMd82hcJVEi0XIP8A6eUOsqKPzob4h6w28sRV0kfqmvgSPh9zpRXf8PR
G43mj1UArMtXj2mPqW4NTF3sgTLXJl+sZiDWvIVQIUuNjbtkxZ89fSZ5cH8AwdRy
Yb3EQ8TRhb5xpfcYj0EPIM/nFUpyQPZxIKZpg2OeTpv0QZ6ZSo+2kiXYQSE1Cljl
j2F8xN8OsOhzS2JTCBr777dn7JIHWjKvQvz0u2d4WBqkWw5O2P9Ea90IU5rPK28X
K8iZ3SXmteQjQsroywTO/jHtYylj8g==
=EEEC
-----END PGP SIGNATURE-----

--zXZMPvM7BUyVfKwq--

