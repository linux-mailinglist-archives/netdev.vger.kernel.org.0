Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7668581297
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 14:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238969AbiGZMBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 08:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239033AbiGZMAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 08:00:46 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431EF32ED2;
        Tue, 26 Jul 2022 05:00:45 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1658836842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vuUtdzjfdpLaDm0Xj29b8qdtw+eGj7xd6Mtgh5eeL8U=;
        b=OoNS1vk4OWAuJSgFL1y6FSQxEsx3nUB6Siu1u/7KXkerKbjNzA4/i5adk7hgRmMGbzSSLB
        RfnMfPAxVAMawa5YwKwuHUY6xPZ2GAq7rDRLufYZGCEhuqbso2darxXyvjr9/7Jn/+Eq4E
        pV5NIAPFJz+jq1CNQsGIxhdsMUTz9VEjJLtcw30DZoxHCXGKrOyT7NSKW1soslyeUjjq32
        m/ssHydSTYvOE+aPYBdeGj53TFKsQe4RTa79DoMZP6z6VW8cbA6ixhPu9uxx6mt87EzlBE
        9FBTZU50LB2K2jiBAb7eq5ey3zoMrcl81581r/YHEtnjQskxZdZ9YSlaFfLEuA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1658836842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vuUtdzjfdpLaDm0Xj29b8qdtw+eGj7xd6Mtgh5eeL8U=;
        b=lrviFpvLXZipPYeyL5NH6xhMlLhndkuP6xI1MVIad4fz+gBNR7Mqze9GI8M65lSqcvYpf0
        TKVRmH/xmXtNsKBQ==
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: Re: [PATCH] dt-bindings: net: hirschmann,hellcreek: use absolute
 path to other schema
In-Reply-To: <20220726115650.100726-1-krzysztof.kozlowski@linaro.org>
References: <20220726115650.100726-1-krzysztof.kozlowski@linaro.org>
Date:   Tue, 26 Jul 2022 14:00:40 +0200
Message-ID: <87pmhsf5hz.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Tue Jul 26 2022, Krzysztof Kozlowski wrote:
> Absolute path to other DT schema is preferred over relative one.
>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Acked-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmLf12gTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgulzEACkltGhaXSH9Cnp9pqpvukbZZTi5sm3
R1UfDJXTHR5aWj8qOx7CFjzm6TTdtGLZ9t8rx+SXP3gYYotGAfgOvcngsVKXccoR
+JNffngJ70Zu2CdXuS+sgZ3MLRI56/bhBDpT9uPCMhsRa26s6myja515Jt1KBOKZ
TVHAqoNPT3aU8U+d8r0TqcOD9+ahxyKCxh3JlPnLD1gg4GjgC24ObnvNY9CxvpGh
i0i3qzSXSQZpRzs2Jg3Gd1fTju3s+9Rxn/4axrqDISGfHez73YOQG0Byl9yNvQYM
9PIFoMIpxGAyiRJJa6R7hoYKuRXa/xapz24ROkGq+rEo1JcDWaKSwT260d+wkXf1
JnNQFgv0Y2fgQ4MM7Ij/c0Pdami1PiHwp++Hw5U7PdrRSSzmnQKW1C0nU89ormgn
iLA1MPTK+1uAvIYbKfruhjHa/o2+8tOXF7R9s44ToQcdBD3XvKuiSYLzJZwFDA+/
iZuCbZ9gRjwyl/v5Hq0o2ZGDVNBeWp994jFSIzq025Dpg89GZpULH2/dmh5spCTo
dh3oo7oPyB9ITmhblLKjHY0pb/jtEQhFYc4jeuXu7E7HxFr0JxwxAPPZJprjGmxV
CK21rjlRoIGfqCumCB/7wL1W+DtTcMK6ay5IwFsKtCOAKNI/3Dduy6gvNMDyzEY8
uUWkwbfOVkmspg==
=I87M
-----END PGP SIGNATURE-----
--=-=-=--
