Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F010B1888D9
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 16:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgCQPQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 11:16:37 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45974 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgCQPQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 11:16:37 -0400
Received: by mail-wr1-f66.google.com with SMTP id t2so16129863wrx.12
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 08:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=zDTn6ZeK0jeXWIJtj9Nm+9dxh7DkSDnIBF6/W8VVgV0=;
        b=Zx2zxpRy/4LU2Cy0EMVNGzRTG25Iq7BCM57c7RS4dop+oGKxWg07Oa4/oTRPH49g4v
         1KGfTveEtkFDqb8GYSXD2ja56bsSeGterp11uQA9kDS+gG1OrpDO/TDMPwM+IUUBPTpL
         2AKM6wf+FEFthXSoJa8hTRWCvIN+yIABIkX+s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zDTn6ZeK0jeXWIJtj9Nm+9dxh7DkSDnIBF6/W8VVgV0=;
        b=K8cXPAmXtGizMoUxXZ6mCJfkRhRAPotYB2xs7KbRKvY5LXcz1U92Hl7EnItw8qJBgN
         eu1V3AXQ9lMqa2qir8y2KOakmngY/U2//TLKjRd85ih5dkPLSvJDxfROhvmHaFibv6dW
         h+BjlzMuby40s8iSIRUq8gjqyPztECoih6CIeGjvFe9HSoHQHil7Mk7+1mnUXHKq1djI
         c5VZgHpfzIWFRlQUA3LcLXfy0VAdxoJBcGWM2o3cMQ5r05m/GW3vBGb6hfyJBpbBqELG
         pjTDtgf8JD7XEtoG+jyhw6AkCiTZATaJIwAkAfkavgkBYWDJ1hazxOt/VVVNQg9HaGOU
         mMdQ==
X-Gm-Message-State: ANhLgQ0UdzKpK2479HewGxrzq3FV07DpEk9XhX8QXIZZ9jzErcUa/EfT
        J5IWzX/xufwXLbl6Ly7K3JfYZLTuECA=
X-Google-Smtp-Source: ADFU+vsULdwYrn4Be6vxZnbJNBbFGs+d/kWPO26vOK4+m4jNXIMX/3dOB2uKYGd3SKMqOEtWD2SZSg==
X-Received: by 2002:a5d:6282:: with SMTP id k2mr6551722wru.401.1584458195997;
        Tue, 17 Mar 2020 08:16:35 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id x6sm4943916wrm.29.2020.03.17.08.16.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Mar 2020 08:16:35 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 00/11] bnxt_en updates to devlink cmd
Date:   Tue, 17 Mar 2020 20:44:37 +0530
Message-Id: <1584458082-29207-1-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for some of the generic as well as driver
specific macros to devlink info_get cb. Updates the devlink-info.rst
and bnxt.rst documentation accordingly.

Patchset also adds support for enable_ecn generic parameter and its
usage in bnxt_en driver.

Pavan Chebbi (2):
  devlink: Add new enable_ecn generic device param
  bnxt_en: Use "enable_ecn" devlink param

Vasundhara Volam (9):
  devlink: add macro for "drv.spec"
  bnxt_en: Add driver HWRM spec version to devlink info_get cb
  devlink: add macro for "hw.addr"
  bnxt_en: Refactor bnxt_hwrm_get_nvm_cfg_ver()
  bnxt_en: Add hw addr and multihost base hw addr to devlink info_get
    cb.
  PCI: Add new PCI_VPD_RO_KEYWORD_SERIALNO macro
  bnxt_en: Read partno and serialno of the board from VPD
  bnxt_en: Add partno and serialno to devlink info_get cb
  bnxt_en: Update firmware interface spec to 1.10.1.26.

 Documentation/networking/devlink/bnxt.rst          |  18 ++
 Documentation/networking/devlink/devlink-info.rst  |  11 +
 .../networking/devlink/devlink-params.rst          |   5 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  59 ++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   4 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  | 168 +++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h  |   3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      | 307 +++++++++++++++++++--
 include/linux/pci.h                                |   1 +
 include/net/devlink.h                              |  10 +
 net/core/devlink.c                                 |   5 +
 11 files changed, 546 insertions(+), 45 deletions(-)

-- 
1.8.3.1

