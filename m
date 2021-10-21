Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3CE435B2E
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 08:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbhJUG6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 02:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbhJUG6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 02:58:02 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD21C061749
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 23:55:46 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634799343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yabP/RpsK5DFupV2L2/4FE38WD+JdcmxPxm3Fg0T804=;
        b=H89wncdUmfjiwSEygV5wn0UCeXvlsyVwOOKhDy1plgDzVoET0F/+i0/NqQ/x3JqHUyLuWH
        7VLiypAX2mknguSxkbgdqB1HvdnAHj+ii3U6+367CUmPCXZlVrHrEaXiNVH40iD7ITk4vY
        Q3ajCT9WFaPYsC9PPKE6gR3i7X4xS+GdtTRx+ywWHYEbAvoXTP+3Pw9e2qP2Pw43a3QEt4
        84gCKv5IYXuCEih5ncRBkrAJgAzWQ+eqiU2UtN8ydTs/51NV0Dq6+w+UzlTDmAK5SB3987
        Etui2keCs3yVjLx6xbzODxhCT5uPQX6F4OPUq54bas3nYNbxx4K2qbnzZVLrLQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634799343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yabP/RpsK5DFupV2L2/4FE38WD+JdcmxPxm3Fg0T804=;
        b=iuvriCwGPzFjknX5Yiu0WhqTI3sv8u4svq2QR3t6buIrJ8dMJqMGoquyAYRfd0E+QoV2Gk
        /esKsDHTfIL8ipDg==
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: stmmac: Fix E2E delay mechanism
In-Reply-To: <20211021064438.GA11169@linux.intel.com>
References: <20211020070433.71398-1-kurt@linutronix.de>
 <20211021064438.GA11169@linux.intel.com>
Date:   Thu, 21 Oct 2021 08:55:42 +0200
Message-ID: <874k9an9xt.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Thu Oct 21 2021, Wong Vee Khee wrote:
> This fixes PTPv2 E2E issue on EHL-based boards. Can this also
> be applied to 5.4 and onwards?

I've submitted the patch to net tree (instead of net-next) meaning it
will be picked up for stable kernels automatically.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmFxDu4THGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwprsOEADEALkrhSD15f4dj4CszZmYa0Q8AJHa
SaU+xrQ9+D8jd1Zot/goNmYfBz3JAWRjXVR5ZlzI6yZlqxccvt4raVowFDTcQWKu
YaBkaHs7q8M5cZ+ghTF1KsixzoZnQi5QIq0BzJqgr9qZ9myCdgOPCXfhNuou2scV
6SwbEoKPOUFz7jeZlyu3C1RdXsTwfzVsKD2hLnhMeVmuRx+Rrm9Non3QCpI0ztzE
iLou/QtiRbr0g8V3EP86l8NrryYhtw6saL/fBEwPamaSOijGqV7s+2rpSWHQksJ1
UXVE6v2JKCv/mhlB8owtmM195ZPsKde40Sgh0DHxQcPOwnQpcAVTz42wX7HgPJSN
PwqyAlBwL9fiATVhdIosGyOaVQ2RZZ6GK4LL0q73q0v6aeslObBKVKE0Hjv3EIWR
+/bidflGM3PusOrsYy8tCZZu1MHgauOu+3irdzjBNTZOHEGcgeMjrWxK29dQnpl2
YFxCWFkaXeeub/MLqnWC+ieeLWmkhfLqH1l+rKEMPGmHF0ho4KtBjzBeXjh1O6rH
Non2GCU6GT9aXlJChxin+LPoWFqFOH2zkFKfIIHD+TowO76LYY0Nza4SAW/6YZlu
pqqmvLMh0IHGprjYCODe4eq+QGmImfle7gObnvusijIhvf+/ZFvICrzpAsAsp7Y0
bzja3aXa2oIZZw==
=CIFD
-----END PGP SIGNATURE-----
--=-=-=--
