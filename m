Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFEE1349855
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 18:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhCYRim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 13:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbhCYRiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 13:38:11 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1055C06174A;
        Thu, 25 Mar 2021 10:38:10 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id h13so3361008eds.5;
        Thu, 25 Mar 2021 10:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I9q63tYJ03BknGivZ05XneXQJyIBDXfgHPnv+sgu2h0=;
        b=t7jvWs6wjvTatSQlhTTEZV62S1SFXf2SkvhIVFBxlYebdjNAjxJhiMJ/U4CdFICFe/
         jGqfU0+yfJPuT4zI0V/mgDcZWzi0KofGkQ74ESAwu6t7H0bXg7VJcbOZ0Wizgt/E7zuF
         FUfgV+JhYwjPukLw8VUP+zpbmFIvDBDXcjmS/SG4QI9zPMdxCL96gDeP1fpi03KXvrsd
         Y+PU6HkFYbtCs6o6/+uJxyZBKevTHNB9qa6gnGCwZz03y1CXW892IqvI+8ZBnzrHaf1I
         UfLJR/ySXIGj2qaC1ST1ugp8Pwyu0nYodjhG5LZQCe4ajSIYTkfqVKnAXBnfImXvxnna
         DkmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I9q63tYJ03BknGivZ05XneXQJyIBDXfgHPnv+sgu2h0=;
        b=QXYZ6TpV+DrIdgSn3SbdVB9z0TyAvatHMThSPUClNWP37+IIQ3I6uj6WrSJ2al+MRX
         gITgJuNZ4/mJmMNE54T8LdBkU9VoAOU2jj6T43fdiJynkbmhyiKbVR8AfWgWHL2ErdAu
         7EHGGkBhC/pzjFb45rhab1llhXND4TAYw7XQ9YObob94ufonaP9UiDBaGS1+/hfIycK0
         65CNj/8IgIlMO7lnqmWNvJ9QF81dDUw7ZTW1PN1AKZt7Mu9uPgQTXz3EYfI5pNwIFQCX
         2bmZZW0KsYUm9uNDvl4ZcZor9KIwbzlHYMrGXK6VDihQdAYY9EsSjV50kmzJRMryGAjX
         a6Gg==
X-Gm-Message-State: AOAM530BhL/t0XO/RcLhBV2j8MYQGbN9yEVKehaEXPCACZOWk2n7O8q6
        wmNcQM0DHUd+PxQYepWKdNZYJJY46Mhe0GgG2kY=
X-Google-Smtp-Source: ABdhPJyJuaXnigXxrj2VNTfYCMQjXdN8sTCW5EW1OJFX24BuQs2VGSkwYTcJ/fG2ACrUlSpEZcUFS6W23kZPN4BKpNY=
X-Received: by 2002:aa7:cf02:: with SMTP id a2mr10325668edy.59.1616693889364;
 Thu, 25 Mar 2021 10:38:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210325124225.2760-1-linux.amoon@gmail.com> <20210325124225.2760-2-linux.amoon@gmail.com>
 <1616691361.069761.1321894.nullmailer@robh.at.kernel.org>
In-Reply-To: <1616691361.069761.1321894.nullmailer@robh.at.kernel.org>
From:   Anand Moon <linux.amoon@gmail.com>
Date:   Thu, 25 Mar 2021 23:07:57 +0530
Message-ID: <CANAwSgSx0uBy3FVboTh5yiooerZKc5sH3FvAxD-6KkzTOoAhXQ@mail.gmail.com>
Subject: Re: [PATCHv1 1/6] dt-bindings: net: ethernet-phy: Fix the parsing of
 ethernet-phy compatible string
To:     Rob Herring <robh@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        netdev@vger.kernel.org, Kevin Hilman <khilman@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree <devicetree@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jerome Brunet <jbrunet@baylibre.com>,
        linux-amlogic@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob

On Thu, 25 Mar 2021 at 22:26, Rob Herring <robh@kernel.org> wrote:
>
> On Thu, 25 Mar 2021 12:42:20 +0000, Anand Moon wrote:
> > Fix the parsing of check of pattern ethernet-phy-ieee802.3 used
> > by the device tree to initialize the mdio phy.
> >
> > As per the of_mdio below 2 are valid compatible string
> >       "ethernet-phy-ieee802.3-c22"
> >       "ethernet-phy-ieee802.3-c45"
> >
> > Cc: Rob Herring <robh@kernel.org>
> > Signed-off-by: Anand Moon <linux.amoon@gmail.com>
> > ---
> >  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
>
> My bot found errors running 'make dt_binding_check' on your patch:
>
> yamllint warnings/errors:
>
> dtschema/dtc warnings/errors:
> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ethernet-phy.example.dt.yaml: ethernet-phy@0: compatible: 'oneOf' conditional failed, one must be fixed:
>         ['ethernet-phy-id0141.0e90', 'ethernet-phy-ieee802.3-c45'] is too long
>         Additional items are not allowed ('ethernet-phy-ieee802.3-c45' was unexpected)
>         'ethernet-phy-ieee802.3-c22' was expected
>         'ethernet-phy-ieee802.3-c45' was expected
>         'ethernet-phy-id0141.0e90' does not match '^ethernet-phy-ieee[0-9]{3}\\.[0-9][-][a-f0-9]{4}$'
>         From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ethernet-phy.yaml
>
> See https://patchwork.ozlabs.org/patch/1458341
>
> This check can fail if there are any dependencies. The base for a patch
> series is generally the most recent rc1.
>
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure 'yamllint' is installed and dt-schema is up to
> date:
>
> pip3 install dtschema --upgrade
>
> Please check and re-submit.
>

Now I have a better understanding on device tree shema in
Documentation/devicetree/bindings/net/ethernet-phy.yaml
changes it meant to parse *ethernet-phy-id0181.4400* for example
and not ethernet-phy-ieee802.3-c22 and ethernet-phy-ieee802.3-c45.

So please dicard these changes.

-Anand
