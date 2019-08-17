Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFD19104E
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 13:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfHQLo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 07:44:57 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39289 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbfHQLo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 07:44:57 -0400
Received: by mail-pg1-f196.google.com with SMTP id u17so4263501pgi.6;
        Sat, 17 Aug 2019 04:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition:user-agent;
        bh=/hJX16OzWnlZFkUFzV1Tz90ho3RnZb6JCm8tAUxRY5o=;
        b=sRE3JxIjE4ct2BL2rmIDpl3MfGfrzcCtgp4yEB77cNLtfjqENPqnj65LCBkwHjp4zo
         unA+atZnbwUXaUGDryIWOuiAxKGErXmXtFXbZ/XyAKFaMQIUcpr8axC0Y51IKGjOyBPA
         GlMyFPIhuJATQAljSStrOj1XCimlBjGzVtiU9oYjK0wp+CQJX4rgjfsVl62pk8Qq1RU+
         /Ugq9KF7Lpo73gfgJluLMn+iZG5WtjzX+vOwgWazkShcuUDFft0xNFvOspR3+yjnBs2R
         TXr67zj6Nh7neRQNp8Rvj2lZG5qjZaux3Tqgv9SVCOWOSPQKy/6J8262tgSWQPzan6SI
         cZ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition:user-agent;
        bh=/hJX16OzWnlZFkUFzV1Tz90ho3RnZb6JCm8tAUxRY5o=;
        b=e+U1REOmI0zD8tnW9Mqv5L9pyRIyxuhTU5PBDzJUFUh2YMN0+PAu1z6FXcUaXfKP4f
         WZVDLmJ3o+wKDxTyW7OYV/8rKke27WY8dB841Zgs0vapCc2GQCDlVBhgn0Lr0BNZ1M8v
         Rx/RP1zY3q+zx6/XmO3pFo+NuSIP4vm/3has1H5C4Hv7VlrRDCcFbvoQE/DKyEb30HJX
         Yc/QOinelfp7IR/mFuztF7F8GwIicX34N/dzdqtwnVU803A0J2USGNa/G3CVyxIjS1yc
         /7D0jGxRPTY72Q3O9OP0xkLlmHWDnOMPzd3muKpz1rcaKVrOlATfqS3vemnqIRsW0FJ/
         IuJQ==
X-Gm-Message-State: APjAAAU3e1hLhHj0IYbZKk8Vr/ac+JzDLpZ8hoFOo3jrPL7521JzOhB0
        R6lXtK242xPNe/gETPstKHpnoXCYYY6ZXg==
X-Google-Smtp-Source: APXvYqxozeN6vvbrkb5j8pxSfQgc/vELhDJyfobHVGXD9M7p70IM/sOZAanlxaJ3D5u2o0ZMxpetlw==
X-Received: by 2002:a65:5144:: with SMTP id g4mr11719945pgq.202.1566042296426;
        Sat, 17 Aug 2019 04:44:56 -0700 (PDT)
Received: from localhost ([192.55.54.43])
        by smtp.gmail.com with ESMTPSA id t7sm7549026pgp.68.2019.08.17.04.44.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Aug 2019 04:44:54 -0700 (PDT)
Date:   Sat, 17 Aug 2019 14:44:51 +0300
From:   Johan Hedberg <johan.hedberg@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth 2019-08-17
Message-ID: <20190817114451.GA10661@abukhnin-mobl1.ccr.corp.intel.com>
Mail-Followup-To: davem@davemloft.net, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dave,

Here's a set of Bluetooth fixes for the 5.3-rc series:

 - Multiple fixes for Qualcomm (btqca & hci_qca) drivers
 - Minimum encryption key size debugfs setting (this is required for
   Bluetooth Qualification)
 - Fix hidp_send_message() to have a meaningful return value

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit 125b7e0949d4e72b15c2b1a1590f8cece985a918:

  net: tc35815: Explicitly check NET_IP_ALIGN is not zero in tc35815_rx (2019-08-11 21:41:48 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git for-upstream

for you to fetch changes up to 58a96fc35375ab87db7c5b69336f5befde1b548f:

  Bluetooth: Add debug setting for changing minimum encryption key size (2019-08-17 13:54:40 +0300)

----------------------------------------------------------------
Balakrishna Godavarthi (1):
      Bluetooth: btqca: Reset download type to default

Claire Chang (1):
      Bluetooth: btqca: release_firmware after qca_inject_cmd_complete_event

Fabian Henneke (1):
      Bluetooth: hidp: Let hidp_send_message return number of queued bytes

Harish Bandi (1):
      Bluetooth: hci_qca: Send VS pre shutdown command.

Marcel Holtmann (1):
      Bluetooth: Add debug setting for changing minimum encryption key size

Matthias Kaehlcke (2):
      Bluetooth: btqca: Add a short delay before downloading the NVM
      Bluetooth: btqca: Use correct byte format for opcode of injected command

Rocky Liao (1):
      Bluetooth: hci_qca: Skip 1 error print in device_want_to_sleep()

Wei Yongjun (2):
      Bluetooth: btusb: Fix error return code in btusb_mtk_setup_firmware()
      Bluetooth: hci_qca: Use kfree_skb() instead of kfree()

 drivers/bluetooth/btqca.c        | 29 +++++++++++++++++++++++++++--
 drivers/bluetooth/btqca.h        |  7 +++++++
 drivers/bluetooth/btusb.c        |  4 +++-
 drivers/bluetooth/hci_qca.c      |  9 ++++++---
 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/hci_core.c         |  1 +
 net/bluetooth/hci_debugfs.c      | 31 +++++++++++++++++++++++++++++++
 net/bluetooth/hidp/core.c        |  9 +++++++--
 net/bluetooth/l2cap_core.c       |  2 +-
 9 files changed, 84 insertions(+), 9 deletions(-)

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEyxvsVXjY3jV7sQ0/JCP2+/mo1BIFAl1X6LEACgkQJCP2+/mo
1BI7VBAAuB/Qbd2b4R4Uhu0UgRXMF0sjsMVIncf/RkyhLwUiFtDhxCCqegroj628
ucDIiIPIuMFWZlVdL/7+mIHobgkwjf6dyUw/urKbTUvm+M5uL35E98Vl05snnr+I
xapVw+NtnXp2sETdERJRiRMK9GtNc0aP/zXTCwW17oWJFQfAxrAjVAhKZwUtN762
Al3tLi44L23kc0jdfKF3npetybeyH7GN4nPMbw07URESEh8iO0ZDlQ4VYL63qcgT
8wtR9OffS9t9SqW2dA7jGVT7t8zLVf7Dnd1inN1UZoMyB5vG+MGBaGJvfjrPDOeq
OZuDNbz8nKPxuf2UmOPIilBL8g8K9qUYW1MVmsrBlKXjMaJKj9FMOIdXZF1T7K54
BiQaeM6kvbRuaiHG4W4/StI64lka2ZDFUtkDPz+TZ/5hN5zQH6q0isnbDkygwYRl
QWYujQNejKRVmTlvCq0jVUTPEBDMaEd3Om2ugv1SF6nGPrG5kFBH5OWse9Gns81h
d7aRLfc9M6xUZ4/w17JqBN0GLm7f1o7nKqGMSvqN7I/36BM7BuvObS3AXJ2TY6dH
MMTMwzPKWgVWTIb4quEppXqNegB2wiqkP9OlBNhL4pqsiV1wj9y8TmheIcdOWkdh
C86nTfWMz1ZUkKxeBONvYQBNYdPyTzsoyUdMXYLTc0KWYxgwOsw=
=Zjok
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
