Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99C6C8CFE8
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 11:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfHNJn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 05:43:26 -0400
Received: from de-out1.bosch-org.com ([139.15.230.186]:51468 "EHLO
        de-out1.bosch-org.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725265AbfHNJnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 05:43:25 -0400
Received: from fe0vm1650.rbesz01.com (unknown [139.15.230.188])
        by fe0vms0187.rbdmz01.com (Postfix) with ESMTPS id 467l56128nz1XLDQw;
        Wed, 14 Aug 2019 11:43:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=escrypt.com;
        s=key1-intmail; t=1565775802;
        bh=X0oETvpFcGplNJn3ohMC9pcbXvP9UDJwP0kLctCAZSI=; l=10;
        h=From:Subject:From:Reply-To:Sender;
        b=PN5uHHgHHbYEx9wMuyHveIFWSj/YduWyBrFtwQWpSFL2zHo03D8cw+cb5hoh10IsU
         cG7FW/2DukItewu8scVOnSY/bzWHLCLmL4/aT/PjHiX0Oh1rJnudrlETzMVbnMqPZd
         HauosnjzwnqmAwnpLKlQdKZHDsBUW9ZpXPFXcC1I=
Received: from si0vm2083.rbesz01.com (unknown [10.58.172.176])
        by fe0vm1650.rbesz01.com (Postfix) with ESMTPS id 467l560bbFz2HN;
        Wed, 14 Aug 2019 11:43:22 +0200 (CEST)
X-AuditID: 0a3aad17-dd5ff700000059bd-c9-5d53d7b9b782
Received: from fe0vm1652.rbesz01.com ( [10.58.173.29])
        (using TLS with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by si0vm2083.rbesz01.com (SMG Outbound) with SMTP id C1.35.22973.9B7D35D5; Wed, 14 Aug 2019 11:43:21 +0200 (CEST)
Received: from FE-MBX2038.de.bosch.com (fe-mbx2038.de.bosch.com [10.3.231.48])
        by fe0vm1652.rbesz01.com (Postfix) with ESMTPS id 467l55674ZzB0L;
        Wed, 14 Aug 2019 11:43:21 +0200 (CEST)
Received: from FE-MBX2038.de.bosch.com (10.3.231.48) by
 FE-MBX2038.de.bosch.com (10.3.231.48) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 14 Aug 2019 11:43:21 +0200
Received: from FE-MBX2038.de.bosch.com ([fe80::12c:f84b:4fd6:38c2]) by
 FE-MBX2038.de.bosch.com ([fe80::12c:f84b:4fd6:38c2%2]) with mapi id
 15.01.1713.008; Wed, 14 Aug 2019 11:43:21 +0200
From:   "FIXED-TERM Buecheler Konstantin (ETAS-SEC/ECT-Mu)" 
        <fixed-term.Konstantin.Buecheler@escrypt.com>
To:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Dan Murphy <dmurphy@ti.com>
Subject: can: tcan4x5x: spi bits_per_word issue on Raspberry PI
Thread-Topic: can: tcan4x5x: spi bits_per_word issue on Raspberry PI
Thread-Index: AdVShK+Dlg6CyEY5S5W9jARFpSiyrA==
Date:   Wed, 14 Aug 2019 09:43:21 +0000
Message-ID: <f1e2a3fba8604996b16e11f9405542d1@escrypt.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.23.200.63]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA21Sf0wTZxjmu/7g7HpyXKm8qyvoZWYZuK60bmlgccz9iP8soOwP96ORAw7a
        AW3XKwJmyRjZSKRjdGY4hhNRBLV0ThiIIhtZhzWyGd0wWjcjmsEGHbNEswChlN3ZYvvH/vny
        fM/7Ps/7fO8dLqI+xFW42eJg7RamgpbKxLLsr9XPnLtRYNQGx3MMzp/6JQb3fIvI4OtYlyva
        ftE/iG1/0JeWj70le6GErTDvYe3Pbi2UmZYbS22exBpfcAKrQ7OSRrQGB3ILLAyFUSOS4RTZ
        ikHnb4ewyOU8guZ9I9LI5R8EnZ1TSJBQ5PcIPq/PF7CUNMNn37owAaeQNnAFvhALWESmg//w
        3MN+BfkinGod43mc73kFPjmYGWnXwLwn+LBdTG6Cvxa/kgqYILOhd9idKGBEquH06SuiiGUq
        9P05H01NwrHhCA+kEmb+CEf5DXDvx6FohM3Qcf6+NIIzofvI36KIfzJc+nJS7ELKtjjbtjhJ
        W5ykLU7SgcRupOTM2j2VOq1Br7EXsdxebZam2FrZhyKfJfUsOn691IswHHnRczhGK4ms2gIj
        tbbIWlJrYjjTbntVBcvRKmJAbTBSikc0V1VUaeY4s9XiRYCL6BTC9ctOI0WUMLV7Wbs1IvOi
        9biYTiXK8Lx3KLKMcbDlLGtj7avVHByngXA6+YHJdraMrSk1VzhWy7SaQAkJCdS6+Er8WAxf
        40V6XM7PdjbyFgRnYyo5c1lU/nhETq2yMekYysNdM4eOivAfLrTz55RwUmKL1cKqUokzDbwX
        KahMVZZHaVRPEE918Q9UxhVijgHkRziiFcSyEETO//uxHEAMCqtLjpIxke4YryEbJNBeb4db
        D0bF0HLyoBRuzzbJwd/Quxb8gYtJMB0eT4Lb1yeTYP/8VBJcG+gn4eflKwoYWJpMA8/MzXRY
        8EynQ7D7+Eb4t671SQhMNGVCuNu3Gc6EPtJA+70FLbSedepg3/ApHYw0Neuhd6VLDyfm6nMh
        NNKzDa6d9OXBwp2xHbB0oOFt2H/kbiFM3w8xMDruLQ7wO8b4Hc/6dwg7djCO/9lxlI09TlWH
        Mj7t0Z7oyNp6aYtE15+RVx3+ZuJ1/Y1Fvbx7ZXDojfKuIs1jaU9XV11l3UHX3fWHM171vct+
        sI16SR+SeH99r+VOWvVKSvZs7qgtp+Dq8685Z3a9qRyq+d2T71iy3pyjzzUXbno/pHhZffTW
        ynfuyxsSezCG3GVMXiy+8HG5S36Z3U2LOROTlSGyc8x/DzM2mZQEAAA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I am trying to use a tcan4550 together with a Raspberry PI 3 B. I am using =
the tcan4x5x driver from net-next.=20
I always get the following error during startup.
	tcan4x5x spi0.0: Probe failed, err=3D-22
	tcan4x5x: probe of spi0.0 failed with error -22

I realized that this happens because the Raspberry PI does only support 8/9=
 bit words. https://elinux.org/index.php?title=3DRPi_SPI#Supported_bits_per=
_word
In the driver it is set to 32.
	spi->bits_per_word =3D 32;

Setting this to 8 does not help of course since the tcan chip expects a mul=
tiple of 32 per spi transaction.=20
I don't know if this is a Raspberry Pi specific problem or if there are mor=
e devices with this hardware limitation.=20

Does anyone have a workaround for that?=20

If this a common issue it might be a good idea to patch the driver. I will =
check if I can find proper a way to do so.=20

Regards,=20
Konstantin=20
