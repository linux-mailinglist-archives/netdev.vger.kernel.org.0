Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6C691153EA
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 16:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfLFPJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 10:09:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:32928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbfLFPJZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Dec 2019 10:09:25 -0500
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2DFF24659;
        Fri,  6 Dec 2019 15:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575644965;
        bh=BFgPiLAZWvknC+JyivIc5BNJUYK/zA0hfsGfey3+1eA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=1apToggpiF4ucp39uITnJH1BPT41klTpiaNDPSHP1+N8HWxX2HYZjWBO8eYyiDet1
         VzWkFrMZalU+SBzGh00HQCcRj/f7UBadzHvyny/QwlK6m3R/YtuI0iz0e9aTnq0KAr
         YTttoosiUtIVhI7o2JhQSzuuL6RUcMG9J1ezc8Bs=
Received: by mail-qt1-f181.google.com with SMTP id t17so775951qtr.7;
        Fri, 06 Dec 2019 07:09:24 -0800 (PST)
X-Gm-Message-State: APjAAAUaXoOJkpv+KhMnCtdDp6nxn2P8pUKywBfRvqjvzNZn8bzBMQd8
        /3Ow054VFOBcoZZDxdkvfu29X2Hq2j9wc4Mtcg==
X-Google-Smtp-Source: APXvYqwq9pG0UVtzn65MnG3xeNSXBTwYw4qRbEzG5O3WKdV3l1dEtcig39I7Btu70v3sqx6/ux9LOuqnTBElx71Ar/E=
X-Received: by 2002:ac8:6747:: with SMTP id n7mr12994057qtp.224.1575644964042;
 Fri, 06 Dec 2019 07:09:24 -0800 (PST)
MIME-Version: 1.0
References: <20191127153928.22408-1-grygorii.strashko@ti.com>
 <CAL_Jsq+viKkF4FFgpMhTjKCMLeGOX1o9Uq-StU6xwFuTcpCL2Q@mail.gmail.com> <eb3cb685-5ddc-8e06-1e26-0f6bc43b294c@ti.com>
In-Reply-To: <eb3cb685-5ddc-8e06-1e26-0f6bc43b294c@ti.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 6 Dec 2019 09:09:12 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKZ5qexJMSm5MZYQp5LutyHHHObbfA3r2_XQa7E6kjqpg@mail.gmail.com>
Message-ID: <CAL_JsqKZ5qexJMSm5MZYQp5LutyHHHObbfA3r2_XQa7E6kjqpg@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: mdio: use non vendor specific
 compatible string in example
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org,
        Simon Horman <simon.horman@netronome.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 6, 2019 at 5:14 AM Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
>
>
>
> On 05/12/2019 19:59, Rob Herring wrote:
> > On Wed, Nov 27, 2019 at 9:39 AM Grygorii Strashko
> > <grygorii.strashko@ti.com> wrote:
> >>
> >> Use non vendor specific compatible string in example, otherwise DT YAML
> >> schemas validation may trigger warnings specific to TI ti,davinci_mdio
> >> and not to the generic MDIO example.
> >>
> >> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> >> ---
> >>   Documentation/devicetree/bindings/net/mdio.yaml | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/Documentation/devicetree/bindings/net/mdio.yaml b/Documentation/devicetree/bindings/net/mdio.yaml
> >> index 5d08d2ffd4eb..524f062c6973 100644
> >> --- a/Documentation/devicetree/bindings/net/mdio.yaml
> >> +++ b/Documentation/devicetree/bindings/net/mdio.yaml
> >> @@ -56,7 +56,7 @@ patternProperties:
> >>   examples:
> >>     - |
> >>       davinci_mdio: mdio@5c030000 {
> >> -        compatible = "ti,davinci_mdio";
> >> +        compatible = "vendor,mdio";
> >
> > The problem with this is eventually 'vendor,mdio' will get flagged as
> > an undocumented compatible. We're a ways off from being able to enable
> > that until we have a majority of bindings converted. Though maybe
> > examples can be enabled sooner rather than later.
> >
>
> May be some generic compatible string be used for all examples,
> like: "vendor,example-ip". What do you think?

I'm still not clear what problem you are trying to solve. 'may trigger
warnings' doesn't sound like an actual problem.

Either make the example complete enough to pass validation or just
remove it because common bindings aren't a complete binding on their
own. I'm sure there will be plenty of other MDIO binding examples.

Rob
