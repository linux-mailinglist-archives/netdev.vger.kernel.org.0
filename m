Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253D139AD3C
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 23:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhFCVyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 17:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhFCVyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 17:54:51 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F42C06174A;
        Thu,  3 Jun 2021 14:52:51 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id z26so5940047pfj.5;
        Thu, 03 Jun 2021 14:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fxjFz/H22/ll+OYsRPrhAcqdHH1oDOjEFZpsdu/tZ6w=;
        b=e+Hh2K1T/ghNgO8eOELOK80A8u1sn2IU4pnu7UxayzVpqal0EQrPzF5/ZMxU6W9tun
         FQ6fVES+hNvT5PSz7dvRLt9m7Y2muHhwkp4t6eo68EVy4df4Kxn80uFBJwjAtXjuHQnk
         30BuJXWSs9JDGeeIU5R2oeTVmH4lG8TAIeI1dr6cCmVUl19ZEafaUFM+B7snzNHx0t72
         YMHECHlfGwIgs3MpI/mgrdaN3EDA+bcFRVeypgfnZDAJbiUh526xrL1JzyFSIX2ylSrO
         4NJUcjwJffnThwYhyk28UTXc/59faD1gUzfKG3vsl8IAzfwpyFxrkRNvILgzcckwu7yy
         o54A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fxjFz/H22/ll+OYsRPrhAcqdHH1oDOjEFZpsdu/tZ6w=;
        b=Opf7BnsNrTDiobQhR3Q2Bt5rdKRcGr1NL+QQevRcPym5g11HR/4akgmhcROSqRSkY+
         /Wk9Nry3aZwvOuY8n5swu3VopSWjyJCD/LK6FXEt2oF1JeoCwkrxxG/EWYAN7+tKR2of
         08XXudXmyJVBFTPksHBKDNNc1OJmO1kgENripuHcOhl4Jb3oLa+CMppyGuCXb1pdOtWf
         EDxPQsUxVRCurYWh8a/7/Jk+x/dBn8Cpoxxr1bpN37xK1FpmZY9nOy3A04S5SF4Qs8L0
         zRd7IS3ICVb5/Qn+8n6P+VEOXclvCx3Xa1djaljogK/v44hezoLfTfmf2zfqreU3SGdV
         6h6A==
X-Gm-Message-State: AOAM530mwKmc8SDwNTEP34GE155LfbSX2funY1GJpkRiY5e+hYx5GIqH
        JvJwWBD88SilBxGiuF34vdw=
X-Google-Smtp-Source: ABdhPJxIsjz9WhYE26aRRgubOR9zGhcX9A53r3CHVUihAK15sYJ/Gi0RZSWKlw0+mX6wirglc/02sQ==
X-Received: by 2002:a62:e908:0:b029:2db:8791:c217 with SMTP id j8-20020a62e9080000b02902db8791c217mr1244862pfh.28.1622757170980;
        Thu, 03 Jun 2021 14:52:50 -0700 (PDT)
Received: from lvondent-mobl4.intel.com (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id t1sm65523pgl.40.2021.06.03.14.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 14:52:50 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth 2021-06-03
Date:   Thu,  3 Jun 2021 14:52:49 -0700
Message-Id: <20210603215249.1048521-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 62f3415db237b8d2aa9a804ff84ce2efa87df179:

  net: phy: Document phydev::dev_flags bits allocation (2021-05-26 13:15:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2021-06-03

for you to fetch changes up to 1f14a620f30b01234f8b61df396f513e2ec4887f:

  Bluetooth: btusb: Fix failing to init controllers with operation firmware (2021-06-03 14:02:17 -0700)

----------------------------------------------------------------
bluetooth pull request for net:

 - Fixes UAF and CVE-2021-3564
 - Fix VIRTIO_ID_BT to use an unassigned ID
 - Fix firmware loading on some Intel Controllers

----------------------------------------------------------------
Lin Ma (2):
      Bluetooth: fix the erroneous flush_work() order
      Bluetooth: use correct lock to prevent UAF of hdev object

Luiz Augusto von Dentz (1):
      Bluetooth: btusb: Fix failing to init controllers with operation firmware

Marcel Holtmann (1):
      Bluetooth: Fix VIRTIO_ID_BT assigned number

 drivers/bluetooth/btusb.c       | 23 +++++++++++++++++++++--
 include/uapi/linux/virtio_ids.h |  2 +-
 net/bluetooth/hci_core.c        |  7 ++++++-
 net/bluetooth/hci_sock.c        |  4 ++--
 4 files changed, 30 insertions(+), 6 deletions(-)
