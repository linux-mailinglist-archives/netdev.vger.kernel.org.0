Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB3A25176F
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 13:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729958AbgHYLVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 07:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729979AbgHYLVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 07:21:36 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF452C061574;
        Tue, 25 Aug 2020 04:21:35 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598354492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nGrucTK6525pBpaxiLtxZM8yZYWGEHd+0H3dBZO4qJg=;
        b=NQINZ5RfH7FO65a1aHSHSh75mSRPV8RsQ7Zl62YhPiTL4My9tMBqYklKV9oodMjNeufuOW
        MfcL1jlC9T/FTDuQMXrUBUWhxR0w2/uFg0FY+TqBPcSfIDrhprPVgktXWznz/ihqs5aZxp
        A8TkZ+zcJSx3ghyPRfp86ORLf7ggTgZQ35MKPdJrB/rnVJ9H2b21HeP5t4Kvfh8F0hlUpf
        V46VIm95qBpdVYxYuScQgg4k67jOF076AjgYJ8nGFl7g9xrPSo9IHWrqRsebjHus/CGm7d
        IV2YXs3qn11JvbNJk27/Sujt5YGIdkA0JFIJS/ZspRkDBZsFU2o+5GbI+Bwx5g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598354492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nGrucTK6525pBpaxiLtxZM8yZYWGEHd+0H3dBZO4qJg=;
        b=4+WhodGiRzkVRO0VTFVT7qkWpsmJMan999hb01hJ84lHjYIbFD6oW0Co7BQ5aqmcPpDk11
        dNzyjReygXxdzsDA==
To:     David Miller <davem@davemloft.net>, olteanv@gmail.com
Cc:     kuba@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, bigeasy@linutronix.de,
        richardcochran@gmail.com, kamil.alkhouri@hs-offenburg.de,
        ilias.apalodimas@linaro.org, ivan.khoronzhuk@linaro.org,
        vinicius.gomes@intel.com, xiaoliang.yang_1@nxp.com, Po.Liu@nxp.com
Subject: Re: [PATCH v3 0/8] Hirschmann Hellcreek DSA driver
In-Reply-To: <20200824.153518.700546598086140133.davem@davemloft.net>
References: <20200820081118.10105-1-kurt@linutronix.de> <20200824143110.43f4619f@kicinski-fedora-PC1C0HJN> <20200824220203.atjmjrydq4qyt33x@skbuf> <20200824.153518.700546598086140133.davem@davemloft.net>
Date:   Tue, 25 Aug 2020 13:21:30 +0200
Message-ID: <87sgcbynr9.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Mon Aug 24 2020, David Miller wrote:
> Agreed, Kurt can you repost this series without the TAPRIO support for
> now since it's controversial and needs more discussion and changes?

OK. It seems like the TAPRIO implementation has to be discussed more and
it might be good to do that separately.

I'll replace the spinlocks (which were only introduced for the hrtimers)
with mutexes and post a sane version of the driver without the TAPRIO
support.

>
> Thank you.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl9E9DoACgkQeSpbgcuY
8KbFjhAAga1JgZ6IRftUgmWMjZCHAq7TMBpRzGySx2owt5cV6CephpKsjs3jccmW
wM2kubrqvX5nSgRNET5F6oqoU3WkTqxdIXJ/M+/mTdCMXgH2aN0ColKn/1Nj+xPP
JUxZVVF0oJGjUcpT9jMf01/ZN/XV8BbhRV6ZI+c1r+tyI5X0cTPSUkk6/PV8Nz8T
FsJIlxpQmM1b1oYrayVVI1Yy0uXhV65m5W39cuci0snp5/8F8exAKzn3t7dApGXU
DFSzaiDA8QYiEhSBcgFjDJ06o3Ioq6xwdelfhjmxic2az7KDXNgiGc/Ik4W2e2cW
cIuCY0MTX+d4J5OxN/eAGTQaub4Ggu0qyZbiOR7QBQWHqOIxGKaiLobL0KALehzr
ReUDSYHdKJL2QAAkk27Jm2Ee5zHCQjTcxC88PbIRkeG28ufeZNqLPjekDFTlAfY7
F4KIyeA1iqvZQ64qrKec1i1ldVYLO3GGfpMqbIhi8euor9OK1NuCdF9JvsGi6v+W
5zDy8sis0EKx+eGQUR3GZu2dbbo+c89RD/DE35CBRSsF5VAUu28EV3qI/XBqM5Hh
s5Su8CL1ZhF9mb2gwfNDa+POxOnyNHyd+P8Qnj4N5JOBofWpAX4HZIU7nQDmY8TA
GXXt8K8DxIuNQYf4RYUJWITtsD/0ekoE6XUGhXaIoYlQ0msrhBM=
=iSfE
-----END PGP SIGNATURE-----
--=-=-=--
