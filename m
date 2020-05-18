Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953871D7400
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 11:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgERJ2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 05:28:32 -0400
Received: from sauhun.de ([88.99.104.3]:39068 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbgERJ2c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 05:28:32 -0400
Received: from localhost (p5486cdc1.dip0.t-ipconnect.de [84.134.205.193])
        by pokefinder.org (Postfix) with ESMTPSA id C706E2C1FDC;
        Mon, 18 May 2020 11:28:28 +0200 (CEST)
Date:   Mon, 18 May 2020 11:28:28 +0200
From:   Wolfram Sang <wsa@the-dreams.de>
To:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-ide@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 17/17] ARM: dts: r8a7742: Add RWDT node
Message-ID: <20200518092827.GB3268@ninjato>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-18-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20200517210837.GL1370@kunai>
 <CA+V-a8t1yJF=2+N+g=doVgFpZmtiRaZX-d_1=KGuWa3zYv9uPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="LpQ9ahxlCli8rRTG"
Content-Disposition: inline
In-Reply-To: <CA+V-a8t1yJF=2+N+g=doVgFpZmtiRaZX-d_1=KGuWa3zYv9uPw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> Its similar to as seen on Rcar-H2 where just the A15 cores are up and
> A7 cores fail to boot. Attached is the boot log where reboot works as
> expected with all A15 core up. Although I have tested the internal
> release based on 3.10 where all the cores are up which used bootarg
> apmu=multicluster (https://patchwork.kernel.org/patch/3948791/). So
> there is some work involved to get all the A7's up and running.

Sounds good enough to me. Thanks for the heads up!


--LpQ9ahxlCli8rRTG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl7CVTsACgkQFA3kzBSg
KbYlIA/7BQNmIQ5iN7qAg4OoKehScI839eWqzjWfVJJjVyzhmGs5YNz6jUGOwvyK
SOin9h74J0oihkHaI8y5H3iGKNZwI/9h7BfxLyC4bjWa57n98flAWXyhFCl0zSjD
0UdNW6fTA9M6CxrE6FKrNbX6lJ5QIngcodP94l6UEweMEmFVVWM5hhAcE5px57Th
SR51V+lCc3tk2L10CHQQ3YUql07NNB/DCH5wTm/pAr2WqgXBtnLIfyuCSRqwDRvS
T+KH3DmA6wddeaFLu0TV5SutjN4Xb/Fe9/x2qHr5PKDjLlaIFv/mb4t5M90kRR0T
GpoO+dLK445whLcNWLO+Q6wD3MPGrNwdSCtl8G1g0wS0ChuUBNgk3joT3dOPx7Lz
0/rJ2xyE/zREnb11j3lXo4llQnBm/nnuzbyUqb74Dl0QUGbMUsxyCaqxkHhMf0y/
nngPExvkJ+r0AEwZ5LHcvANS6sMia2+awGcxM9gOvJDNdy1Wy/8k2NAyXqti78/l
XLKXuGY7yLek/K0qH52T7DrBnYTCNRl6DRvaArQh7XycZcYVn2aGopxq8wwCEvhw
/dvnxWkXBtLHl0Wogh1bzUS4hyPIaX66RqERFAhp71fhGSZBLJGGdGMt2oO0Va9V
eNa4h+50ew64uBoGEWPEgcCpc1jxIAiYgF/Otj7pbRtwwV2dz08=
=SuFA
-----END PGP SIGNATURE-----

--LpQ9ahxlCli8rRTG--
