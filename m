Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233AE36B495
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 16:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhDZOP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 10:15:56 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:34356 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbhDZOPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 10:15:54 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1619446511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5B/T1CuqWPCNqs22nVrQhItaO/mUhF7UkyKIplWE5Eo=;
        b=o7XL3QKmrmP9TtPabYq7HeJ2ZuGhekW5pGsTAR9z5oOvbYhTnn24JC1pdhGdnMOe2bzd7n
        mzEKegEHZFmTT5mT/jmRLtCmQLex1wCRGAEj370KkC823NcN1rfLdatObkMy2CjZuS/1dt
        RKiO0IUe+FDVtLDLxB44Fq03sDyEuqqupOZgafnHsCg8TALS0RLQRvCJk8yo34ibwLJYCn
        ECDkzMMSqQ/qxPqR263o1ICX8bTrefIhxCsKI4yigvjYzVLE/XeihxDD5CrMaylGCnSPt6
        poWQjkoZt1AsC7U4cTusF6NzIeIRwVJdV1B0ySRUkRWqlP5W+Gmg0dIL16L9Iw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1619446511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5B/T1CuqWPCNqs22nVrQhItaO/mUhF7UkyKIplWE5Eo=;
        b=Cm/Uxjazk6FAgIQPwuiCr6l0Mb4hf4hOVf/uN7Hj/0KR4aNOEsRvAWxvIBGmgra2Dg5a5F
        ZqNn+nY+3QpDCACQ==
To:     Tyler S <tylerjstachecki@gmail.com>
Cc:     alexander.duyck@gmail.com, anthony.l.nguyen@intel.com,
        ast@kernel.org, bigeasy@linutronix.de, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        ilias.apalodimas@linaro.org, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, lorenzo@kernel.org, netdev@vger.kernel.org,
        richardcochran@gmail.com, sven.auhagen@voleatech.de,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: Re: [PATCH net v2] igb: Fix XDP with PTP enabled
In-Reply-To: <CAMfj=-YEh1ZnLB8zye7i-5Y2S015n0qat+FQ6JW7bFKwBUHBPg@mail.gmail.com>
References: <CAMfj=-YEh1ZnLB8zye7i-5Y2S015n0qat+FQ6JW7bFKwBUHBPg@mail.gmail.com>
Date:   Mon, 26 Apr 2021 16:15:08 +0200
Message-ID: <871rax9loz.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Sun Apr 25 2021, Tyler S wrote:
> Thanks for this work; I was having trouble using XDP on my I354 NIC until this.
>
> Hopefully I have not err'd backporting it to 5.10 -- but I'm seeing
> jumbo frames dropped after applying this (though as previously
> mentioned, non-skb/full driver XDP programs do now work).
>
> Looking at the code, I'm not sure why that is.

I'm also not sure, yet.

Can you try with version 3 of this patch [1] and see if there are still
issues with jumbo frames? Can you also share the backported patch for
v5.10?

Thanks,
Kurt

[1] - https://lkml.kernel.org/netdev/20210422052617.17267-1-kurt@linutronix.de/

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmCGyuwACgkQeSpbgcuY
8Ka3Jg/6Av5nptVlgBmPCzHPNjBzGI3hr3Q0WP40E4nSnXwQokkuP1Lal69/9oFF
xP9bRGuWNUSnkjh+CNOHhI/RZZCKQ9Ivu3UIHjh9hWrmPXX2o40gACTf//mgYOX2
YQLyFqE1Gzd40Nj1FkKUdcBX0jo2e8l/2fMhFARGev9z5ZtRRx1quGfDa5S7WsBz
gQqG5a/u3OvBtwknjSKsMj5Q5TapnhfhanX7a9KeElllF0fdPFAPqDt0JMZrvasR
W2w3L0gjZgui7AYNCg2SYdmbT+ZDpeOpe3CHvox25BFjm2Uu+NhVJgBisD3KQc1r
EZMzUjOyZEPxpyBoPC5LZTVqtGBAkf3dp3lA5h1tgbLtCubD7HsSuFYXPa8z9CZq
DBdft/Ig+c4GGpZ1oy11ikijeUL8RLzNhLGSJaPRoErIfS7jUmmjFwijoiVyyxOC
jY8BqFcWqDbgGtYnBjkUoUupFoo6BoQDXZWHneTC0shYyJvjVA1bCR9SzgdqBxry
JKkoSFQAK50tC7k8YQte4KhXg/JcoZpAwU9rDPD6kXfCYUKHEZUtD8unwPXbj8gO
euwA2tcn/WTe58A5GWUWQSOSLJZvsRv5eoho3yd2a+7fY8Qz1hKJYvcJiWoKt+z4
P1jJotIhyIgxXmZ8MFDfxOQomgpXhAekpFkuWBdBzO+uhBbUxAA=
=yT0P
-----END PGP SIGNATURE-----
--=-=-=--
