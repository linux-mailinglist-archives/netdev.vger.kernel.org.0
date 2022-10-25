Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360B860CEC2
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbiJYOSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbiJYOSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:18:01 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE70B46DBE;
        Tue, 25 Oct 2022 07:17:47 -0700 (PDT)
Received: from mercury (dyndsl-095-033-154-085.ewe-ip-backbone.de [95.33.154.85])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 9692D66017D3;
        Tue, 25 Oct 2022 15:17:34 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1666707454;
        bh=n69auhz0Ir0VGRIA5Bye37d1x6LLrH8ICp6KQcQA+8c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oCtHezU1Ok3oYWhsSRhZCr0wT9aISnoiWLqTGmnJpa2pQ01K2feGoMToVu5H0/F35
         9MQr6opKRN/dmBayoL9AmB36wqq8lf/PAlqi9h3qOieUjArSlnhg8g1Lf36WCtdiHf
         eqaSTH7MOf7w0urxr1OG1Ym3mwDePBjq9resKtIXrL7Pbzp8UEf/fAFI6TLq1RQ/Rp
         YEFRUPGN4VGfj9i6ZiPXLWE2PUdyRo85LhWYK4hzV6HE/CJ9KDto6DRCpDM6hxtwml
         BLtI52iHB6To+JPqn3S87Ryzx2YAaI4qePG6GXG1j0ibi5irOrS+0PbAFmL6yB6Ndu
         mSrICxIt9FUJA==
Received: by mercury (Postfix, from userid 1000)
        id 43E5C10607D6; Tue, 25 Oct 2022 16:17:32 +0200 (CEST)
Date:   Tue, 25 Oct 2022 16:17:32 +0200
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
Message-ID: <20221025141732.z65kswaptgeuz2cl@mercury.elektranox.org>
References: <20221021171055.85888-1-sebastian.reichel@collabora.com>
 <761d6ae2-e779-2a4b-a735-960c716c3024@linaro.org>
 <20221024222850.5zq426cnn75twmvn@mercury.elektranox.org>
 <aa146042-2130-9fc3-adcd-c6d701084b4a@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mydihmwcuy62wu5n"
Content-Disposition: inline
In-Reply-To: <aa146042-2130-9fc3-adcd-c6d701084b4a@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mydihmwcuy62wu5n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Mon, Oct 24, 2022 at 07:28:29PM -0400, Krzysztof Kozlowski wrote:
> Old binding did not document "tx-queues-config". Old binding had
> "snps,mtl-tx-config" which was a phandle, so this is an ABI break of
> bindings.
>
> You are changing the binding - adding new properties.

The new binding still has the phandle. The only thing I changed is
explicitly allowing the referenced node to be a subnode of the dwmac
node. This is 100% compatible, since the binding does not specify
where the referenced node should be. Only the example suggested it
could be next to the ethernet node. But changing any properties in
the config node means a ABI break requiring code changes.

Note, that right now 4/7 devicetrees with snps,mtl-tx-config already
follow the scheme I documented. The other 3 have the queue config
below the root node like the current example:

has the queues config in /:
 * arch/arm/boot/dts/artpec6.dtsi
 * arch/arm64/boot/dts/mediatek/mt2712e.dtsi
 * arch/arm64/boot/dts/qcom/sa8155p-adp.dts

has the queues config in the ethernet node:
 * arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi
 * arch/arm64/boot/dts/freescale/imx8mp-evk.dts
 * arch/arm64/boot/dts/rockchip/rk3568.dtsi
 * arch/arm64/boot/dts/rockchip/rk356x.dtsi

After my change both are considered valid. Anyways I'm doing this
for rk3588 and planned to follow the subnode style. But if I have
to fully fix this mess I will just put the queue config to the
root node instead and let somebody else figure this out.

-- Sebastian

--mydihmwcuy62wu5n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmNX7/EACgkQ2O7X88g7
+pqxixAAixJg4jKnLIysudmOG3bwFNtz/E0sXxWmxFPMDK8dm0zwNVq1b1kP3prG
xyEy7uqMRw1l5JzcmaQTkFbDjBVA0BLHGwY31/FEU5MR4ElFKqWdkFzkt3oV6N5b
+RUOd1SYAPngXZlbwcegdDirl+fMBOvS4KyJxEmlaxka0HQ5eLU5jdK7QWc6dhnL
eKdfch2qVThP3K00Oz47hQEpqWaGZUv8KmxMPTgHZTElx/lkOjKyMj9ATIS/2Wlc
2gH608dBl8OqOmC9dyMCMxFHECK1qIkizebKkSQNRn1FudDlbgTFSNdJpjSCUBRo
V9fwJc8ZeJKNf/fmh+eHoXG751pOVKT8ica2Akiba4M4TbwJ5Hej0q+DI8li43zE
F+XKzg8jxXguKus74HF2rewG/+LqSz2XhfgZC1OqEB8uyBZu9SeAzNwONQ9L49Mt
OsYtOobXRiFQ+a5AJQtIsR3UBqD6L1lgRvb8MWk04EJ75jk4grxDbMAF8cRXY6pn
f3y9YxevlGmzh+xUThA/PLx55N15PRWfAYUOELcvsyKlzToS8N/lDrvUUTp+MTbr
yTvBSzC7poEN1lLm3VWBuIIJpmO3ZgERVrMRO3EXtrR801+fjBH8fm/33sLyFNdE
yMNecsOaBb8E8ixFzLcZtaQXc2gjAZJ4OTnpQbI6F+ACuFkYcAI=
=9qXU
-----END PGP SIGNATURE-----

--mydihmwcuy62wu5n--
