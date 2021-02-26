Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A19325E45
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 08:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhBZHYs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 26 Feb 2021 02:24:48 -0500
Received: from mail.a-eberle.de ([213.95.140.213]:35537 "EHLO mail.a-eberle.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230107AbhBZHY0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 02:24:26 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.a-eberle.de (Postfix) with ESMTP id 5AAD33802F4
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 08:23:39 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at aeberle-mx.softwerk.noris.de
Received: from mail.a-eberle.de ([127.0.0.1])
        by localhost (ebl-mx-02.a-eberle.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id aEHXfIY5q79G for <netdev@vger.kernel.org>;
        Fri, 26 Feb 2021 08:23:38 +0100 (CET)
Received: from gateway.a-eberle.de (unknown [178.15.155.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "sg310.eberle.local", Issuer "A. Eberle GmbH & Co. KG WebAdmin CA" (not verified))
        (Authenticated sender: postmaster@a-eberle.de)
        by mail.a-eberle.de (Postfix) with ESMTPSA
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 08:23:31 +0100 (CET)
Received: from exch-svr2013.eberle.local ([192.168.1.9]:24206 helo=webmail.a-eberle.de)
        by gateway.a-eberle.de with esmtps (TLSv1.2:AES256-SHA:256)
        (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <Marco.Wenzel@a-eberle.de>)
        id 1lFXTB-0003Ld-1k; Fri, 26 Feb 2021 08:23:25 +0100
Received: from EXCH-SVR2013.eberle.local (192.168.1.9) by
 EXCH-SVR2013.eberle.local (192.168.1.9) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 26 Feb 2021 08:23:25 +0100
Received: from EXCH-SVR2013.eberle.local ([::1]) by EXCH-SVR2013.eberle.local
 ([::1]) with mapi id 15.00.1497.006; Fri, 26 Feb 2021 08:23:25 +0100
From:   "Wenzel, Marco" <Marco.Wenzel@a-eberle.de>
To:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "george.mccollister@gmail.com" <george.mccollister@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Andreas Oetken <andreas.oetken@siemens.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "Arvid Brodin" <Arvid.Brodin@xdin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: AW: [PATCH net] net: hsr: add support for EntryForgetTime
Thread-Topic: [PATCH net] net: hsr: add support for EntryForgetTime
Thread-Index: AQHXCrS24j34VvXTokStyTYWKTY4T6ppFtEAgADzEiA=
Date:   Fri, 26 Feb 2021 07:23:25 +0000
Message-ID: <6643f25719964f07bef17eee294670d3@EXCH-SVR2013.eberle.local>
References: <CAFSKS=PnV-aLnGeNqjqrsT4nfFby18uYQpScCCurz6dZ39AynQ@mail.gmail.com>
        <20210224094653.1440-1-marco.wenzel@a-eberle.de>        <YDZaxXkP25RjN02G@lunn.ch>
 <20210225094900.10ba8346@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210225094900.10ba8346@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.242.2.55]
x-kse-serverinfo: EXCH-SVR2013.eberle.local, 9
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: Clean, bases: 26.02.2021 06:16:00
x-kse-attachment-filter-triggered-rules: Clean
x-kse-attachment-filter-triggered-filters: Clean
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 6:49 PM Jakub Kicinski <kuba@kernel.org> wrote:
> 
> On Wed, 24 Feb 2021 14:55:17 +0100 Andrew Lunn wrote:
> > On Wed, Feb 24, 2021 at 10:46:49AM +0100, Marco Wenzel wrote:
> > > In IEC 62439-3 EntryForgetTime is defined with a value of 400 ms.
> > > When a node does not send any frame within this time, the sequence
> > > number check for can be ignored. This solves communication issues
> > > with Cisco IE 2000 in Redbox mode.
> > >
> > > Fixes: f421436a591d ("net/hsr: Add support for the High-availability
> > > Seamless Redundancy protocol (HSRv0)")
> > > Signed-off-by: Marco Wenzel <marco.wenzel@a-eberle.de>
> > > Reviewed-by: George McCollister <george.mccollister@gmail.com>
> > > Tested-by: George McCollister <george.mccollister@gmail.com>
> >
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> Applied, thanks!

Thank you all for supporting me during the submission of my first kernel patch!

Best regards,
Marco

