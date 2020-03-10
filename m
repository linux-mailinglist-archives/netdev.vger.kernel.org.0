Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F050180747
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 19:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbgCJSrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 14:47:39 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42335 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgCJSri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 14:47:38 -0400
Received: by mail-pf1-f193.google.com with SMTP id f5so6903140pfk.9
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 11:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=G90VbaNMIGZg/BzwTNjiUi1j0f7ZfUEqWoFv/RbnBEU=;
        b=Tm0/HIyKT5VfFDp5X+BGsHodNSilzTiX0KJh0k0FA+/btMCBXffYRF7yI9bMwDsrsq
         8/4/H+gDAAkzZtBUnFAlAR+4WWbxSY0ZaLPub4gGrj9VyjhNRMIxqL3o6JTQG6xOzTJO
         p/Cyz1Xi37yoapRlre5xRgjYuVKZoA07o0hJVGJ8z7kCDyVmawoPmbmRwlZ3XsRJ7zND
         ugLq6yHDO5nNfQfZayiU0qsPFPolOnOo+CLzNSXAdCGoNzVMtE19eYJ7ZuvxHlSkLZCS
         TJz7htCA4+Y4F4ZSB1z5UHpNLFs5nY346WVC+MG6bUWtv6kfZLRF6myUrPr6mMNRFqwL
         TYqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=G90VbaNMIGZg/BzwTNjiUi1j0f7ZfUEqWoFv/RbnBEU=;
        b=MYLuOVgFui/Tf1jC+U3KS57VukgY+zKtQOGEwr8/OiB9DFIzsNaQS4GabYYeuHPcGD
         Sb6UNjCBuD06cdNMEPSE/PNOZHlxWwy0GZfSXeY7xTVn3n/FijcTSVHP25exomiZOX+X
         lJaRghNgrZJNwGY7BTtMkoPJKoMVS4ATfwggJ6Eyzi7Nj3hG7ny4CExtlc0as7t5vvQg
         T79BFVUTaRfzJXRUZbZyuSKLCP89FXJWFh0i28fP0bAHWYkJOt/uJMHSIcgjcHuLc+u1
         oXbQfCeocW3d0ESXsYePk8tM779m74YeBMj97v1evz3ZQTNUWuVn8coBGdzAqngHnkzw
         c0eA==
X-Gm-Message-State: ANhLgQ1c/ImnLUbLvIxS6e/IhEvemgLIZxGsikwCIRXpUXG3xkj/u7Pp
        Ay9SSE1sQsWuiFAVQVje302Z7EEmPBw=
X-Google-Smtp-Source: ADFU+vu9dw07Qyy8VTL2SrqU22XXgTKU+/29fjieRKMQlV6mBh1sQ+ur71QFHECsHffwtiKYhgTieg==
X-Received: by 2002:a63:375b:: with SMTP id g27mr1380197pgn.151.1583866055853;
        Tue, 10 Mar 2020 11:47:35 -0700 (PDT)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id v67sm4240490pfc.120.2020.03.10.11.47.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 10 Mar 2020 11:47:35 -0700 (PDT)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH net-next 0/6] octeontx2-vf: Add network driver for virtual function
Date:   Wed, 11 Mar 2020 00:17:19 +0530
Message-Id: <1583866045-7129-1-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

This patch series adds  network driver for the virtual functions of
OcteonTX2 SOC's resource virtualization unit (RVU).

Geetha sowjanya (2):
  octeontx2-pf: Handle VF function level reset
  octeontx2-pf: Cleanup all receive buffers in SG descriptor

Sunil Goutham (1):
  octeontx2-pf: Enable SRIOV and added VF mbox handling

Tomasz Duszynski (3):
  octeontx2-vf: Virtual function driver dupport
  octeontx2-vf: Ethtool support
  octeontx2-vf: Link event notification support

 drivers/net/ethernet/marvell/octeontx2/Kconfig     |   6 +
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |   2 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  23 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  27 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 131 +++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 771 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_reg.h  |  13 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  35 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   | 674 ++++++++++++++++++
 9 files changed, 1671 insertions(+), 11 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c

-- 
2.7.4

