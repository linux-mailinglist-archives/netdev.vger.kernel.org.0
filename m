Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F213A3A39
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 05:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhFKD0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 23:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbhFKD0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 23:26:32 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D0CC061574;
        Thu, 10 Jun 2021 20:24:34 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4G1R672BSXz9sVb;
        Fri, 11 Jun 2021 13:24:30 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1623381871;
        bh=Rhn5+R2MWACwQyfO1X4gGUHE7SYNLWc4cq+JGmoGgn4=;
        h=Date:From:To:Cc:Subject:From;
        b=mQW0gwOnni19qFEn9YLgFPsQxH7m1XLgdDoMxkWtVLpqzx8JBDGxeTUsJTKYq4KOb
         iQ/KRkFbtHwS0yIF0CR+PMvZwsSKMFpXfOHcDzprlApkr3dr3hs4aOsdoljVUxN9pl
         MKwUOJSQrPXyLzL9eEWRlJDS2dTsmvUsldI4eO5V0CvZxNeKKjzuEmq38MFd66BcLi
         ZUxTPXR8VvkoUkFH491z/jvSEZ/5WSbdPBaVSldmduUKLH4yemg/eOKfyCDt9yX0ME
         61v14Rb15ED4BFjbsyBxYARkGFEye1DYU2m+3ygkOskllRQbsWX4A96BityqKYOFMx
         2KnPl+hroRPlQ==
Date:   Fri, 11 Jun 2021 13:24:28 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Cristobal Forno <cforno12@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20210611132428.74f6c1f9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/zZ0lldrmVKcOFzK4.x/go5U";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/zZ0lldrmVKcOFzK4.x/go5U
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

drivers/net/ethernet/ibm/ibmvnic.c: In function 'adapter_state_to_string':
drivers/net/ethernet/ibm/ibmvnic.c:855:2: warning: enumeration value 'VNIC_=
DOWN' not handled in switch [-Wswitch]
  855 |  switch (state) {
      |  ^~~~~~
drivers/net/ethernet/ibm/ibmvnic.c: In function 'reset_reason_to_string':
drivers/net/ethernet/ibm/ibmvnic.c:1958:2: warning: enumeration value 'VNIC=
_RESET_PASSIVE_INIT' not handled in switch [-Wswitch]
 1958 |  switch (reason) {
      |  ^~~~~~

Introduced by commit

  53f8b1b25419 ("ibmvnic: Allow device probe if the device is not ready at =
boot")

--=20
Cheers,
Stephen Rothwell

--Sig_/zZ0lldrmVKcOFzK4.x/go5U
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDC12wACgkQAVBC80lX
0GytjAgAjnmH5QhAcdHm1zWjXG1lYpqm4C8IyFEjBNx3D010yeGBngBQVwrV0I0n
14NVqRiwAk4yQdlloEHlY4WBs2ImhzaXUxIS1HLxI00Aqk8XwTyoOA5Rgc7pV0mp
JsCbI8o9QoLrq8pylyxiwvV+4tlm4F81YoryRTCupKPlgOJlw9LmHJas3XyLn0n3
VaNaUZQj1zjSsdxQdNEOZbVcm/5L30J5Vo6u0U8sbV8dELJ51YAD30STfjQkKc4p
H9inSd8HoAXpMui/rvKdGzD4jQLul8GnVPvthVMi1T9de70/z0n/tDOHa9V5g4pF
xvItw3bewqJTMASMFGrRjDyGpTpSMQ==
=Wm3b
-----END PGP SIGNATURE-----

--Sig_/zZ0lldrmVKcOFzK4.x/go5U--
