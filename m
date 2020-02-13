Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA03E15C10F
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 16:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgBMPIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 10:08:52 -0500
Received: from smtp2.axis.com ([195.60.68.18]:34413 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727558AbgBMPIv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 10:08:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; l=508; q=dns/txt; s=axis-central1;
  t=1581606531; x=1613142531;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xjML30A0J06ZJszvBVGOp3QBPCQ5dITj1aUWsMWeqqE=;
  b=F8/cQ++e+96Jh7gcKAFq1n6LIdQG2Zt+srq0ORIlGLXFsXrlIwxlFhvw
   Tw2cccREKSsEr4TZvn2IwBO677P4UyeCL0KfyGpPMgc1gjfHEvW+x1QLz
   ge3kwdISlc+TuPiTPrk85KsmwMT8wKMOSxva0uwW600iIPtZXXnwgmPSE
   hJEDBrgScH9aiK0lAzzqofoEU8tyCGCJIWjksvz/0YlJiMck5yLhBlL+r
   TOmG9Kk391bZ2WZSIcpd8w1HWHBxWY9b4t8DV/wuWF3X1SXLgZ38Zt/zG
   zQSe4weW39DPPGubpiUU0e8ymeqmV//5pZqpYSP6wRgjoYnyDw/F+DeQ9
   A==;
IronPort-SDR: qKMWupvBJt9qrVyKL+Dw8elZ82nJjBHI7WJjKyKtiZ2kQvREm/xqvthQGJfAH/vpQjs7yjfCVK
 iAo1ZY+v/sW+OBbtj3B7zCnz6mHteoOsMzOv8M0RIxWLhZP4hfjFYdWwQd54HjnYFevxIprmaB
 Vw9+nTBvBy8yMOKDv61uVd3F8fQvDS0P/q9Gclnw/Rep3BAx5lsDPZVO4Bg4VqLuOiPSIxZIDr
 aAPGDj2+btcgq6239Qb1/v2O067BnSUDLwmjvZVbQHIyTGOqhaTQBa6PNR8epTKKJj5bm+fmFZ
 zMk=
X-IronPort-AV: E=Sophos;i="5.70,437,1574118000"; 
   d="scan'208";a="5245915"
From:   =?iso-8859-1?Q?Per_F=F6rlin?= <Per.Forlin@axis.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "o.rempel@pengutronix.de" <o.rempel@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net 1/2] net: dsa: tag_qca: Make sure there is headroom
 for tag
Thread-Topic: [PATCH net 1/2] net: dsa: tag_qca: Make sure there is headroom
 for tag
Thread-Index: AQHV4nSnWpwCXWOuDkCjQdhNaulpYqgZFoMAgAAiE6M=
Date:   Thu, 13 Feb 2020 15:08:49 +0000
Message-ID: <1581606529347.48907@axis.com>
References: <20200213135100.2963-1-per.forlin@axis.com>
 <20200213135100.2963-2-per.forlin@axis.com>,<20200213140132.GC12151@lunn.ch>
In-Reply-To: <20200213140132.GC12151@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.0.5.60]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
> > This change does not introduce any overhead in case there=0A=
> > is already available headroom for tag.=0A=
> >=0A=
> > Signed-off-by: Per Forlin <perfn@axis.com>=0A=
=0A=
> Hi Per=0A=
=0A=
> If these are for net, you need a Fixes: tag.=0A=
=0A=
> Also, you should add the Reivewed-by: tags i gave for these patches.=0A=
=0A=
Yes, I should add this too.=0A=
I will post a new series after the weekend with the received Reviewed-by an=
d Tested-by as well.=0A=
=0A=
BR=0A=
Per=0A=
