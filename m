Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E90FDCBF1B
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 17:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389630AbfJDP1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 11:27:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37524 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389559AbfJDP1a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 11:27:30 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 63B8E90916
        for <netdev@vger.kernel.org>; Fri,  4 Oct 2019 15:27:29 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id k9so2813423wmb.0
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 08:27:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6hCmHIb50qdbxFpZeHYQlO48b2olEtbuVMQIwTxxhQY=;
        b=pLafg0s2oVl0LkDJCyyuVBFJEceqoYupNhMKSdmXCXjZZlmK6EdC+W6Ko8CDIcnz7d
         BXgLlJW784MRymvtAXSv2LkcW/auU7Y5++iCNcM7r7DrwIZ/zrALPkDRgRyy5GS3Gule
         eyCLkgwuPTGLpa5psZTNOhFO70W/Iaph0astPt+F2N3WfaIDoYTBV5MwNGoPOSvb0ijw
         zJi8jchxm+fTdElB5gwIfg7ZVk47/Eq/kuqh6PYzHtoardMcyclH4UNa2FueVml2410R
         +o+zRDP6Nj/PxTBZIMptx7MZxVBgMNaW/p7LmecObi9fYSgxBqCKnWQSJneUn1YiB9m9
         IItQ==
X-Gm-Message-State: APjAAAXhfwnQ3GwA+r4avdLbCd1gJFBVco1xSIbUawTjtTcnOTAGem0Q
        LlQaw01OCI92h8RgACRVEIei9tq2WzUaWk/En9HiVavBzAS8g5e+ERa7X8JoEismUEfhXKdXyEG
        Y6rHBUKKfS7U1STAs
X-Received: by 2002:a05:600c:2049:: with SMTP id p9mr11214104wmg.30.1570202848042;
        Fri, 04 Oct 2019 08:27:28 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwJRg0O1FVeXwPYFHsMf3JiAh5XG9Yv+SrNG456l1Rklngd5o7JfyQlTXMelm7yipfYMiN//A==
X-Received: by 2002:a05:600c:2049:: with SMTP id p9mr11214088wmg.30.1570202847717;
        Fri, 04 Oct 2019 08:27:27 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id w4sm7699917wrv.66.2019.10.04.08.27.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 08:27:26 -0700 (PDT)
Date:   Fri, 4 Oct 2019 17:27:24 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        lbianconi@redhat.com, xmu@redhat.com
Subject: Re: [PATCH net] net: ipv4: avoid mixed n_redirects and rate_tokens
 usage
Message-ID: <20191004152724.GA14948@localhost.localdomain>
References: <25ac83a5c5660b43a27712d692266cd97668a2e4.1570194598.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <25ac83a5c5660b43a27712d692266cd97668a2e4.1570194598.git.pabeni@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Since commit c09551c6ff7f ("net: ipv4: use a dedicated counter
> for icmp_v4 redirect packets") we use 'n_redirects' to account
> for redirect packets, but we still use 'rate_tokens' to compute
> the redirect packets exponential backoff.
>=20
> If the device sent to the relevant peer any ICMP error packet
> after sending a redirect, it will also update 'rate_token' according
> to the leaking bucket schema; typically 'rate_token' will raise
> above BITS_PER_LONG and the redirect packets backoff algorithm
> will produce undefined behavior.
>=20
> Fix the issue using 'n_redirects' to compute the exponential backoff
> in ip_rt_send_redirect().
>=20
> Note that we still clear rate_tokens after a redirect silence period,
> to avoid changing an established behaviour.
>=20
> The root cause predates git history; before the mentioned commit in
> the critical scenario, the kernel stopped sending redirects, after
> the mentioned commit the behavior more randomic.
>=20
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Fixes: c09551c6ff7f ("net: ipv4: use a dedicated counter for icmp_v4 redi=
rect packets")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

> ---
>  net/ipv4/route.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 7dcce724c78b..14654876127e 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -916,16 +916,15 @@ void ip_rt_send_redirect(struct sk_buff *skb)
>  	if (peer->rate_tokens =3D=3D 0 ||
>  	    time_after(jiffies,
>  		       (peer->rate_last +
> -			(ip_rt_redirect_load << peer->rate_tokens)))) {
> +			(ip_rt_redirect_load << peer->n_redirects)))) {
>  		__be32 gw =3D rt_nexthop(rt, ip_hdr(skb)->daddr);
> =20
>  		icmp_send(skb, ICMP_REDIRECT, ICMP_REDIR_HOST, gw);
>  		peer->rate_last =3D jiffies;
> -		++peer->rate_tokens;
>  		++peer->n_redirects;
>  #ifdef CONFIG_IP_ROUTE_VERBOSE
>  		if (log_martians &&
> -		    peer->rate_tokens =3D=3D ip_rt_redirect_number)
> +		    peer->n_redirects =3D=3D ip_rt_redirect_number)
>  			net_warn_ratelimited("host %pI4/if%d ignores redirects for %pI4 to %p=
I4\n",
>  					     &ip_hdr(skb)->saddr, inet_iif(skb),
>  					     &ip_hdr(skb)->daddr, &gw);
> --=20
> 2.21.0
>=20

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXZdk2QAKCRA6cBh0uS2t
rHkyAP9Ld1Oqf8fFSAYJThVo1xcoVnghmk+N5gaEvXm9LHzu8gD/elIAjmtplkTO
P/I0bXFaNGIBpbd1v4TAVfn9IeVQ/Ag=
=3HVX
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
