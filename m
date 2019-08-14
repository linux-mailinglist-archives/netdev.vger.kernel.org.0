Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C56E8D6CB
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 17:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbfHNPBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 11:01:47 -0400
Received: from de-out1.bosch-org.com ([139.15.230.186]:57302 "EHLO
        de-out1.bosch-org.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbfHNPBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 11:01:47 -0400
Received: from si0vm1947.rbesz01.com (unknown [139.15.230.188])
        by fe0vms0187.rbdmz01.com (Postfix) with ESMTPS id 467t8S6s0yz1XLDR1;
        Wed, 14 Aug 2019 17:01:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=escrypt.com;
        s=key1-intmail; t=1565794905;
        bh=tr1+zuR17b0O+ok/Vwxp++E35xoAd0xPOQql34gtAW8=; l=10;
        h=From:Subject:From:Reply-To:Sender;
        b=vnBMzSqpHfVIih4mg50ewOvQ7HHp+rj6Ie26N+7nJNgB8i+K+sg633vwz7Nks454R
         r+VIGb9drj6+FqUX+loq1qzViwkgC/icpSBfGNzRWTqR24bDmSAMnNh8X7ZwwIaY8D
         n0XVQiZ1dW3EaOErq1LEtciccnl2HusEDIlpz93g=
Received: from fe0vm1741.rbesz01.com (unknown [10.58.172.176])
        by si0vm1947.rbesz01.com (Postfix) with ESMTPS id 467t8S6Wgkz6CjQSZ;
        Wed, 14 Aug 2019 17:01:44 +0200 (CEST)
X-AuditID: 0a3aad15-9a9ff70000002236-31-5d542258c0c2
Received: from fe0vm1652.rbesz01.com ( [10.58.173.29])
        (using TLS with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by fe0vm1741.rbesz01.com (SMG Outbound) with SMTP id 38.FB.08758.852245D5; Wed, 14 Aug 2019 17:01:44 +0200 (CEST)
Received: from FE-MBX2039.de.bosch.com (fe-mbx2039.de.bosch.com [10.3.231.49])
        by fe0vm1652.rbesz01.com (Postfix) with ESMTPS id 467t8S4ng5zB0M;
        Wed, 14 Aug 2019 17:01:44 +0200 (CEST)
Received: from FE-MBX2038.de.bosch.com (10.3.231.48) by
 FE-MBX2039.de.bosch.com (10.3.231.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 14 Aug 2019 17:01:44 +0200
Received: from FE-MBX2038.de.bosch.com ([fe80::12c:f84b:4fd6:38c2]) by
 FE-MBX2038.de.bosch.com ([fe80::12c:f84b:4fd6:38c2%2]) with mapi id
 15.01.1713.008; Wed, 14 Aug 2019 17:01:44 +0200
From:   "FIXED-TERM Buecheler Konstantin (ETAS-SEC/ECT-Mu)" 
        <fixed-term.Konstantin.Buecheler@escrypt.com>
To:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Dan Murphy <dmurphy@ti.com>
Subject: can: tcan4x5x: spi bits_per_word issue on Raspberry PI
Thread-Topic: tcan4x5x: spi bits_per_word issue on Raspberry PI
Thread-Index: AdVShK+Dlg6CyEY5S5W9jARFpSiyrAAKzACw
Date:   Wed, 14 Aug 2019 15:01:44 +0000
Message-ID: <3f71bdff8f4f4fe19ad9a09be89bc73d@escrypt.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.23.200.63]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmrmkOLIzCtJLcpLzFFi42LhslorqxuhFBJr8KnJ0KL79BZWi1XfpzJb
        HFsg5sDscfzGdiaPz5vkApiiuGxSUnMyy1KL9O0SuDI6fj1lLWjirvjT3cnWwHieo4uRk0NC
        wETi04Wn7F2MXBxCAjOYJCZ1rmeDcHYzSmzpvMQK4bxllOi6OpMRpEVIYB+jxKF1ziA2m0Cm
        xMTNE5hAbBGBAokJr6azgNjMAvISN+Z/AKsXFrCXWDfjFAtEjb3E1cY77BC2kcTzKyfAelkE
        VCX2PbgLVsMrYCXRtvIxWA2jgKzEhg3nmSFmiktsevadFeJsAYkleyDiEgKiEi8f/4OKK0i8
        O7wL6gYdiQW7P7FB2NoSyxa+ZoaYLyhxcuYTlgmMorOQjJ2FpGUWkpZZSFoWMLKsYhRNSzUo
        yzU0NzHUK0pKLa4yMNRLzs/dxAiJGNEdjB9eph1iZOJgPMRoysGkJMpbPjU4VogvKT+lMiOx
        OCO+qDQntVhJinerrEWskDBcuLg0KTezuDgzP+8QowQHs5II74SLQbFCvCmJlVWpRfkQbYcY
        pTlYlMR50zn8Y4QE0hNLUrNTUwtSi2Cy1hwcShK8vxRCYoUEi1LTUyvSMnNKYNJKsryMDAwM
        QmLIMsjWMnFwHmI05uAB2q2uCDSCt7ggMbc4Mx2qXRKiXQgmitB6itGfY8LLuYuYOQ4enQck
        n4JIIZa8/LxUKXFeZWmgWQIgXRmleXDXSMnwqi8FelAUSQJh4ivGG4wcjErCvBvEgJp5gKkf
        4Q4J3u2goBOECiI0GS0B6hFYzSExr6lI4s7nIywSTeu/skhMXTmbTeLem14eiRdnTvBIdCz6
        yiNxo20jn8SNV8f5JV78u8wvce/aE36JSd+f8ktc2bpFQOLM3/PCEh1bTopJvJj3WUpi6+8n
        chJrXt6Ul/ix5oW8xPtlyxUlvjbMUJHo3t+vKfHqfq+2xL9lx3QkXpz4rSux7U+LnsSKCz16
        EvPe/TCQmLGj20iic886I4n9vf3GEhv/LzV+BQxjJmAYv7kRCArjksQSLGEMFUV4TqqBkUW2
        ZeZTjgLdMlffT4wB06a/ttvw7s9ste6GmZ9FrLmtDnDfZYyIZAzVUKg3n7htZoukxdGPmze7
        vd9jGZZoacJ+Omlq68SO9mP6F23kbO6utPfU/FZgqfBZ875mSdzuSHWlaYsfH/OMfLZ8VmPg
        nGlsV/fODQ7l/tqdcXjiDif9cnm+2y2HlViKMxINtZiLihMBaFYbzZYEAAA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi all,
>=20
> I am trying to use a tcan4550 together with a Raspberry PI 3 B. I am usin=
g the
> tcan4x5x driver from net-next.
> I always get the following error during startup.
> 	tcan4x5x spi0.0: Probe failed, err=3D-22
> 	tcan4x5x: probe of spi0.0 failed with error -22
>=20
> I realized that this happens because the Raspberry PI does only support 8=
/9 bit
> words. https://elinux.org/index.php?title=3DRPi_SPI#Supported_bits_per_wo=
rd
> In the driver it is set to 32.
> 	spi->bits_per_word =3D 32;
>=20
> Setting this to 8 does not help of course since the tcan chip expects a m=
ultiple of
> 32 per spi transaction.
> I don't know if this is a Raspberry Pi specific problem or if there are m=
ore devices
> with this hardware limitation.
>=20
> Does anyone have a workaround for that?

It seems to be enough to just change the bits_per_word value to 8

>=20
> If this a common issue it might be a good idea to patch the driver. I wil=
l check if I
> can find proper a way to do so.
>=20
> Regards,
> Konstantin

Now I have another really confusing problem. Anything I write to SPI is wri=
tten little endian. The tcan chip expects big endian.=20
Anything I read from SPI is treated as little endian but is big endian. Doe=
s anyone know why this happens?=20
Is there a flag or something I can set for the SPI device/wire to fix this?

Regards,
Konstantin
