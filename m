Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 681BF4ED38
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 18:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbfFUQjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 12:39:52 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36567 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfFUQjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 12:39:52 -0400
Received: by mail-pl1-f193.google.com with SMTP id k8so3277196plt.3;
        Fri, 21 Jun 2019 09:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K/oM9MiJ+YoaLl7ZRiNfUcpN2FrI/0gTJNusR9Pmj58=;
        b=L9R2M6Z1d5nINcBYvAgMOP97hnIL1JvsZELIkfeZuXRfI8UCAPEOIXgm368nReWzzX
         7GhgE+Vo91OAcMAKqIz9QxGwJ5aER+p0sbxhq72nWrtEfmaTO6W2SLESbBZCDyBDf0Cl
         XO/jky3A/Rur7DUQUMsCsebe10lHJ1zZ3CLdj/+JMIb9PXltU5Vq4yqEztLOieIoNglv
         6dKKGJqKhJJaupg/mrhFw7+YFdCkaf7LRmemd91pR4RdlaUE7WtX9rX+W25QILEobH0p
         /L6eK3SijuF4O4J+siLxl0mOyi2gO2GGIjrb8VnqdUDQKve1Eh/dHKMfFqJpR9gHOFvO
         7GgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K/oM9MiJ+YoaLl7ZRiNfUcpN2FrI/0gTJNusR9Pmj58=;
        b=WIfFyAdK38h8ZASXMJJKa+AQlgQN0LDV4u4d//mezo60cuTMgz/AYg+FSmd57PcNQn
         OtQB++Nru8E9jwiMD5hpnMWpf+nXgj/ZmPMrwzTNYzbhospBo5Qae9Cr5eDpM9Gc48Cq
         x9sg1ZAeuPKZd05dlST1H/Bv6LaTPCU/yRglzV2aHU3KUNrRLZMh93qEXPO8uLAh1inp
         tiOZeWZhfmBN1KYES6qALipNtwJyhdMx/eQ8/8YckRzs6humB689ISA7ceY6TIdhIK1v
         RN/jq60xyjQx5W1sOxmdFwq8Ef1HoiFbVxkIqqqpXAPvuTKe8i62ACkqMDrR/BH+nwdW
         SfXQ==
X-Gm-Message-State: APjAAAWQ7rDd2paqf3JeW0fjiPtum+9o3fz0KEzaksfUclEwsYLyG09J
        zdQmpodwKzKCvQWgqh+oN+s=
X-Google-Smtp-Source: APXvYqx2TvZTnWfhHPL/eUpzz0cnLBD+Ha8WUSYjaHY+p4EaHqpIwaZzbheWnR8U0u2GeXGJBY/rSA==
X-Received: by 2002:a17:902:106:: with SMTP id 6mr70087637plb.64.1561135191752;
        Fri, 21 Jun 2019 09:39:51 -0700 (PDT)
Received: from localhost.localdomain ([112.196.181.13])
        by smtp.googlemail.com with ESMTPSA id n89sm25702450pjc.0.2019.06.21.09.39.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 09:39:51 -0700 (PDT)
From:   Puranjay Mohan <puranjay12@gmail.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Puranjay Mohan <puranjay12@gmail.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 0/3] net: ethernet: atheros: atlx: Use PCI generic definitions instead of private duplicates
Date:   Fri, 21 Jun 2019 22:09:18 +0530
Message-Id: <20190621163921.26188-1-puranjay12@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series removes the private duplicates of PCI definitions in
favour of generic definitions defined in pci_regs.h.

Puranjay Mohan (3):
  net: ethernet: atheros: atlx: Rename local PCI defines to generic
    names
  net: ethernet: atheros: atlx: Include generic PCI definitions
  net: ethernet: atheros: atlx: Remove unused and private PCI
    definitions

 drivers/net/ethernet/atheros/atlx/atl2.c | 5 +++--
 drivers/net/ethernet/atheros/atlx/atl2.h | 2 --
 drivers/net/ethernet/atheros/atlx/atlx.h | 1 -
 3 files changed, 3 insertions(+), 5 deletions(-)

-- 
2.21.0

