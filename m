Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4C1255A34
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 14:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbgH1McL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 08:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729376AbgH1Mb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 08:31:56 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25CAC061264;
        Fri, 28 Aug 2020 05:31:53 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598617902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TUlOgQ1Ae4acAoCoTyQ5RZNzLvp1OcaWRYPRqm2zm+0=;
        b=MDinm23RjqFHDWjquXIdL2By0xiohZ7K7A6BSr5Qj0v++Z8SYY5DsXSiJr0bjntayyY9Ep
        OLXxXyYHrF2uYQIFMT4S4X43AOw7q/5OSFTPHr1Nl+wEBAT2qHr7o8+klDhvKeuX6vII/g
        23rLljmvzjxSSmedJfpQZ0nXjfbxl3lTw6Xw7k11IrDYj8uCn/66G+xyivUnQXtSNzFbVl
        aRViVbb2vingdypwXyhcOIVE2nVkjX64RyQDG7PEjZFaj7gpTR4Rgt67omq73CEHegb1nR
        NcBv7m8b4Ba2zyrSpB7VHw3dFMqymDDJ1Cdv6xlQrTxtVbNA+VuxBS2U1N6J0w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598617902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TUlOgQ1Ae4acAoCoTyQ5RZNzLvp1OcaWRYPRqm2zm+0=;
        b=LEn1/3twlhtXTzSzQT891gPJZhOWTuiQ8IeEzhL+ZL91mJr3MOCQpk+sdvzL4wqAJpVYFq
        1fXxkYsI8HfrfnDA==
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v3 5/8] net: dsa: hellcreek: Add TAPRIO offloading support
In-Reply-To: <20200827162551.GB13292@hoboy>
References: <20200820081118.10105-1-kurt@linutronix.de> <20200820081118.10105-6-kurt@linutronix.de> <20200824225615.jtikfwyrxa7vxiq2@skbuf> <878se3133y.fsf@kurt> <20200825093830.r2zlpowtmhgwm6rz@skbuf> <871rjv123q.fsf@kurt> <20200827162551.GB13292@hoboy>
Date:   Fri, 28 Aug 2020 14:31:41 +0200
Message-ID: <875z930x5e.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Richard,

On Thu Aug 27 2020, Richard Cochran wrote:
> On Tue, Aug 25, 2020 at 11:55:37AM +0200, Kurt Kanzenbach wrote:
>>=20
>> I get your point. But how to do it? We would need a timer based on the
>> PTP clock in the switch.
>
> Can't you use an hrtimer based on CLOCK_MONOTONIC?

When the switch and the Linux machine aren't synchronized, we would
calculate the difference between both systems and could arm the Linux
timer based on CLOCK_MONOTONIC. Given the fact that we eight seconds, it
would *probably* work when the ptp offset adjustments are in that range.

>
> I would expect the driver to work based solely on the device's clock.

Understood.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl9I+S0ACgkQeSpbgcuY
8KaiQg//dbvqena9jGhjHZDELVtphJeIXHhq8fpQxNELNIkZcxfPV6Zr2sB+dzui
Ss7Nlu06lZfM8It4/oaflPh2spvdJ841VyRx38brxDhQQCRx4IAZYOjFojxJV0+8
q8j5AT6rkcUdfJA4GienyVf50t4DzEOfxlxuyDZQUXTJ08QXgmicS09huWL5D+vz
HAFqxOSO9fxM04xEeRTfQqHnnMQOlXBsTJwTVEWc1AVzcFea/3W3rrZa2pcwyxoB
NngpvX9N1oNqGXPq+Fyp/cA6CUd6Sn3ZA2L6dwz5rJcBiHN/gU1q6OopvoVuUA1q
5JidK+BlgATk45ps1vBlXp3njo/pMHpjPrrU0VaD7N09Jq+R/D/9K5cibJSBxbva
DuXOGIWJw+6QoXBW/75tKmVtdgNk5Gf9+PRdWlD3t++4Oof1tptVgOBhU/cnXH8X
W+sA22oD1RdRf//lrG3wdwY4yXfzbA98oWEOLlN78Vx3/wZ2gFiaVMVEiJNfndTQ
1PUjYpLilbURkg65o9CRk0cNQ8+nZaDbtbm+ygRh7RtufWeIz1Ozi3V1xP06Uv4T
1tFdJTKSLzdLgbRIt7m9av1K/9rw+Aj4JzcTa2AcRC0SzpYgJhHlykXqZwAiY00W
m9sofpfiaa7dKsG42l4K0rk3sI54zhjiwLuJXSEKZi6gDaVfoRE=
=Z7BZ
-----END PGP SIGNATURE-----
--=-=-=--
