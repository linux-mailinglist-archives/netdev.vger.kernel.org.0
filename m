Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE45487E06
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 22:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiAGVJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 16:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiAGVJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 16:09:44 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E630C061574;
        Fri,  7 Jan 2022 13:09:44 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id z30so2953532pge.4;
        Fri, 07 Jan 2022 13:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XkYADB5CgWF1drM8ejpgrhca/LafZph1PQYcMctGTyY=;
        b=kCk29wImjCjzHK6rAmmOa6qjr8RtnjMf95p5gxfADOuiwE8cCxt1jQNQqVBYgDE0JQ
         exSWNifZSZxUfkqcR3S1r4bt7rcsIdliYEJOufZ+EJUe+3FqOzm3LRXFad0wHZCFSPj1
         eQ4UjnAlVhpSofW/gj7XEzKf8pg8jjqUo78TFaPSyp41wA/mlu476jV9/vs7aKKNUw7i
         HHMqRw5YWZZQvUs4JgCBSuOQN+gdXlaTt8WpVkxjLOBBSHz+9UZkUnhvxOy8NilJtiwZ
         /FCLIo4hczxNu7f0IhVnyFNmBhPGfvUcEgnT0G73b/kzC72J1ClSYifI5HnrCcuVky90
         9L4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XkYADB5CgWF1drM8ejpgrhca/LafZph1PQYcMctGTyY=;
        b=3Wfzl/N99gOu/HwEbLb3WhgKpyp/Dc5PX4VZ1wdezHyBPSibavMcZ5ITIaVXvp2LaU
         HHsEV1fnbPsEFnuFkRNtBDbQeCxg0PGgmGyjwR09Ck+di7ui8oiHFZDNCN1JmYTIty3M
         jNwq6AyQ7z1kE/jLfn8bOZjmldoGFTDCQF13swVUZyYgKZ+6ypkDHn9AeV8B/uRcM5Fi
         3Bb17Oegx+oUTClfSnLPEu7yB+RK+pTzKr/0iKx1iQoIVotA9ePZ+vvyePJ2ITvhtxNQ
         nMNUC91aYIuMJx4hS0sFiXt9Tz6m36X0277gai9VcGSyYXSGRHpWRiIOAasnQMkmRpvS
         7Qbw==
X-Gm-Message-State: AOAM532A0raLlxL2JJCLjRaQGpN04WQZ6mmpj5Ggtrul19f7Y2DhC2Ud
        mzKpZib0vEbLcYzcewJnlT4=
X-Google-Smtp-Source: ABdhPJzycjN36sI7wx/zmdotMqQlChYtSSDDulGWMNzoNMBtXCMwSK1M08dshrMGcji6DIBro3aS8Q==
X-Received: by 2002:a05:6a00:22d2:b0:4b0:da80:2dac with SMTP id f18-20020a056a0022d200b004b0da802dacmr65830344pfj.66.1641589784075;
        Fri, 07 Jan 2022 13:09:44 -0800 (PST)
Received: from lvondent-mobl4.. (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id hk13sm7127815pjb.35.2022.01.07.13.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 13:09:43 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth 2022-01-07
Date:   Fri,  7 Jan 2022 13:09:42 -0800
Message-Id: <20220107210942.3750887-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 710ad98c363a66a0cd8526465426c5c5f8377ee0:

  veth: Do not record rx queue hint in veth_xmit (2022-01-06 13:49:54 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2022-01-07

for you to fetch changes up to b9f9dbad0bd1c302d357fdd327c398f51f5fc2b1:

  Bluetooth: hci_sock: fix endian bug in hci_sock_setsockopt() (2022-01-07 08:41:38 +0100)

----------------------------------------------------------------
bluetooth-next pull request for net-next:

 - Add support for Foxconn QCA 0xe0d0
 - Fix HCI init sequence on MacBook Air 8,1 and 8,2
 - Fix Intel firmware loading on legacy ROM devices

----------------------------------------------------------------
Aaron Ma (1):
      Bluetooth: btusb: Add support for Foxconn QCA 0xe0d0

Aditya Garg (1):
      Bluetooth: btbcm: disable read tx power for MacBook Air 8,1 and 8,2

Dan Carpenter (2):
      Bluetooth: L2CAP: uninitialized variables in l2cap_sock_setsockopt()
      Bluetooth: hci_sock: fix endian bug in hci_sock_setsockopt()

Jiasheng Jiang (1):
      Bluetooth: hci_bcm: Check for error irq

Luiz Augusto von Dentz (1):
      Bluetooth: hci_event: Rework hci_inquiry_result_with_rssi_evt

Miaoqian Lin (1):
      Bluetooth: hci_qca: Fix NULL vs IS_ERR_OR_NULL check in qca_serdev_probe

Sai Teja Aluvala (1):
      Bluetooth: btqca: sequential validation

Tedd Ho-Jeong An (1):
      Bluetooth: btintel: Fix broken LED quirk for legacy ROM devices

 drivers/bluetooth/btbcm.c   | 12 ++++++++++++
 drivers/bluetooth/btintel.c | 20 ++++++++++---------
 drivers/bluetooth/btintel.h |  2 +-
 drivers/bluetooth/btqca.c   | 47 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/bluetooth/btqca.h   |  2 ++
 drivers/bluetooth/btusb.c   | 16 ++++++++++++---
 drivers/bluetooth/hci_bcm.c |  7 ++++++-
 drivers/bluetooth/hci_qca.c |  6 +++---
 include/net/bluetooth/hci.h |  6 +-----
 net/bluetooth/hci_event.c   | 19 +++++++++---------
 net/bluetooth/hci_sock.c    |  5 +++--
 net/bluetooth/l2cap_sock.c  | 14 ++++++++------
 12 files changed, 116 insertions(+), 40 deletions(-)
