Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A404ACBB3
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 10:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbfIHIy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 04:54:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34380 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727312AbfIHIy3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Sep 2019 04:54:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8MiUPlhtzPdP7++tuRHoQSctPszJcQsc3WCeGa9AaEU=; b=d03zQhpQmDFSPjhUb2/9/79IQP
        UYf8/RWDS4BF53TskUruVNUrJQ27U0ubN9PbDZGBquczqaTeP+iGsyL5DnQQFukDuQRprkclUjY9Y
        oghrO6sJDBRCotthUA2CE5puTJ+F5uT8hiPwhbX7SKOap3UllAKoure5V2NIj1UFBY4E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i6sxd-0007SP-74; Sun, 08 Sep 2019 10:54:17 +0200
Date:   Sun, 8 Sep 2019 10:54:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Trent Piepho <tpiepho@impinj.com>
Subject: Re: [PATCH 1/2] net: phy: dp83867: Add documentation for SGMII mode
 type
Message-ID: <20190908085417.GA28580@lunn.ch>
References: <20190907153919.GC21922@lunn.ch>
 <1567700761-14195-1-git-send-email-vitaly.gaiduk@cloudbear.ru>
 <1567700761-14195-2-git-send-email-vitaly.gaiduk@cloudbear.ru>
 <2894361567896439@iva5-be053096037b.qloud-c.yandex.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <2894361567896439@iva5-be053096037b.qloud-c.yandex.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 08, 2019 at 01:47:19AM +0300, Vitaly Gaiduk wrote:
> Hi, Andrew.<div>I=E2=80=99m ready to do this property with such name but =
is it good practice to do such long names? :)</div><div>Also, Trent Piepho =
wrote about sgmii-clk and merged all ideas we have =E2=80=9Cti,sgmii-ref-cl=
k=E2=80=9D.</div><div>It=E2=80=99s better, isn=E2=80=99t it?</div><div>Vita=
ly.</div><div><div><br />07.09.2019, 18:39, "Andrew Lunn" &lt;andrew@lunn.c=
h&gt;:<br /><blockquote><p>On Thu, Sep 05, 2019 at 07:26:00PM +0300, Vitaly=
 Gaiduk wrote:<br /></p><blockquote class=3D"b4fd5cf2ec92bc68cb898700bb8135=
5fwmi-quote">=C2=A0Add documentation of ti,sgmii-type which can be used to =
select<br />=C2=A0SGMII mode type (4 or 6-wire).<br /><br />=C2=A0Signed-of=
f-by: Vitaly Gaiduk &lt;<a href=3D"mailto:vitaly.gaiduk@cloudbear.ru">vital=
y.gaiduk@cloudbear.ru</a>&gt;<br />=C2=A0---<br />=C2=A0=C2=A0Documentation=
/devicetree/bindings/net/ti,dp83867.txt | 1 +<br />=C2=A0=C2=A01 file chang=
ed, 1 insertion(+)<br /><br />=C2=A0diff --git a/Documentation/devicetree/b=
indings/net/ti,dp83867.txt b/Documentation/devicetree/bindings/net/ti,dp838=
67.txt<br />=C2=A0index db6aa3f2215b..18e7fd52897f 100644<br />=C2=A0--- a/=
Documentation/devicetree/bindings/net/ti,dp83867.txt<br />=C2=A0+++ b/Docum=
entation/devicetree/bindings/net/ti,dp83867.txt<br />=C2=A0@@ -37,6 +37,7 @=
@ Optional property:<br />=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0for ap=
plicable values.  The CLK_OUT pin can also<br />=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0be disabled by this property.  When omitted, the<br />=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0PHY's default will be left as is.<br />=
=C2=A0+	- ti,sgmii-type - This denotes the fact which SGMII mode is used (4=
 or 6-wire).<br /></blockquote><p><br />Hi Vitaly<br /><br />You probably w=
ant to make this a Boolean. I don't think SGMII type is<br />a good idea. T=
his is about enabling the receive clock to be passed to<br />the MAC. So ho=
w about ti,sgmii-ref-clock-output-enable.<br /><br />=C2=A0=C2=A0=C2=A0=C2=
=A0Andrew<br /></p></blockquote></div></div>

Hi Vitaly

Please reconfigure your mail client to not obfuscate with HTML.

The length should be O.K. For a PHY node, it should not be too deeply
indented, unless it happens to be part of an Ethernet switch.

	  Andrew
