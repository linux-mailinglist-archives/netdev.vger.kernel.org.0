Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E497321C401
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 13:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgGKLf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 07:35:29 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53808 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbgGKLf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 07:35:29 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594467326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DgnS2u/iZEVZUFMYv/l3fA9kTrSNsYlDPdDSbnGCtnA=;
        b=MyRqZkHNqgmXRO+II7wtGu4lp41woc9bM50qsxTiZeHrBvQTEs4DQOypvqfKwsGJ+yFbs+
        Js9DE0Zjxp89OghXKINbnaRWSH6cQ1gZzkJGHbkTabSDoK9uX5IbqJrPUcn0niKTw+kXSm
        NVwPADgxiWa3LIlHc2LPjfA74PCa+u5owm4yBqXv1Vj85ZVaj5NCFmqyxGJiipQiFLjp0Q
        xz7WM2rUQZ47AXFCiLc/As0zNYtz4I+Yc+2tcgl8/Z/7RII5JonXvfpUQYlxFXJifg+mej
        l/V+2j/uPl49ewsvJbi/SdvQNql43++GfEA7sItGwaZAln0h+eoPEti+4Kql8A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594467326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DgnS2u/iZEVZUFMYv/l3fA9kTrSNsYlDPdDSbnGCtnA=;
        b=5y9NRFdh2SVWFfsCKr3Zjat/8HwNC/EkpwchTco90hwMZ4aBYebtau/5rko1GtMnD1Dx8S
        AMaJSr3TSeZotWAg==
To:     Rob Herring <robh@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v1 1/1] dt-bindings: net: dsa: Add DSA yaml binding
In-Reply-To: <20200710163940.GA2775145@bogus>
References: <20200710090618.28945-1-kurt@linutronix.de> <20200710090618.28945-2-kurt@linutronix.de> <20200710163940.GA2775145@bogus>
Date:   Sat, 11 Jul 2020 13:35:12 +0200
Message-ID: <874kqewahb.fsf@kurt>
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

On Fri Jul 10 2020, Rob Herring wrote:
> On Fri, 10 Jul 2020 11:06:18 +0200, Kurt Kanzenbach wrote:
>> For future DSA drivers it makes sense to add a generic DSA yaml binding =
which
>> can be used then. This was created using the properties from dsa.txt. It
>> includes the ports and the dsa,member property.
>>=20
>> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>> ---
>>  .../devicetree/bindings/net/dsa/dsa.yaml      | 80 +++++++++++++++++++
>>  1 file changed, 80 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/dsa/dsa.yaml
>>=20
>
>
> My bot found errors running 'make dt_binding_check' on your patch:
>
> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/=
ti,cpsw-switch.example.dt.yaml: switch@0: 'ports' is a required property
> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/=
qcom,ipq8064-mdio.example.dt.yaml: switch@10: 'ports' is a required property

Okay, the requirement for 'ports' has be to removed.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8Jo/AACgkQeSpbgcuY
8KaLXA/+NPPoaiikeFDzjgjRt4O12iCt5MG0wwBb5VHk3d9B4Y666hFDtv+qxhtD
ZBHuhx2nycKyVAORa4oa7cvEtKlwWRokgDpSe9qyTXs9RpZN7S1dbBc+s9UhteQN
j8ndkSndrNe40Iw+4ru0f5NljQB4cTcf8gV8417LPUY6P2cHxrAv6ANuE0zFT1Ws
T7XgqGftaWo1324KaZQHCjo0Y/B+GZjyB/lbgJ9h2mMe839gebeghoRSlcDiQweh
xZqrWTkznAFUjT4KPoPyucAGz1hOp+jFWuPQlCnsEZx1UFx8Ukzfqo+DfsfZ1YHk
cAz24LwXYbm31eZ4Jvf3ptKvGi7x5KxufD2RxHV5dh5U6+mdDPRvDaw2ty2++X1R
7xiN9a6n2wHrbT4qHnPrGq3P/xtGsWkLXF3WbHo+FXr8y3o75AnMi9abG9l1YhWY
thD1UElZCcDM7SqGIZ+3HSPMio+gw0HWS49mqetIPLjNd8fKBEWFi6fSo0DGcgS3
szdVPMbKxMJZOul1SI28i0/Qi08nWImtKV9ZoD2XoN2mYnkE2M3lBcizemvMT5I7
+2Bm20UGlD1B0PAtvQUrZLs/9VcR5TE8lVQVuDTWGizkelDZaLjMlaBH2s941AZ7
NFOfdK3PP0r4uhipzTMUutAADqBLb1PokrO+2yxIR7lFJPMAy8k=
=bQlp
-----END PGP SIGNATURE-----
--=-=-=--
