Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 560BD3321E
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbfFCO3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:29:17 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:58543 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727650AbfFCO3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 10:29:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559572156; x=1591108156;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RFXnpVEdUstwhIqWnAFGHQa8J6rEkmfJBq47F940L/8=;
  b=O8BmDhQK5SKGMlFPblBCl5RRmkJBX0NZl1EONop8NCUL211JlJfmSl7A
   gA2Y3CUEdslEHbaOD38AxG/diopV9atieJrxyGPA7WW2a/HhqoNbUxX3+
   PmZGd6RS3EGtGMdoyrT6srU625pliDLoLD0m8gn04grw1JFNdKudCCOrY
   0=;
X-IronPort-AV: E=Sophos;i="5.60,547,1549929600"; 
   d="scan'208";a="677815062"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 03 Jun 2019 14:29:14 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id BD5A8A2900;
        Mon,  3 Jun 2019 14:29:14 +0000 (UTC)
Received: from EX13D04EUB003.ant.amazon.com (10.43.166.235) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 3 Jun 2019 14:29:14 +0000
Received: from EX13D11EUB003.ant.amazon.com (10.43.166.58) by
 EX13D04EUB003.ant.amazon.com (10.43.166.235) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 3 Jun 2019 14:29:13 +0000
Received: from EX13D11EUB003.ant.amazon.com ([10.43.166.58]) by
 EX13D11EUB003.ant.amazon.com ([10.43.166.58]) with mapi id 15.00.1367.000;
 Mon, 3 Jun 2019 14:29:13 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
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
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Subject: RE: [PATCH V1 net-next 02/11] net: ena: ethtool: add extra properties
 retrieval via get_priv_flags
Thread-Topic: [PATCH V1 net-next 02/11] net: ena: ethtool: add extra
 properties retrieval via get_priv_flags
Thread-Index: AQHVFgPv7tmg4sCX/k+uebqTR4T5DKaEE2CAgAXx5cA=
Date:   Mon, 3 Jun 2019 14:29:13 +0000
Message-ID: <852aa9d7989c476f81e750724c99cb10@EX13D11EUB003.ant.amazon.com>
References: <20190529095004.13341-1-sameehj@amazon.com>
        <20190529095004.13341-3-sameehj@amazon.com>
 <20190530.124141.171150800649105078.davem@davemloft.net>
In-Reply-To: <20190530.124141.171150800649105078.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.155]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Thursday, May 30, 2019 10:42 PM
> To: Jubran, Samih <sameehj@amazon.com>
> Cc: netdev@vger.kernel.org; Kiyanovski, Arthur <akiyano@amazon.com>;
> Woodhouse, David <dwmw@amazon.co.uk>; Machulsky, Zorik
> <zorik@amazon.com>; Matushevsky, Alexander <matua@amazon.com>;
> Bshara, Saeed <saeedb@amazon.com>; Wilson, Matt <msw@amazon.com>;
> Liguori, Anthony <aliguori@amazon.com>; Bshara, Nafea
> <nafea@amazon.com>; Tzalik, Guy <gtzalik@amazon.com>; Belgazal,
> Netanel <netanel@amazon.com>; Saidi, Ali <alisaidi@amazon.com>;
> Herrenschmidt, Benjamin <benh@amazon.com>
> Subject: Re: [PATCH V1 net-next 02/11] net: ena: ethtool: add extra
> properties retrieval via get_priv_flags
>=20
> From: <sameehj@amazon.com>
> Date: Wed, 29 May 2019 12:49:55 +0300
>=20
> > @@ -560,6 +564,14 @@ struct ena_admin_set_feature_mtu_desc {
> >  	u32 mtu;
> >  };
> >
> > +struct ena_admin_get_extra_properties_strings_desc {
> > +	u32 count;
> > +};
> > +
> > +struct ena_admin_get_extra_properties_flags_desc {
> > +	u32 flags;
> > +};
>=20
> These single entry structures are a big overkill.  If anything just do on=
e which
> is like "ena_value_desc" and has that "u32 val;"

We think that it's better to leave it as it is, since it's more readable wh=
en the types and fields have meaningful names,  and it also leaves place fo=
r extending it in the future.
