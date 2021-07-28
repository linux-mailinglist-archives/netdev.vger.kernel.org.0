Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0074C3D9430
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 19:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhG1RX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 13:23:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229574AbhG1RX1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 13:23:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5AF56103B;
        Wed, 28 Jul 2021 17:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627493005;
        bh=oy2CdTpDQZqSOXZB0jmZSt0g6kLN/VjpudOGzr8rM1Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LMTrXSBJdcPhhVK888FzkTPIHHm1QFIqtRu60IEoVpEUAZ/PyMNeRlhQDj6f+lJrn
         LuNrLo9g+x4eWRU8zc2XHBEJ/hBzjPNaWRXq72zeR3Z/4hn0Tswg/Udvl6kkXTkmG0
         qyUP9yn4iLclKOk3DiUlVepSrd9vx8YNF4lA2gLLE0nX25tdtqE8y7PhR25OxLK28Q
         oO5MPFValqqViyBawxoEP4yoFIjAGlc7UZlcG9Sp34Cql7PkNRH3c5WWmws/LU+E3P
         C8NX9uV7a0ejx04WN8j6rKGz7svCPo+d458miN5KN3RTwWhKNIeqlRfO1cOejMasFh
         hK6a+l6dFwrow==
Received: by mail-ej1-f52.google.com with SMTP id o5so5850791ejy.2;
        Wed, 28 Jul 2021 10:23:25 -0700 (PDT)
X-Gm-Message-State: AOAM532S7ljnTHLog9caJ4MEPSU3qiE92Mfk1TWjHAElpo+wqW3OcI9e
        HXk4Ka66cubgk12Id3mU+m4hPIkCqWiaVg6qlQ==
X-Google-Smtp-Source: ABdhPJzBRhqr2Ud4HELrNH9AHHg58LqSJjd4vf9qzNk7vw7IkgfkJNJ/8+Otv5jy2oAsvgquPL7L3ePPRqeCXlHZK28=
X-Received: by 2002:a17:907:766c:: with SMTP id kk12mr477374ejc.525.1627493004282;
 Wed, 28 Jul 2021 10:23:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210712130631.38153-1-alexandru.tachici@analog.com>
 <20210712130631.38153-8-alexandru.tachici@analog.com> <20210727055329.7y23ob7kir3te2e4@pengutronix.de>
In-Reply-To: <20210727055329.7y23ob7kir3te2e4@pengutronix.de>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Wed, 28 Jul 2021 11:23:12 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJXAPW7KRAdJac+uje95Nk-b6ojjow8VEzkF=PZvbDvnA@mail.gmail.com>
Message-ID: <CAL_JsqJXAPW7KRAdJac+uje95Nk-b6ojjow8VEzkF=PZvbDvnA@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] dt-bindings: adin1100: Add binding for ADIN1100
 Ethernet PHY
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Alexandru Tachici <alexandru.tachici@analog.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 11:53 PM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
>
> On Mon, Jul 12, 2021 at 04:06:31PM +0300, alexandru.tachici@analog.com wrote:
> > From: Alexandru Tachici <alexandru.tachici@analog.com>
> >
> > DT bindings for the ADIN1100 10BASE-T1L Ethernet PHY.
> >
> > Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> > ---
> >  .../devicetree/bindings/net/adi,adin1100.yaml | 45 +++++++++++++++++++
> >  1 file changed, 45 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/adi,adin1100.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/net/adi,adin1100.yaml b/Documentation/devicetree/bindings/net/adi,adin1100.yaml
> > new file mode 100644
> > index 000000000000..14943164da7a
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/adi,adin1100.yaml
> > @@ -0,0 +1,45 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/adi,adin1100.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Analog Devices ADIN1100 PHY
> > +
> > +maintainers:
> > +  - Alexandru Tachici <alexandru.tachici@analog.com>
> > +
> > +description:
> > +  Bindings for Analog Devices Industrial Low Power 10BASE-T1L Ethernet PHY
> > +
> > +allOf:
> > +  - $ref: ethernet-phy.yaml#
> > +
> > +properties:
> > +  adi,disable-2400mv-tx-level:
> > +    description:
> > +      Prevent ADIN1100 from using the 2.4 V pk-pk transmit level.
> > +    type: boolean
>
> This property should be generic. It is defined by IEEE 802.3cg 2019 and can
> be implemented on all T1L PHYs.
>
> I assume, it should be something like:
> ethernet-phy-10base-t1l-2.4vpp-enable
> ethernet-phy-10base-t1l-2.4vpp-disable

'ethernet-phy-' is a bit redundant and I'd make it a tristate (not
present, 0, 1). So just '10base-t1l-2.4vpp'?

> To overwrite bootstrapped of fuzed values if supported. The IEEE 802.3cg
> specification uses following wordings for this functionality:
> "10BASE-T1L increased transmit level request ..."
