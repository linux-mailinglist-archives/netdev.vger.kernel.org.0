Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4838818DA1
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 18:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfEIQFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 12:05:43 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:36226 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726590AbfEIQFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 12:05:43 -0400
Received: from mailhost.synopsys.com (dc8-mailhost2.synopsys.com [10.13.135.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B3C97C012B;
        Thu,  9 May 2019 16:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557417946; bh=+zT3l6b7Trmptm1zDuRdBEK5WtdkP9JnR8Dw1dNvr2k=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=F8xwqlS41ukC9ZSKTag3xvOyOWuYu6Mja15XfGc8P5rl4NkqRBZKPiQI6DqjywDlO
         zCPnBhcdBu6wlTYaKpoaw37GoeudHO+vZzmIFEbVmXHHFW3S/DYkql2gLT82ANj6Vb
         vFD2njGohHPhsXEjBI+ZCohKOsyRlK4EaPO8fe9YBhYJwYJ9Pix1himYxk14E8e6We
         /kEtxjzpkvRyM+P2sTHMbn5zkPGV7zWELCid83BSxd3hLHo4HgBXIM6aAvc5+/t7C9
         Hme23HLoQh3N/Qyq/ZaXO1FCmjWaWyf04xa/2bOSXqvm9/+q+IPpe2JJvN0hvHjyKr
         bJfAX93QuW1mw==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 3DEB9A008E;
        Thu,  9 May 2019 16:05:38 +0000 (UTC)
Received: from DE02WEHTCA.internal.synopsys.com (10.225.19.92) by
 us01wehtc1.internal.synopsys.com (10.12.239.231) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 9 May 2019 09:05:38 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCA.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Thu,
 9 May 2019 18:05:35 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     'Andrew Lunn' <andrew@lunn.ch>,
        'Jose Abreu' <Jose.Abreu@synopsys.com>
CC:     "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        'Joao Pinto' <Joao.Pinto@synopsys.com>,
        "'David S . Miller'" <davem@davemloft.net>,
        'Giuseppe Cavallaro' <peppe.cavallaro@st.com>,
        'Alexandre Torgue' <alexandre.torgue@st.com>
Subject: RE: [PATCH net-next 00/11] net: stmmac: Selftests
Thread-Topic: [PATCH net-next 00/11] net: stmmac: Selftests
Thread-Index: AQHVBXLZwJ2RZgEDF0CNP6MWY759gKZhghGAgADw7NCAAIOwAA==
Date:   Thu, 9 May 2019 16:05:35 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B47B52A@DE02WEMBXB.internal.synopsys.com>
References: <cover.1557300602.git.joabreu@synopsys.com>
 <20190508195011.GK25013@lunn.ch>
 <78EB27739596EE489E55E81C33FEC33A0B47AAEE@DE02WEMBXB.internal.synopsys.com>
In-Reply-To: <78EB27739596EE489E55E81C33FEC33A0B47AAEE@DE02WEMBXB.internal.synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.107.19.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <joabreu@synopsys.com>
Date: Thu, May 09, 2019 at 09:17:03

> From: Andrew Lunn <andrew@lunn.ch>
> Date: Wed, May 08, 2019 at 20:50:11
>=20
> > The normal operation is interrupted by the tests you carry out
> > here. But i don't see any code looking for ETH_TEST_FL_OFFLINE
>=20
> Ok will fix to only run in offline mode then.
>=20
> >=20
> > > (Error code -95 means EOPNOTSUPP in current HW).
> >=20
> > How deep do you have to go before you know about EOPNOTSUPP?  It would
> > be better to not return the string and result at all. Or patch ethtool
> > to call strerror(3).
>=20
> When I looked at other drivers I saw that they return positive value (1)=
=20
> or zero so calling strerror in ethtool may not be ideal.
>=20
> I think its useful to let the user know if a given test is not supported=
=20
> in HW so maybe I can return 1 instead of EOPNOTSUPP ?

After thinking about this in more detail I now realize that returning 1=20
is not ideal because when a test fails it will also return 1. So if I do=20
it this way and more than one test fails then user won't know if the test=20
really failed or if it wasn't supported in the first time.

Any advice ?

Thanks,
Jose Miguel Abreu
