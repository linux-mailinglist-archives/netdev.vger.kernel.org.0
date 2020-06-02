Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5051F1EB34B
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 04:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbgFBCRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 22:17:39 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:50059 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbgFBCRj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 22:17:39 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49bbKW6Jncz9sSJ;
        Tue,  2 Jun 2020 12:17:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1591064256;
        bh=NQkeWgxvrc5bDW6xcAlwVko/45XXVKKSZtWco6AydyE=;
        h=Date:From:To:Cc:Subject:From;
        b=r2kV2Hhsh5pqP1VR/R0VhDOCfXx0eRukYYNWYFJvIun6RDJBrhxdz4mhtlS2ZbPi+
         WopNVcTyI9BczWLZ9Rbt9QsCwMGOJvmFVwq5oNqZq4MTVXwbPOAjT413WxtBkp5/Xn
         e3wqXAUR+8WfP+BQ1uIS/z2/x3ZPChqWChW240uKYzcNetgzN7jexXTXQAaJ5/uj/u
         LTOXCFPi6DUEQoekPUEt/S+lSev+qaebTi+22XUk5rRQlF5NeDJ9/2mxicPst5yvFF
         vxpN0QSvXmUmY1VCsPRSPaXJgQ0Lik/bx8tzZMujs8r928hfv/1kYqXyaCguSFzOJA
         4KS5dA0joTLFA==
Date:   Tue, 2 Jun 2020 12:17:35 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20200602121735.1a2e5d0f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/O+F9y2hA8jhXXkOdAj=1Ljo";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/O+F9y2hA8jhXXkOdAj=1Ljo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c:666:13: warning: 'cxgb4_uld_=
in_use' defined but not used [-Wunused-function]
  666 | static bool cxgb4_uld_in_use(struct adapter *adap)
      |             ^~~~~~~~~~~~~~~~

Introduced by commit

  a3ac249a1ab5 ("cxgb4/chcr: Enable ktls settings at run time")

CONFIG_CHELSIO_TLS_DEVICE is not set for this build.

--=20
Cheers,
Stephen Rothwell

--Sig_/O+F9y2hA8jhXXkOdAj=1Ljo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7Vtr8ACgkQAVBC80lX
0GwTgQf+N1E7JfLN6CfTX+HRa2FoFOc0dIPjx1pnPB3+ewI0Y0GtwIcbLbeZFoaa
uxdhw9EQ8SYHATbftOaAFEE3wbCSAlcZRHHWf20bOLNuMKgpS8MIkwdyqa79v/u/
yk8E33Y5CDqB/AeCMRPAVUOfPrGl2ZSIYXmIo6M42FXfQ2L2IvRFcxDnrpqaLBVg
UGDQSW8lYOQ+hJQasUvTGOnGqz+3oGHO/CbV2H4PUw1vkWBox3pUHc2lQTt1yBWa
DGPPmmzT9HDN3IKOHYL8kVJDFq40mQXJ3dgLTkGRZL9iWoeMeHQ6JTDgyJqJGGap
tmx/SdtqkVzJsKuGS/iQuhqzI/bfmg==
=GDoB
-----END PGP SIGNATURE-----

--Sig_/O+F9y2hA8jhXXkOdAj=1Ljo--
