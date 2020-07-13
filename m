Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20BE21E1B7
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 22:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgGMU45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 16:56:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726325AbgGMU44 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 16:56:56 -0400
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD56F207BC;
        Mon, 13 Jul 2020 20:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594673816;
        bh=4wfonj6lsRhQ0cW3cAS4E4Zpd7EpJTMw1F1kI7y+4MU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WbO0QXZGfr9zYDH55vgD8iBWLb5D/FaD/5nYpP46EnLAcstG92jNdleAamMO1EouO
         H7LbzwE2jQI/LRr28s1CowjmWd1nsexCb4ZsrmOS40v3pBPe7+Bq0KPh+Fvw4Cdstb
         8nMsGHu7tmUtSo3u0oHjpAYzyYyWKD+bpILVh5cY=
Received: by mail-oi1-f170.google.com with SMTP id e4so12195033oib.1;
        Mon, 13 Jul 2020 13:56:55 -0700 (PDT)
X-Gm-Message-State: AOAM5323KRSXP0GqV42fkTPpA6SHNErty962cqAIzcOtZfeMxKWesMeK
        W59YjH/KztTm2si/Wdevb9tJoQDEpT9/rnyxDA==
X-Google-Smtp-Source: ABdhPJwVv71g0MzRH+ftAnZ69z1/ABXIEb9TxKX2p2+w/ni7qEXb6zxqydnTbTljeSr/4/pjPY6VB2WkZ8y6LFjZPgo=
X-Received: by 2002:aca:30d2:: with SMTP id w201mr1103898oiw.147.1594673815264;
 Mon, 13 Jul 2020 13:56:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200710090618.28945-1-kurt@linutronix.de> <20200710090618.28945-2-kurt@linutronix.de>
 <20200710163940.GA2775145@bogus> <874kqewahb.fsf@kurt> <20200711165203.GO1014141@lunn.ch>
In-Reply-To: <20200711165203.GO1014141@lunn.ch>
From:   Rob Herring <robh@kernel.org>
Date:   Mon, 13 Jul 2020 14:56:43 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKe47GdjVXJ6GeRCfZ7v+WKxee6P2jAi64+M5BYaf=8SQ@mail.gmail.com>
Message-ID: <CAL_JsqKe47GdjVXJ6GeRCfZ7v+WKxee6P2jAi64+M5BYaf=8SQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] dt-bindings: net: dsa: Add DSA yaml binding
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 11, 2020 at 10:52 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sat, Jul 11, 2020 at 01:35:12PM +0200, Kurt Kanzenbach wrote:
> > On Fri Jul 10 2020, Rob Herring wrote:
> > > On Fri, 10 Jul 2020 11:06:18 +0200, Kurt Kanzenbach wrote:
> > >> For future DSA drivers it makes sense to add a generic DSA yaml binding which
> > >> can be used then. This was created using the properties from dsa.txt. It
> > >> includes the ports and the dsa,member property.
> > >>
> > >> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
> > >> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> > >> ---
> > >>  .../devicetree/bindings/net/dsa/dsa.yaml      | 80 +++++++++++++++++++
> > >>  1 file changed, 80 insertions(+)
> > >>  create mode 100644 Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > >>
> > >
> > >
> > > My bot found errors running 'make dt_binding_check' on your patch:
> > >
> > > /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: switch@0: 'ports' is a required property
> > > /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.example.dt.yaml: switch@10: 'ports' is a required property
> >
> > Okay, the requirement for 'ports' has be to removed.
>
> Hummm....
>
> ti.cpsw is not a DSA switch. So this binding should not apply to
> it. It is a plain switchdev switch.

Well, the binding looks very similar with the same
ethernet-ports/port@X structure. So maybe we need a switch schema that
covers both and then a DSA schema.

> The qcom,ipq806 is just an MDIO bus master. The DSA binding might
> apply, for a specific .dts file, if that dts file has a DSA switch on
> the bus. But in general, it should not apply.
>
> So i actually think you need to work out why this binding is being
> applied when it should not be.
>
> I suspect it is the keyword 'switch'. switch does not imply it is a
> DSA switch. There are other sorts of switches as well.

Yes, by default, we match on compatible or node name if no compatible.
The simple solution here is adding 'select: false' and then dsa.yaml
will only be applied when explicitly referenced by the h/w specific
bindings.

There's also mscc-ocelot which is not yet a schema.

Rob
