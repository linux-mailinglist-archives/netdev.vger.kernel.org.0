Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222001CE7EE
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 00:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgEKWJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 18:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725836AbgEKWJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 18:09:20 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB956C061A0C;
        Mon, 11 May 2020 15:09:19 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49LZph23WXz9sRf;
        Tue, 12 May 2020 08:09:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1589234956;
        bh=NLp2iwmJol7crhzKzA9NGQFP2FD7zXoJFHdFYX7gelg=;
        h=Date:From:To:Cc:Subject:From;
        b=uRLMK9B9PTUhBKTBYUM506OYo+FvhLyFbZ8+VkpAGJOa96lsVbzxz7094rkAkPVTA
         tdgErcTukJRikinXeyUZTljWu74mNMJWnOO3qIyETGZsY3WJoGaFwjuRrfBGG+of8k
         aOj41gIpx7YLb2OKReVTHUwLIbZiLW4zwx3IYzxVLONFiOhd4jerHR9JKT1DQQiodV
         SmIPXAEHCEUXCWuOJ/vIBP9bCHFcV01LMAK76EHStiO/RKrMWAJvYVQsgZcEk1qT70
         9aLV7atJTgEqXACRe2yCF8gafbcxo9uRvT4uk7Sm6A1euNaxNAiJpnUy5dzEPKn8fn
         b0jRhuyNWUyOA==
Date:   Tue, 12 May 2020 08:09:14 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tom Zhao <tzhao@solarflare.com>,
        Edward Cree <ecree@solarflare.com>
Subject: linux-next: Signed-off-by missing for commit in the net-next tree
Message-ID: <20200512080914.42dadf0c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Qhva7hVypyXGbe/DmUkaVMS";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Qhva7hVypyXGbe/DmUkaVMS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  be904b855200 ("sfc: make capability checking a nic_type function")

is missing a Signed-off-by from its author.

--=20
Cheers,
Stephen Rothwell

--Sig_/Qhva7hVypyXGbe/DmUkaVMS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl65zQoACgkQAVBC80lX
0Gw4xwgAntK+XyGolpni1agR8ixJWVKudqx/onhp/GMpmx4WlL9h6FIeyf1HG8sK
wHm96937gusVCUEjT0L+FiAiGOn9wUN+wcE5ZmM60WieJCPrOXjq+H7AGW9ylbio
8N8VQdbRv/+5Z0+sZSQYRKdxeBNwFKKiTtAKeovTcMNe2vDSd7zBQ657+BSR70nX
NkK0qMhvUxe50+L4G2sad6c23r+WVqtgCWADImWu+gC6HG25Zg9HaeQM586OzuA/
QNyR+RtFtNP0Vcnvrfr0WhJ/pMgKzO3wFzWzmO/GsPkBuz0BUkoluHv6ybi3sbdn
qrECP9JC4q4+0v8esN5yq6p4tVk/yg==
=nYtz
-----END PGP SIGNATURE-----

--Sig_/Qhva7hVypyXGbe/DmUkaVMS--
