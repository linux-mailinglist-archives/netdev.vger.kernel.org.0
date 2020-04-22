Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0301B39C0
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgDVIN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:13:57 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:51886 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725786AbgDVIN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 04:13:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587543236; x=1619079236;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=X0ycJ+LmcOrmyVHQpF5kPha7hT4G7QkE2Mta9E1rZ4U=;
  b=XHKJfgND5S3Xwp+qCA3xnpyKcSlSHm/hcEgGTShvW+VJU0DiaGW0bKXD
   EVd8wXXpjCQc2YdDhjgVPdBbwg+M9k0m5bx2Gvc4LFAQHMavm4qwG75mF
   +AeIEQXYJrwYNkEDCmFW74GzrwwhDaJTundXI+9Rv4II2bkQWXBR0YRYz
   8=;
IronPort-SDR: dNQWW0hDysau6RVnORn2PycGcWC9fzQxmHRieEpGuTnEQRhcWZDZwpZqlaKv13kYlBZnW0XhTD
 dZ+NrNi6M8dg==
X-IronPort-AV: E=Sophos;i="5.72,412,1580774400"; 
   d="scan'208";a="27053812"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 22 Apr 2020 08:13:55 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id 027CFA1809;
        Wed, 22 Apr 2020 08:13:54 +0000 (UTC)
Received: from EX13D17EUB001.ant.amazon.com (10.43.166.85) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:13:54 +0000
Received: from EX13D11EUB003.ant.amazon.com (10.43.166.58) by
 EX13D17EUB001.ant.amazon.com (10.43.166.85) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:13:53 +0000
Received: from EX13D11EUB003.ant.amazon.com ([10.43.166.58]) by
 EX13D11EUB003.ant.amazon.com ([10.43.166.58]) with mapi id 15.00.1497.006;
 Wed, 22 Apr 2020 08:13:53 +0000
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
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>
Subject: RE: [PATCH V1 net 00/13] Enhance current features in ena driver
Thread-Topic: [PATCH V1 net 00/13] Enhance current features in ena driver
Thread-Index: AQHWGH1byd5v+WPXTkm5WFtdIYV6r6iEykqQ
Date:   Wed, 22 Apr 2020 08:13:53 +0000
Deferred-Delivery: Wed, 22 Apr 2020 08:13:22 +0000
Message-ID: <b3ef046598b64a8084beefc35705e14f@EX13D11EUB003.ant.amazon.com>
References: <20200422080923.6697-1-sameehj@amazon.com>
In-Reply-To: <20200422080923.6697-1-sameehj@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.178]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please ignore this patch series, I'll resend to net-next

> -----Original Message-----
> From: sameehj@amazon.com <sameehj@amazon.com>
> Sent: Wednesday, April 22, 2020 11:09 AM
> To: davem@davemloft.net; netdev@vger.kernel.org
> Cc: Jubran, Samih <sameehj@amazon.com>; Woodhouse, David
> <dwmw@amazon.co.uk>; Machulsky, Zorik <zorik@amazon.com>;
> Matushevsky, Alexander <matua@amazon.com>; Bshara, Saeed
> <saeedb@amazon.com>; Wilson, Matt <msw@amazon.com>; Liguori,
> Anthony <aliguori@amazon.com>; Bshara, Nafea <nafea@amazon.com>;
> Tzalik, Guy <gtzalik@amazon.com>; Belgazal, Netanel
> <netanel@amazon.com>; Saidi, Ali <alisaidi@amazon.com>; Herrenschmidt,
> Benjamin <benh@amazon.com>; Kiyanovski, Arthur
> <akiyano@amazon.com>; Dagan, Noam <ndagan@amazon.com>
> Subject: [PATCH V1 net 00/13] Enhance current features in ena driver
>=20
> From: Sameeh Jubran <sameehj@amazon.com>
>=20
> This patchset introduces the following:
> * minor changes to RSS feature
> * add total rx and tx drop counter
> * add unmask_interrupt counter for ethtool statistics
> * add missing implementation for ena_com_get_admin_polling_mode()
> * some minor code clean-up and cosmetics
> * use SHUTDOWN as reset reason when closing interface
>=20
> Arthur Kiyanovski (6):
>   net: ena: fix error returning in ena_com_get_hash_function()
>   net: ena: avoid unnecessary admin command when RSS function set fails
>   net: ena: change default RSS hash function to Toeplitz
>   net: ena: implement ena_com_get_admin_polling_mode()
>   net: ena: move llq configuration from ena_probe to ena_device_init()
>   net: ena: cosmetic: extract code to ena_indirection_table_set()
>=20
> Sameeh Jubran (7):
>   net: ena: allow setting the hash function without changing the key
>   net: ena: changes to RSS hash key allocation
>   net: ena: remove code that does nothing
>   net: ena: add unmask interrupts statistics to ethtool
>   net: ena: add support for reporting of packet drops
>   net: ena: use SHUTDOWN as reset reason when closing interface
>   net: ena: cosmetic: remove unnecessary spaces and tabs in ena_com.h
>     macros
>=20
>  .../net/ethernet/amazon/ena/ena_admin_defs.h  |   8 +
>  drivers/net/ethernet/amazon/ena/ena_com.c     |  44 +++---
>  drivers/net/ethernet/amazon/ena/ena_com.h     |  39 +++--
>  drivers/net/ethernet/amazon/ena/ena_ethtool.c |  68 ++++----
> drivers/net/ethernet/amazon/ena/ena_netdev.c  | 146 ++++++++++--------
>  drivers/net/ethernet/amazon/ena/ena_netdev.h  |   2 +
>  6 files changed, 181 insertions(+), 126 deletions(-)
>=20
> --
> 2.24.1.AMZN

