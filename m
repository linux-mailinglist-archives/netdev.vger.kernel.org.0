Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F3F21E194
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 22:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgGMUld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 16:41:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgGMUld (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 16:41:33 -0400
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7191620809;
        Mon, 13 Jul 2020 20:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594672892;
        bh=uV+upRMNLN0EEuKpXARG/DTjrTmb62mp8f5waKgSwKs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tTrpToElmLFk95o6tIA/bXsi6XkiViEnF+lQAUv/JsX+DeLOlPklLPUFi5eVpRVsc
         6nD2H7teYX9p6EjLo7BJsVgy3x+4Bv2EZhjypsC9sNh8XmMs+teZ55fPEZROhxpwBQ
         9jV2wKsuXd/bQnyeezRt+K9u0f/33NQMF7N2k0lE=
Received: by mail-oi1-f169.google.com with SMTP id r8so12124937oij.5;
        Mon, 13 Jul 2020 13:41:32 -0700 (PDT)
X-Gm-Message-State: AOAM531bZ5pdGkWbNRzaN3GpLHV5H/Ggxz2E1AkliN2jVp9SC3TcXw45
        UdJy4cfzMaYafLl2rO7+GC+MBWnktobFA7Fo2A==
X-Google-Smtp-Source: ABdhPJz0d2q53KND1DSgvXo0raYHu0/zzAI/J9tprS2P2vpfElz3BlccN7l8cimXpHSNuzUXT1YJPVWqTw0K+ZCwTXQ=
X-Received: by 2002:aca:bb82:: with SMTP id l124mr1109702oif.106.1594672891731;
 Mon, 13 Jul 2020 13:41:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200710090618.28945-1-kurt@linutronix.de> <20200710090618.28945-2-kurt@linutronix.de>
 <20200710164500.GA2775934@bogus> <8c105489-42c5-b4ba-73b6-c3a858f646a6@gmail.com>
 <CAL_Jsq+zP9++MftM+Dh2Fe-OdKq6EiGA_tASEbBwA_jEdwoFCA@mail.gmail.com> <871rliw9cq.fsf@kurt>
In-Reply-To: <871rliw9cq.fsf@kurt>
From:   Rob Herring <robh@kernel.org>
Date:   Mon, 13 Jul 2020 14:41:19 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJjjSCmijJsN5wH4VgmDCQdDhe7N3tWgzzS7oeqzZjzug@mail.gmail.com>
Message-ID: <CAL_JsqJjjSCmijJsN5wH4VgmDCQdDhe7N3tWgzzS7oeqzZjzug@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] dt-bindings: net: dsa: Add DSA yaml binding
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 11, 2020 at 5:59 AM Kurt Kanzenbach <kurt@linutronix.de> wrote:
>
> Hi,
>
> On Fri Jul 10 2020, Rob Herring wrote:
> > On Fri, Jul 10, 2020 at 11:20 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
> >>
> >>
> >>
> >> On 7/10/2020 9:45 AM, Rob Herring wrote:
> >> > On Fri, Jul 10, 2020 at 11:06:18AM +0200, Kurt Kanzenbach wrote:
> >> >> For future DSA drivers it makes sense to add a generic DSA yaml binding which
> >> >> can be used then. This was created using the properties from dsa.txt. It
> >> >> includes the ports and the dsa,member property.
> >> >>
> >> >> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
> >> >> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> >> >> ---
> >> >>  .../devicetree/bindings/net/dsa/dsa.yaml      | 80 +++++++++++++++++++
> >> >>  1 file changed, 80 insertions(+)
> >> >>  create mode 100644 Documentation/devicetree/bindings/net/dsa/dsa.yaml
> >> >>
> >> >> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> >> >> new file mode 100644
> >> >> index 000000000000..bec257231bf8
> >> >> --- /dev/null
> >> >> +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> >> >> @@ -0,0 +1,80 @@
> >> >> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> >> >> +%YAML 1.2
> >> >> +---
> >> >> +$id: http://devicetree.org/schemas/net/dsa/dsa.yaml#
> >> >> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> >> >> +
> >> >> +title: Distributed Switch Architecture Device Tree Bindings
> >> >
> >> > DSA is a Linuxism, right?
> >>
> >> Not really, it is a Marvell term that describes their proprietary
> >> switching protocol. Since then DSA within Linux expands well beyond just
> >> Marvell switches, so the terms have been blurred a little bit.
> >
> > Either way, sounds like the terminology here should be more general.
>
> How?

I don't know, just call it 'ethernet switch' binding or something.
>
> >
> > Though I missed that this is really just a conversion of dsa.txt which
> > should be removed in this patch. Otherwise, you'll get me re-reviewing
> > the binding.
>
> Yes, it's a conversion of the dsa.txt. I should have stated that more
> clearly. I didn't remove the .txt file, because it's referenced in all
> the different switch bindings such as b53.txt, ksz.txt and so on. How to
> handle that?

Either update them if not many, or make dsa.txt just point to dsa.yaml
as Andrew mentioned. I haven't looked, but seems like this would be a
small number.

Updating all the users to schema is also welcome. :)

> >> >> +
> >> >> +maintainers:
> >> >> +  - Andrew Lunn <andrew@lunn.ch>
> >> >> +  - Florian Fainelli <f.fainelli@gmail.com>
> >> >> +  - Vivien Didelot <vivien.didelot@gmail.com>
> >> >> +
> >> >> +description:
> >> >> +  Switches are true Linux devices and can be probed by any means. Once probed,
> >> >
> >> > Bindings are OS independent.
>
> OK.
>
> >> >
> >> >> +  they register to the DSA framework, passing a node pointer. This node is
> >> >> +  expected to fulfil the following binding, and may contain additional
> >> >> +  properties as required by the device it is embedded within.
> >> >
> >> > Describe what type of h/w should use this binding.
>
> I took the description from the dsa.txt. However, it makes sense to
> adjust that description. Basically all Ethernet switches with a
> dedicated CPU port should use DSA and this binding.
>
> >> >
> >> >> +
> >> >> +properties:
> >> >> +  $nodename:
> >> >> +    pattern: "^switch(@.*)?$"
> >> >> +
> >> >> +  dsa,member:
> >> >> +    minItems: 2
> >> >> +    maxItems: 2
> >> >> +    description:
> >> >> +      A two element list indicates which DSA cluster, and position within the
> >> >> +      cluster a switch takes. <0 0> is cluster 0, switch 0. <0 1> is cluster 0,
> >> >> +      switch 1. <1 0> is cluster 1, switch 0. A switch not part of any cluster
> >> >> +      (single device hanging off a CPU port) must not specify this property
> >> >> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> >> >> +
> >> >> +  ports:
> >> >> +    type: object
> >> >> +    properties:
> >> >> +      '#address-cells':
> >> >> +        const: 1
> >> >> +      '#size-cells':
> >> >> +        const: 0
> >> >> +
> >> >> +    patternProperties:
> >> >> +      "^port@[0-9]+$":
> >> >
> >> > As ports and port are OF graph nodes, it would be better if we
> >> > standardized on a different name for these. I think we've used
> >> > 'ethernet-port' some.
> >>
> >> Yes we did talk about that before, however when the original DSA binding
> >> was introduced about 7 years ago (or maybe more recently, my memory
> >> fails me now), "ports" was chosen as the encapsulating node. We should
> >> be accepting both ethernet-ports and ports.
> >
> > Yes, I'm aware of the history. Back then it was a free-for-all on node
> > names. Now we're trying to be more disciplined. Ideally, we pick
> > something unique to standardize on and fix the dts files to match as
> > long as the node name is generally a don't care for the OS.
> >
> > The schema says only port/ports is allowed,
>
> Yes, it does.
>
> > so at a minimum
> > ethernet-port/ethernet-ports needs to be added here.
>
> Just to be sure. Instead of
>
>   ports {
>     port@1 {
>       ...
>     }
>   }
>
> The following should be possible as well?
>
>   ethernet-ports {
>     port@1 {

Yes, but probably 'ethernet-port@1' here. Or both can be allowed.

>       ...
>     }
>   }
>
> Is there an easy way to add that alternative to the schema? Or does the
> ethernet-ports property has to be defined as well?

You need a pattern like:

patternProperties:
  "^(ethernet-)?ports$":
    ...

You could also make one property a $ref to another, but I prefer the above.

Rob
