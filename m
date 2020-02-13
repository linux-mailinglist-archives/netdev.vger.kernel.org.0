Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2AD15C089
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 15:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbgBMOmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 09:42:52 -0500
Received: from smtp1.axis.com ([195.60.68.17]:13817 "EHLO smtp1.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgBMOmw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 09:42:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; l=340; q=dns/txt; s=axis-central1;
  t=1581604972; x=1613140972;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=xpUxFgN9JjBOEGpsSTkvoetfA/VG0y83VpFdB2Pi1uM=;
  b=KeKwqgrpS1TVX07SsutnyJZFVjAqtF6kJP9LkFG7YPlJ0vscDjHZo8SV
   8QJSmrZFqce/f6BgWJqFEGsoD5p2CX8OpkwnhJEK0d8nLYdGXn/+TUjcD
   fwkMDpvpD+Oqq4q4asgUjr1v85O6pQFG9QW2udGUsiOqZyfXT9iGprJrK
   Jj8BGOTA4Wn0kR6hH8k+0VO3UipKp7mvY8x/xUEjDrODPUF6h8NE5Z4of
   zMg05hN+yXG2KSBhmA6M4yq9HruWAJ2KVHVZg9tbnE7oyOWHkEoFsD6rR
   u6mFG6vqvS3gX2CcUMCVRb+7pg62g8NgzXAQVTGGBhd5QORxc6sDgqllV
   g==;
IronPort-SDR: +CjIgq9O4TI1iUeQ6VQiaSJE0Zyf02A82LxQHueP5xaW2Zxa4SokBa0ps94j0w0BMm0rlkrOow
 6SZj3TkfzENLtuCgHvfLNl5wFjFexezEvyjC7s+uWUf9vfSycAo9GfTj4lx58FQwL3HIsfdqSl
 +SxiPAeJHyutIb8uCwI5/ndl3Q+fxR5d/SsTu0sTpmejWu1oVuHvQFnr7TpGgPcsE5+lT1TfEH
 onD1+goTc49F0G6VNJ3JRo0YrMWnC5TO+91PhlcbSRvyYM/+9xmpv6tD5egvyhfINFGDajlLau
 hFg=
X-IronPort-AV: E=Sophos;i="5.70,437,1574118000"; 
   d="scan'208";a="5391249"
From:   =?iso-8859-1?Q?Per_F=F6rlin?= <Per.Forlin@axis.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net 2/2] net: dsa: tag_ar9331: Make sure there is headroom
 for tag
Thread-Topic: [PATCH net 2/2] net: dsa: tag_ar9331: Make sure there is
 headroom for tag
Thread-Index: AQHV4nSoSNN9wTO8RUyIDZgxhpcizagZFhMAgAAb67E=
Date:   Thu, 13 Feb 2020 14:42:50 +0000
Message-ID: <1581604970155.53037@axis.com>
References: <20200213135100.2963-1-per.forlin@axis.com>
 <20200213135100.2963-3-per.forlin@axis.com>,<e1c554fa-fde7-0e8b-959d-603e66db54b0@pengutronix.de>
In-Reply-To: <e1c554fa-fde7-0e8b-959d-603e66db54b0@pengutronix.de>
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

> >=0A=
> > Signed-off-by: Per Forlin <perfn@axis.com>=0A=
=0A=
> Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>=0A=
=0A=
> Thank you!=0A=
=0A=
> Are you using this driver?=0A=
Hi,=0A=
=0A=
I'm not using this particular driver.=0A=
I'm using the tag_qca driver and this driver had the same typo.=0A=
=0A=
Br=0A=
Per=0A=
