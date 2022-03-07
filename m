Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2714CF290
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 08:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235014AbiCGH1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 02:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234444AbiCGH1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 02:27:48 -0500
Received: from dvalin.narfation.org (dvalin.narfation.org [213.160.73.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B02264E0
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 23:26:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1646638009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SUDWX+qX7lJO1lMZKRMgkFBP+55hQ3ybpY5JUvU6KS0=;
        b=1RfbpQxg3XtX2zKAbfVsU66X7W4yc6g7d9rbtDP3W50b+QRPhLl4uvsoBldHwunTl31eMD
        +vwX+dy2ETC04D1hyrrlBRXQrqCCyIsu1obwtOiNPlap2YiSgHvom1bHmMnvsy3BBRLtXR
        aHLlqf/hnJD2OOmDXqQ0Yo5RT2bUOb8=
From:   Sven Eckelmann <sven@narfation.org>
To:     netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Antonio Quartulli <a@unstable.cc>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH net-next 05/10] batman-adv: Use netif_rx().
Date:   Mon, 07 Mar 2022 08:26:44 +0100
Message-ID: <6057237.0618BOYifV@ripper>
In-Reply-To: <20220306215753.3156276-6-bigeasy@linutronix.de>
References: <20220306215753.3156276-1-bigeasy@linutronix.de> <20220306215753.3156276-6-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart23526821.4xDK8nd8PC"; micalg="pgp-sha512"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart23526821.4xDK8nd8PC
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: netdev@vger.kernel.org, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Antonio Quartulli <a@unstable.cc>, Marek Lindner <mareklindner@neomailbox.ch>, Simon Wunderlich <sw@simonwunderlich.de>, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH net-next 05/10] batman-adv: Use netif_rx().
Date: Mon, 07 Mar 2022 08:26:44 +0100
Message-ID: <6057237.0618BOYifV@ripper>
In-Reply-To: <20220306215753.3156276-6-bigeasy@linutronix.de>
References: <20220306215753.3156276-1-bigeasy@linutronix.de> <20220306215753.3156276-6-bigeasy@linutronix.de>

On Sunday, 6 March 2022 22:57:48 CET Sebastian Andrzej Siewior wrote:
> Since commit
>    baebdf48c3600 ("net: dev: Makes sure netif_rx() can be invoked in any context.")
> 
> the function netif_rx() can be used in preemptible/thread context as
> well as in interrupt context.
> 
> Use netif_rx().
> 
> Cc: Antonio Quartulli <a@unstable.cc>
> Cc: Marek Lindner <mareklindner@neomailbox.ch>
> Cc: Simon Wunderlich <sw@simonwunderlich.de>
> Cc: Sven Eckelmann <sven@narfation.org>
> Cc: b.a.t.m.a.n@lists.open-mesh.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  net/batman-adv/bridge_loop_avoidance.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)


Acked-by: Sven Eckelmann <sven@narfation.org>
--nextPart23526821.4xDK8nd8PC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmIls7QACgkQXYcKB8Em
e0b2/Q//XcO0hhSLL1nArD2M/D4WHYoT7j507mGwYAJ9TxgHdAL1OMnK+rNBs0ad
FjYaoPzYhnhMBDvVWnkAbr2B+GPp6h3LNzWbjvc9hX/HMewWynKM6bpYGgfmPOz3
OSdTsrVGG9gmX5/rQUAjcYAXycOkiHWL3fsRzxjeB0BLwRjyOlXu77Y+E9sDNU41
XZ4cyEwG1ylIWx+JvtaK9TquoNAZ7BwdlHKdLGcnpJ2REI8ir+myjy0SxmKxB3w2
wi6YU6BfJXf1afHogDl4Tu4LmwJirs9+Gl+JPH+bQ9zD+V0hSYUN4akjCFuUAzM3
erKsgZVyabJ0J9VQSwTZBgo0myiW63uCG467Pu0IFVkY+0WZtdG4Dt6Z07O8KwaX
+Ls8Kp2cUj5E76dodkQlFqaBP2tLCe9D9PUUmVIAdWuI+UT8S7cGRBN9pV70uxaf
eRcdtiJ5GyCYDUoW7VxxslCiI/j3MjX1IE3/iqjImEbLXFXJb+TjVboYub8FXAtD
Zjv+gzOi4NEyN3DduyecXQ0xig6wcfaY7osZi21svj3/dBCvHA7ahRp+FMz+8m05
5Xf8QUQTQ2nydN/EqT/4Pn5zbsXM4e3fNoqZYj6QDfNCOccMItZRMCcdCZT1PPfo
epdgj0HJCpuGGdLzDAGb1Q+OuGFVtmE6ZvE9ro97nS/qFqrX8SA=
=cEkA
-----END PGP SIGNATURE-----

--nextPart23526821.4xDK8nd8PC--



