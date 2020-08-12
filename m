Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123A52429D3
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 14:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbgHLMx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 08:53:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23515 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728089AbgHLMx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 08:53:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597236836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=hZGK4VqKBNGocuw1XQy75xG39H+4wy2WFXYhD1mNjbI=;
        b=cmYz7EwbJ3e46Oy+gG32wBg0puQmAQ4QMTA438XCmmDaQvrx6Xeonwi/WSHB+l0jguxgbv
        cpPmkqgjk0QVpuG17HUlETWBFjAi8VUkQR7FMBh2X12vxpikbAsUPKpWimJZSihjE/USAr
        M/4s9d+tUf4yU0fkfoKO0nQrq2/rNS0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-hughY1zvPq-xDTXEGsqJ5g-1; Wed, 12 Aug 2020 08:53:53 -0400
X-MC-Unique: hughY1zvPq-xDTXEGsqJ5g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DD548015C4;
        Wed, 12 Aug 2020 12:53:52 +0000 (UTC)
Received: from [10.10.114.130] (ovpn-114-130.rdu2.redhat.com [10.10.114.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E42B600D4;
        Wed, 12 Aug 2020 12:53:50 +0000 (UTC)
Subject: Re: [PATCH net] net: accept an empty mask in
 /sys/class/net/*/queues/rx-*/rps_cpus
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        Alex Belits <abelits@marvell.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20200812013440.851707-1-edumazet@google.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <e234d062-b32a-a819-494a-716cd5b9c39c@redhat.com>
Date:   Wed, 12 Aug 2020 08:53:49 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200812013440.851707-1-edumazet@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VhxJelrm2oQHV6KKW7FPr4CLjEIoPM03G"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VhxJelrm2oQHV6KKW7FPr4CLjEIoPM03G
Content-Type: multipart/mixed; boundary="BPOAKSSZa9mWyF2fIXh4F0jTxfqXeItaL"

--BPOAKSSZa9mWyF2fIXh4F0jTxfqXeItaL
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 8/11/20 9:34 PM, Eric Dumazet wrote:
> We must accept an empty mask in store_rps_map(), or we are not able
> to disable RPS on a queue.
>
> Fixes: 07bbecb34106 ("net: Restrict receive packets queuing to housekeepi=
ng CPUs")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Maciej =C5=BBenczykowski <maze@google.com>
> Cc: Alex Belits <abelits@marvell.com>
> Cc: Nitesh Narayan Lal <nitesh@redhat.com>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  net/core/net-sysfs.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index 9de33b594ff2693c054022a42703c90084122444..efec66fa78b70b2fe5b0a5920=
317eb1d0415d9e3 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -757,11 +757,13 @@ static ssize_t store_rps_map(struct netdev_rx_queue=
 *queue,
>  =09=09return err;
>  =09}
> =20
> -=09hk_flags =3D HK_FLAG_DOMAIN | HK_FLAG_WQ;
> -=09cpumask_and(mask, mask, housekeeping_cpumask(hk_flags));
> -=09if (cpumask_empty(mask)) {
> -=09=09free_cpumask_var(mask);
> -=09=09return -EINVAL;
> +=09if (!cpumask_empty(mask)) {
> +=09=09hk_flags =3D HK_FLAG_DOMAIN | HK_FLAG_WQ;
> +=09=09cpumask_and(mask, mask, housekeeping_cpumask(hk_flags));
> +=09=09if (cpumask_empty(mask)) {
> +=09=09=09free_cpumask_var(mask);
> +=09=09=09return -EINVAL;
> +=09=09}
>  =09}
> =20
>  =09map =3D kzalloc(max_t(unsigned int,

Ah! my bad.
Thanks for the fix.

Acked-by: Nitesh Narayan Lal <nitesh@redhat.com>


--BPOAKSSZa9mWyF2fIXh4F0jTxfqXeItaL--

--VhxJelrm2oQHV6KKW7FPr4CLjEIoPM03G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl8z5l0ACgkQo4ZA3AYy
ozkylQ/9FLnKgVtmjpDHCmf+SihtZH6I+NuJHbnUvDyAxDHqclyGsAF/rVlGHVxt
hQ1EXyPN24BWOrR75AIj2/EYPFbsqz0ss5qh7lYiHJE6kHNCg0JKhEqrug5gTd/8
Yk/U0M/h7G5FROJxy2DyXnlHDgxXS/zjYVcRKubb94mFiWCM9t/1VmMzXcXLH/UH
Sl21/YEdrjU0LW39cqJaSvHyE9xKOaDrBIhL4It0m9QB7o848sXK8DE7kBQ5sKXM
ESt9sZU6ZUm2ZSK3rCgzaa0bRN9bAcqxOkV9T8vINuXZ24+eBonDGEwFMa+G9+Or
lowFnltqroffV55i77Gc9a2MRLGyj7qXkf0i0XiHnhca+CYOSSjFuDIAHmchS9wi
cEm4Jq2UPEQHfuoMol/PGvm/B4PDyJ2dgKva1t9vN/JLs7vSR53Vj/gJ17393K5e
1U9DfZKucem30P+LzRN6MHJ5XoNAtBIFKj+VBX8COb097o12OFw8Ji/JuG+WSL2g
kPnpYQVGwjVOOCD62cNh/Nq4AuaSz897bFSQ+7fba4eO//LzzL9b/xGlGow/CxNW
39UbPfvq2BUBmONTnuvKneXJUsy2siptMSOgAbrm5vbHopavC57hrF1fnzrZAeP+
LMUiS5pp3NtEFjZ+MvNqH72xfDXe34wKFt1+/598aWLEG0F400Y=
=pGmN
-----END PGP SIGNATURE-----

--VhxJelrm2oQHV6KKW7FPr4CLjEIoPM03G--

