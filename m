Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3D81F15F3
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 11:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbgFHJ5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 05:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728745AbgFHJ5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 05:57:17 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FE6C08C5C3;
        Mon,  8 Jun 2020 02:57:16 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id q11so16702956wrp.3;
        Mon, 08 Jun 2020 02:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=irlh/DAmGezzFSz/ZBwka7zqE6vVCqBDs6ozHXOIxqY=;
        b=EngZ9vYwjWfjJRgmP5bX1bo/qHbsxx85LLqxWUmO8c7u3d+JbZn5DNJCLIZ+i84LnX
         H3diKX8V9KBpQOv8CPJ8GRwqJf93FpaocP5msBC+L+erbYF55mdnYYpMN17bvAdj389D
         Yd0mrpJkTb8eRXVqqFa8GZbqY5m4h0ZNW7SpZz6Yj0OU2ol93aoVsIa73q1xzXpJU+cv
         +7nLuX/sRwV4BMPDPLLdF5mMZZouXn64XQy9RANABnhLwaAFAW6gY5p70M9lnil07N/G
         E1eZ0d3g5aAMPySs8MpXyZ798UDZVAo603is4axZif/QLMA3Kexo9en9GYOUBSJL6Rz5
         7rsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=irlh/DAmGezzFSz/ZBwka7zqE6vVCqBDs6ozHXOIxqY=;
        b=VfA54iIHG+Zojy/cjjLKneiICLM/NLa6U2xUYGEvPsljqtjJSbHjOVPCfHKzWref5z
         m565yk4hzTWmFO7MGASYqKLqK2epXAzBuKDqYjtTWTwvDVRIm6RfEw/8c23LEv8fEqVa
         9cCdxnbnnjR1jJCRMCTsX3VmspuIRKkhEJm7u1+mA8irGE+/Hsq1wbzWh5ftK+vmkxhL
         hU47/0I850ifzXb1N7HD9B1B/YLJWlQ7M/jPij93WcgmHH7GFsFmg/fNc6EU3T3Ur49A
         39VpbxeotztpQCI2wEMSnDDPsf6cYjlJT+BwdI4EXdJ3RuqXHnLlssctmawwqKS9s4bT
         UQsQ==
X-Gm-Message-State: AOAM533YqwXy8TcwpO34RExeiWwrZThNbEEe52dvNUTT01OOYWX9q5ZR
        83xn8RYRlexTaGQzdvb4VKA=
X-Google-Smtp-Source: ABdhPJwM5am6ET01ZHpQxOXqWgs/YmeMFbTYTcVvDiGZDZOutBBcV+gGDbCKng83YgT4N3gVfVuOLw==
X-Received: by 2002:adf:d852:: with SMTP id k18mr22928605wrl.177.1591610234965;
        Mon, 08 Jun 2020 02:57:14 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id c70sm11547618wme.32.2020.06.08.02.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 02:57:14 -0700 (PDT)
Date:   Mon, 8 Jun 2020 10:57:12 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        eperezma@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH RFC v5 11/13] vhost/scsi: switch to buf APIs
Message-ID: <20200608095712.GD83191@stefanha-x1.localdomain>
References: <20200607141057.704085-1-mst@redhat.com>
 <20200607141057.704085-12-mst@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3Gf/FFewwPeBMqCJ"
Content-Disposition: inline
In-Reply-To: <20200607141057.704085-12-mst@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3Gf/FFewwPeBMqCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 07, 2020 at 10:11:46AM -0400, Michael S. Tsirkin wrote:
> Switch to buf APIs. Doing this exposes a spec violation in vhost scsi:
> all used bufs are marked with length 0.
> Fix that is left for another day.
>=20
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/vhost/scsi.c | 73 ++++++++++++++++++++++++++------------------
>  1 file changed, 44 insertions(+), 29 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--3Gf/FFewwPeBMqCJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl7eC3gACgkQnKSrs4Gr
c8jC3Af+LPXirMBmRcs7FQbxFSgLfLDjpnub+fLUo+dN0CH5ElfkoqGW6HJ8d7er
qlDKL+3ZPm1i0cRsqnN+xg6qZ2UKbC83RHrZ1z12NzkrluuFD4knW3/gjyyQPXvw
N8QQvguhNCO6DJ5yj8njHLuaAi44jkigVA5kFA5e8EFjsGHSQhoamQH23M/89rey
FOot5VmlwGfXtL216ALh6oIoLPuVvrQlQA6iVZGxXP4hgv+z7mJXzLmfJ7l2UnkB
OrdaqlvJcy4ZpKXZtVl5kfLbvRMuuv6a1OeLKW/FU2pJKxa5gn8WGdek5o5XrmpP
Uf/M6MvauUK5c9F369S2pWsEv+mqag==
=6nV4
-----END PGP SIGNATURE-----

--3Gf/FFewwPeBMqCJ--
