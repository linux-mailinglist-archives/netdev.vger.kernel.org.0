Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6FAC664475
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 16:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238693AbjAJPVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 10:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbjAJPVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 10:21:05 -0500
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8DC140D2
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 07:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673364063; x=1704900063;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kNlT6MjxnelHdlfEtzK7r9Mr23aFnseXUfFufjlHyWw=;
  b=X7ZtGN4VXIR1g64fERHyqrNDSkq1ogSCXzkfwMMyyovjmS0poq+39iBo
   /0HMrwyJokpHX/i2ra+M5GZxE34E+mS0yKGMnRR/w5Z0NR6UNOySRpHFf
   W/0IN+DNR5i+L1uHVaSoMGoWjquuR0uJGLxPsEjDUBgYwtKoFxXbvSIzL
   4=;
X-IronPort-AV: E=Sophos;i="5.96,315,1665446400"; 
   d="scan'208";a="1091100637"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-e7094f15.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 15:20:57 +0000
Received: from EX13D48EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-e7094f15.us-west-2.amazon.com (Postfix) with ESMTPS id 06F4641796;
        Tue, 10 Jan 2023 15:20:56 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX13D48EUB003.ant.amazon.com (10.43.166.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 10 Jan 2023 15:20:55 +0000
Received: from EX19D047EUB004.ant.amazon.com (10.252.61.5) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.7; Tue, 10 Jan 2023 15:20:55 +0000
Received: from EX19D047EUB004.ant.amazon.com ([fe80::e4ef:7b7e:20b2:9c20]) by
 EX19D047EUB004.ant.amazon.com ([fe80::e4ef:7b7e:20b2:9c20%3]) with mapi id
 15.02.1118.020; Tue, 10 Jan 2023 15:20:55 +0000
From:   "Arinzon, David" <darinzon@amazon.com>
To:     "Iwashima, Kuniyuki" <kuniyu@amazon.co.jp>
CC:     "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Abboud, Osama" <osamaabb@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>
Subject: RE: [PATCH V1 net-next 5/5] net: ena: Add devlink documentation
Thread-Topic: [PATCH V1 net-next 5/5] net: ena: Add devlink documentation
Thread-Index: AQHZI++t68mEJLVeVUqOAdNiiooy+a6XxXdg
Date:   Tue, 10 Jan 2023 15:20:55 +0000
Message-ID: <a5032fe447a044c08135814aa906ae70@amazon.com>
References: <20230108103533.10104-6-darinzon@amazon.com>
 <20230109060015.30921-1-kuniyu@amazon.com>
In-Reply-To: <20230109060015.30921-1-kuniyu@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.85.143.173]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-10.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good catch! Thanks.
This will be addressed in the next version of the patchset.

> -----Original Message-----
> From: Iwashima, Kuniyuki <kuniyu@amazon.co.jp>
> Sent: Monday, January 9, 2023 8:00 AM
> To: Arinzon, David <darinzon@amazon.com>
> Cc: Kiyanovski, Arthur <akiyano@amazon.com>; Saidi, Ali
> <alisaidi@amazon.com>; davem@davemloft.net; Itzko, Shahar
> <itzko@amazon.com>; kuba@kernel.org; Matushevsky, Alexander
> <matua@amazon.com>; Bshara, Nafea <nafea@amazon.com>; Dagan,
> Noam <ndagan@amazon.com>; netdev@vger.kernel.org; Abboud, Osama
> <osamaabb@amazon.com>; Bshara, Saeed <saeedb@amazon.com>;
> Agroskin, Shay <shayagr@amazon.com>; Machulsky, Zorik
> <zorik@amazon.com>; Iwashima, Kuniyuki <kuniyu@amazon.co.jp>
> Subject: Re: [PATCH V1 net-next 5/5] net: ena: Add devlink documentation
>=20
> From:   David Arinzon <darinzon@amazon.com>
> Date:   Sun, 8 Jan 2023 10:35:33 +0000
> > Update the documentation with a devlink section, the added files, as
> > well as large LLQ enablement.
> >
> > Signed-off-by: Shay Agroskin <shayagr@amazon.com>
> > Signed-off-by: David Arinzon <darinzon@amazon.com>
> > ---
> >  .../device_drivers/ethernet/amazon/ena.rst    | 30
> +++++++++++++++++++
>=20
> Each driver's devlink doc exists under Documentation/networking/devlink/
> and linked from index.html there.
>=20
> We should duplicate this doc under Documentation/networking/devlink/
> or link from the index.html ?
>=20
>=20
> >  1 file changed, 30 insertions(+)
> >
> > diff --git
> > a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> > b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> > index 8bcb173e0353..1229732a8c91 100644
> > ---
> a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> > +++
> b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> > @@ -53,6 +53,7 @@ ena_common_defs.h   Common definitions for
> ena_com layer.
> >  ena_regs_defs.h     Definition of ENA PCI memory-mapped (MMIO)
> registers.
> >  ena_netdev.[ch]     Main Linux kernel driver.
> >  ena_ethtool.c       ethtool callbacks.
> > +ena_devlink.[ch]    devlink files (see `devlink support`_ for more inf=
o)
> >  ena_pci_id_tbl.h    Supported device IDs.
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> >
> > @@ -253,6 +254,35 @@ RSS
> >  - The user can provide a hash key, hash function, and configure the
> >    indirection table through `ethtool(8)`.
> >
> > +.. _`devlink support`:
> > +DEVLINK SUPPORT
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +.. _`devlink`:
> >
> +https://www.kernel.org/doc/html/latest/networking/devlink/index.html
> > +
> > +`devlink`_ supports toggling LLQ entry size between the default 128
> > +bytes and 256 bytes.
> > +A 128 bytes entry size allows for a maximum of 96 bytes of packet
> > +header size which sometimes is not enough (e.g. when using tunneling).
> > +Increasing LLQ entry size to 256 bytes, allows a maximum header size
> > +of 224 bytes. This comes with the penalty of reducing the number of
> > +LLQ entries in the TX queue by 2 (i.e. from 1024 to 512).
> > +
> > +The entry size can be toggled by enabling/disabling the
> > +large_llq_header devlink param and reloading the driver to make it tak=
e
> effect, e.g.
> > +
> > +.. code-block:: shell
> > +
> > +  sudo devlink dev param set pci/0000:00:06.0 name large_llq_header
> > + value true cmode driverinit  sudo devlink dev reload
> > + pci/0000:00:06.0
> > +
> > +One way to verify that the TX queue entry size has indeed increased
> > +is to check that the maximum TX queue depth is 512. This can be
> > +checked, for example, by
> > +using:
> > +
> > +.. code-block:: shell
> > +
> > +  ethtool -g [interface]
> > +
> >  DATA PATH
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > --
> > 2.38.1
