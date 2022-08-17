Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657D2596ADA
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 10:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234107AbiHQIEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 04:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234458AbiHQIEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 04:04:02 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CA02BB22
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 01:03:49 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1660723426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y+IiiAqHQxXEJSfIySKU/sUMP4TU/yYnAZiP2reQG9I=;
        b=dLusxE9hEzg0DCD/FAoY1NcwO9oyYHPYxxBFGpfH1GtRyTcB0UZoTps/xDC8B5mGHFreK6
        Vt/H4PpET4fU1h2JSr+TN6xtnfefeSyKJ47wy3CR/S9ymrVLwgXNXe1gXuoltuIB+BSDOw
        N2orMdLbuxqtGr7SFE8oXjipBOXYodx+oQs3qzuzjdTp3qDxWqBThgmGRr4fhcXqdSMRh/
        uENC4l8iqkiD/oRJOt7LP5Lt4sRS+6BBEbvek2zz92Fpik4Wt77A8X83RbXIIS2t9bYggM
        Q4TDPR40na4uK8k4KrwTxLEvhx3xXWpAyFXy0aTJyctLWNpQXtNViUpAHWxkeA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1660723426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y+IiiAqHQxXEJSfIySKU/sUMP4TU/yYnAZiP2reQG9I=;
        b=PJviA+kV7EgEtz6CJaAvK6UvoiYsTMjlYo0gUMWbjCo52nyN2OUFYk+AOrzUvLpYgezoN1
        CySmj3uNOckQ4iAA==
To:     Wong Vee Khee <veekhee@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Wong Vee Khee <veekhee@apple.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [net-next v2 1/1] stmmac: intel: remove unused 'has_crossts' flag
In-Reply-To: <20220817064324.10025-1-veekhee@gmail.com>
References: <20220817064324.10025-1-veekhee@gmail.com>
Date:   Wed, 17 Aug 2022 10:03:45 +0200
Message-ID: <87v8qrnvoe.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Wed Aug 17 2022, Wong Vee Khee wrote:
> From: Wong Vee Khee <veekhee@apple.com>
>
> The 'has_crossts' flag was not used anywhere in the stmmac driver,
> removing it from both header file and dwmac-intel driver.
>
> Signed-off-by: Wong Vee Khee <veekhee@apple.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmL8oOETHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgrdyD/wN1G6PpVS9Zni8NjZRqJNolCjpzcaS
/wLhZotpC8t7W8H56TXfV/PIQt4nQZCswdFENfTJYqzYKd9EZSPOqlvYGtXUQT+M
tRTAoL5bwIb/mMG2w4h05jdSn2eWdpII7UawfOmL3SZSdsuDg5Joi2ZQQpmt2mhY
eUyzX4KSL9Hxd/q5eJBzkfKfZAOnYUrUAmsZcUCCax3ZnnDnxzelc8yh8GQFnuis
p5qzj2VgtJRF/rXIPJ8J4lcJD2OJJPhXjinS0IqNDDYRVw4hX4O20a+ZV8FzoQue
i20ysNrPeVGBAeit9sy6CeUa/MX7tfu3Cp5+BYaKO2QgAn3CmkoByE75xPl24Ncm
+46Ayf3Y0HRRbgpIn52Ou2jfPiXLp+zbzp7N6Wi5vaWENwsIx2E71Nk7EkOa0eP5
+ky+XZZhsUC5GIlivOVM8HE5MnmePwFL/eWuh4srE9B6JWejG+ATwa8RamntitMP
7yfpWaKpluAzyUEtdCOtGBSAvvCe/fKcKz//O145X4whUx3XYcW6JPau77cWrIY6
I/8x2JF3ab2qpSym7rxu5Cud8AkmLDEIRn4Y30MHMiSlzaCDOEYT7Ll2SDH6JDu9
SxdhphSuvsbTct52XzWxTg6+oyauhZbc3Nz/SInk+B+7P+Saqjb0tTdalEP5yMD+
f+HHarM3/K7Y7w==
=yDEv
-----END PGP SIGNATURE-----
--=-=-=--
