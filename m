Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D8B45B985
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 12:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241496AbhKXL7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 06:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbhKXL7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 06:59:30 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E745C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 03:56:20 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637754977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dV0T9NFOfR7A0s7gpzqC4XY8Wgq7BahgzV+vSPDvUs0=;
        b=ljco+TBNgl2lWIfB8P59MhxZzQjo6AdjmCTHHwH0pLkFaflsejo9oD1qPiDzpFhA/3U0zD
        6ckFl6vRx7uhLUmwIYWdClhpPu9vSU7yoHcfGPrhkc7obXxGKyKtIcYO/BQsOtVbKp9022
        gTTyQV86i/O1VVjL6Ng2J+JaAxWIk923aacYF6Jh1NHwa1g9BjP0loE2Nyv+UT9ItU2XBB
        EHtsV6prU7lAR0AYRLppglIHscFmWDqWgLezK/nUT4SDbDzpGKPvbQKCp25ML3s8/Ge9mw
        eop9waerl1/uVZ/uxqUUU13XQPnerov4WY6SItflXdvY1A3lHtLYIIpQHLTA1Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637754977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dV0T9NFOfR7A0s7gpzqC4XY8Wgq7BahgzV+vSPDvUs0=;
        b=E5PFkpkeaKwwZY2bbeODDtZbDdXrMmKP0tI4hq/rwiV+NYuXGjzWA+IA34TDoJ1QkFrSQv
        rZ8ALpYgzb8JIaDQ==
To:     Ong Boon Leong <boon.leong.ong@intel.com>, netdev@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        alexandre.torgue@foss.st.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: Re: [PATCH net-next 1/1] net: stmmac: perserve TX and RX coalesce
 value during XDP setup
In-Reply-To: <20211124114019.3949125-1-boon.leong.ong@intel.com>
References: <20211124114019.3949125-1-boon.leong.ong@intel.com>
Date:   Wed, 24 Nov 2021 12:56:16 +0100
Message-ID: <87k0gxhin3.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Wed Nov 24 2021, Ong Boon Leong wrote:
> When XDP program is loaded, it is desirable that the previous TX and RX
> coalesce values are not re-inited to its default value. This prevents
> unnecessary re-configurig the coalesce values that were working fine
> before.
>
> Fixes: ac746c8520d9 ("net: stmmac: enhance XDP ZC driver level switching performance")
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>

Tested-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmGeKGATHGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwpgFYEACC6wX+b3hh/rszdizC6oH6JsfQZjqX
kEjwGOzIx1D3be4l7obEPaLVB9OUS0AxcsWuvLQl5L/ZVQOO4MXAseKFlju8iE1o
+wKeALZD1eZ69xs9h/XooQzOqunZ5hFF3Bnl1Wh2fpz/uI3qJ4TafE8QF8rfIJWl
ppywC8kxkknvFUa+rO6JTSTCmZx8p6dRzS6oBG0NDCy4SIqVo5AjD2eEBBpE70mM
ulPbmjb2ABLT+qK9smmh5Hp/FdSLo9/Aop4l2xevyRfiWh02Njp0p8kOe+Z8j3QW
T408UkEXm0tmFBSPy7ImEcqUbhqBU1pQdmxz98HpMhhrGnLKGzGZu8toyQn1BDnM
F2PDAT1WqsXhWBVycQV1v2cJ2VdQcSRTJU7gr4tg8sYKkY9rSzLCKM6tlFLSdqRM
egObj0X766EZ+kdlJKIoEepXlh3gUm8l5JE0V/7geYgdvcSlJGldR+nAjoX2TqlG
S0ZORYkO6byNZQkpuz840hrdtyQ3irHSBI8ZB8heWNfnOBrqznze2ggsWEpMwrwk
vz2FVM/+zzpPS3PmvQJvBIbHdQ/tUVkmpkDAczk9WPUiQGpnxGvlCd651UgGlgrL
ffPPiEYvT/0VQgv/REDPceDblcloa8erQzZ7MWqOmdNiV9vWFui8pyEM4tV0Mgd/
mqIpatJ6BfYUlQ==
=Tozc
-----END PGP SIGNATURE-----
--=-=-=--
