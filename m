Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948FF47BE87
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 12:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236868AbhLULD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 06:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236854AbhLULD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 06:03:27 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A79C061574;
        Tue, 21 Dec 2021 03:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Content-Transfer-Encoding:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-To:Resent-Cc:Resent-Message-ID;
        bh=yglYthrFmg///JUzG1COfGQeT83+F4LyeoS2yb5n4eY=; t=1640084607; x=1641294207; 
        b=h6Kmdyamhqj/2ksbaLz9/jTwuL+9NMJmpjmSUUPnIA1wi3lksMBXoryb3oSeX5wMx6uWp56vGhb
        B0tft34aQEWMABxeLChfSw8fBl4NS/7ORzOKgzmJJahGuC1wwfbKnoTeC+lH936VcWKDgmEkKPekC
        uiGDXQtatAlNAxnpmmSv+3YQU9HsY2L8TZyr3zyActttvB4KJaKh3KO4h7qHg3mvUkCJVzNolAkYg
        TpQmzTQ0yRHVrnzv0eY+iKX/Njsjv7LJ9WlC0xrgR5D7NcZIdb2lpBALZgNyEXrZMiFC562mdgZbi
        mMpCOssHWCeBH1wB7FZSCCiAA5h4MxKQZHmQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mzcvB-00EXEt-94;
        Tue, 21 Dec 2021 12:03:06 +0100
Message-ID: <82d41a8b2c236fa40697094a3d4a325865bde2b2.camel@sipsolutions.net>
Subject: Re: linux-next: build failure after merge of the mac80211-next tree
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Wireless <linux-wireless@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Kalle Valo <quic_kvalo@quicinc.com>,
        Wen Gong <quic_wgong@quicinc.com>,
        Ayala Beker <ayala.beker@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Date:   Tue, 21 Dec 2021 12:02:57 +0100
In-Reply-To: <20211221115004.1cd6b262@canb.auug.org.au>
References: <20211221115004.1cd6b262@canb.auug.org.au>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-IsYl64bjhYT+ofXkGlet"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-malware-bazaar-2: OK
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-IsYl64bjhYT+ofXkGlet
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

Thanks for the heads-up, also on the merge issue.

I'll pull back net-next and fix this.

johannes


--=-IsYl64bjhYT+ofXkGlet
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEH1e1rEeCd0AIMq6MB8qZga/fl8QFAmHBtGEACgkQB8qZga/f
l8St2Q/+Lik9DpdokHmVx7W0bgDNJHpogY6YKv7S56LMQwzYafq88nZrn2VaNdON
8eNouxP64ypNKdIq4qc6qwE1vBHFfFNsJ93eAJp9T6RgDK1y6thKwWnhOdVVTh42
+m4cwS8hOGI4MSxIFujHsi9oSafzLmGWvXpT7uIQ3ozB/g5RhvP74Z7/dkKKQxvy
IV/hjVH3YELpjDWxSohdX9gS3u65139UDDmw05EPp1aXEJ8P+ZkqywyGFEIa9oGo
Qe2QNW9LhO5FgjPQPKY5dKr078CUTQPn/FTtuiYQ+iYQvuHDaIHqE83uhTyhEXky
tRpBU9X8JfZK1IdSLlQepshd0hRUi7csfRZCNo74lLovgwqb2Z7ANnHlOpN8j+J/
MxsG5gqPfpnIv9IzGN9MQQn94ZEsKs2NkDrDkIiIoxbfSw9fAc6576jXmhdFPmsm
d0edOXh7w17SAZBCrvzRjBcCnrbkNTnPhrZUHXI9cmbfa/OTHTVN7iW/gUAbF6DP
GVHjc+OdjcL2IZbbeqQ9nThlQdGFeiGCyK3W3Pk4cXgStRmw6TDV9lojfKJ8Mw1a
gOY3uXQrhV6EiqeXkjapkzrKwA9ydf8OAR6GfskC+9bp81Pje7cdWg8Y06n2buSW
IXUIXTKFXeNyVLSuS04BBwxyqAJvF2V7vErUjy0yRewyPgG/iKo=
=rbU4
-----END PGP SIGNATURE-----

--=-IsYl64bjhYT+ofXkGlet--
