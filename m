Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E86A25433D
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 12:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbgH0KMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 06:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728523AbgH0KMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 06:12:38 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFD3C061264;
        Thu, 27 Aug 2020 03:12:38 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598523151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TylHLzYobByIM/E/ha4ZGNETDJPDDGQ31gNBIO1Nims=;
        b=2ANz293EXHRZf+hOSNPOpA+xqKlaBemYHCWXnXRHQtEApefVdeotdbukovXsc1dcJNN7yS
        EGy8Ij/V/HcN48GhbZPPChEZo7PhgAkyhr9udT/k2URYu0HzMSyhIBlJ2jYmm9spgIkp3D
        Gnc1Si+9rJc+9W7NDeSV/DvOk8lNASFZdoHLEnlO6gFDz6zuXx8rSwKN1JyHUpjEVqZPIu
        dyRtsOMtMcwOaEDH1q8dhWxQBh2JW+/Uy7NXAhPx5OWnYyEg3Rto89txcVOzc8CFveTDZQ
        3vBbn7eC+RHySWT2ngQSkR/E79FyyTJb06cNKdvSumymweSve0ezyDLXL/pjCA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598523151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TylHLzYobByIM/E/ha4ZGNETDJPDDGQ31gNBIO1Nims=;
        b=8gB+5a03RZ1bDn3um/eccY3cTlQQlyFougrd//k26fxUjW8BPXTxOlTu7at199j5WBJ1GL
        XyejErM+cEwslMCg==
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v3 5/8] net: dsa: hellcreek: Add TAPRIO offloading support
In-Reply-To: <878se2txp0.fsf@intel.com>
References: <20200820081118.10105-1-kurt@linutronix.de> <20200820081118.10105-6-kurt@linutronix.de> <20200822143922.frjtog4mcyaegtyg@skbuf> <87imd8zi8z.fsf@kurt> <87y2m3txox.fsf@intel.com> <875z9712qd.fsf@kurt> <878se2txp0.fsf@intel.com>
Date:   Thu, 27 Aug 2020 12:12:29 +0200
Message-ID: <87zh6gcs8i.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Vinicius,

On Tue Aug 25 2020, Vinicius Costa Gomes wrote:
> Hi Kurt,
>
> Kurt Kanzenbach <kurt@linutronix.de> writes:
>
>> I think so. As Vladimir pointed out, the driver should setup an identity
>> mapping which I already did by default.
>>
>> Can you point me your patch?
>
> Just sent it for consideration:
>
> http://patchwork.ozlabs.org/project/netdev/patch/20200825174404.2727633-1-vinicius.gomes@intel.com/

Thank you. That looks good. So the driver just has to deal with queues
and I can setup an identity mapping in the hellcreek code.

I see the patch is already merged, otherwise I'd have acked it.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl9Hhw0ACgkQeSpbgcuY
8KZxlQ//VnPK/fJDCN6AoLIuOxTPO4KJyOCEw2Z/APHbpN4kCgW5emjqfrFRE7EW
Ef8aYVtZnNW/0RNeCED6rzVn7yHm3QJnhazhs9CElWA2OyBGQJnDU6Kc/DYXom9R
QyYTq3WECDooq7F6Dfwf11Cc2FxXrUOrXlSrfcAZudW7IhCEbpW8D2L7cXy3gPrc
PyK36LXC7Vnr7D6Tlus5blG1MgfpDYF+iGebwpx1VVYePAqAXBOxr9NaRugWSnUH
luwSNhiG+uzEYVSOd5qtb2j8yGrvbHHtELIqMoSkMWCaPg5LVJtqcLZBrTq4IWSb
IF0mXJAeA1nrEWoe7qpesK7rrO1XLc2sU25MaCDXwlZUpzdmjp51nB5m9POSXNaK
/zzuWCqwEc6acXY77kL13nfBWB4gmjdRNFi9ot6O/jxGkRR9KHYlVxl2z5etuK6J
/12Sp4RNpCiAULgfnEDwVifPd1duV1M5QMxTk8pZpkBVG+QBA6uBI78adY1gpZ2/
XuQxsOtv1t9ViZ09uxHk8Aoi1CAcJmWCS6Vj04FLx3dkiaYNd6qn13ktiaxs1uWz
DMdorPlf0zTAEEhVeoNQNbgwesM5t9Bcn5+8/KaqRf+8Qd1FeHJn8GBLHBHZlW+p
H6RLoPk7PHMezKX7xYc5kgO3XHyJ7+oCpKVtLjhslH2eVZeH2qA=
=qWWN
-----END PGP SIGNATURE-----
--=-=-=--
