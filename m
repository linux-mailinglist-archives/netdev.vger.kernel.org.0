Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D55249E2E
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 14:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgHSMh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 08:37:59 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:26534 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728204AbgHSMh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 08:37:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597840675; x=1629376675;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=vMyjjK5GpxUkh/BkWlb69XCrLX8C5jQw3Xl/XCD2C+A=;
  b=KyjF003AWzVolWa2ACQR6mgUTQ3wqz5OSnml4W31JLFV6e6Din4vFj/6
   QpRWJoY6pxrAr7VvnzmUGZEkctV3bt67BqV9yIFkqE28IDUd3Z0Ey+8tK
   /nbWiM7mAjuXJ6VPoRWHBJKRdTmX9rKJpf35H6pdz69FlXxu1oVva52of
   0=;
X-IronPort-AV: E=Sophos;i="5.76,331,1592870400"; 
   d="scan'208";a="69160532"
Subject: RE: [PATCH V1 net-next 1/3] net: ena: ethtool: Add new device statistics
Thread-Topic: [PATCH V1 net-next 1/3] net: ena: ethtool: Add new device statistics
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 19 Aug 2020 12:37:42 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id EE7AFA2415;
        Wed, 19 Aug 2020 12:37:40 +0000 (UTC)
Received: from EX13D04EUB004.ant.amazon.com (10.43.166.59) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 12:37:40 +0000
Received: from EX13D11EUB002.ant.amazon.com (10.43.166.13) by
 EX13D04EUB004.ant.amazon.com (10.43.166.59) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 12:37:39 +0000
Received: from EX13D11EUB002.ant.amazon.com ([10.43.166.13]) by
 EX13D11EUB002.ant.amazon.com ([10.43.166.13]) with mapi id 15.00.1497.006;
 Wed, 19 Aug 2020 12:37:39 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>
Thread-Index: AQHWaA8PdWMyvxlF2ESnQPypO1dpgakm99wAgBhgdSA=
Date:   Wed, 19 Aug 2020 12:37:21 +0000
Deferred-Delivery: Wed, 19 Aug 2020 12:35:53 +0000
Message-ID: <86e83120b1224a94a0ce2cecec7a441c@EX13D11EUB002.ant.amazon.com>
References: <20200801142130.6537-1-sameehj@amazon.com>
        <20200801142130.6537-2-sameehj@amazon.com>
 <20200803151818.5a2e5616@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200803151818.5a2e5616@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.118]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, August 4, 2020 1:18 AM
> To: Jubran, Samih <sameehj@amazon.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; Woodhouse, David
> <dwmw@amazon.co.uk>; Machulsky, Zorik <zorik@amazon.com>;
> Matushevsky, Alexander <matua@amazon.com>; Bshara, Saeed
> <saeedb@amazon.com>; Wilson, Matt <msw@amazon.com>; Liguori,
> Anthony <aliguori@amazon.com>; Bshara, Nafea <nafea@amazon.com>;
> Tzalik, Guy <gtzalik@amazon.com>; Belgazal, Netanel
> <netanel@amazon.com>; Saidi, Ali <alisaidi@amazon.com>; Herrenschmidt,
> Benjamin <benh@amazon.com>; Kiyanovski, Arthur
> <akiyano@amazon.com>; Dagan, Noam <ndagan@amazon.com>
> Subject: RE: [EXTERNAL] [PATCH V1 net-next 1/3] net: ena: ethtool: Add ne=
w
> device statistics
>=20
> CAUTION: This email originated from outside of the organization. Do not c=
lick
> links or open attachments unless you can confirm the sender and know the
> content is safe.
>=20
>=20
>=20
> On Sat, 1 Aug 2020 14:21:28 +0000 sameehj@amazon.com wrote:
> > +     if (eni_stats_needed) {
> > +             ena_update_hw_stats(adapter);
> > +             for (i =3D 0; i < ENA_STATS_ARRAY_ENI(adapter); i++) {
> > +                     ena_stats =3D &ena_stats_eni_strings[i];
> > +
> > +                     ptr =3D (u64 *)((uintptr_t)&adapter->eni_stats +
> > +                             (uintptr_t)ena_stats->stat_offset);
>=20
> In the kernel unsigned long is the type for doing maths on pointers.
Ack, will fix in V2.
>=20
> > +                     ena_safe_update_stat(ptr, data++, &adapter->syncp=
);
> > +             }
> > +     }
> > +
> >       ena_queue_stats(adapter, &data);
> >       ena_dev_admin_queue_stats(adapter, &data);  }
> >
> > +static void ena_get_ethtool_stats(struct net_device *netdev,
> > +                               struct ethtool_stats *stats,
> > +                               u64 *data) {
> > +     struct ena_adapter *adapter =3D netdev_priv(netdev);
> > +
> > +     ena_get_stats(adapter, data, adapter->eni_stats_supported); }
>=20
> Why the indirections? You always pass adapter->eni_stats_supported as a
> parameter, why not just use it directly?

please note that ena_dump_stats_ex(), ena_get_strings() and ena_get_stats()
are called with the parameter set to false. This is done to avoid sending a=
n admin command, which sleeps, during the execution
of this function.
This function is called from the timer interrupt handler, which is an atomi=
c context, and we want to avoid sleeping during
such context.
>=20
> Other than the two nits, the set LGTM.
