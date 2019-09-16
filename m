Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D20CB3990
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 13:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731632AbfIPLju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 07:39:50 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:34423 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731110AbfIPLju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 07:39:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568633989; x=1600169989;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LOU9QT7eDpBxlxQCzu4phRmo6ckEBAuZgSulb903qOQ=;
  b=EMPDi0PGBkaTk3pNXshM5vW9Fm8+oDlO3tH8PD72leh42xT9YRl4qNO+
   bcDRlWG5jlMfQeizN4k6yoMRqa/jhaQtse7UCcZmpoGhSyP1/WJ+L53Cu
   Q4/eu//CwAJWx1FvLB3f3oGXIUHaH7B36nH+dad8CdiFkD66cA3v8EVHT
   c=;
X-IronPort-AV: E=Sophos;i="5.64,512,1559520000"; 
   d="scan'208";a="415451041"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 16 Sep 2019 11:39:48 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com (Postfix) with ESMTPS id F34B8A17E2;
        Mon, 16 Sep 2019 11:39:46 +0000 (UTC)
Received: from EX13D04EUA001.ant.amazon.com (10.43.165.136) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Sep 2019 11:39:46 +0000
Received: from EX13D22EUA004.ant.amazon.com (10.43.165.129) by
 EX13D04EUA001.ant.amazon.com (10.43.165.136) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Sep 2019 11:39:45 +0000
Received: from EX13D22EUA004.ant.amazon.com ([10.43.165.129]) by
 EX13D22EUA004.ant.amazon.com ([10.43.165.129]) with mapi id 15.00.1367.000;
 Mon, 16 Sep 2019 11:39:45 +0000
From:   "Kiyanovski, Arthur" <akiyano@amazon.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
        "Jubran, Samih" <sameehj@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>
Subject: RE: [PATCH V1 net-next 01/11] net: ena: add intr_moder_rx_interval to
 struct ena_com_dev and use it
Thread-Topic: [PATCH V1 net-next 01/11] net: ena: add intr_moder_rx_interval
 to struct ena_com_dev and use it
Thread-Index: AQHVaba3tinElGdX106WUGXswoL1n6ctFHyAgAEeZmA=
Date:   Mon, 16 Sep 2019 11:39:39 +0000
Deferred-Delivery: Mon, 16 Sep 2019 11:39:14 +0000
Message-ID: <681f96d217b24b9f929da7ac61019e72@EX13D22EUA004.ant.amazon.com>
References: <1568326128-4057-1-git-send-email-akiyano@amazon.com>
        <1568326128-4057-2-git-send-email-akiyano@amazon.com>
 <20190915.193241.878202512573492759.davem@davemloft.net>
In-Reply-To: <20190915.193241.878202512573492759.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.55]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Sunday, September 15, 2019 9:33 PM
> To: Kiyanovski, Arthur <akiyano@amazon.com>
> Cc: netdev@vger.kernel.org; Woodhouse, David <dwmw@amazon.co.uk>;
> Machulsky, Zorik <zorik@amazon.com>; Matushevsky, Alexander
> <matua@amazon.com>; Bshara, Saeed <saeedb@amazon.com>; Wilson, Matt
> <msw@amazon.com>; Liguori, Anthony <aliguori@amazon.com>; Bshara,
> Nafea <nafea@amazon.com>; Tzalik, Guy <gtzalik@amazon.com>; Belgazal,
> Netanel <netanel@amazon.com>; Saidi, Ali <alisaidi@amazon.com>;
> Herrenschmidt, Benjamin <benh@amazon.com>; Jubran, Samih
> <sameehj@amazon.com>; Dagan, Noam <ndagan@amazon.com>
> Subject: Re: [PATCH V1 net-next 01/11] net: ena: add intr_moder_rx_interv=
al to
> struct ena_com_dev and use it
>=20
> From: <akiyano@amazon.com>
> Date: Fri, 13 Sep 2019 01:08:38 +0300
>=20
> > @@ -1307,8 +1304,8 @@ static void
> ena_com_update_intr_delay_resolution(struct ena_com_dev *ena_dev,
> >  	ena_dev->intr_delay_resolution =3D intr_delay_resolution;
> >
> >  	/* update Rx */
> > -	for (i =3D 0; i < ENA_INTR_MAX_NUM_OF_LEVELS; i++)
> > -		intr_moder_tbl[i].intr_moder_interval /=3D intr_delay_resolution;
> > +	ena_dev->intr_moder_rx_interval /=3D intr_delay_resolution;
> > +
> >
> >  	/* update Tx */
>=20
> Now there are two empty lines here, please remove one of them.

Thanks.
For some reason checkpatch did not catch this and also another such extra s=
pace.
Sent out V2 of the patchset.
