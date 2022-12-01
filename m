Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADE563EE11
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 11:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiLAKkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 05:40:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbiLAKkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 05:40:07 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68E09493D;
        Thu,  1 Dec 2022 02:40:06 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NNCJN4W7qz4xFy;
        Thu,  1 Dec 2022 21:40:04 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1669891204;
        bh=KTDVN/7lIjIrER/XXkOz9H8eWtf2nxvkUgRAGM5il/U=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=mtH77xWqReqw3bUURmWOaOMUgI1fnhJeqxa/jFrTE2AiPxZgRHJOdcrEogd7m6t+K
         hSD5E6U7i+ckFXkoXJyBCf9GV9mhqfTh6a2EhgZiI/SRGv0KENZChmJYXHVWQJ6yRk
         6YrETuvLSFH3GLBrIHlAqPWESejuap3arDVMjfILKy+BGr1aGCqxlVdA7HLC4kSTkB
         h2Fc1q1HQQmg4WuwySsEcmNguqQitD5GKa/mEHq6/vneU8YBjQFOfp9St3mhaor2x1
         6DM3kpUr8F1g1c/fjGREENP6GL+7W1pjUv9OMijMtZXQ/VLwrb7rHigKdo6xpjkop7
         l5PmypY+0tAfg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 5/5] powerpc: dts: remove label = "cpu" from DSA dt-binding
In-Reply-To: <20221130141040.32447-6-arinc.unal@arinc9.com>
References: <20221130141040.32447-1-arinc.unal@arinc9.com>
 <20221130141040.32447-6-arinc.unal@arinc9.com>
Date:   Thu, 01 Dec 2022 21:40:03 +1100
Message-ID: <87a647s8zg.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com> writes:
> This is not used by the DSA dt-binding, so remove it from all devicetrees.
>
> Signed-off-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> ---
>  arch/powerpc/boot/dts/turris1x.dts | 2 --
>  1 file changed, 2 deletions(-)

Adding Pali to Cc.

These were only recently updated in commit:

  8bf056f57f1d ("powerpc: dts: turris1x.dts: Fix labels in DSA cpu port nod=
es")

Which said:

  DSA cpu port node has to be marked with "cpu" label.

But if the binding doesn't use them then I'm confused why they needed to
be updated.

cheers


> diff --git a/arch/powerpc/boot/dts/turris1x.dts b/arch/powerpc/boot/dts/t=
urris1x.dts
> index 045af668e928..3841c8d96d00 100644
> --- a/arch/powerpc/boot/dts/turris1x.dts
> +++ b/arch/powerpc/boot/dts/turris1x.dts
> @@ -147,7 +147,6 @@ ports {
>=20=20
>  					port@0 {
>  						reg =3D <0>;
> -						label =3D "cpu";
>  						ethernet =3D <&enet1>;
>  						phy-mode =3D "rgmii-id";
>=20=20
> @@ -184,7 +183,6 @@ port@5 {
>=20=20
>  					port@6 {
>  						reg =3D <6>;
> -						label =3D "cpu";
>  						ethernet =3D <&enet0>;
>  						phy-mode =3D "rgmii-id";
>=20=20
> --=20
> 2.34.1
