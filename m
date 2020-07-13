Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE0821CFF3
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 08:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgGMGph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 02:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgGMGpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 02:45:36 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E93EC061794;
        Sun, 12 Jul 2020 23:45:36 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594622734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Kf/nuRryitoAmJQ9FWeY087byFdcNTAQOaJG29udnw0=;
        b=XEWFleZr0sHhedxUOMbSBzqxRLKbrf1FiW84VcKEGfxQ8Egz7DBDZdmFlSQ6j9GlBssV+d
        yXntHRrsjbI+eT4DU77kv1PNgFVXNoIpxBH2QRDxoMX5lsbvjeWGOBmclfv2WvRJ6OjyDd
        4L9edSO4v6Mt3hEASzcTtDEx4Grg4rISAfjqctRpgTlvDvgxnRkQKK9c9Az2FdL5hpXcIE
        3B9b2+pZbLpPmzpJ2vCiJMSJsVZBijDWF7lj20xEunGA5dRxVPd6eIuxpSoOay5CqMwd0K
        hryP/40oCsWQosZ59aAwO3hrDdm5Abgr2U2LV7jHezaY9if2bxek60VwRA+qxQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594622734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Kf/nuRryitoAmJQ9FWeY087byFdcNTAQOaJG29udnw0=;
        b=H9rYNp09dzFG+qQK2dNfMhI/myIHRNBvDNe3zs/4ilSQKrU2Oq7QlPHUFO/KSABjo9TM/t
        /cvF/hDfP9ITi0Cg==
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v1 8/8] dt-bindings: net: dsa: Add documentation for Hellcreek switches
In-Reply-To: <92b7dca3-f56d-ecb1-59c2-0981c2b99dad@gmail.com>
References: <20200710113611.3398-1-kurt@linutronix.de> <20200710113611.3398-9-kurt@linutronix.de> <92b7dca3-f56d-ecb1-59c2-0981c2b99dad@gmail.com>
Date:   Mon, 13 Jul 2020 08:45:33 +0200
Message-ID: <87mu43ncaa.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat Jul 11 2020, Florian Fainelli wrote:
> On 7/10/2020 4:36 AM, Kurt Kanzenbach wrote:
>> Add basic documentation and example.
>>=20
>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>> ---
>>  .../bindings/net/dsa/hellcreek.yaml           | 132 ++++++++++++++++++
>>  1 file changed, 132 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/dsa/hellcreek.=
yaml
>>=20
>> diff --git a/Documentation/devicetree/bindings/net/dsa/hellcreek.yaml b/=
Documentation/devicetree/bindings/net/dsa/hellcreek.yaml
>> new file mode 100644
>> index 000000000000..bb8ccc1762c8
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/dsa/hellcreek.yaml
>> @@ -0,0 +1,132 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/dsa/hellcreek.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: Hirschmann Hellcreek TSN Switch Device Tree Bindings
>> +
>> +allOf:
>> +  - $ref: dsa.yaml#
>> +
>> +maintainers:
>> +  - Andrew Lunn <andrew@lunn.ch>
>> +  - Florian Fainelli <f.fainelli@gmail.com>
>> +  - Vivien Didelot <vivien.didelot@gmail.com>
>
> Don't you want to add yourself here as well?

Sure.

>
>> +
>> +description:
>> +  The Hellcreek TSN Switch IP is a 802.1Q Ethernet compliant switch. It=
 supports
>> +  the Pricision Time Protocol, Hardware Timestamping as well the Time A=
ware

s/Pricision/Precision/g;

>> +  Shaper.
>> +
>> +properties:
>> +  compatible:
>> +    oneOf:
>> +      - const: hirschmann,hellcreek
>> +
>> +  reg:
>> +    description:
>> +      The physical base address and size of TSN and PTP memory base
>
> You need to indicate how many of these cells are required.

Yes.

>
>> +
>> +  reg-names:
>> +    description:
>> +      Names of the physical base addresses
>
> Likewise.
>
>> +
>> +  '#address-cells':
>> +    const: 1
>> +
>> +  '#size-cells':
>> +    const: 1
>
> Humm, not sure about those, you do not expose a memory mapped interface
> bus from this switch to another sub node.

True. That might be even different for other SoCs.

>
>> +
>> +  leds:
>> +    type: object
>> +    properties:
>> +      '#address-cells':
>> +        const: 1
>> +      '#size-cells':
>> +        const: 0
>> +
>> +    patternProperties:
>> +      "^led@[0-9]+$":
>> +          type: object
>> +          description: Hellcreek leds
>> +
>> +          properties:
>> +            reg:
>> +              items:
>> +                - enum: [0, 1]
>> +              description: Led number
>> +
>> +            label:
>> +              description: Label associated with this led
>> +              $ref: /schemas/types.yaml#/definitions/string
>> +
>> +            default-state:
>> +              items:
>> +                enum: ["on", "off", "keep"]
>> +              description: Default state for the led
>> +              $ref: /schemas/types.yaml#/definitions/string
>> +
>> +          required:
>> +            - reg
>
> Can you reference an existing LED binding by any chance?

Yes, we should reference leds/common.yaml somehow. Looking at
leds-gpio.yaml for example, it should be possible like this:

patternProperties:
  "^led@[0-9]+$":
      type: object
      description: Hellcreek leds

      $ref: ../../leds/common.yaml#

      [...]

But, how to express that only label and default-state should be used?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8MAw0ACgkQeSpbgcuY
8KYPzg//R5idczbboAKCnVnY4K7KSHLZ39RQEuwAdaEQ43EBMG/OG4XeW6NvuNBs
TRNF6dko9zhHYvEJxQjbtK/cE8gJhkOxPXzr1kmcfemiClio2tiIRnzuLbotHMxK
irUB/LRpG/K5H+qsw0R8liKqz8ma1GB/FQ8fYMjjirjpTr7R0Zp7D351s+RRen24
0PrewSKi+9kgqb+/WQpbT/qU4hETf9pZXUsewsJ0T5TnUi/8Tcwa5RnUFt1I2COa
D6VNjMSFT6HmsxOXnAdJBSwJl/bHOvPN1YZpxe+EoJLI71yxRY4r/tsRIKmKxpkX
gpqtOY0nPj4QeatvSwffpbUcy40RbDGzRzGfktC6/VhqNrk787+ASxzAoQoYgFOl
764pVv8It3tt6mGVQzPKruCrLJgjgPL9MHI2zii2ZeQ2C4+kLQjlIxBG57CREBKG
5+zF56jL04HzTF2R3J5jjTCc2qKx/qyWZhveGEimUrPprIKVgBYS7GQBmTqIJK/6
/k55xUQS2ngRkjSr3LbTjVx8vLW4R8mD4fKBgV2ir7lqbOeeu8X6H57dxXuAYvBh
npyaEHgZk7c7Gl0iN+Sn+3pjRaB1os1SJvyGpY4XjmQle8yUJVpX+3wuvQ3Y/pcH
x/b1TueKZzO1Npa3IaFCXFaJL+z2s8tn7tD6UwaXYPligWJKjz4=
=QLWv
-----END PGP SIGNATURE-----
--=-=-=--
