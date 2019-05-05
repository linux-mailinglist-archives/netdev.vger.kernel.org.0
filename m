Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78AD914209
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 21:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbfEETMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 15:12:09 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:33693 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfEETMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 15:12:09 -0400
Received: by mail-pg1-f170.google.com with SMTP id k19so5343785pgh.0;
        Sun, 05 May 2019 12:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:user-agent;
        bh=Fipyoptx6eV0hAvOLwL0MXlGgs/fg+c7AJV/X+NGfRA=;
        b=uG+Jv6b07EMtw6Zcepj3tA+tq7D4mdJxn6Q2aA42pmK7ZaCy3boMTuxsOMTv3FoK5/
         2CYWXpZYPXWKbWkNBE2SPHDPrw4TUGhGHaRFycAlLYcB6pwywYHbblJm8j3vZF0Q91iV
         rNWY5dBHB2A3vTzJ48c6uMSBVLM2yx3jpHZO+gzbKau9S2Yo1eXdIfK56rRPzqBLl8iE
         t7eNuu0r6z075xeFMaAGM5lCgMKpdPfmErNUDK+2RS6cxbmA653HGvZgz41/OiYrdFtd
         wNZ9WwGcGeMtpE3j86lHaLLXQFbXtAX/b+p4b/F8bpmiMICxLmeVXI1jkb5t0Rqm666E
         FBMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition:user-agent;
        bh=Fipyoptx6eV0hAvOLwL0MXlGgs/fg+c7AJV/X+NGfRA=;
        b=DANfaMVPv+jsv3dHwhTJVj/2Fd8qV/ITJay1TEya3/p9ej0eMXYEBvYfowbZ53UerU
         B04Nrc8mirwx1hdoiJdSblIwDTpBfl9hJbgvUKNnTF1W1rmpfSMjigrPWBXhlX0K3/ji
         UssYIMGRoUNDHgr2pEccc9Qhj4ItHqh3KWEFnPW+cIg4PrKY2ijBdc0bnt0ZQ4OatRzs
         OiuPTYoTn9REudpYM8bRG5cVSI+VhGyDVnVqHJXEVJ8eIo6WgW2xxMZ2K5QJW8LcpF1y
         YJjbcMixeBdISiiu3ccsjKLJMlXfkpwcmFHjsLlzWD1jDUAtJNpmmk15W8OWNKEZWYIU
         8Yig==
X-Gm-Message-State: APjAAAUfkBv3Pp6IomNO5KbMbL8SNPFeOawRhUnYhZT0Lot/9DQ1V2Kx
        ptMYWUXZihpbnFy521EIt08=
X-Google-Smtp-Source: APXvYqwO81HSBH3jsjOeItovmEyPwoFG8wN1O6hdlRpdbysMSmICmEjjFMsl98ZOz+/28ubwrx3Yvw==
X-Received: by 2002:a65:5941:: with SMTP id g1mr27027772pgu.51.1557083528597;
        Sun, 05 May 2019 12:12:08 -0700 (PDT)
Received: from localhost ([192.55.54.44])
        by smtp.gmail.com with ESMTPSA id c129sm10809005pfg.178.2019.05.05.12.12.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 12:12:07 -0700 (PDT)
Date:   Sun, 5 May 2019 22:12:03 +0300
From:   Johan Hedberg <johan.hedberg@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth-next 2019-05-05
Message-ID: <20190505191203.GA86553@iliorx-mobl.ger.corp.intel.com>
Mail-Followup-To: davem@davemloft.net, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Here's one more bluetooth-next pull request for 5.2:

 - Fixed Command Complete event handling check for matching opcode
 - Added support for Qualcomm WCN3998 controller, along with DT bindings
 - Added default address for Broadcom BCM2076B1 controllers

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit ff24e4980a68d83090a02fda081741a410fe8eef:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2019-05-02=
 22:14:21 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.gi=
t for-upstream

for you to fetch changes up to 62a91990f4c52f0b56cfae3e4093a27ed61c49db:

  Bluetooth: hci_qca: Rename STATE_<flags> to QCA_<flags> (2019-05-05 19:34=
:00 +0200)

----------------------------------------------------------------
Harish Bandi (2):
      Bluetooth: hci_qca: Added support for WCN3998
      dt-bindings: net: bluetooth: Add device tree bindings for QTI chip WC=
N3998

Jo=E3o Paulo Rechi Vita (1):
      Bluetooth: Ignore CC events not matching the last HCI command

Matthias Kaehlcke (1):
      Bluetooth: hci_qca: Rename STATE_<flags> to QCA_<flags>

Stephan Gerhold (1):
      Bluetooth: btbcm: Add default address for BCM2076B1

 .../devicetree/bindings/net/qualcomm-bluetooth.txt |  5 +-
 drivers/bluetooth/btbcm.c                          |  5 ++
 drivers/bluetooth/btqca.c                          |  7 +--
 drivers/bluetooth/btqca.h                          | 11 ++++-
 drivers/bluetooth/hci_qca.c                        | 55 +++++++++++++-----=
----
 include/net/bluetooth/hci.h                        |  1 +
 net/bluetooth/hci_core.c                           |  5 ++
 net/bluetooth/hci_event.c                          | 12 +++++
 net/bluetooth/hci_request.c                        |  5 ++
 net/bluetooth/hci_request.h                        |  1 +
 10 files changed, 80 insertions(+), 27 deletions(-)

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEyxvsVXjY3jV7sQ0/JCP2+/mo1BIFAlzPNYAACgkQJCP2+/mo
1BJsTg//QIHHvPuI52sJ4wcbHuOvlGHdVJP54qsajCSFY0p4m4ML6xJ+UP6K8Mfv
zvdX+4D7zdkLlI02LvTedrJT9AdP6dCuf/BrLXu2llDdGsT6DF2c2noylxRhFZli
PAWo0vXxROKPgBIr1wwOG47n8tUd8tYXdDXb4vMywZjH6eEbQvPoE1GW8462TeZN
j3XCs0NxsK7F/qppJeiLasYSa7q7kw8PR1S6h+3zij37AqZlcLpvQzCt0XiSN61T
X9w1Se38RQoG7kYqD3l50QhF/Bwls0YUDDP2n8o/9QaYjXooYdlWB1g7vFcp333N
7JEcUUbc0I7t3HB5XGwnFsQboTM+JPhsaw7G2h3VAE5d5nyvtHD15l+Hq+Uuyp1V
5kzEaTlvkrX2x4P16MynatqS0V/PKro+0QsuPSz00X8iOsoO7nty1KAzTSGU/vsk
CEqhkF6+fOeEP6mzAESfzEA9OwXD01x8Hh7zXeK4yVHP10e5O/y3ja+zPPP+ICfX
CmB4/eMf1pqxgD9MoGdLxp1KXdkl5/Vgqq2fXXdaU8UR2My5JZLnNVkLtNeNJcaQ
wJxH/yi4BMsINM9zWg+UKNpjGAexu2PYHRljfEhKDsxMXJAsQ8kv8fthQ8UmUzcL
0Da/wSYdnQCloVrjcaoRTIFYZqMbUVl14oRPUszG47oN1UXZlWI=
=ivpf
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
