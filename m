Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B17E197087
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 23:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgC2Vcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 17:32:36 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:40308 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727370AbgC2Vcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 17:32:36 -0400
Received: by mail-pj1-f45.google.com with SMTP id kx8so6438290pjb.5;
        Sun, 29 Mar 2020 14:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:user-agent;
        bh=GrpNMhLH/0irTvzJOWjdmC5wzGKWEVEhUezDwVQIJ4g=;
        b=QFDa4rHZz8QvOh1R+OacXXxaN3guL1r8ep02Y0W/7IXGz9s0Te/GnLIosU24APNij8
         864FXYH6UbTFkWybaaR/J+MYWEp5CxD06LVVFxD0YVkV34hd2+xA+KnIXliTGqdHuPRb
         y8FksIrBTwrrbRagobOlZfOEGtEkd2qDOfRP4beHMickv8/+vjAORaf08jHCV3YwL5Jq
         N9c3L4VSvcdW3kT8YB4jsiktUD248i9SAb/ZO5VOdu0POGIMouI0BpPcb40gJ17fOf9X
         zom+vlxFOJ2r9Vu9b6j5VOxq+pHbV4sxGtKuyJZZZJwoPCpyQq2EA0uTapP6qCOrMRaK
         caZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition:user-agent;
        bh=GrpNMhLH/0irTvzJOWjdmC5wzGKWEVEhUezDwVQIJ4g=;
        b=ChWcUOqY/puLFGYxlp1KR8oBLtgUHKjkTMK5ft6wOWCkLRF8GMXTzoA57AdbDbeleq
         A1GWKzwYZHJJ7bMu3YxBYdWYSY0JcDAzH0voWyMea5r30HW+kNb5EKrWp9PtO4ImB1sE
         pYS4dYUhtkEYhiOZ0K9kZjSbuVAsuSOTERuE+YMN9a+yAizLHt+m7FlkoAHfNTabMOex
         nhEHT35yRG6IPiXIjOW4jOh4jPbrcCiaBGr1EjFuEsUKo4Jlo7ICQUd61UbFTqvSl2jc
         ZdAiYTQmwE8fmVHmfz/6PE7MjUvXoTLEOj5dKDGHJQU5IrjnuVIz4O/uNt5FrPAGclNJ
         PZLA==
X-Gm-Message-State: ANhLgQ3K2j7zWROucPa84lo/fl17vbF4Q2AdBx3lpaSVnBfmlt4hAhoI
        WLgYohlrGZPwUa0aRsIrh5qESUsi1Vq2mw==
X-Google-Smtp-Source: ADFU+vv+dO8iJZdfAUO5eiNhbA6ssongekkPUVf6Nlq13iEMD3CKn32UJBDYfcPNYw5IpIdvpziL6Q==
X-Received: by 2002:a17:90b:292:: with SMTP id az18mr12121962pjb.126.1585517553168;
        Sun, 29 Mar 2020 14:32:33 -0700 (PDT)
Received: from localhost (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id c62sm8631337pfc.136.2020.03.29.14.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 14:32:32 -0700 (PDT)
Date:   Mon, 30 Mar 2020 00:32:28 +0300
From:   Johan Hedberg <johan.hedberg@gmail.com>
To:     davem@davemloft.net
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth-next 2020-03-29
Message-ID: <20200329213228.GA16750@sharonc1-mobl.ger.corp.intel.com>
Mail-Followup-To: davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dave,

Here are a few more Bluetooth patches for the 5.7 kernel:

 - Fix assumption of encryption key size when reading fails
 - Add support for DEFER_SETUP with L2CAP Enhanced Credit Based Mode
 - Fix issue with auto-connected devices
 - Fix suspend handling when entering the state fails

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit 0d7043f355d0045bd38b025630a7defefa3ec07f:

  Merge tag 'mac80211-next-for-net-next-2020-03-20' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next (2020-03-20 08:57:38 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to da49b602f7f75ccc91386e1274b3ef71676cd092:

  Bluetooth: L2CAP: Use DEFER_SETUP to group ECRED connections (2020-03-25 22:16:08 +0100)

----------------------------------------------------------------
Abhishek Pandit-Subedi (2):
      Bluetooth: Restore running state if suspend fails
      Bluetooth: Fix incorrect branch in connection complete

Alain Michaud (1):
      Bluetooth: don't assume key size is 16 when the command fails

Luiz Augusto von Dentz (2):
      Bluetooth: L2CAP: Add get_peer_pid callback
      Bluetooth: L2CAP: Use DEFER_SETUP to group ECRED connections

 include/net/bluetooth/l2cap.h |   5 ++
 net/bluetooth/hci_core.c      |  39 ++++++------
 net/bluetooth/hci_event.c     |  25 ++++----
 net/bluetooth/l2cap_core.c    | 137 +++++++++++++++++++++++++++++++++++++++---
 net/bluetooth/l2cap_sock.c    |   8 +++
 5 files changed, 173 insertions(+), 41 deletions(-)

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQQ8m6QjaLXd1XJ73Dsfyv3T9pQ3KgUCXoET6AAKCRAfyv3T9pQ3
Khc9AQDEDhqbnaeUlcdZsBAL4oUARERnZCLhbVKRNzq4WibPjgEA6XUoUq3yNMO5
/fQ5MUVKufpAgIJbzkwMrRuKGWZC+As=
=TX1R
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
