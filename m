Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6B91E9EE3
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 09:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgFAHIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 03:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727769AbgFAHIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 03:08:07 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5543CC061A0E;
        Mon,  1 Jun 2020 00:08:07 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id z18so6756494lji.12;
        Mon, 01 Jun 2020 00:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-disposition;
        bh=teGMIGEAn03SZAqmtnK5Eu6aKuLPbrLDJb7FJDqvaOM=;
        b=qqQNOe5Kp2xXDLgI4mqggchcmLtjcg3TkOFUTyjbS2sD+AELJkLQ0sM85sffwd4WaE
         jEl8GVTRxtTJER2zovNEPEL4TnTjrha0IlImbRcYAS6aNCJx8/OVQSQ+BntSm4x+5IUz
         IdsI/kc1J0Wemp2CKH9Url/76SSuUn2wE5/QibTDx9zNPLLNdjfDkiooH8bKnxeVUFMA
         TwKqodLOOqeFJPMQucAXasBq1ueE9BiTq7EVdmVMjofDbIjIRUB7godEe+ImmO7Eswzu
         fbdDmTTObtWBFrJTzt/HzUSERyGNDQwO5OvVjX2MS1qZXdkbmA1UlBqvmmonNwzBWRqY
         8MfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition;
        bh=teGMIGEAn03SZAqmtnK5Eu6aKuLPbrLDJb7FJDqvaOM=;
        b=AuexlAZfk1iJzqNsWagdxj9qiQnye87xT+topejHtOj1raUW7x3Hj1wak1uFxAgVqa
         vhtpbNC3G4HLNuvU7U+mBMHJHeo7/Rm8Rb6th2jWKVjC6szAJ0su461KttMv7rnCH44G
         7meUd020CQ/eXt4rrwXo2NXwsOwn7H4bu2SXUf/cjgXb6zyFmu519s6IQbd8nKUdPC2/
         NFx/vfNdJiCS7vn0C9eSpgf9U8v7+uYxTI+gss67JmzXm5Yxt0os+kX2HluPdYcEQxlR
         Ao5FPrmMpccKi1Mbp7dhIN9LTwy/OJ/dGaT6hAPD9qEn+voBBrUbf8h32cZ2xX9Si68l
         /2Gw==
X-Gm-Message-State: AOAM532es6ZGzNnhizlisOZJLrpCFSpfgH2zH3uCSh9xAHYAYbdS2Gj/
        aRgintKrKLyLXwOn0oW/b64hiOOn8Ug=
X-Google-Smtp-Source: ABdhPJzRQ5yNhrGbMz2rTO8/rA9WStA+JQhGOgeunlLdmaV0kA44XmRDV8eAXVB8cxCmmzkSeNdMjQ==
X-Received: by 2002:a2e:a545:: with SMTP id e5mr9526990ljn.271.1590995285717;
        Mon, 01 Jun 2020 00:08:05 -0700 (PDT)
Received: from localhost (91-154-113-38.elisa-laajakaista.fi. [91.154.113.38])
        by smtp.gmail.com with ESMTPSA id h24sm4477850lfj.11.2020.06.01.00.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 00:08:04 -0700 (PDT)
Date:   Mon, 1 Jun 2020 10:08:03 +0300
From:   Johan Hedberg <johan.hedberg@gmail.com>
To:     davem@davemloft.net
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth-next 2020-06-01
Message-ID: <20200601070803.GA18009@jhedberg-mac01.home>
Mail-Followup-To: davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Here's one last bluetooth-next pull request for 5.8, which I hope can
still be accepted.

 - Enabled Wide-Band Speech (WBS) support for Qualcomm wcn3991
 - Multiple fixes/imprvovements to Qualcomm-based devices
 - Fix GAP/SEC/SEM/BI-10-C qualfication test case
 - Added support for Broadcom BCM4350C5 device
 - Several other smaller fixes & improvements

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit dbfe7d74376e187f3c6eaff822e85176bc2cd06e:

  rds: convert get_user_pages() --> pin_user_pages() (2020-05-17 12:37:45 -=
0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.gi=
t for-upstream

for you to fetch changes up to e5aeebddfc312ea7bb55dfe6c7264e71a3b43992:

  Bluetooth: hci_qca: Fix QCA6390 memdump failure (2020-06-01 08:07:33 +020=
0)

----------------------------------------------------------------
Abhishek Pandit-Subedi (2):
      Bluetooth: hci_qca: Enable WBS support for wcn3991
      Bluetooth: hci_qca: Fix uninitialized access to hdev

Azamat H. Hackimov (1):
      Bluetooth: btbcm: Added 003.006.007, changed 001.003.015

Chuhong Yuan (1):
      Bluetooth: btmtkuart: Improve exception handling in btmtuart_probe()

Gustavo A. R. Silva (1):
      Bluetooth: L2CAP: Replace zero-length array with flexible-array

Hsin-Yu Chao (1):
      Bluetooth: Add SCO fallback for invalid LMP parameters error

Luiz Augusto von Dentz (2):
      Bluetooth: Consolidate encryption handling in hci_encrypt_cfm
      Bluetooth: Fix assuming EIR flags can result in SSP authentication

Sebastian Andrzej Siewior (1):
      Bluetooth: Acquire sk_lock.slock without disabling interrupts

Zijun Hu (5):
      Bluetooth: hci_qca: Fix suspend/resume functionality failure
      Bluetooth: hci_qca: Fix qca6390 enable failure after warm reboot
      Bluetooth: hci_qca: Improve controller ID info log level
      Bluetooth: btmtkuart: Use serdev_device_write_buf() instead of serdev=
_device_write()
      Bluetooth: hci_qca: Fix QCA6390 memdump failure

=C5=81ukasz Rymanowski (1):
      Bluetooth: Fix for GAP/SEC/SEM/BI-10-C

 drivers/bluetooth/btbcm.c        |   3 +-
 drivers/bluetooth/btmtkuart.c    |  17 +++---
 drivers/bluetooth/btqca.c        |  14 +++--
 drivers/bluetooth/hci_qca.c      | 123 ++++++++++++++++++++++++++++++++---=
----
 include/net/bluetooth/hci_core.h |  20 ++++++-
 include/net/bluetooth/l2cap.h    |   6 +-
 net/bluetooth/hci_conn.c         |   2 -
 net/bluetooth/hci_event.c        |  29 ++-------
 net/bluetooth/rfcomm/sock.c      |   7 +--
 net/bluetooth/smp.c              |   4 ++
 10 files changed, 154 insertions(+), 71 deletions(-)

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQQ8m6QjaLXd1XJ73Dsfyv3T9pQ3KgUCXtSpUQAKCRAfyv3T9pQ3
KuvzAQCO5NoK8D0Udbo0aEgxCG3fuOcrHc66eTVVUqO4m0lxJwEAjvrGiL5woyRx
qfxurg76LzK40rbYA4+GIXVFX/sBJws=
=zNxK
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
