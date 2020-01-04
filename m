Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 195C0130443
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 20:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgADT7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 14:59:37 -0500
Received: from dvalin.narfation.org ([213.160.73.56]:48756 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbgADT7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 14:59:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1578167974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=do0qYq13q2UgxHBLRzs6kzswMNcpGZSR/m5UnG1sUoQ=;
        b=sTFaPKE/VHTOhNY+pVqv6yj1Qc/LJDS7SaIRuXG4PcrlUzwuraKRdqG1c1ePKGvi+LQZED
        cp5W+pRuvTZnsb+tMBaTU6jr1s0rNuDJ5L6vFeIZxyL+QRruYSoz+TQRsfm64ooueQF7TG
        Bnr2WtHKEBl5Z7WqYSs7kNwixOKcnXY=
From:   Sven Eckelmann <sven@narfation.org>
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        marcel@holtmann.org, johan.hedberg@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        jon.maloy@ericsson.com, ying.xue@windriver.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-hyperv@vger.kernel.org, bpf@vger.kernel.org,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 3/8] net: batman-adv: remove unneeded MODULE_VERSION() usage
Date:   Sat, 04 Jan 2020 20:59:30 +0100
Message-ID: <3299640.fQ7R2JBGAg@sven-edge>
In-Reply-To: <20200104195131.16577-3-info@metux.net>
References: <20200104195131.16577-1-info@metux.net> <20200104195131.16577-3-info@metux.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart26314590.TLOP3i5lGz"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart26314590.TLOP3i5lGz
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Saturday, 4 January 2020 20:51:26 CET Enrico Weigelt, metux IT consult wrote:
> Remove MODULE_VERSION(), as it isn't needed at all: the only version
> making sense is the kernel version.
> 
> Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
> ---

While it is not strictly required, there are still some consumers that need 
this information to detect the version when installing various modules via 
backports.

Kind regards,
	Sven
--nextPart26314590.TLOP3i5lGz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl4Q7qIACgkQXYcKB8Em
e0ZWtxAAoeAT2LXc/P9gl9ouGpP+eXTe1HrRHNFos1gCKLRDX8CKmAy7GISoF1Nh
qFnDKzO0HjCvVymbjkW1o2XA6FmMbMiJmU0kQ7elcgsWAkEcE2fa/+aIaoCMGXbf
laWSCknJBtCfNii8G20PMnk41Gl7q0EO3tU51SWkJS3smDMCom02tQ3KI4Nth7Jk
0oG9X9piCtsqOAdKm4xc0TQ47cC3R0G0Bi3Mp0Z0h5TPVkJwM9seZYqwQzudC0lG
PxaWQKqcGwwbsyqkrltGg6PPIVDAOvBQs44TPJFgLNh9Cr1RX7zYWqHu7lB7K8Sg
55DWm8lpmmf9AE+C18FqStkbpmoaqIalW+pxSo38GCVXhK0/2h5pbKu0uawy053Q
AGVgxM6QvwfeCwK5QYZ+L8W886pwlWmhlA9PctQLbZB8LRyqbNd93wUIPfLe/BdG
zR3vi4yV0TUQl4sKANMch14tImMoOdTiRHhbeIgpf2JtKNwJtXpROC7Eu7QDmdTM
V0SBH+iUMGTOyN8+U0JyP3Vu4vpDhubB9XS9yf36DVfdOVQRNJmcgAYUdcEZv4dE
gsDbjhHBsiz3qpdP3ixG4K/MohhpDuSfJE3yysPw4PwYr627x769ksDQKBO5qhzH
s7H9oUOVjbHtuOjbk8rd1pX4xZQLPWju+ScoRsME9MECVqn3uRE=
=HJk2
-----END PGP SIGNATURE-----

--nextPart26314590.TLOP3i5lGz--



