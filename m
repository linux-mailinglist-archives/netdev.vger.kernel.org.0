Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B8621C41A
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 13:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgGKL7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 07:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgGKL7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 07:59:37 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B603C08C5DD;
        Sat, 11 Jul 2020 04:59:36 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594468774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r/ZB0aH7Lk6222wmBa/3Gm841BbvM+uw3UE2TJX53Es=;
        b=ZHnuYHFiJHA9qzMvQ0E+Po40sDqnwXODGaj3YqLMhcht6joMAKHOqXRgbGYgBVpSUAnMqb
        91rEDny6G7dZ2nEg4SSVNjOTnbTugeL10ZGJiUybjFwgalW7UN/b1woksEoPskc45vTNTi
        5ZfyD4RtVGhghC6Y1kAxh9dyRBHW50GXEYsHaUEKWTDfOOhNBO9zELOuJE+aMWnA2B431u
        dt5liyyhOIUQYy1gVsibK8nf7MSmOgD6yC6rHM0lbplY99k6xPuqAAi6znBlE++8NqsLS/
        IdiVdm1Dq11/EiFPpsbehoTtQqfcoEe/p2Ya6UwiS4pEZj8JcH+yeBMGuDvmtw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594468774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r/ZB0aH7Lk6222wmBa/3Gm841BbvM+uw3UE2TJX53Es=;
        b=GOT1dMz4ILKq5x9Hu6YtJmhHaxDzePmDpPDtHqFgxamdIkqQQsNou1rkjohU1qEb5WycDK
        grOt9q+dV0ZLhdAg==
To:     Rob Herring <robh@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v1 1/1] dt-bindings: net: dsa: Add DSA yaml binding
In-Reply-To: <CAL_Jsq+zP9++MftM+Dh2Fe-OdKq6EiGA_tASEbBwA_jEdwoFCA@mail.gmail.com>
References: <20200710090618.28945-1-kurt@linutronix.de> <20200710090618.28945-2-kurt@linutronix.de> <20200710164500.GA2775934@bogus> <8c105489-42c5-b4ba-73b6-c3a858f646a6@gmail.com> <CAL_Jsq+zP9++MftM+Dh2Fe-OdKq6EiGA_tASEbBwA_jEdwoFCA@mail.gmail.com>
Date:   Sat, 11 Jul 2020 13:59:33 +0200
Message-ID: <871rliw9cq.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi,

On Fri Jul 10 2020, Rob Herring wrote:
> On Fri, Jul 10, 2020 at 11:20 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>>
>>
>> On 7/10/2020 9:45 AM, Rob Herring wrote:
>> > On Fri, Jul 10, 2020 at 11:06:18AM +0200, Kurt Kanzenbach wrote:
>> >> For future DSA drivers it makes sense to add a generic DSA yaml binding which
>> >> can be used then. This was created using the properties from dsa.txt. It
>> >> includes the ports and the dsa,member property.
>> >>
>> >> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
>> >> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>> >> ---
>> >>  .../devicetree/bindings/net/dsa/dsa.yaml      | 80 +++++++++++++++++++
>> >>  1 file changed, 80 insertions(+)
>> >>  create mode 100644 Documentation/devicetree/bindings/net/dsa/dsa.yaml
>> >>
>> >> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
>> >> new file mode 100644
>> >> index 000000000000..bec257231bf8
>> >> --- /dev/null
>> >> +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
>> >> @@ -0,0 +1,80 @@
>> >> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> >> +%YAML 1.2
>> >> +---
>> >> +$id: http://devicetree.org/schemas/net/dsa/dsa.yaml#
>> >> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> >> +
>> >> +title: Distributed Switch Architecture Device Tree Bindings
>> >
>> > DSA is a Linuxism, right?
>>
>> Not really, it is a Marvell term that describes their proprietary
>> switching protocol. Since then DSA within Linux expands well beyond just
>> Marvell switches, so the terms have been blurred a little bit.
>
> Either way, sounds like the terminology here should be more general.

How?

>
> Though I missed that this is really just a conversion of dsa.txt which
> should be removed in this patch. Otherwise, you'll get me re-reviewing
> the binding.

Yes, it's a conversion of the dsa.txt. I should have stated that more
clearly. I didn't remove the .txt file, because it's referenced in all
the different switch bindings such as b53.txt, ksz.txt and so on. How to
handle that?

>
>> >> +
>> >> +maintainers:
>> >> +  - Andrew Lunn <andrew@lunn.ch>
>> >> +  - Florian Fainelli <f.fainelli@gmail.com>
>> >> +  - Vivien Didelot <vivien.didelot@gmail.com>
>> >> +
>> >> +description:
>> >> +  Switches are true Linux devices and can be probed by any means. Once probed,
>> >
>> > Bindings are OS independent.

OK.

>> >
>> >> +  they register to the DSA framework, passing a node pointer. This node is
>> >> +  expected to fulfil the following binding, and may contain additional
>> >> +  properties as required by the device it is embedded within.
>> >
>> > Describe what type of h/w should use this binding.

I took the description from the dsa.txt. However, it makes sense to
adjust that description. Basically all Ethernet switches with a
dedicated CPU port should use DSA and this binding.

>> >
>> >> +
>> >> +properties:
>> >> +  $nodename:
>> >> +    pattern: "^switch(@.*)?$"
>> >> +
>> >> +  dsa,member:
>> >> +    minItems: 2
>> >> +    maxItems: 2
>> >> +    description:
>> >> +      A two element list indicates which DSA cluster, and position within the
>> >> +      cluster a switch takes. <0 0> is cluster 0, switch 0. <0 1> is cluster 0,
>> >> +      switch 1. <1 0> is cluster 1, switch 0. A switch not part of any cluster
>> >> +      (single device hanging off a CPU port) must not specify this property
>> >> +    $ref: /schemas/types.yaml#/definitions/uint32-array
>> >> +
>> >> +  ports:
>> >> +    type: object
>> >> +    properties:
>> >> +      '#address-cells':
>> >> +        const: 1
>> >> +      '#size-cells':
>> >> +        const: 0
>> >> +
>> >> +    patternProperties:
>> >> +      "^port@[0-9]+$":
>> >
>> > As ports and port are OF graph nodes, it would be better if we
>> > standardized on a different name for these. I think we've used
>> > 'ethernet-port' some.
>>
>> Yes we did talk about that before, however when the original DSA binding
>> was introduced about 7 years ago (or maybe more recently, my memory
>> fails me now), "ports" was chosen as the encapsulating node. We should
>> be accepting both ethernet-ports and ports.
>
> Yes, I'm aware of the history. Back then it was a free-for-all on node
> names. Now we're trying to be more disciplined. Ideally, we pick
> something unique to standardize on and fix the dts files to match as
> long as the node name is generally a don't care for the OS.
>
> The schema says only port/ports is allowed,

Yes, it does.

> so at a minimum
> ethernet-port/ethernet-ports needs to be added here.

Just to be sure. Instead of

  ports {
    port@1 {
      ...
    }
  }

The following should be possible as well?

  ethernet-ports {
    port@1 {
      ...
    }
  }

Is there an easy way to add that alternative to the schema? Or does the
ethernet-ports property has to be defined as well?

>
>>
>> >
>> >> +          type: object
>> >> +          description: DSA switch ports
>> >> +
>> >> +          allOf:
>> >> +            - $ref: ../ethernet-controller.yaml#
>> >
>> > How does this and 'ethernet' both apply?
>>
>> I think the intent here was to mean that some of the properties from the
>> Ethernet controller such as phy-mode, phy-handle, fixed-link also apply
>> here since the switch port is a simplified Ethernet MAC on a number of
>> counts.
>
> Okay, it's good to explicitly define which of those apply as I imagine
> some don't. Just need "<prop>: true" to do that.

Yes, that was my intent. Only a few properties from the Ethernet
controller are needed. I'll add them like you suggested.

>
> Rob

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8JqaUACgkQeSpbgcuY
8KZk0xAAzyYFGOGGHbdoEQVnTG0GUNCaD4qd6qSpt9YEjE3/w5MB0Tfnsrfd0Du9
w9v5ZKF9nVVB0HrjiCKdoVP36sM3MEy8XfH/9RY2dUJqbgp/dgeJBhkwWEA4glM/
pagFc0bVgH0r9t6IajsLzJZy354HswShe9XncIKUPszVGo+/vXO/l/byoF7akTZD
setf0HzfMLfEH60e1FEAt9Z4J6R1aAEI0YLsBsNK1LcoNDuWu48d1cbJJXTa/Jcx
W3En9KLyZ7uRCjC8UPYPs/bmx0nFUOzczZ8A1cZt7eJEN4FVzg6xA3341i+oD9cn
ZiLfdq4dSnhMeY0DtLIUdQ1mUhHRJPoAhdM3WrIN4q6WDsyJo84MEMc0BYn34/eG
fq3RHnF0ns7Au/W2VQwOt7OZ8TjBdYsdGalC44M0qn1KwrWzuF0F9fw4Trw5klFS
18kI4sAYRwpwMC5+4sTwL9mWWcCGAV+D+qq4+EZoBJCX7OwrMepjm/xc0WQWI+/1
oXlcx5nZVkWRpUrCZb8mee/WsIJ+nX6thPmLfFyxqJ1c1kw6s/VlfNrWRQUro4/G
E7ge1djJXNEph97PF0oq90XkmEsF5+HwrrQocuuPbHA0m0B59GrsJzxB4WS+rKkl
0HFbAH1hbiDuc4TCFVIjOPZoM0Ov6yn+woabn95yW0fZ29YY/xA=
=CHYY
-----END PGP SIGNATURE-----
--=-=-=--
