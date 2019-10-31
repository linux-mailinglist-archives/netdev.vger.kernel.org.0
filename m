Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2BA3EB554
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 17:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbfJaQti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 12:49:38 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:5478 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727715AbfJaQth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 12:49:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1572540576; x=1604076576;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rAYIgEe8GJJx1KYsTHHUxy+1Q0hG5RMpa/W0rU60q10=;
  b=dwopr+kzI1afhOl1VPgeWgwlGWPHjGopRJu9BUKMloQpXl1Y6oCamhrz
   RYbDf1RMWxXSWZseffUdypSgIfd9CJTlwuK7l//99hW325mSnyDCKRJgj
   H7kTzpVpIf65mJDylOUNDV4z1l5RKKl06r/GFJMyQK2+PR7u2xaUeRoEe
   w=;
IronPort-SDR: F/XRfC61yGhb3qlaD74g/p8Q3HYPD+UKw2N3ThW1eo3mZpd0VvVtIqMKWKpwWOsPvRpuEkgMSC
 38J1kxcXzwfg==
X-IronPort-AV: E=Sophos;i="5.68,252,1569283200"; 
   d="scan'208";a="1445137"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-e7be2041.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 31 Oct 2019 16:49:36 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-e7be2041.us-west-2.amazon.com (Postfix) with ESMTPS id 6F785A1E32;
        Thu, 31 Oct 2019 16:49:35 +0000 (UTC)
Received: from EX13D08EUB004.ant.amazon.com (10.43.166.158) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 31 Oct 2019 16:49:34 +0000
Received: from EX13D11EUB003.ant.amazon.com (10.43.166.58) by
 EX13D08EUB004.ant.amazon.com (10.43.166.158) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 31 Oct 2019 16:49:34 +0000
Received: from EX13D11EUB003.ant.amazon.com ([10.43.166.58]) by
 EX13D11EUB003.ant.amazon.com ([10.43.166.58]) with mapi id 15.00.1367.000;
 Thu, 31 Oct 2019 16:49:33 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     "Jubran, Samih" <sameehj@amazon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Woodhouse, David" <dwmw@amazon.co.uk>,
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
        "Kiyanovski, Arthur" <akiyano@amazon.com>
Subject: RE: [RFC V2 net-next v2 0/3] Introduce XDP to ena
Thread-Topic: [RFC V2 net-next v2 0/3] Introduce XDP to ena
Thread-Index: AQHVkAk+umigFoppI0SI91cuFMkOg6d09fjQ
Date:   Thu, 31 Oct 2019 16:49:33 +0000
Message-ID: <9417aed7a7cb43758646f430fb6dcb29@EX13D11EUB003.ant.amazon.com>
References: <20191031163539.12539-1-sameehj@amazon.com>
In-Reply-To: <20191031163539.12539-1-sameehj@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This was resent by mistake, please ignore.

> -----Original Message-----
> From: sameehj@amazon.com <sameehj@amazon.com>
> Sent: Thursday, October 31, 2019 6:36 PM
> To: davem@davemloft.net; netdev@vger.kernel.org
> Cc: Jubran, Samih <sameehj@amazon.com>; Woodhouse, David
> <dwmw@amazon.co.uk>; Machulsky, Zorik <zorik@amazon.com>;
> Matushevsky, Alexander <matua@amazon.com>; Bshara, Saeed
> <saeedb@amazon.com>; Wilson, Matt <msw@amazon.com>; Liguori,
> Anthony <aliguori@amazon.com>; Bshara, Nafea <nafea@amazon.com>;
> Tzalik, Guy <gtzalik@amazon.com>; Belgazal, Netanel
> <netanel@amazon.com>; Saidi, Ali <alisaidi@amazon.com>; Herrenschmidt,
> Benjamin <benh@amazon.com>; Kiyanovski, Arthur
> <akiyano@amazon.com>
> Subject: [RFC V2 net-next v2 0/3] Introduce XDP to ena
>=20
> From: Sameeh Jubran <sameehj@amazon.com>
>=20
> This patchset includes 3 patches:
> * XDP_DROP implementation
> * XDP_TX implementation
> * A fix for an issue which might occur due to the XDP_TX patch. I see fit
>   to place it as a standalone patch for clarity.
>=20
> Difference from RFC v1 (XDP_DROP patch):
> * Initialized xdp.rxq pointer
> * Updated max_mtu on attachment of xdp and removed the check from
>   ena_change_mtu()
> * Moved the xdp execution from ena_rx_skb() to ena_clean_rx_irq()
> * Moved xdp buff (struct xdp_buff) from rx_ring to the local stack
> * Started using netlink's extack mechanism to deliver error messages to
>   the user
>=20
> Sameeh Jubran (3):
>   net: ena: implement XDP drop support
>   net: ena: Implement XDP_TX action
>   net: ena: Add first_interrupt field to napi struct
>=20
>  drivers/net/ethernet/amazon/ena/ena_ethtool.c |   4 +-
>  drivers/net/ethernet/amazon/ena/ena_netdev.c  | 839
> ++++++++++++++++--  drivers/net/ethernet/amazon/ena/ena_netdev.h  |
> 70 ++
>  3 files changed, 815 insertions(+), 98 deletions(-)
>=20
> --
> 2.17.1

