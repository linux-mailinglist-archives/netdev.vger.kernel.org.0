Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B89BEAADD
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 08:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfJaHKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 03:10:50 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:47997 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbfJaHKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 03:10:50 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 473c13017Jz9sP6;
        Thu, 31 Oct 2019 18:10:46 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1572505847;
        bh=nlW1TawYOsxryRi1PP1SPj/8xSEbJkkKrpqsW0WrDe8=;
        h=Date:From:To:Cc:Subject:From;
        b=ZdtzbdgTp20jJdwSTaL3y2rRBNJPGf89+qFIFXP+mt/x00IczbTzsKa4j7u+4eQPz
         JtgxwOt5Hnz6LBlh25w5e+JxnHXilFP3kzIuogP9MeB2PtebgNRRuf/rV6OPpjIf2b
         AjYAzA2Xi4P1PRXbNazjRm1Y947UtMpFB7zFuE/cmWaml2+JJxb9dmllH3e+uTjPPX
         u2BT/4KLMdcdTiVcTOYqz8QLHEbRzbynu/R1XHhl68xRDuHfqKuB6UHIoInKtKRo99
         W7UKRkluqwyUrr5NJczqB8GW769OYDF6S2ApwIpiWp9lD2GSOvHfm9gLZRNNehZsZj
         4c6nU6qaXse3A==
Date:   Thu, 31 Oct 2019 18:10:44 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: linux-next: Signed-off-by missing for commit in the net-next tree
Message-ID: <20191031181044.0f96b16d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/aqOgMv0q6e5QQnboXQi2zzg";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/aqOgMv0q6e5QQnboXQi2zzg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Commit

  a7023819404a ("e1000e: Use rtnl_lock to prevent race conditions between n=
et and pci/pm")

is missing a Signed-off-by from its committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/aqOgMv0q6e5QQnboXQi2zzg
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl26iPQACgkQAVBC80lX
0Gz6lAf/XS7nUCDM7ahHdQaXMuBP0a4zx/UMa4WhTb5V9Idzprt9BIGIYgRlnJCn
zSZ3wsMQYs6l1lIOT2jcpq5OL3E5BpgYkqq9/fZU0Rgt2G/8IQMPLIUGxee/0JMY
wG7pyqnIxVa6OtDkc9s1SF5NXg2B9k4Yp+rhGV6lCF6T77OGxfE6jWjmutfIVPTu
bVWpTtwGrs+XERhjYCuz/ChCPcTH+c0F6SN9WgB9hSLCnd2GMLEa59nlpHKtXnS+
AK10i9em1lL0nZFSdCpMyVLzrYnRCY+m8dNtDQvaMYKMSrlIqNezhXWD0/PvPXt9
sNChy1yp+BnxXacIPgt7Fzdih4Oyew==
=u7WE
-----END PGP SIGNATURE-----

--Sig_/aqOgMv0q6e5QQnboXQi2zzg--
