Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9521F25C418
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 17:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbgICPDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 11:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728812AbgICN6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 09:58:48 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 738D6C061A12
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 06:40:47 -0700 (PDT)
Received: from [IPv6:2a02:8010:6359:1:551f:34b6:cf72:2539] (unknown [IPv6:2a02:8010:6359:1:551f:34b6:cf72:2539])
        (Authenticated sender: james)
        by mail.katalix.com (Postfix) with ESMTPSA id 5396986B5D;
        Thu,  3 Sep 2020 14:39:30 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1599140370; bh=+cPRgJZpQNKMZr8sz0TSYxrhCksbgm6ICKYSqUo2OQE=;
        h=Subject:To:References:Cc:From:Message-ID:Date:MIME-Version:
         In-Reply-To:From;
        z=Subject:=20Re:=20[PATCH=20net-next=200/6]=20l2tp:=20miscellaneous
         =20cleanups|To:=20Tom=20Parkin=20<tparkin@katalix.com>|References:
         =20<20200903085452.9487-1-tparkin@katalix.com>|Cc:=20netdev@vger.k
         ernel.org|From:=20James=20Chapman=20<jchapman@katalix.com>|Message
         -ID:=20<655103fe-6881-1122-bbcb-62c59af2b102@katalix.com>|Date:=20
         Thu,=203=20Sep=202020=2014:39:30=20+0100|MIME-Version:=201.0|In-Re
         ply-To:=20<20200903085452.9487-1-tparkin@katalix.com>;
        b=YXbsM7/MOt0iTrrJVfA6c0bek2Ezd/tfo7crZRuGhALXslsqj3Bwh38XmqOM6Kvhi
         Li4NHj2BB+0NSCaDKY7qnm/mHqIgjR/rR21/BwyRrUjGULgXR5NTzTPgm6FHKs0doH
         rDoB9n6rTszZUzcF+vnaMD325aHCtO6GMg5LlOcI8VMoU3EdhDn5AsywGqRx5iza5m
         MwHf2yfPJiAtsoRm0DmwxMtOjvVVvwkMIXUJzN2q6WWHeuU/O32y3V54TBD1OSLNiR
         mscCsrAvdc0x4eLJHf3U9r3ceFss5KgKloAVd44+UjY1bxqhdpzaGzyZUJE0PrAxSo
         IhzOXkLXXjeag==
Subject: Re: [PATCH net-next 0/6] l2tp: miscellaneous cleanups
To:     Tom Parkin <tparkin@katalix.com>
References: <20200903085452.9487-1-tparkin@katalix.com>
Cc:     netdev@vger.kernel.org
From:   James Chapman <jchapman@katalix.com>
Autocrypt: addr=jchapman@katalix.com; prefer-encrypt=mutual; keydata=
 xsBNBFDmvq0BCACizu6XvQjeWZ1Mnal/oG9AkCs5Rl3GULpnH0mLvPZhU7oKbgx5MHaFDKVJ
 rQTbNEchbLDN6e5+UD98qa4ebvNx1ZkoOoNxxiuMQGWaLojDKBc9x+baW1CPtX55ikq2LwGr
 0glmtUF6Aolpw6GzDrzZEqH+Nb+L3hNTLBfVP+D1scd4R7w2Nw+BSQXPQYjnOEBDDq4fSWoI
 Cm2E18s3bOHDT9a4ZuB9xLS8ZuYGW6p2SMPFHQb09G82yidgxRIbKsJuOdRTIrQD/Z3mEuT/
 3iZsUFEcUN0T/YBN3a3i0P1uIad7XfdHy95oJTAMyrxnJlnAX3F7YGs80rnrKBLZ8rFfABEB
 AAHNJEphbWVzIENoYXBtYW4gPGpjaGFwbWFuQGthdGFsaXguY29tPsLAeAQTAQIAIgUCUOa+
 rQIbIwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQINzVgFp/OkBr2gf7BA4jmtvUOGOO
 JFsj1fDmbAzyE6Q79H6qnkgYm7QNEw7o+5r7EjaUwsh0w13lNtKNS8g7ZWkiBmSOguJueKph
 GCdyY/KOHZ7NoJw39dTGVZrvJmyLDn/CQN0saRSJZXWtV31ccjfpJGQEn9Gb0Xci0KjrlH1A
 cqxzjwTmBUr4S2EHIzCcini1KTtjbtsE+dKP4zqR/T52SXVoYvqMmJOhUhXh62C0mu8FoDM0
 iFDEy4B0LcGAJt6zXy+YCqz7dOwhZBB4QX4F1N2BLF3Yd1pv8wBBZE7w70ds7rD7pnIaxXEK
 D6yCGrsZrdqAJfAgYL1lqkNffZ6uOSQPFOPod9UiZM7ATQRQ5r6tAQgAyROh3s0PyPx2L2Fb
 jC1mMi4cZSCpeX3zM9aM4aU8P16EDfzBgGv/Sme3JcrYSzIAJqxCvKpR+HoKhPk34HUR/AOk
 16pP3lU0rt6lKel2spD1gpMuCWjAaFs+dPyUAw13py4Y5Ej2ww38iKujHyT586U6skk9xixK
 1aHmGJx7IqqRXHgjb6ikUlx4PJdAUn2duqasQ8axjykIVK5xGwXnva/pnVprPSIKrydNmXUq
 BIDtFQ4Qz1PQVvK93KeCVQpxxisYNFRQ5TL6PtgVtK8uunABFdsRqlsw1Ob0+mD5fidITCIJ
 mYOL8K74RYU4LfhspS4JwT8nmKuJmJVZ5DjY2wARAQABwsBfBBgBAgAJBQJQ5r6tAhsMAAoJ
 ECDc1YBafzpA9CEH/jJ8Ye73Vgm38iMsxNYJ9Do9JvVJzq7TEduqWzAFew8Ft0F9tZAiY0J3
 U2i4vlVWK8Kbnh+44VAKXYzaddLXAxOcZ8YYy+sVfeVoJs3lAH+SuRwt0EplHWvCK5AkUhUN
 jjIvsQoNBVUP3AcswIqNOrtSkbuUkevNMyPtd0GLS9HVOW0e+7nFce7Ow9ahKA3iGg5Re9rD
 UlDluVylCCNnUD8Wxgve4K+thRL9T7kxkr7aX7WJ7A4a8ky+r3Daf7OhGN9S/Z/GMSs0E+1P
 Qm7kZ2e0J6PSfzy9xDtoRXRNigtN2o8DHf/quwckT5T6Z6WiKEaIKdgaXZVhphENThl7lp8=
Organization: Katalix Systems Ltd
Message-ID: <655103fe-6881-1122-bbcb-62c59af2b102@katalix.com>
Date:   Thu, 3 Sep 2020 14:39:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200903085452.9487-1-tparkin@katalix.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/09/2020 09:54, Tom Parkin wrote:
> This series of patches makes the following cleanups and improvements to=

> the l2tp code:
> =20
>  * various API tweaks to remove unused parameters from function calls
>  * lightly refactor the l2tp transmission path to capture more error
>    conditions in the data plane statistics
>  * repurpose the "magic feather" validation in l2tp to check for
>    sk_user_data (ab)use as opposed to refcount debugging
>  * remove some duplicated code
>
> Tom Parkin (6):
>   l2tp: remove header length param from l2tp_xmit_skb
>   l2tp: drop data_len argument from l2tp_xmit_core
>   l2tp: drop net argument from l2tp_tunnel_create
>   l2tp: capture more tx errors in data plane stats
>   l2tp: make magic feather checks more useful
>   l2tp: avoid duplicated code in l2tp_tunnel_closeall
>
>  net/l2tp/l2tp_core.c    | 134 +++++++++++++++++++---------------------=

>  net/l2tp/l2tp_core.h    |  10 ++-
>  net/l2tp/l2tp_eth.c     |   2 +-
>  net/l2tp/l2tp_ip.c      |   2 +-
>  net/l2tp/l2tp_ip6.c     |   2 +-
>  net/l2tp/l2tp_netlink.c |   2 +-
>  net/l2tp/l2tp_ppp.c     |  15 ++++-
>  7 files changed, 87 insertions(+), 80 deletions(-)
>
Reviewed-by: James Chapman <jchapman@katalix.com>



