Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF91B294F62
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 17:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443378AbgJUPA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 11:00:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56321 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442511AbgJUPA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 11:00:58 -0400
Received: from mail-ej1-f69.google.com ([209.85.218.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <juerg.haefliger@canonical.com>)
        id 1kVFbk-00086X-Hv
        for netdev@vger.kernel.org; Wed, 21 Oct 2020 15:00:56 +0000
Received: by mail-ej1-f69.google.com with SMTP id k13so1885595ejv.16
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 08:00:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:subject:message-id:organization
         :mime-version;
        bh=QqKTVh8abiiLDOAS0tY89EcE85b17gm7rWRAFCgUU4E=;
        b=pzwYJWjJyD0vSoasy7OpAZBZBw4g4vK3gvRiuc0Vt/zHhL5ijO7Gy/E54hqL8KWcdY
         mQw7YNImOIEMFuTDL/Un9f3bZ2jILUNL1w91TsabYCocHH9lQmCUQ5uXXPkVAL8djFiz
         ef4+pRnTgYlx29gpdG7LmbYRS7MTx/XPuJ9JfVix8UyW/CBknIa6rRE1ZfKW5I0/WqWt
         qK4Vw9DHn9PxmN2vjFj3P4bH0IJk/h3ghpwneAxcGxNegFmmgE03DP/mVvZnW47u82PL
         UdGbs4qifYcngZxwYgAcjOfSzZreR9ehTK44y30BzlqVOEhdT+wHl21TqNe5w9WJ8AIJ
         zx6A==
X-Gm-Message-State: AOAM530r4jsz4dqrq5JM9bxCbcE6y2pEZz6yVpOR/ZtqGZFRiOsicOzV
        2sHGg8q4gTxoXK07hvGC9s6fb5rVAlapmJ6dSAqWwlIo9Bs75uE94K7PUiHqkq5CethSDV345Zz
        8ReYcIButlY+8nJoyGvYdmy5xvlQxGAm91w==
X-Received: by 2002:a05:6402:1615:: with SMTP id f21mr3603319edv.257.1603292456105;
        Wed, 21 Oct 2020 08:00:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyAhgSIoLUVIRJTFWHjBV7WQpwhktb/dub+a2Nhc01S2HDNmbsT2IBV1OgBuIuj9+9HfH2y4w==
X-Received: by 2002:a05:6402:1615:: with SMTP id f21mr3603299edv.257.1603292455849;
        Wed, 21 Oct 2020 08:00:55 -0700 (PDT)
Received: from gollum ([194.191.244.86])
        by smtp.gmail.com with ESMTPSA id c3sm2214595edl.60.2020.10.21.08.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 08:00:55 -0700 (PDT)
From:   Juerg Haefliger <juerg.haefliger@canonical.com>
X-Google-Original-From: Juerg Haefliger <juergh@canonical.com>
Date:   Wed, 21 Oct 2020 17:00:53 +0200
To:     netdev@vger.kernel.org, woojung.huh@microchip.com
Subject: lan78xx: /sys/class/net/eth0/carrier stuck at 1
Message-ID: <20201021170053.4832d1ad@gollum>
Organization: Canonical Ltd
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/bI5Li84hr7TXWfXO1+AIGUi";
 protocol="application/pgp-signature"; micalg=pgp-sha512
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/bI5Li84hr7TXWfXO1+AIGUi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

If the lan78xx driver is compiled into the kernel and the network cable is
plugged in at boot, /sys/class/net/eth0/carrier is stuck at 1 and doesn't
toggle if the cable is unplugged and replugged.

If the network cable is *not* plugged in at boot, all seems to work fine.
I.e., post-boot cable plugs and unplugs toggle the carrier flag.

Also, everything seems to work fine if the driver is compiled as a module.

There's an older ticket for the raspi kernel [1] but I've just tested this
with a 5.8 kernel on a Pi 3B+ and still see that behavior.

...Juerg

[1] https://github.com/raspberrypi/firmware/issues/1100

--Sig_/bI5Li84hr7TXWfXO1+AIGUi
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEhZfU96IuprviLdeLD9OLCQumQrcFAl+QTSUACgkQD9OLCQum
QreQQA//eemk9gZvHW3utAMPmAT87YeSEPOEEK/KeczO/GJMsmjiaazph1w6RLwh
Jgjj2CkcNMYwLJv4wRvABEkXGnC+0IMw+I3IvtiWcngnH8lvZoe+iJiwXFwU3SOi
CDcjFqW+w4qxCrtzhrqSdd2xtGv0fHjUJ+N2WeQwDdS4No651YcyV01bLnPU+vLR
Z2L6putFFBvTIb9pS4aH8yTPSPwX0+zKCJPAijSRo58FN9IJPoTG2UcXlhX4wmDN
j/ar7W9GXf2pB6HTrg1kkkp3fd1yiczthN3PlpMCxgQTkjqQkSzoCZ8ckhrgS4lP
7Eb+fq1qcjLf5lUi/xKi4P3Fbofci5wA4EzJ26sClI9MXhO9bMmDUDjendzShkIC
XyODJ1oCrJpS/2kuSWA3c6pqngEGATDHdyqu536E6tgUPaxjV4tXBmrobFgPIqbH
Kbobse81qKgZReiukhNU4EeU7CW5slbJmu14d4MrgQvvgB1HOy63KMcoKCXqPT1e
+G2oYYo+Oclq1LA3NKiAdNh8Xdnevh2KMJPWy90EJiCgiNIOXHNFzwL8xM7H+iH8
sXHPfmTks2AqgKpYjbHwjnFu76S1F6e6/p1RHrZuDr2hZX3PpnmuP+DtU5foRUNi
zEyHkzw4rAI0CuptdO0zGlU1hsmcC/sSlb/T3BLyl4HHDWFDMD8=
=XXNp
-----END PGP SIGNATURE-----

--Sig_/bI5Li84hr7TXWfXO1+AIGUi--
