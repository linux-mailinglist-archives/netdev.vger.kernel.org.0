Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F09FA108361
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 14:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfKXN0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 08:26:51 -0500
Received: from mail-pf1-f182.google.com ([209.85.210.182]:45652 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbfKXN0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 08:26:50 -0500
Received: by mail-pf1-f182.google.com with SMTP id z4so5936444pfn.12;
        Sun, 24 Nov 2019 05:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:user-agent;
        bh=m0jvqBQyNbjSNN57AfewGyO2Va35MQB0Hla+myhYpfc=;
        b=UeGCzkzr9EnaHFQobcJMFTcGFvt1SJj3PQJeCUDddOTXtsmCIWOS8f8GUqS+G55HhO
         Fb5/h9JwAR6UXukXMiPhASFtN9VSsj9uO/ANQddKM6J/MwNbD+06AGbVG0D4svcfvzDl
         fzgzbNetG6D99C8NQh9360ftRksWGsbKFvN2UL5EbMSyUcXFgKOSqGs/x1zUwAqMvLbH
         ze8gyk0ED5w7xxaG/M7P0jZJkQqxZVQ485/nP2VN/ibghatmvsZJbgjrC5gD2XajW9nh
         DBUwx8xcvV5ACm/sHGYMjx5M08CA/OPGqCMUE+xHkwXepJYMsjf6ICR3jBzJ/5JBCCPN
         K54Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition:user-agent;
        bh=m0jvqBQyNbjSNN57AfewGyO2Va35MQB0Hla+myhYpfc=;
        b=ZCXCu/l0ZxY8hhU53PD8qvG6FqQC+S0fpxXibTqAjfX2wODR+jeKtmFa7iq/SlNpLu
         LiQS3P2rSQOkWQJbV4dHBQI9zCARGGEIdmCOl5aRxtwY4ecLTrHDP8sQb9wlRCGOa5/F
         Y5sTxPrrPY4h7OL9BhekCWmQD88hYdG8TrHvlSmcYUyy/peGAHEIUQkMfqj0R9Uo9Kea
         T8k4JpV4AXCunweb27bbwE7VemmCBQNmOBD/wWDe8wc73johqIJ8vx8Kz4el/iMCCmSy
         DDuL4S8cHdkTOP0m0M34SXu4LCJjwySznyyUSYgj+v+j0Z29m9WTC22db6FZXg4CuQ9v
         f9Mg==
X-Gm-Message-State: APjAAAXuFgNJZ3oLh7MLwgEhQEBIeCDyD/ph9Oxb2jVQfDE7mqjYxTVQ
        G1s89K/IZesZYVcusJApdJN4qHJPMUbdIw==
X-Google-Smtp-Source: APXvYqwSmprUJshibAr5vugf8DmyGQjq91dkRNhgtXTcrAe9ERZRJO1HVeRll5Wh2DbIYpdENGYJ2w==
X-Received: by 2002:a65:654e:: with SMTP id a14mr26208044pgw.170.1574602009638;
        Sun, 24 Nov 2019 05:26:49 -0800 (PST)
Received: from localhost ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id g4sm4572041pfh.172.2019.11.24.05.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 05:26:48 -0800 (PST)
Date:   Sun, 24 Nov 2019 15:26:45 +0200
From:   Johan Hedberg <johan.hedberg@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth-next 2019-11-24
Message-ID: <20191124132645.GA43125@pehoward-mobl1.ger.corp.intel.com>
Mail-Followup-To: davem@davemloft.net, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dave,

Here's one last bluetooth-next pull request for the 5.5 kernel:

 - Fix BDADDR_PROPERTY & INVALID_BDADDR quirk handling
 - Added support for BCM4334B0 and BCM4335A0 controllers
 - A few other smaller fixes related to locking and memory leaks

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit 90bc72b13c08eedf73b7c0bd94ef23c467800c4a:

  Merge branch 'ARM-Enable-GENET-support-for-RPi-4' (2019-11-12 20:08:00 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to a4f95f31a9f38d9bb1fd313fcc2d0c0d48116ee3:

  Bluetooth: btbcm: Use the BDADDR_PROPERTY quirk (2019-11-22 13:35:20 +0100)

----------------------------------------------------------------
Andre Heider (1):
      Bluetooth: btbcm: Use the BDADDR_PROPERTY quirk

Dan Carpenter (1):
      Bluetooth: delete a stray unlock

Marcel Holtmann (1):
      Bluetooth: Allow combination of BDADDR_PROPERTY and INVALID_BDADDR quirks

Mohammad Rasim (2):
      dt-bindings: net: Add compatible for BCM4335A0 bluetooth
      Bluetooth: btbcm: Add entry for BCM4335A0 UART bluetooth

Navid Emamdoost (1):
      Bluetooth: Fix memory leak in hci_connect_le_scan

Oliver Neukum (1):
      Bluetooth: btusb: fix PM leak in error case of setup

Stephan Gerhold (1):
      Bluetooth: btbcm: Add entry for BCM4334B0 UART Bluetooth

 .../devicetree/bindings/net/broadcom-bluetooth.txt |  1 +
 drivers/bluetooth/btbcm.c                          | 10 +++++++++
 drivers/bluetooth/btusb.c                          |  3 ++-
 drivers/bluetooth/hci_bcm.c                        |  1 +
 net/bluetooth/hci_conn.c                           |  4 +++-
 net/bluetooth/hci_core.c                           | 26 ++++++++++++++++++++--
 net/bluetooth/l2cap_core.c                         |  4 +---
 7 files changed, 42 insertions(+), 7 deletions(-)

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEyxvsVXjY3jV7sQ0/JCP2+/mo1BIFAl3ahRMACgkQJCP2+/mo
1BLzpg//ZpVdq8MVctZlf9I0Z9t2mhm8/jI3BEdT6S6MP7lgOKKvNFpbSPH3FIij
TV2EB3vQlNW/gernUeSPia2KCLIZAxBiSnsLdwPbE5Klz7g/uHe4mTyHdFsvXhsM
Ru8BItoRWp0DPLsEbuZSvirtsNg+Nf6IPbuCYoPwU1hAdsqmdnyRq8jCI6PgmBWQ
nproGKZe/Be9QPbWin4BiHdzqWkJwdlOxp4ot3vZtVPK3sjdbF0tArd9jTEz0wdd
wY2wdIj7O6FVkN0nAu4NRvjKnZmrYqb0zcHXyX1S8KpXs/nvxeBOrbGgjBuoX4ha
RM8pR5Xhygr8NcGRy9ofH9/+gBl/zRIAR0bZy+Om+JcjSW8KmJ4YjzKSKsKDUgnK
qNczZ52+n2u5BenxX86UuoUHxui4aZvMwtVNvZ7HXQoG4OJia0mehWbED9IuWypp
QUmfsFZqzf1IBuciulsgUvlEs47V1Urxh2u0oD8Cii6ijiMuWkTHUthDe40Cpndq
/hOJRPE9g9L1p4FOAuBP3wuXIzfCBckAiJo7EkIqUikeTvpvvVJ4EbqE3nCL96uh
Jv8ke1vYJEeY8Q8bc/uKjLgVh8fjEZ2YBrV9tS8GdB4VLvjHgFduvTC9AFC/NlZ9
ykFqXfMQ9N3o3UyS8prWTnA6jYA/VWo8g+ZdjVAFsjxs7M/pwlc=
=P9ps
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
