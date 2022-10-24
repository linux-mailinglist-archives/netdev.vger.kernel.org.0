Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0577260BF43
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 02:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiJYALL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 20:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbiJYAKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 20:10:53 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4345D24AAED;
        Mon, 24 Oct 2022 15:28:59 -0700 (PDT)
Received: from mercury (unknown [185.209.196.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 3FF466602820;
        Mon, 24 Oct 2022 23:28:53 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1666650533;
        bh=DSMOaz0bSVEM135EYGKdHyt8dv6g/81o2jOsEPTmjt0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CccIu3a0gJwdR9patHIs+EHGRyRtsd+TOd4mwzj09V6PGXbLmhIvvx2qm+b8bdHw7
         WrND0GIoo6By0kXgigfziOCvdlY/nB6UPHATA9DjvUr2roq3A/gVh6ED3Ial1UI0Wy
         +C4PM4B7VdvplAMiaLwq6aP9FEBjPtCd8I53RvKaaRPQe8XMHTNLzbrFNnPGudQJdD
         lxksbBPzaf+2P0SA4uZ8V7F7LV5VDPzgATo9kdEZkFMhYPUry8KTqp0U+SDUzvY9CJ
         2BdH9ne99wXS9U3BbeQfMcgIuEy5eXpFpYUZ8PaQgbCRIb+uxqArJ0pwBn+0SFv8bU
         pYsiQ8Hm04YMw==
Received: by mercury (Postfix, from userid 1000)
        id B8A4410607D6; Tue, 25 Oct 2022 00:28:50 +0200 (CEST)
Date:   Tue, 25 Oct 2022 00:28:50 +0200
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@collabora.com
Subject: Re: [PATCH 1/1] dt-bindings: net: snps,dwmac: Document queue config
 subnodes
Message-ID: <20221024222850.5zq426cnn75twmvn@mercury.elektranox.org>
References: <20221021171055.85888-1-sebastian.reichel@collabora.com>
 <761d6ae2-e779-2a4b-a735-960c716c3024@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vt336faofz3rlkrt"
Content-Disposition: inline
In-Reply-To: <761d6ae2-e779-2a4b-a735-960c716c3024@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vt336faofz3rlkrt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Oct 22, 2022 at 12:05:15PM -0400, Krzysztof Kozlowski wrote:
> On 21/10/2022 13:10, Sebastian Reichel wrote:
> > The queue configuration is referenced by snps,mtl-rx-config and
> > snps,mtl-tx-config. Most in-tree DTs put the referenced object
> > as child node of the dwmac node.
> >=20
> > This adds proper description for this setup, which has the
> > advantage of properly making sure only known properties are
> > used.
> >=20
> > Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> > ---
>> [...]
>=20
> Please update the DTS example with all this.

ok

>=20
> > =20
> >    snps,mtl-tx-config:
> >      $ref: /schemas/types.yaml#/definitions/phandle
> >      description:
> > -      Multiple TX Queues parameters. Phandle to a node that can
> > -      contain the following properties
> > -        * snps,tx-queues-to-use, number of TX queues to be used in the
> > -          driver
> > -        * Choose one of these TX scheduling algorithms
> > -          * snps,tx-sched-wrr, Weighted Round Robin
> > -          * snps,tx-sched-wfq, Weighted Fair Queuing
> > -          * snps,tx-sched-dwrr, Deficit Weighted Round Robin
> > -          * snps,tx-sched-sp, Strict priority
> > -        * For each TX queue
> > -          * snps,weight, TX queue weight (if using a DCB weight
> > -            algorithm)
> > -          * Choose one of these modes
> > -            * snps,dcb-algorithm, TX queue will be working in DCB
> > -            * snps,avb-algorithm, TX queue will be working in AVB
> > -              [Attention] Queue 0 is reserved for legacy traffic
> > -                          and so no AVB is available in this queue.
> > -          * Configure Credit Base Shaper (if AVB Mode selected)
> > -            * snps,send_slope, enable Low Power Interface
> > -            * snps,idle_slope, unlock on WoL
> > -            * snps,high_credit, max write outstanding req. limit
> > -            * snps,low_credit, max read outstanding req. limit
> > -          * snps,priority, bitmask of the priorities assigned to the q=
ueue.
> > -            When a PFC frame is received with priorities matching the =
bitmask,
> > -            the queue is blocked from transmitting for the pause time =
specified
> > -            in the PFC frame.
> > +      Multiple TX Queues parameters. Phandle to a node that
> > +      implements the 'tx-queues-config' object described in
> > +      this binding.
> > +
> > +  tx-queues-config:
> > +    type: object
> > +    properties:
> > +      snps,tx-queues-to-use:
> > +        $ref: /schemas/types.yaml#/definitions/uint32
> > +        description: number of TX queues to be used in the driver
> > +      snps,tx-sched-wrr:
> > +        type: boolean
> > +        description: Weighted Round Robin
> > +      snps,tx-sched-wfq:
> > +        type: boolean
> > +        description: Weighted Fair Queuing
> > +      snps,tx-sched-dwrr:
> > +        type: boolean
> > +        description: Deficit Weighted Round Robin
> > +      snps,tx-sched-sp:
> > +        type: boolean
> > +        description: Strict priority
> > +    patternProperties:
> > +      "^queue[0-9]$":
> > +        description: Each subnode represents a queue.
> > +        type: object
> > +        properties:
> > +          snps,weight:
> > +            $ref: /schemas/types.yaml#/definitions/uint32
> > +            description: TX queue weight (if using a DCB weight algori=
thm)
> > +          snps,dcb-algorithm:
> > +            type: boolean
> > +            description: TX queue will be working in DCB
> > +          snps,avb-algorithm:
>=20
> Is DCB and AVB compatible with each other? If not, then this should be
> rather enum (with a string for algorithm name).
>=20
> This applies also to other fields which are mutually exclusive.

Yes and I agree it is ugly. But this is not a new binding, but just
properly describing the existing binding. It's not my fault :)

> > +            type: boolean
> > +            description:
> > +              TX queue will be working in AVB.
> > +              Queue 0 is reserved for legacy traffic and so no AVB is
> > +              available in this queue.
> > +          snps,send_slope:
>=20
> Use hyphens, no underscores.
> (This is already an incompatible change in bindings, so we can fix up
> the naming)

No, this is not an incompatible change in the bindings. It's 100%
compatible. What this patch does is removing the text description
for 'snps,mtl-tx-config' and instead documenting the node in YAML
syntax. 'snps,mtl-tx-config' does not specify where this node should
be, so many DTS files do this:

ethernet {
    compatible =3D "blabla";
    snps,mtl-tx-config =3D <&eth_tx_setup>;
    snps,mtl-rx-config =3D <&eth_rx_setup>;

    eth_tx_setup: tx-queues-config {
        properties;
    };

    eth_rx_setup: rx-queues-config {
        properties;
    };
};

This right now triggers a dt-validate warning, because the binding
does not expect 'tx-queues-config' and 'rx-queues-config'. This
patch fixes the binding to allow that common setup. Also it improves
the validation for this common case. Having the queue config stored
somewhere else is still supported, but in that case the node is not
validated.

> > +            type: boolean
> > +            description: enable Low Power Interface
> > +          snps,idle_slope:
> > +            type: boolean
> > +            description: unlock on WoL
> > +          snps,high_credit:
> > +            type: boolean
> > +            description: max write outstanding req. limit
>=20
> Is it really a boolean?
>
> > +          snps,low_credit:
> > +            type: boolean
> > +            description: max read outstanding req. limit
>=20
> Same question

No, they are mistakes on my side. I will fix this in v2.

> > +          snps,priority:
> > +            $ref: /schemas/types.yaml#/definitions/uint32
> > +            description:
> > +              Bitmask of the tagged frames priorities assigned to the =
queue.
> > +              When a PFC frame is received with priorities matching th=
e bitmask,
> > +              the queue is blocked from transmitting for the pause tim=
e specified
> > +              in the PFC frame.
> > +    additionalProperties: false
> > =20
> >    snps,reset-gpio:
> >      deprecated: true

Thanks,

-- Sebastian

--vt336faofz3rlkrt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmNXEZ8ACgkQ2O7X88g7
+prUZhAAggHrtds4P7tj6UwZKlbRaSbYuggDdM5yO2DJMsexdTBWANLDpRrnq2hh
MdHuFs2xJjwuQLNwr198RMpm6GY4iJQ+PVjiaTSaReXZHj2snKrS+oBqKkS69qzB
DeZ6l/1e/O/eBmAHTXHQOEGt+Upgqh1kI4pB3WhVRIEaxZTbIt7CAN+GQNHSpu8r
7UDpIDkbjbpXlc31nvVJP4p50tUpAtBx14yfknL+plgn9AUwQ9HQ17HfWvMlCbCh
qhD3uvyYPWQ0cmXYZsoDDcQNXuLv1VueeXHtPPFkwsBSMZRAqqc8hgxrV0nesq3i
lxAWDCYSKuid4lL2F0eY12miL4q922EsQ/qSUA4SYAO5Nm3JW+2ozZRSYvLTN1iC
VgF9zY6sdOfYRPU2juo1LkcNjT23nT8552tmQ9i8Y6jyyxrFaMz8Il8FNjYR4SZa
KoPdhnJgTxZLNEtJXbMIoDktf90idm3r5kb0Y7mgwqd5kl5GCDNvYBONmuMsfrlx
3JKSfWAAW2x9a+d2lf5OyVxCp+56H7LjKq+Oi0T6NvkwGokTtPSX8KyYP/Ywz6CB
e+92vYFnjd+M5v1Ku7KlDGdYuvWUr5Fvo5SDjKv/FKvaVBFTAMt++2PQ0RmftwlO
GGwQaF/vQ9VoMRo3u3Ld1N0u2In/ZAJpbJcyTEsPfggmFcYKlmM=
=j9gW
-----END PGP SIGNATURE-----

--vt336faofz3rlkrt--
