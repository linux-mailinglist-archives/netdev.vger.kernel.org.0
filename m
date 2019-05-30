Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B778C2FB80
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 14:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfE3MWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 08:22:00 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:53725 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfE3MV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 08:21:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559218918; x=1590754918;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h80KA21o1LfjsW48KugFCSI4gSeNMOcUkjzyfe6KKTo=;
  b=QDJuwFjQXp1MDHFtO/xnvwy6LJeUfWWpEX5QPR31KxSylI1aMMfxvQWn
   vVap5mkgg8isyxkfBX9uqwrKfHtCmlvQjUbZZmu5yeAnQTxun6USV35tg
   AW2PgF1vkQfVkVAiLPaFCVK35bBPO8B1GiZ23IE60j7E8uj2zfQ3NG32x
   E=;
X-IronPort-AV: E=Sophos;i="5.60,531,1549929600"; 
   d="scan'208";a="404325144"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 30 May 2019 12:21:57 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id 8A77FA2398;
        Thu, 30 May 2019 12:21:56 +0000 (UTC)
Received: from EX13D10EUA004.ant.amazon.com (10.43.165.131) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 30 May 2019 12:21:55 +0000
Received: from EX13D22EUA004.ant.amazon.com (10.43.165.129) by
 EX13D10EUA004.ant.amazon.com (10.43.165.131) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 30 May 2019 12:21:55 +0000
Received: from EX13D22EUA004.ant.amazon.com ([10.43.165.129]) by
 EX13D22EUA004.ant.amazon.com ([10.43.165.129]) with mapi id 15.00.1367.000;
 Thu, 30 May 2019 12:21:54 +0000
From:   "Kiyanovski, Arthur" <akiyano@amazon.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "Jubran, Samih" <sameehj@amazon.com>
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
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Subject: RE: [PATCH V1 net-next 02/11] net: ena: ethtool: add extra properties
 retrieval via get_priv_flags
Thread-Topic: [PATCH V1 net-next 02/11] net: ena: ethtool: add extra
 properties retrieval via get_priv_flags
Thread-Index: AQHVFgPvytj2THIl5UKdCp4ln0o45aaCqnOAgADssQA=
Date:   Thu, 30 May 2019 12:21:35 +0000
Deferred-Delivery: Thu, 30 May 2019 12:21:00 +0000
Message-ID: <b39873d56509459a956ff41458b5ca19@EX13D22EUA004.ant.amazon.com>
References: <20190529095004.13341-1-sameehj@amazon.com>
        <20190529095004.13341-3-sameehj@amazon.com>
 <20190529150953.3cf14bca@cakuba.netronome.com>
In-Reply-To: <20190529150953.3cf14bca@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.250]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Thursday, May 30, 2019 1:10 AM
> To: Jubran, Samih <sameehj@amazon.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; Kiyanovski, Arthur
> <akiyano@amazon.com>; Woodhouse, David <dwmw@amazon.co.uk>;
> Machulsky, Zorik <zorik@amazon.com>; Matushevsky, Alexander
> <matua@amazon.com>; Bshara, Saeed <saeedb@amazon.com>; Wilson, Matt
> <msw@amazon.com>; Liguori, Anthony <aliguori@amazon.com>; Bshara,
> Nafea <nafea@amazon.com>; Tzalik, Guy <gtzalik@amazon.com>; Belgazal,
> Netanel <netanel@amazon.com>; Saidi, Ali <alisaidi@amazon.com>;
> Herrenschmidt, Benjamin <benh@amazon.com>
> Subject: Re: [PATCH V1 net-next 02/11] net: ena: ethtool: add extra prope=
rties
> retrieval via get_priv_flags
>=20
> On Wed, 29 May 2019 12:49:55 +0300, sameehj@amazon.com wrote:
> > From: Arthur Kiyanovski <akiyano@amazon.com>
> >
> > This commit adds a mechanism for exposing different driver properties
> > via ethtool's priv_flags.
> >
> > In this commit we:
> >
> > Add commands, structs and defines necessary for handling extra
> > properties
> >
> > Add functions for:
> > Allocation/destruction of a buffer for extra properties strings.
> > Retreival of extra properties strings and flags from the network device=
.
> >
> > Handle the allocation of a buffer for extra properties strings.
> >
> > * Initialize buffer with extra properties strings from the
> >   network device at driver startup.
> >
> > Use ethtool's get_priv_flags to expose extra properties of the ENA
> > device
> >
> > Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
> > Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
>=20
> This commit DMAs in the string set blindly from the FW and exposes it to =
user
> space, without any interpretation by the driver, correct?
> Making the driver a mere proxy for the FW.  I think it should be clearly
> mentioned in the commit message, to make sure we know what what we are
> accepting here.  I'm always a little uncomfortable with such changes :) (=
I'm not
> actually sure there is a precedent for this).

Ack. We will update the commit message in the next version of the patch wit=
h more information.
