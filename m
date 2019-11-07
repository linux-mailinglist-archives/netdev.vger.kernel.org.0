Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60745F2853
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 08:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfKGHra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 02:47:30 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:45033 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbfKGHra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 02:47:30 -0500
Received: from [IPv6:2a02:810c:c200:2e91:9c11:3c5b:d198:83e8] (unknown [IPv6:2a02:810c:c200:2e91:9c11:3c5b:d198:83e8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id AB67A23E40;
        Thu,  7 Nov 2019 08:47:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1573112848;
        bh=1TyjvgjvYw4OB/HtJtOb05TZVEDh4q+2iHLZKIbZDc0=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=potpmc5fxQnZukSsGdAANNlyqe0Lv8oKGk+HN46dPJvbbW/FKgVi4fvRlZ3WxMNdS
         AGxdCHOItnVXNmDaTgyuNdoMBHRrV53SOVABKW+VXccW57BZrZhpBJZHp9sU9dDnQP
         sGHiEeDpqKjqMWoqa6BWHyYcujfyb+fpLLP9Eylk=
Date:   Thu, 07 Nov 2019 08:47:25 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <20191107020436.GD8978@lunn.ch>
References: <20191106223617.1655-1-michael@walle.cc> <20191106223617.1655-5-michael@walle.cc> <20191107020436.GD8978@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 4/6] net: phy: at803x: mention AR8033 as same as AR8031
To:     Andrew Lunn <andrew@lunn.ch>
CC:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Rob Herring <robh@kernel.org>,
        David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
From:   Michael Walle <michael@walle.cc>
Message-ID: <1DE4295A-1D25-4FAD-8DAB-45BD97E511C9@walle.cc>
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 7=2E November 2019 03:04:36 MEZ schrieb Andrew Lunn <andrew@lunn=2Ech>:
>On Wed, Nov 06, 2019 at 11:36:15PM +0100, Michael Walle wrote:
>> The AR8033 is the AR8031 without PTP support=2E All other registers are
>> the same=2E Unfortunately, they share the same PHY ID=2E Therefore, we
>> cannot distinguish between the one with PTP support and the one
>without=2E
>
>Not nice=2E I suppose there might be a PTP register you can read to
>determine this, but that is not very helpful=2E

I tried that actually=2E=2E There is a PTP enable bit=2E It's default is 1=
 (according to the AR8031 datasheet)=2E Now guess what it's value is on the=
 AR8033=2E=2E its also 1=2E Not enough=2E=2E I also tried to enable the rea=
ltime counter=2E well that worked too=2E

And yes=2E I've double checked the package marking=2E It definitely was an=
 AR8033=2E So either I was just lucky, or maybe=2E=2E the AR8033 is just a =
relabled AR8031 ;)=20

-michael

