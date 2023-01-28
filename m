Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8558067F7BC
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 13:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234054AbjA1MFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 07:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbjA1MFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 07:05:44 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F27790BE
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:05:43 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1674907541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1wMoI9B260N8M/m/LDN4UKduCekJ4x1ZgJ0t5YYP2tA=;
        b=u8neHnjOC5LLSjL9zcw4VyPyg2SPzwotXa2ZH4/t0n3XVsgOzzHEnLmceLd4iIzNUSKcNw
        xDnpJjyq8BpZ/0nnYRLw21Fbminxna6qcTXYFezQBbL3l9DGy2IcwV3pdW4SlwFocyzb88
        O/34X+VKiSarBQQC9HxUwRieWaXxzWEWZskSibqhFzSKuJ0MHe3lbS7PSQVf8amNm8n75x
        BocqPu9BCv++Hp1zn28NIKgIihI9HBx3OOQ6DITW42RK8IlT39Sg/YEXcQWKmIRn3cabK5
        w89XAToR2keXoLHL6nqKpI5G6hbA0ZBRKLKakwWOx7gaFPEBVuEvHJuKjpwhLQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1674907541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1wMoI9B260N8M/m/LDN4UKduCekJ4x1ZgJ0t5YYP2tA=;
        b=+FX981rEzA0Ro64lYWHRdmsHjMivfwRZJV9b1wxfcJJmPNe7ivxarShzpYZOx3biz4vjlo
        XXiL7XTbe4HuujBQ==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [RFC PATCH net-next 08/15] net/sched: taprio: calculate budgets
 per traffic class
In-Reply-To: <20230128010719.2182346-9-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
 <20230128010719.2182346-9-vladimir.oltean@nxp.com>
Date:   Sat, 28 Jan 2023 13:05:40 +0100
Message-ID: <87bkmivp7v.fsf@kurt>
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

On Sat Jan 28 2023, Vladimir Oltean wrote:
> Currently taprio assumes that the budget for a traffic class expires at
> the end of the current interval as if the next interval contains a "gate
> close" event for this traffic class.
>
> This is, however, an unfounded assumption. Allow schedule entry
> intervals to be fused together for a particular traffic class by
> calculating the budget until the gate *actually* closes.
>
> This means we need to keep budgets per traffic class, and we also need
> to update the budget consumption procedure.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPVD5QTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgi/gD/94hzFICLjcizrxlrZHI5qKKa53Wetn
KC/nZWNXbzBl1nzVTXHG84vOPITgO0YKZXp1BfCaJOOmTNTQ8F/b9df/YF3Amdvl
PXgnkMqM7A4SMTPQkV94shlFPEzCSEDAHwZQEwUvpOgmoRV2BsLZSJg4j09bu5Wv
1Y+O7y31dx2Z7V7zq+sJtuIT5XIknGa9vHHTRxAmrENOZ1kVxPws2lYVrfCR6Xji
x5yKp9CLSx32ADuUvyCxKqRy5zEwY/21xRZzdVUHVbC47AK3Cfv8tQpGtxS+9C8X
0f4CXHZ9fxncLjbT3xDYp3j63eubHuc3vDS1L1PW3d1Q7qEWjQlIGLexuwutlzun
JcBbcWtuaLeE0BYF9KBpMYP0xn8/cC5wJ1cF6/UEcpzt/jp5xCJZSVF1B1OqH3Tv
woMSBMeFWBhhUbAXAN5iQeijCM59TgC10osIv4gBsb5wOUVhIUc0aFjHkMzKzLHm
/YjBaA7P3XFHo4fISwyszubycVq0DnF0R6pmpGmgs94btM6t5+Huxm9BceCsFz3W
M6TQxWn1Wo2dKl6yh1MRc01EHpg1YClzWO4wlJ1reRqheFANw+oskphSuEC39VfZ
eY0r5hp3d8tks5uzP/NtAa+P7ukSexVTJ/oBESDOpIsc9+bstxiYesGgjoM1Anh/
WcsN9KWANjh2PQ==
=iaKc
-----END PGP SIGNATURE-----
--=-=-=--
