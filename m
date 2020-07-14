Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF7D21E7F6
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 08:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgGNGTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 02:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgGNGTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 02:19:11 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33008C061755;
        Mon, 13 Jul 2020 23:19:11 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594707548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v/S9ee/bUUWrtlIuRaKnITeD/w1HyRpCSHHvDECwsQU=;
        b=f5pQaFBZPCc246hcRtfvdIxYw3gsShjZ//NN7S5l9RZYswj7ALM1mgtSDF6L0aqI1BQ1kL
        XlqHnbAZ9y7ei8Swh5mdKXsj3hsa2fkQZZIVWc+iy2w4fIxb7Pd020nBQ3L3dULHHTBtVx
        3rEKpw9yIBgaNeCoKIIHI8m7CRCJFL19XstIM4wOlSzp9j64tlc69nUE1mtLtdUhwRz3yR
        c9F/4j3+rzFkCMcuAf8Nna3O1lk/Gx9yVP8Gf9LRM3Xy2qUnM+WT5jGUW2TUTU9XRUjoJy
        VYA++QnLpQ2muy0nd905iERlnrrK/J1+CoNTNFNrJY/54inamw9d48c99CHAxw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594707548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v/S9ee/bUUWrtlIuRaKnITeD/w1HyRpCSHHvDECwsQU=;
        b=WHAP7lnpDb/B11Kn30Hw9HHB4rd8n8uYGntsXNBBzZ+RFHM88BeZyHOSFKZqUIPgHZ22F1
        uUJodHJefRWLq5Ag==
To:     Rob Herring <robh@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v1 1/1] dt-bindings: net: dsa: Add DSA yaml binding
In-Reply-To: <CAL_JsqJjjSCmijJsN5wH4VgmDCQdDhe7N3tWgzzS7oeqzZjzug@mail.gmail.com>
References: <20200710090618.28945-1-kurt@linutronix.de> <20200710090618.28945-2-kurt@linutronix.de> <20200710164500.GA2775934@bogus> <8c105489-42c5-b4ba-73b6-c3a858f646a6@gmail.com> <CAL_Jsq+zP9++MftM+Dh2Fe-OdKq6EiGA_tASEbBwA_jEdwoFCA@mail.gmail.com> <871rliw9cq.fsf@kurt> <CAL_JsqJjjSCmijJsN5wH4VgmDCQdDhe7N3tWgzzS7oeqzZjzug@mail.gmail.com>
Date:   Tue, 14 Jul 2020 08:18:57 +0200
Message-ID: <87k0z6wre6.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Rob,

On Mon Jul 13 2020, Rob Herring wrote:
> On Sat, Jul 11, 2020 at 5:59 AM Kurt Kanzenbach <kurt@linutronix.de> wrote:
>> How?
>
> I don't know, just call it 'ethernet switch' binding or something.

OK.

>> Yes, it's a conversion of the dsa.txt. I should have stated that more
>> clearly. I didn't remove the .txt file, because it's referenced in all
>> the different switch bindings such as b53.txt, ksz.txt and so on. How to
>> handle that?
>
> Either update them if not many, or make dsa.txt just point to dsa.yaml
> as Andrew mentioned. I haven't looked, but seems like this would be a
> small number.

OK.

>
> Updating all the users to schema is also welcome. :)
>
>> Just to be sure. Instead of
>>
>>   ports {
>>     port@1 {
>>       ...
>>     }
>>   }
>>
>> The following should be possible as well?
>>
>>   ethernet-ports {
>>     port@1 {
>
> Yes, but probably 'ethernet-port@1' here. Or both can be allowed.

I think both should be allowed. No binding is using
ethernet-port. They're all using ethernet-ports and port within
(example: ti,cpsw-switch.yaml).

But, if the binding does allow for ethernet-ports, then the DSA core has
to be adjusted, or? The current code searches only for "ports" (in
dsa_switch_parse_ports_of()).

>
>>       ...
>>     }
>>   }
>>
>> Is there an easy way to add that alternative to the schema? Or does the
>> ethernet-ports property has to be defined as well?
>
> You need a pattern like:
>
> patternProperties:
>   "^(ethernet-)?ports$":
>     ...

I see. Thanks!

>
> You could also make one property a $ref to another, but I prefer the
> above.

That's what I wanted to avoid.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8NTlEACgkQeSpbgcuY
8KYjog//Tr9f+p/xPVt/XVuaC/PiarBYGr5b72oyUbDATm5/DEt/WKK147dALpxi
MFBwlv/oHilGUqrnyVMJGSCHA3p6DQEeC1BKppIwg+OP1GRTk0stHGa4BAqVWc3J
YyGFnFI+lU+DLJokQ/G4cfsWtb4E0gnE9i8QYC/hv7mDZje1q1TVZXm8+L3KhK++
4h413eEgxyM6nmJS/c2opamBw1E5ClwX3ttRCMEx817Fr+Vd4GH74Gt+j8Jh3lHU
wAUPPQkvyqnhy1QiyXWxF5M/zvm3C+Kq0BHUguNrNpNmpDiLIZ6eLRJbm+tGj3qT
F40QBpYb7CN8QAl1+3b1b9VFdJ9Vbjs0bdvBUEWeTFKMkEp7y4s+2+046/C6tmum
TH6cJOQ8X5JIzeXxhDaUFXWP09NQkb1yTbjO379AICM43pH0pem/Nup2Vbzf947g
qTUvgP/uFE/40Mv1TNd6zABCNiUmAg04bZ/EnnB6b6UB3YwFN+G0hkD7ue0kdczv
4Y3Cgs0j/K8beKcr6BPTq16DOBmm9AaabVIE4GlObn04+s32zMobBk3LOB3xf4Wq
g7eelL+GWpfCWyDQ2s5x4c2EdqqdHikzpdyrmyQJQYrbUx+stCDQaUW0wkWsBSS4
eRqUaXxfIE5YkqUJ3WkAl3Wa8+hdPUzQ0nIZyt47ZJGmWQf0Yro=
=sK4k
-----END PGP SIGNATURE-----
--=-=-=--
