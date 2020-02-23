Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F38E16969A
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 08:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgBWHbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 02:31:49 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39591 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgBWHbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 02:31:48 -0500
Received: by mail-wr1-f67.google.com with SMTP id y11so6657358wrt.6
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 23:31:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RXN1AYBY22/d3z007DZLfV11591htx79RdpHiCBie0U=;
        b=qqGSSFxVh+FOEnNjHRYbIyp2uja6zNvfJKyx9f0oRlxnZsaYeazkACZDEe4bTVnqUW
         Nmt6L8tE1wTdsdWXTkcBb4vC4swFPH18x+7Nf+0SGgUFKF6DcMSuHVw69Hc+pBlu+KmT
         t2EaDLvRRlfqIoEKGJMZDZ1LnHLeXMzerpPDw8prZFBShVrZxD1n+DD/RnOpctBYAFzt
         /Z3oEVKOhHh3ng4un0KdQiAM+km2v3YgJA8ZcUDVhwbWsKkKbGS3kA9lJA7M3ZT+qcCV
         qxGCNn9GcgOrMiRrDOuAliChbDbwewrO70fBkPjU6Ru4vyHV/mFWrrZWxUYoZViaKw9J
         i4nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RXN1AYBY22/d3z007DZLfV11591htx79RdpHiCBie0U=;
        b=BK3J2ze2apqPNfgqEE8gVJ+IWMDq8k86sY1av3Vkd/uCpaERxRQSUx8AnSsOcSV9uT
         1a6hmtHenLW1TL8an3Jzgx2Q7fFDe0a27omvwrvOwDIsIeHYPLHvW3q36L6qo9vOMOEd
         kzuVUjZHJL6hSH9/e0aZWZz7ljqWD3lx0rFEEsI1DutpDyYSEwUml/2StnHIXzcUyGlQ
         XlEtfdclSfb2VP1Mz5ERk0on/STXs5kU+VwhuBbSlPw/CfR0/hKn9YY5+4SEN5mLLlL6
         u2MSbHgMlkRkK8bqVXtzko7MtiEZ50cdbAiLPwJ2o0xtgFjJY1jpDDjfZsO1H+9zt3mO
         Fb3A==
X-Gm-Message-State: APjAAAX68usBByO86K8ddl9ABCtn2OGuQKDKXXnhSMJETbb0jpAstf4w
        QbhLZyWsomnl3NiHfgqrhZqW+Dv3mJo=
X-Google-Smtp-Source: APXvYqxWaM0+vacQZnOz+gXlW1VK8+C+4isToM6hT6HaXx87hbcHF37RZ1cI8976riCiP1bWkYu7eg==
X-Received: by 2002:adf:e5c6:: with SMTP id a6mr60078920wrn.185.1582443105836;
        Sat, 22 Feb 2020 23:31:45 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id j5sm11993655wrb.33.2020.02.22.23.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2020 23:31:45 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 00/12] mlxsw: Cosmetic fixes
Date:   Sun, 23 Feb 2020 08:31:32 +0100
Message-Id: <20200223073144.28529-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

This is a set of mainly action/trap related cosmetic fixes.
No functional changes.

Ido Schimmel (1):
  mlxsw: pci: Remove unused values

Jiri Pirko (11):
  mlxsw: spectrum_trap: Use err variable instead of directly checking
    func return value
  mlxsw: spectrum_trap: Move functions to avoid their forward
    declarations
  mlxsw: core_acl_flex_actions: Rename Trap / Discard Action to Trap
    Action
  mlxsw: spectrum_trap: Move policer initialization to
    mlxsw_sp_trap_init()
  mlxsw: core: Remove unused action field from mlxsw_rx_listener struct
  mlxsw: core: Remove dummy union name from struct mlxsw_listener
  mlxsw: core: Convert is_event and is_ctrl bools to be single bits
  mlxsw: core: Remove initialization to false of mlxsw_listener struct
  mlxsw: spectrum_trap: Make global arrays const as they should be
  mlxsw: spectrum_acl: Make block arg const where appropriate
  mlxsw: core: Remove priv from listener equality comparison

 drivers/net/ethernet/mellanox/mlxsw/core.c    |  38 ++-
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  19 +-
 .../mellanox/mlxsw/core_acl_flex_actions.c    | 103 ++++----
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h  |   2 -
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   7 +-
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    |  10 +-
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 221 ++++++++----------
 7 files changed, 174 insertions(+), 226 deletions(-)

-- 
2.21.1

