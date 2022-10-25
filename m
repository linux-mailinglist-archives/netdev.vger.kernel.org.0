Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19DCE60C608
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 10:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbiJYIEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 04:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbiJYIEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 04:04:02 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B607118756;
        Tue, 25 Oct 2022 01:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1666685003;
        bh=Z2HSpaRQj29O9zp94GLJhtJEeTFRJ0EOqD6UEleaf74=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=dBBSXeoY3Eqyxvo9sdp3Ai6RmiwHSGeIu5/wMEMkZpNfD+/i6yETtWD4FTkb0nylP
         QwcUaWUnmc7zPFNdLdjGFQZighJpw8STFiM7lgRWTj4qE2mAjXoT2N1fAFuPt5447T
         dLYK7I5fLpBEexB4XX4DYXqc7TbsiajwJk0XV8kw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [217.61.152.57] ([217.61.152.57]) by web-mail.gmx.net
 (3c-app-gmx-bap29.server.lan [172.19.172.99]) (via HTTP); Tue, 25 Oct 2022
 10:03:23 +0200
MIME-Version: 1.0
Message-ID: <trinity-defa4f3d-804e-401e-bea1-b36246cbc11b-1666685003285@3c-app-gmx-bap29>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 25 Oct 2022 10:03:23 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <Y1ansgmD69AcITWx@shell.armlinux.org.uk>
References: <Y1UMrvk2A9aAcjo5@shell.armlinux.org.uk>
 <trinity-5350c2bc-473d-408f-a25a-16b34bbfcba7-1666537529990@3c-app-gmx-bs01>
 <Y1Vh5U96W2u/GCnx@shell.armlinux.org.uk>
 <trinity-1d4cc306-d1a4-4ccf-b853-d315553515ce-1666543305596@3c-app-gmx-bs01>
 <Y1V/asUompZKj0ct@shell.armlinux.org.uk>
 <trinity-ac9a840b-cb06-4710-827a-4c4423686074-1666551838763@3c-app-gmx-bs01>
 <trinity-169e3c3f-3a64-485c-9a43-b7cc595531a9-1666552897046@3c-app-gmx-bs01>
 <Y1Wfc+M/zVdw9Di3@shell.armlinux.org.uk>
 <Y1Zah4+hyFk50JC6@shell.armlinux.org.uk>
 <trinity-d2f74581-c020-4473-a5f4-0fc591233293-1666622740261@3c-app-gmx-bap55>
 <Y1ansgmD69AcITWx@shell.armlinux.org.uk>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:53WuUgAivhzjnbgTyCQ6ngUqS8VdgbK75ZA8qrv0jKAGadej8zg5bKvaxG2slWsUqvlar
 YQhB/6zRVpxflislPQnApGvGw85ekSAkh5GbGVLFfcvFYYJ3kT3dj+MObr31CFyop6B+UoLTcN5T
 X/+OXXbcWykkmlaL3bJX+GzK4WIEgjKnk+wBU7IS9ozKMXzRBMnQyaJC2VvkrnQNooxu5anmHshB
 8XpsMOb6k0zc3VtcwgW6jHQ3VnZqzIbOppgtq+tv0rM5NMg462jQpenEXY1s/SQPQRrHahfipUNZ
 Jo=
X-UI-Out-Filterresults: notjunk:1;V03:K0:mxDCYmMzkp0=:wOIllALP4nys1rPLXvZWds
 Vy4r3vMmtLvgvrr5XEEQWkKjiPyAFZIZqOorBEvL3BqwDNjMTYLixTsM1zilCKdnp/TvhONQz
 8TzkJTuhPqR2Eqac1f5ufPabrGp8sWIQNPpot5bCG+tcLZOMNtbXS+lY3z2/E0vqe+UtgH6RZ
 DjZdtv5myPOPOZsAS3nLLx/LgmoragQKtho/qZfhd6ayEC4MymY8M9BASv+rF1XfccDqneCej
 NN3cM/omTbGuEEbB/HkhavsNWCVqwXSyco4Flgp70J5KPpOSQJe0qBNoDM/8UbPt2U1CtojZn
 qNuq2TsBMvvUas2SEd19+fo4mVIUu2/iS0QvTQgZAC5w0UCCY+62BHryVd5lpmuPlk+MXoJmE
 kOy9jsdRFIw4EKDHKVPw2YQE5Knyjs1vOFDBhUEPKe+NMTK8c0WRc2rQQkwzCcN4Yq7MHafnO
 +aXyeQ1EGLEf3eeZ3/vO7uuVulCx7a+eft6+GbEJ1BQNY186TdzCOoxCdmx1gcS9qIkpaowoM
 YJW+BR3NAd+NR3R+Aj9QImTbWrZHwBJLVQo0VPF1kp4hemvf/ZX8XvFmaeI1xCObC2EAgjt/j
 o2MIySN6ikcxdhEJddTxgxxUrOdPPCjlAo6+hbyQw4HOrl7mXSgEfS8+f0WeVJmCzDZXSJs4k
 eyrdfql6pj421ZWIZyx7MGWATTPMw8XEjkZqEvi1lnhi8JqARu8oti2zaVXbXgut9wUM51MjF
 dusyFqrkxVPZH1zb7e4Gx9h3HjUE4gqSgM4Az/UnTUbAoyCuRWbsAX1pCU0VWQs28W0C5Je+s
 PEXFo88zo9QRcFUSRGSrT5T8qYdIUtIboDugunO65CGmFB9eZj/Ib7rHvhsVLmE4Ugiq7qJ7K
 K5RFW5znIiNMhJGSasxsREBnuyOhvBU02YqLD67yN9H5NWnyA4wSbf/hz/h5Wttajsygn28YU
 flI9IxubLW7oYeWUaSWmSqWzwXjYYKrGfxr+SGwzS0YTx8HqrUyvGXp043kPaWHLJdIKiuC6M
 79/XMOGX56jqO1Et858zK/97OBnAyzshur0l3QitoVujuxcCzgtcwkgzwQZKapusMeuVRKtC3
 UzhbyNXLn3HUpo6mYPopa2L7lRNYMyHhujWYf8OzIf/8EqC7KB+t7dn9BHB2i5hheOOIGUDN/
 xwmvILfAMz42LQgi/HoKQtnqWO5Sh9I9lgwUAHdBuVEc0hxsEIOyKWKJO7jKlLbpp1UGWXuLt
 3v+BZwIJRpS3agG85HFYet5Vh4QGQvZBYcID4DvK6rQxSioUTEq0xONoSOADfAQ4dtUI5GZPJ
 1UDweX5X
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Montag, 24=2E Oktober 2022 um 16:56 Uhr
> Von: "Russell King (Oracle)" <linux@armlinux=2Eorg=2Euk>
> On Mon, Oct 24, 2022 at 04:45:40PM +0200, Frank Wunderlich wrote:
> > Hi
> > > Gesendet: Montag, 24=2E Oktober 2022 um 11:27 Uhr
> > > Von: "Russell King (Oracle)" <linux@armlinux=2Eorg=2Euk>
> >=20
> > > Here's the combined patch for where I would like mtk_sgmii to get to=
=2E
> > >
> > > It looks like this PCS is similar to what we know as pcs-lynx=2Ec, b=
ut
> > > there do seem to be differences - the duplex bit for example appears
> > > to be inverted=2E
> > >
> > > Please confirm whether this still works for you, thanks=2E
> >=20
> > basicly Patch works, but i get some (1-50) retransmitts on iperf3 on f=
irst interval in tx-mode (on r3 without -R), other 9 are clean=2E reverse m=
ode is mostly clean=2E
> > run iperf3 multiple times, every first interval has retransmitts=2E sa=
me for gmac0 (fixed-link 2500baseX)
> >=20
> > i notice that you have changed the timer again to 10000000 for 1000/25=
00baseX=2E=2E=2Emaybe use here the default value too like the older code do=
es?
>=20
> You obviously missed my explanation=2E I will instead quote the 802=2E3
> standard which covers 1000base-X:

sorry, right i remember you've already mentioned it

> 37=2E3=2E1=2E4 Timers
>=20
>  link_timer
>           Timer used to ensure Auto-Negotiation protocol stability and
> 	  register read/write by the management interface=2E
>=20
> 	  Duration: 10 ms, tolerance +10 ms, =E2=80=930 s=2E
>=20
> For SGMII, the situation is different=2E Here is what the SGMII
> specification says:
>=20
>   The link_timer inside the Auto-Negotiation has been changed from 10
>   msec to 1=2E6 msec to ensure a prompt update of the link status=2E
>=20
> So, 10ms is correct for 1000base-X, and 1=2E6ms correct for SGMII=2E
>=20
> However, feel free to check whether changing it solves that issue, but
> also check whether it could be some ARP related issue - remember, if
> two endpoints haven't communicated, they need to ARP to get the other
> end's ethernet addresses which adds extra latency, and may result in
> some packet loss in high packet queuing rate situations=2E

tried with 1=2E6ms, same result (or even worse on 1000baseX)=2E i guess ar=
p cache should stay for ~5s?
so at least second round followed directly after the first should be clean=
 when looking on ARP=2E

apart from this little problem it works much better than it actually is so=
 imho more
people should test it on different platforms=2E

regards Frank
