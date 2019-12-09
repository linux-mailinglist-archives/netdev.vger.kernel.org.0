Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59315116D4C
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 13:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbfLIMsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 07:48:13 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41140 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbfLIMsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 07:48:13 -0500
Received: by mail-pf1-f195.google.com with SMTP id s18so7185630pfd.8;
        Mon, 09 Dec 2019 04:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:user-agent;
        bh=NcUkOZc19gbsS2NnimxaYxAkciuFPds/CNa4rJKU++Q=;
        b=jgPTzQkWr9Z0r9gTe4tdKSppEdIdCA7KTuBX6Y3qMPr5y0EmyWnaQndvNiI43wOjIN
         7PjO0XaGZTRr8sBljY6ktV9A/1XP/fSR8ua2eHxqulSkhbi7OXgoiyfHDb/3U2s7NuLo
         Ymyy3uHP7jDziwtbeYncfRjYrjY+mBI51EAJJpNISoKJj403EjZ95Mcom/azvUKFRRgv
         dhuWIvjSJbtMJy9p1RTsD4XvTXajjItN3xyFoQmcx4GDO+g/1RQRd6KCWPMhloFZAvCv
         EvpdBb40KS/hjmimp/yjvnNMpz0ySNkyrsubM9QOIu0XR3uwGCOIY36IjkCsjI/WwwIk
         44vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition:user-agent;
        bh=NcUkOZc19gbsS2NnimxaYxAkciuFPds/CNa4rJKU++Q=;
        b=Q6AVIEuAtX7rl2lobRyaiWAK7TEIclN6i4Vd7yerYPpgjW5Y7ONbQLaQYb/kAYC3Ks
         KwzceUIQh572X6UyHGJyFT+mme7mt0i+shJggaXsYbr5PP99GJDlG/NliOhRaiXkXZ80
         llpQFbiVdQWr8R0raTWILBdJquwQQ3+qQwvD99kBxZpEVp8RAxxD2S3CWjm9P+0fSHIJ
         ztUer5jJaFPUW1JZsUYd1yASVoEYfWiiT9Ou7qpyUsKOKYejkvN3cMiDPI3qdBmVSKFg
         GamdHHxAk6cfJ3Hfbp3vQV7anNjLc10BTS8flMhZJToLyHCh9/0A7DQWmBtT5T11W6lc
         Rd8g==
X-Gm-Message-State: APjAAAUhJ2WlxOJXm+qNOejbdy85AoZcOauIng1cFcDMbPaCclv7fYc2
        y14nVBA07/qjGiEG3OyyEF7V9M/H+AfRQQ==
X-Google-Smtp-Source: APXvYqz+BqltE+Woe7RuKwWQyphl33r916ZqyuDENlzsL1Q2GgK1SrPp+/niax9WPMUIm3OXb1jnbw==
X-Received: by 2002:a62:d449:: with SMTP id u9mr30048066pfl.225.1575895692715;
        Mon, 09 Dec 2019 04:48:12 -0800 (PST)
Received: from localhost ([192.55.55.45])
        by smtp.gmail.com with ESMTPSA id g18sm24821707pfi.80.2019.12.09.04.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 04:48:11 -0800 (PST)
Date:   Mon, 9 Dec 2019 14:48:07 +0200
From:   Johan Hedberg <johan.hedberg@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth-next 2019-12-09
Message-ID: <20191209124807.GA7309@jhedberg-mac01.local>
Mail-Followup-To: davem@davemloft.net, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dave,

Here's the first bluetooth-next pull request for 5.6:

 - Devicetree bindings updates for Broadcom controllers
 - Add support for PCM configuration for Broadcom controllers
 - btusb: Fixes for Realtek devices
 - butsb: A few other smaller fixes (mem leak & non-atomic allocation issue)

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit be2eca94d144e3ffed565c483a58ecc76a869c98:

  Merge tag 'for-linus-5.5-1' of git://github.com/cminyard/linux-ipmi (2019-11-25 21:41:48 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to 7ecacafc240638148567742cca41aa7144b4fe1e:

  Bluetooth: btusb: Disable runtime suspend on Realtek devices (2019-12-05 10:31:29 +0100)

----------------------------------------------------------------
Abhishek Pandit-Subedi (5):
      Bluetooth: hci_bcm: Disallow set_baudrate for BCM4354
      Bluetooth: btbcm: Support pcm configuration
      dt-bindings: net: bluetooth: update broadcom-bluetooth
      Bluetooth: hci_bcm: Support pcm params in dts
      dt-bindings: net: bluetooth: Minor fix in broadcom-bluetooth

Colin Ian King (1):
      Bluetooth: btusb: fix memory leak on fw

Johan Hovold (1):
      Bluetooth: btusb: fix non-atomic allocation in completion handler

Kai-Heng Feng (1):
      Bluetooth: btusb: Disable runtime suspend on Realtek devices

Max Chou (1):
      Bluetooth: btusb: Edit the logical value for Realtek Bluetooth reset

 .../devicetree/bindings/net/broadcom-bluetooth.txt |  7 +++
 drivers/bluetooth/btbcm.c                          | 46 ++++++++++++++++++++
 drivers/bluetooth/btbcm.h                          | 16 +++++++
 drivers/bluetooth/btusb.c                          | 12 ++++--
 drivers/bluetooth/hci_bcm.c                        | 50 +++++++++++++++++++++-
 5 files changed, 125 insertions(+), 6 deletions(-)

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEyxvsVXjY3jV7sQ0/JCP2+/mo1BIFAl3uQoYACgkQJCP2+/mo
1BKzUg//Qf6RSP/Hr56Hyknpnhy2IM29ilPwzMPGT1p66C2LMhTgwLAMAlwirx5r
KOtfHFR/CzgSdAcSLEt7Ha6QM6zwsj2Vnld8u+F6pVlsYlA/oC+tmnyEGysNGwfS
0NT55HW6hG66AfjvK9zWv7dZOkHFrQJK41paqwamhExbJOzEopmftlcBa0fzfpAU
welc02DlCvigZL279E3PAJKaVL4qS6NjuvLrZQLuUjPpnHWZNrWKENkdHeUgXeLj
OIFzb87iDOpiyKEjhxREuHsT9tj65wZotf26R3eekh0QvnPa4aoqpArCHaqFH5DA
rLetS8Ej0IgkpMA/TLWoHxm6Sjh7VnV2S1ZhAu4i/JKt3OGEJEPh5bkN7XR3quvd
15km/luGU4trXNo8DDWHfnlGVYYRUW2kGCko1mNX/oRkq5m88jiGCaKchMQ3/rM9
NOjjc+jcmu1V4XTS1LhQ+/5V3Gf5NdJsfu8pk0q4Bx+WMq5eqhNh7bfyhPJJv5Kd
OX4VtQhkDSctr0GbqKfVUbaK0KoI/f5axdnU91Sf0fv0xiVcyZ0vic+00GaVFyJI
F+VjDMpa77EDiPQybL063VFqeybmZH2HX6Bg1bTulRcHU/TsbVK0DWGAa6FbuTxc
J+UA9UKsdZBQbFPMbY9kF1RPYThkmm+J7GJ34WBPFAmvgeoV+aw=
=2xWZ
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
