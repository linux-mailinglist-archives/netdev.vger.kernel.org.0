Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE73D1029
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 15:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731578AbfJIN35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 09:29:57 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50561 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731083AbfJIN34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 09:29:56 -0400
Received: by mail-wm1-f67.google.com with SMTP id 5so2631657wmg.0;
        Wed, 09 Oct 2019 06:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kPARn1gRAGISUDOuIMr4FiKWck9MsiA5kLmQAdvS720=;
        b=NErizZG0azQ4tnzTvztnRozTwie1h5j4oXuZTEdWR3b+2rNM9uOMvA5cIcZ2luy5RG
         Udr430wAbIizmD/GzgVPCorn2j0BVoreSQ/dM0z8jz4zU+OL1iWL5kllkS0+udAY1PS3
         L74tBc5ZuMt5SW41BsutQIJI2RrM0WJ35l+6UVv4r5E0SNsmPfMKRmjZhueqN+7RErIA
         um+b455mA8/y/1hRX3kenVgcEpTVi9ZZSt3W846FqtlsHwRFU8pQrur9LWyMrByg29Gn
         Qc7pV07JoBOrJ3NMbHZBteZOEjcB70gh+gSRbKtUisfHto6d3jvsB5FKe5LIVtumEVRo
         2jlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kPARn1gRAGISUDOuIMr4FiKWck9MsiA5kLmQAdvS720=;
        b=IZnx/7qrpHp/BLohbGaRoPBK3DazlVKgu/3GyFQXrfSdoLa2yrYumfVbYxEpmASE+y
         tL5dJSwDXlkdKdJau3sv7VjBgISBLHe2DC0VPgzWST0GysATFl8RynASX9ceWoWX42zs
         YN1c/vw1y7b6O8D4G2DJluUAGCTOaGKX2r9/dlQy9ZsUhfP3uUd+dBqNZLy7U+ecCDTa
         e+jwgwmmPRtG2kWi3wFAeixy8sgj/946uyKOZkQC8TJDjUb/quaERm69MdBkKjuvjfvc
         zWvPN8EiF8c7kutgj9IeFd9bRQuvcUIFcLRm9k7WVWK5ZZW8DWhxXH425gbkQesHRCmy
         B6Nw==
X-Gm-Message-State: APjAAAUJdcEpzfRfA9jPJ6Er6IWcV13UyMR3+GgUhluV2O5mCJR+oQ9L
        6Rxw9+3JJvsBhmfUDiz03GY=
X-Google-Smtp-Source: APXvYqzOZya/RwBPXyofFayWNyGbtAoU9HS//lK8oaKkFf5O/NaPrJ1GkbFV3HXNfJ2FijPkk9i+Kw==
X-Received: by 2002:a1c:55c8:: with SMTP id j191mr2601345wmb.54.1570627793829;
        Wed, 09 Oct 2019 06:29:53 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id z5sm3676203wrs.54.2019.10.09.06.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 06:29:53 -0700 (PDT)
Date:   Wed, 9 Oct 2019 14:29:52 +0100
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
Subject: Re: [RFC PATCH 00/13] vsock: add multi-transports support
Message-ID: <20191009132952.GO5747@stefanha-x1.localdomain>
References: <20190927112703.17745-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="E+IgQzR66AIOcbjA"
Content-Disposition: inline
In-Reply-To: <20190927112703.17745-1-sgarzare@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--E+IgQzR66AIOcbjA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 27, 2019 at 01:26:50PM +0200, Stefano Garzarella wrote:
> Hi all,
> this series adds the multi-transports support to vsock, following
> this proposal:
> https://www.spinics.net/lists/netdev/msg575792.html

Nice series!  I have left a few comments but overall it looks promising.

Stefan

--E+IgQzR66AIOcbjA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2d4M8ACgkQnKSrs4Gr
c8hxCQgAvBCgXesjZRNdIi6a/BOoOtpjAFvdIAVMUPXSLpgkAAwwm/PP7tAvx1MJ
YhMxO/wQRSz0MM8hB5SXpylSlELvGW60PDeBGeQXn9mza8dNK+G1Q1gW+k0+iJId
gcqRKa56j0w0ZwF11MWPE3Z5NTAm3UqDkvnAkzkE6QBRtV6yoQfh7pXVWjL/7it/
Y+D8zOxmNIH8rnCyWudTorhTXZdaXu0HQa0G5Kgj4FQlBimBC9LWVVpc0kch0OIY
CzPrOAhxCXgPjXo7W2rw3e+D3lgiqSfV8RsUkfcWjZR0xv9w0ycyU73HsIlPtvrF
iAvhxHWYhtUV+1CUQEHabyPmMNNclg==
=y58O
-----END PGP SIGNATURE-----

--E+IgQzR66AIOcbjA--
