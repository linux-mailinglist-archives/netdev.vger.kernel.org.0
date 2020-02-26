Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC76B16F9B5
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 09:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbgBZIjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 03:39:25 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46215 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgBZIjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 03:39:25 -0500
Received: by mail-wr1-f67.google.com with SMTP id j7so1802195wrp.13
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 00:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O3GYw7IiPfHISwu2X7OMlzNmWNaPwarOE1KSW2/647c=;
        b=Yf6YAi80CTNsiyuwCqDIzNEEgQQwwA4nn4xB8CgpsRoIsaiAi1ySuGYavOz1qFTj9R
         bSYVYIyE3wB0X3AYZNxB72g35JgGaqJDKl4Bhc/uZBz6GOUa0A/WtJ3c9wM4fLUCO0nU
         dtQMr8yTRVyR2QmqtqRthwU99oUVWThqRgMKnZQwJcMmd44V9XDI21lP7TA/GH4M7aac
         DuWQMAcZLSHItMCrsZ17IPHtnEVd+IfKnuxTvhmTAIdeopq8oLDY37woGwrexvbPNM6D
         YPRksIW7qxtak5jvS5T7Qd3JnDRl63RiM4OxWXMjtVkah1QMkEsMFHMMx8L/htZqNHC9
         TZJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O3GYw7IiPfHISwu2X7OMlzNmWNaPwarOE1KSW2/647c=;
        b=YF+IZVR8CbBHO1osn96eIwVgnNkHYz/zyZM5tcZfkkjqntqk0xrQw/6+FR1K32zbgG
         MLiuwIPNY4HACK8obWSluoJNRaRAwcpO5pVozmksy1+oHeQhQBSna7Kbf4vXTXSs69B4
         mF1iv5h0VX+Nm+85utDugBHWv3HjTkYl2RcRRfPR3Kh6mFdrHv/TSNwjAEC+oaIpYZI/
         S72r6NZKfxdviAHYkKEisrYJ4t5j9e/UsbZQu1YAN8pX9IOzYNZd3yEpsLGz8BW0k30P
         H9QpmyeMR17av+uva9lJkT2yQKwpCG5Qj5pXFEHFBQgL1tnvgK/bsMWK1TwXS5IRwHym
         9QfQ==
X-Gm-Message-State: APjAAAXrRK24GSSQndQ9GKiUKxNU6x6i4W4uF1yygMvoOugJDaKgp1+u
        HO8XdsiRnKFo5pTVbzDynpMfXPxdd/g=
X-Google-Smtp-Source: APXvYqz9yGT6GXcIJZNkttHd+1M20LG67jAMCX1uJqnIb6BIm51Kn2eHXx536xj5w5knRDyJjM6P1A==
X-Received: by 2002:a05:6000:1046:: with SMTP id c6mr328993wrx.411.1582706361802;
        Wed, 26 Feb 2020 00:39:21 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id i2sm1901910wmb.28.2020.02.26.00.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 00:39:21 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 0/4] mlxsw: Small driver update
Date:   Wed, 26 Feb 2020 09:39:16 +0100
Message-Id: <20200226083920.16232-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

This patchset contains couple of patches not related to each other. They
are small optimization and extension changes to the driver.

Ido Schimmel (1):
  mlxsw: spectrum: Initialize advertised speeds to supported speeds

Jiri Pirko (1):
  mlxsw: spectrum_switchdev: Optimize SFN records processing

Petr Machata (2):
  mlxsw: spectrum: Move the ECN-marked packet counter to ethtool
  mlxsw: spectrum: Add mlxsw_sp_span_ops.buffsize_get for Spectrum-3

 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 134 +++++++-----------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   6 -
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  |   9 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       |  35 +++--
 5 files changed, 80 insertions(+), 106 deletions(-)

-- 
2.21.1

