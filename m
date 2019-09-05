Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F439A9A65
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 08:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730539AbfIEGOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 02:14:52 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34851 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbfIEGOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 02:14:52 -0400
Received: by mail-pg1-f196.google.com with SMTP id n4so809399pgv.2;
        Wed, 04 Sep 2019 23:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:user-agent;
        bh=9MyJls/3pTeaGKyKyHjzn9JlAJCd6lHjYWAtz/m6Flw=;
        b=jnMYGG4ip7r2EjqeJXdUO1MFOeUjXFq8ce0sSbZR2YKHVQHKmeYPZUVqoddpwDKf0P
         QgIIh84afLxq0A6z9jLCkf9BVenlrigWoE8hlnuVWiODkGjY1xcq2FioC6PEayai3+iF
         btIK5lWVyc440yVNOVQuflM7xTWG29/Et/rCbn2oJv4cQjbM3BDMUSbcIuSj5zOstSYs
         +JaPQMCdjE3RcNDChmPOx+f66sA9OrkezVMC4RSltDxmwEi4j0rkyLyeGgsJQhiHLbyZ
         rYBAiSKBFBkPivu2ofSThh77zNr3tk1LasbNPzkBdCnO4C+ziGYp2X223G88Q5+VQs+v
         9nFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition:user-agent;
        bh=9MyJls/3pTeaGKyKyHjzn9JlAJCd6lHjYWAtz/m6Flw=;
        b=mu/9cetQuUw3vdLAC3v3JrEtg6UtIZbs4eR3hnFVzHtBosLaakmvDGE10tVRX2AxAt
         aM1T2nxcORg8f5WhLQtLluK5TEg58mNH0sARkznnj28h4Y2NCoxgjJxXNcA1/+vtEXFX
         Bp+3hZUqFwKYGFxckdwmQzfcpjzCTmUgJni+6mp9qj70ha/2EeFLhuKD5cZkS52A4qKZ
         Qkbx/X2tFLmFAnqk/kyEr5k8MfMtMbkscruGLA9XcXfi0I5Ef0sU+bcoJ+N4rAMPhtQT
         efxvYANVNtiE+koJYrc/lpAzJm1xdQj9mpwtZKPdmC014JMPtzPUpy33JSBIfyb838MS
         ZlkQ==
X-Gm-Message-State: APjAAAVTvnCCEIyBFgh/zBMEHK+fl6NdoOcaXUrztlpEzv6ZK2Qwlm/d
        j3rzb5U2Bw72Zc5IwBo9kJeDC83C4MmKXg==
X-Google-Smtp-Source: APXvYqybNEzEiOFp47YxU9xk8vlpckBv4BbmnghyyTs2egxlOHXMeFb9cFmBA3idHk/m1G/e/UQK9g==
X-Received: by 2002:a63:5402:: with SMTP id i2mr1648429pgb.414.1567664091625;
        Wed, 04 Sep 2019 23:14:51 -0700 (PDT)
Received: from localhost (fmdmzpr04-ext.fm.intel.com. [192.55.54.39])
        by smtp.gmail.com with ESMTPSA id b24sm1187360pfi.75.2019.09.04.23.14.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 23:14:50 -0700 (PDT)
Date:   Thu, 5 Sep 2019 09:14:44 +0300
From:   Johan Hedberg <johan.hedberg@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth 2019-09-05
Message-ID: <20190905061444.GA47480@blobacz-mobl.ger.corp.intel.com>
Mail-Followup-To: davem@davemloft.net, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dave,

Here are a few more Bluetooth fixes for 5.3. I hope they can still make
it. There's one USB ID addition for btusb, two reverts due to discovered
regressions, and two other important fixes.

Please let me know if there any issues pulling. Thanks.

Johan

---
The following changes since commit 8693265329560af4d1190aaa195ad767a05ceeab:

  Merge tag 'mac80211-for-davem-2019-08-29' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211 (2019-08-29 16:44:15 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git for-upstream

for you to fetch changes up to 68d19d7d995759b96169da5aac313363f92a9075:

  Revert "Bluetooth: validate BLE connection interval updates" (2019-09-05 09:02:59 +0300)

----------------------------------------------------------------
Harish Bandi (1):
      Bluetooth: hci_qca: disable irqs when spinlock is acquired

Jian-Hong Pan (1):
      Bluetooth: btrtl: Additional Realtek 8822CE Bluetooth devices

Marcel Holtmann (1):
      Revert "Bluetooth: validate BLE connection interval updates"

Mario Limonciello (1):
      Revert "Bluetooth: btusb: driver to enable the usb-wakeup feature"

Navid Emamdoost (1):
      Bluetooth: bpa10x: change return value

 drivers/bluetooth/bpa10x.c  |  2 +-
 drivers/bluetooth/btusb.c   |  8 +++-----
 drivers/bluetooth/hci_qca.c | 10 ++++++----
 net/bluetooth/hci_event.c   |  5 -----
 net/bluetooth/l2cap_core.c  |  9 +--------
 5 files changed, 11 insertions(+), 23 deletions(-)

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEyxvsVXjY3jV7sQ0/JCP2+/mo1BIFAl1wp9IACgkQJCP2+/mo
1BLznw/+LIFw58lLX/bOeG513L1ikqFrc10Udt+PuvPBEi1MDu8TOfRNdd0uKgWJ
AsoVfoQT3nsxz4g86A6KEbsj3QAwdHXZTxd1YxA4d1H7GdVSy79rCBTUhsoz9Vs9
EnNp9thWNlR2GUeQHoYsxHGBaglCJpowpxwXof6bKLS3bMfdCTkAv+yYNtRf83Cr
ADqnTWTElAxKe7RY4NjKXPyzBULKY/s0y/4Iu9Xy1gRZBn8LqBt723K7cPYhteMH
qgu6brILHvU4RrlE5xXkSi6Qh1GLqDwWRathqsnmAsqHQAFFD3YAO3DBL7nL/GNJ
OLAw5Doysdfh8mHP+LL2ZFauNHsIp7OpO6AwwoBMPDsGdFVTk6AQ+65t9HVv06AG
wHvjSuvC4TloD0M3ldhoFyB2aqT8j+abuSEML37LcT7n6hvmgCnBQiztPl8pMX41
PMmHyCTU62HgVQvmz4nr9GE/5f/HUhCIDeqRYly6yLyqFTxlSf4vkfrV8CWTXEPV
yElbF4rCvyPyRBi6uvPOT5bFaPg27galY77HZRnXfBKOpkDZzphddOjHosTSwECu
YtM/66bf+lKUCTpVUeitEo5WA1ipm3zCDL6TqwEM6/qe6ThjPoEOD2rbrsMHV0XT
GgC9mtTpFlS3XtS/d14shL/lum67qKfQDrAo2eifncqVGMf9ZD0=
=BCWj
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
