Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD20E1518CC
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 11:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgBDK1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 05:27:37 -0500
Received: from mail.katalix.com ([3.9.82.81]:58122 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbgBDK1g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Feb 2020 05:27:36 -0500
Received: from [IPv6:2a02:8010:6359:1:f9de:51c5:a310:b61b] (unknown [IPv6:2a02:8010:6359:1:f9de:51c5:a310:b61b])
        (Authenticated sender: james)
        by mail.katalix.com (Postfix) with ESMTPSA id 898F08F822;
        Tue,  4 Feb 2020 10:27:35 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=katalix.com; s=mail;
        t=1580812055; bh=0o6QmOcMKw/rZxSgsdmiuJ1Nt+D2/4h6Zpq/EYE4t84=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Abh812nVWzhTO++tSha3YyVufWvKNBXZmutDeY2PE3QaXNkk2esSKeA9EtkQphKGT
         GMsDzi6ngocH3TyFdiNZ+3uJcsMAk8N7Fte+xb4Equins7wbtzfT9jBnQvteuOY4ZU
         hZZKIKUYgcxIA59XIqNbfG+7pTCy7vkqu2fvxGVogkxoCK6/3aXLN/meI++B8MDIUP
         uGWeUfsvm2LPMPqU8cHAALCm4KrZpfzzEZijt23VDTL+y9ozEJklJlS0M8raCkyW+C
         fb0aQWRGmkEXcVgThfSWPcwX0v4NM0mNNRk3CPSBc8QWi5dFIX2lMChwwEhbvg9803
         EWP5mSDXPAAgA==
Subject: Re: [PATCH v2 net] l2tp: Allow duplicate session creation with UDP
To:     Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>,
        netdev@vger.kernel.org
Cc:     gnault@redhat.com, tparkin@katalix.com
References: <20200203232400.28981-1-ridge.kennedy@alliedtelesis.co.nz>
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
Message-ID: <d14d7bba-c29b-7831-f976-5658e9503bf3@katalix.com>
Date:   Tue, 4 Feb 2020 10:27:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200203232400.28981-1-ridge.kennedy@alliedtelesis.co.nz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/02/2020 23:24, Ridge Kennedy wrote:
> In the past it was possible to create multiple L2TPv3 sessions with the=

> same session id as long as the sessions belonged to different tunnels.
> The resulting sessions had issues when used with IP encapsulated tunnel=
s,
> but worked fine with UDP encapsulated ones. Some applications began to
> rely on this behaviour to avoid having to negotiate unique session ids.=

>
> Some time ago a change was made to require session ids to be unique acr=
oss
> all tunnels, breaking the applications making use of this "feature".
>
> This change relaxes the duplicate session id check to allow duplicates
> if both of the colliding sessions belong to UDP encapsulated tunnels.
>
> Fixes: dbdbc73b4478 ("l2tp: fix duplicate session creation")
> Signed-off-by: Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>

Acked-by: James Chapman <jchapman@katalix.com>


> ---
>  net/l2tp/l2tp_core.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> index f82ea12bac37..425b95eb7e87 100644
> --- a/net/l2tp/l2tp_core.c
> +++ b/net/l2tp/l2tp_core.c
> @@ -322,8 +322,13 @@ int l2tp_session_register(struct l2tp_session *ses=
sion,
> =20
>  		spin_lock_bh(&pn->l2tp_session_hlist_lock);
> =20
> +		/* IP encap expects session IDs to be globally unique, while
> +		 * UDP encap doesn't.
> +		 */
>  		hlist_for_each_entry(session_walk, g_head, global_hlist)
> -			if (session_walk->session_id =3D=3D session->session_id) {
> +			if (session_walk->session_id =3D=3D session->session_id &&
> +			    (session_walk->tunnel->encap =3D=3D L2TP_ENCAPTYPE_IP ||
> +			     tunnel->encap =3D=3D L2TP_ENCAPTYPE_IP)) {
>  				err =3D -EEXIST;
>  				goto err_tlock_pnlock;
>  			}



