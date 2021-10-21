Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12EF436D47
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 00:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhJUWNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 18:13:50 -0400
Received: from ixit.cz ([94.230.151.217]:60682 "EHLO ixit.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230233AbhJUWNt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 18:13:49 -0400
Received: from [127.0.0.1] (ip-89-176-96-70.net.upcbroadband.cz [89.176.96.70])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ixit.cz (Postfix) with ESMTPSA id 5750320064;
        Fri, 22 Oct 2021 00:11:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
        t=1634854290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ei8POAb+X6oO+/oTFo2niVhFPP85+JXrdHFErDGQUwc=;
        b=i1qhKDaV9RFi1sYnf64cAlk9NnxJql95fj0el3CTAT2EUp5P64H/dxF+NkCBRa2eC8qcvW
        87TQwz9gDsqke1pyne8Q1oXzyzt94gUfkB4+r1AddzowomBWE4QHNOR/+bDK1a/nDLFrcH
        x9bsQzspusbJ+1YJ29+naBnb9/pxgH8=
Date:   Thu, 21 Oct 2021 22:11:29 +0000
From:   David Heidelberg <david@ixit.cz>
To:     Alex Elder <elder@ieee.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Alex Elder <elder@kernel.org>
CC:     ~okias/devicetree@lists.sr.ht, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_1/2=5D_dt-bindings=3A_net=3A_qco?= =?US-ASCII?Q?m=2Cipa=3A_describe_IPA_v4=2E5_interconnects?=
In-Reply-To: <05b2cc69-d8a4-750d-d98d-db8580546a15@ieee.org>
References: <20211020225435.274628-1-david@ixit.cz> <05b2cc69-d8a4-750d-d98d-db8580546a15@ieee.org>
Message-ID: <C9217CCA-1A9B-40DC-9A96-13655270BA8F@ixit.cz>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Alex,

it's make dtbs_check (for me with ARCH=3Darm)

David


-------- P=C5=AFvodn=C3=AD zpr=C3=A1va --------
Odes=C3=ADlatel: Alex Elder <elder@ieee=2Eorg>
Odesl=C3=A1no: 21=2E =C5=99=C3=ADjna 2021 20:35:14 UTC
Komu: David Heidelberg <david@ixit=2Ecz>, Andy Gross <agross@kernel=2Eorg>=
, Bjorn Andersson <bjorn=2Eandersson@linaro=2Eorg>, "David S=2E Miller" <da=
vem@davemloft=2Enet>, Jakub Kicinski <kuba@kernel=2Eorg>, Rob Herring <robh=
+dt@kernel=2Eorg>, Alex Elder <elder@kernel=2Eorg>
Kopie: ~okias/devicetree@lists=2Esr=2Eht, linux-arm-msm@vger=2Ekernel=2Eor=
g, netdev@vger=2Ekernel=2Eorg, devicetree@vger=2Ekernel=2Eorg, linux-kernel=
@vger=2Ekernel=2Eorg
P=C5=99edm=C4=9Bt: Re: [PATCH 1/2] dt-bindings: net: qcom,ipa: describe IP=
A v4=2E5 interconnects

On 10/20/21 5:54 PM, David Heidelberg wrote:
> IPA v4=2E5 interconnects was missing from dt-schema, which was trigering
> warnings while validation=2E
>=20
> Signed-off-by: David Heidelberg <david@ixit=2Ecz>

Can you please tell me a command to use to trigger
the warnings you are seeing?  I don't see an error
when building "dtbs" or doing "dt_binding_check"=2E

Thanks=2E

					-Alex

> ---
>   Documentation/devicetree/bindings/net/qcom,ipa=2Eyaml | 10 ++++++++++
>   1 file changed, 10 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa=2Eyaml b/Doc=
umentation/devicetree/bindings/net/qcom,ipa=2Eyaml
> index b8a0b392b24e=2E=2Ea2835ed52076 100644
> --- a/Documentation/devicetree/bindings/net/qcom,ipa=2Eyaml
> +++ b/Documentation/devicetree/bindings/net/qcom,ipa=2Eyaml
> @@ -95,6 +95,11 @@ properties:
>             - description: Path leading to system memory
>             - description: Path leading to internal memory
>             - description: Path between the AP and IPA config space
> +      - items: # IPA v4=2E5
> +          - description: Path leading to system memory region A
> +          - description: Path leading to system memory region B
> +          - description: Path leading to internal memory
> +          - description: Path between the AP and IPA config space
>       interconnect-names:
>       oneOf:
> @@ -105,6 +110,11 @@ properties:
>             - const: memory
>             - const: imem
>             - const: config
> +      - items: # IPA v4=2E5
> +          - const: memory-a
> +          - const: memory-b
> +          - const: imem
> +          - const: config
>       qcom,smem-states:
>       $ref: /schemas/types=2Eyaml#/definitions/phandle-array
>=20

