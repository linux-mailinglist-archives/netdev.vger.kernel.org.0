Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255BA26381E
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 22:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729738AbgIIU72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 16:59:28 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:41251 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgIIU72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 16:59:28 -0400
Received: by mail-io1-f66.google.com with SMTP id z13so4721496iom.8;
        Wed, 09 Sep 2020 13:59:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=WKB+fi6JCqB8h42W2jDTX81Eu1SDKw5nPBzug3L1wKk=;
        b=hxHPeGFAUtgUmg5hW991eJxPhwNe/WxQEiN95AJ7khN4pj1u9YTGugeobQLapX77am
         jzQ+S8+IXw6XeiXMJCuI6tLdvF4dQcR57RIMjgSQ5IjJB0+xoeyMgPjV4UvVmo6WJXZl
         2d88K0nxrkIvfr23zaW48nUCbyMrwOu3ApWfVzfkkRIMxw/RbsTFTrh2vnViK1IrQYEr
         uOyWiBfI/ekmKD4z1u+WzrK6yC5QS2tDOUPW9rEjlOHHyIp/6nIiNDAFKz2DK6saZkw1
         gyNF8hPevF65MB28p4luzuHDw1kbxHcOmdGi/jIg09nEmwM4VZADJmQr5uCFVN4yRveM
         lfJA==
X-Gm-Message-State: AOAM5317RwA0GcDOt63Sgmg1N3HrZbsM2Tj8Dm59BvCX3fpi0IWO0lOR
        +TSzr0ldNFnOh7R+Y8pl4g==
X-Google-Smtp-Source: ABdhPJwW0wptLj8Blqz4AudnStaiqqzrhgJ8UPkFvAKAjhyBybXWPMeEKd/hnKGHVxntbYiTaVTUjw==
X-Received: by 2002:a6b:f90f:: with SMTP id j15mr2959502iog.169.1599685166842;
        Wed, 09 Sep 2020 13:59:26 -0700 (PDT)
Received: from xps15 ([64.188.179.251])
        by smtp.gmail.com with ESMTPSA id c9sm2047352ili.31.2020.09.09.13.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 13:59:25 -0700 (PDT)
Received: (nullmailer pid 3066042 invoked by uid 1000);
        Wed, 09 Sep 2020 20:59:23 -0000
Date:   Wed, 9 Sep 2020 14:59:23 -0600
From:   Rob Herring <robh@kernel.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next + leds v2 1/7] dt-bindings: leds: document
 binding for HW controlled LEDs
Message-ID: <20200909205923.GB3056507@bogus>
References: <20200909162552.11032-1-marek.behun@nic.cz>
 <20200909162552.11032-2-marek.behun@nic.cz>
 <20200909182730.GK3290129@lunn.ch>
 <20200909203310.15ca4e42@dellmb.labs.office.nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200909203310.15ca4e42@dellmb.labs.office.nic.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 09, 2020 at 08:33:10PM +0200, Marek Behún wrote:
> On Wed, 9 Sep 2020 20:27:30 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > On Wed, Sep 09, 2020 at 06:25:46PM +0200, Marek Behún wrote:
> > > Document binding for LEDs connected to and controlled by various
> > > chips (such as ethernet PHY chips).
> > > 
> > > Signed-off-by: Marek Behún <marek.behun@nic.cz>
> > > Cc: Rob Herring <robh+dt@kernel.org>
> > > Cc: devicetree@vger.kernel.org
> > > ---
> > >  .../leds/linux,hw-controlled-leds.yaml        | 99
> > > +++++++++++++++++++ 1 file changed, 99 insertions(+)
> > >  create mode 100644
> > > Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml
> > > 
> > > diff --git
> > > a/Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml
> > > b/Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml
> > > new file mode 100644 index 0000000000000..eaf6e5d80c5f5 ---
> > > /dev/null +++
> > > b/Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml
> > > @@ -0,0 +1,99 @@ +# SPDX-License-Identifier: GPL-2.0-only OR
> > > BSD-2-Clause +%YAML 1.2
> > > +---
> > > +$id:
> > > http://devicetree.org/schemas/leds/linux,hw-controlled-leds.yaml#
> > > +$schema: http://devicetree.org/meta-schemas/core.yaml# +
> > > +title: LEDs that can be controlled by hardware (eg. by an ethernet
> > > PHY chip) +
> > > +maintainers:
> > > +  - Marek Behún <marek.behun@nic.cz>
> > > +
> > > +description:
> > > +  Many an ethernet PHY (and other chips) supports various HW
> > > control modes
> > > +  for LEDs connected directly to them. With this binding such LEDs
> > > can be
> > > +  described.
> > > +
> > > +properties:
> > > +  compatible:
> > > +    const: linux,hw-controlled-leds
> > > +
> > > +  "#address-cells":
> > > +    const: 1
> > > +
> > > +  "#size-cells":
> > > +    const: 0
> > > +
> > > +patternProperties:
> > > +  "^led@[0-9a-f]+$":
> > > +    type: object
> > > +    allOf:
> > > +      - $ref: common.yaml#
> > > +    description:
> > > +      This node represents a LED device connected to a chip that
> > > can control
> > > +      the LED in various HW controlled modes.
> > > +
> > > +    properties:
> > > +      reg:
> > > +        maxItems: 1
> > > +        description:
> > > +          This property identifies the LED to the chip the LED is
> > > connected to
> > > +          (eg. an ethernet PHY chip can have multiple LEDs
> > > connected to it). +
> > > +      enable-active-high:
> > > +        description:
> > > +          Polarity of LED is active high. If missing, assumed
> > > default is active
> > > +          low.
> > > +        type: boolean
> > > +
> > > +      led-tristate:
> > > +        description:
> > > +          LED pin is tristate type. If missing, assumed false.
> > > +        type: boolean
> > > +
> > > +      linux,default-hw-mode:
> > > +        description:
> > > +          This parameter, if present, specifies the default HW
> > > triggering mode
> > > +          of the LED when LED trigger is set to `dev-hw-mode`.
> > > +          Available values are specific per device the LED is
> > > connected to and
> > > +          per LED itself.
> > > +        $ref: /schemas/types.yaml#definitions/string
> > > +
> > > +    required:
> > > +      - reg  
> > 
> > My Yaml foo is not very good. Do you need to list colour, function and
> > linux,default-trigger, or do they automagically get included from the
> > generic LED binding?

They do with the '$ref: common.yaml#'. You need to list them if you want 
to say which properties of a common schema you are using (IMO, you 
should, but that's a secondary concern) and/or you have additional 
constraints on them.

> > 
> > 	Andrew
> 
> I don't know :) I copied this from other drivers, I once tried setting
> up environment for doing checking of device trees with YAML schemas,
> and it was a little painful :)

pip3 install dtschema ?

Can you elaborate on the issue.

Rob

