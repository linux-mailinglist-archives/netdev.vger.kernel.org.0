Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0A9229E81
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 19:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730896AbgGVRYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 13:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgGVRYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 13:24:41 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4032EC0619DC;
        Wed, 22 Jul 2020 10:24:41 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id n2so2251499edr.5;
        Wed, 22 Jul 2020 10:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gPP0o2IshuB1LsGL+RlWYagGQFRTxZqJkVHgsKuPywk=;
        b=eXn7IUD/qqGZ665TjtY/1XQa6zE3hdJTIfxcjm9PHJSTXYZx8C6sRqi8KjavPYnP4j
         glhyUS6oA94YrOTN/C75FuWP7eHJF06P90j6gT4U8tHksMu8dYeOaUv4kEQJ2ZjGNrx4
         zmtxNETChqqAejiSizVPikMweJuWEBb8tqO2cjekgH6LP6r/CPW2gDyC8hTXDmPWPcf0
         3mUGe7ytgBVKEaljkhd3OWBCCQu5vlt0/oKnLKxRrJWaxWJTePwFYAKVzC86eHxajaEt
         5mwxIjbKDswO3P2a3H4oGhKR+L6iqHEoYdKEd4WHo2iE7wyXLbNoy9Sjv/NfQN+aa/Jb
         XSLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gPP0o2IshuB1LsGL+RlWYagGQFRTxZqJkVHgsKuPywk=;
        b=P+N2NS8gY7DOHMJ0S6X8dTADZD32WLiy3A1B6BXHNxwMoqZQhHmQxp7wFalNjJWIeJ
         2IpIiOsGMAfga5mPmeVshjSRoFHFz8zVIfCCFXvV4dG4wQdI2CcLN/jDtxbKRBf9SVnR
         xI5VdK1KxsoBCM2aNhR7PF38InoaCImGO1654F7Hwn6jne1VTL6DI2I8kblcNdER8DdW
         SGTnqHE0SGkQHRaMbetuj+3g6Prmg7L7JIR1dREWQU3Ty0YZNEU+6q2R1VExORgEZyCk
         ScPCTgB5DVpngsXco5gPdstXj03O43FHv3b6e+T3HmdwCkvyOLXrlI+GWBFZvX4ekvx0
         BkHw==
X-Gm-Message-State: AOAM533S+4Awmp12a3YK+g9inD6+LG76dIfd8q/hqlGyQM0dc+AAuIeW
        /vRM9wd3dvEtqQMfzAr0z/A=
X-Google-Smtp-Source: ABdhPJw6qCvxHjC43/yrpWhDOe/AsWnZXiBnfMRI2ghCPn3hOLpRGBpWv3Dxsjl6tQ8CgvCHhpH0Mw==
X-Received: by 2002:a05:6402:3064:: with SMTP id bs4mr517588edb.350.1595438679957;
        Wed, 22 Jul 2020 10:24:39 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id bt26sm311517edb.17.2020.07.22.10.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 10:24:39 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     robh+dt@kernel.org, shawnguo@kernel.org, mpe@ellerman.id.au,
        devicetree@vger.kernel.org
Cc:     benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Subject: [PATCH devicetree 0/4] Add Seville Ethernet switch to T1040RDB
Date:   Wed, 22 Jul 2020 20:24:18 +0300
Message-Id: <20200722172422.2590489-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Seville is a DSA switch that is embedded inside the T1040 SoC, and
supported by the mscc_seville DSA driver. The driver has been accepted
this release cycle and is currently available in net-next (and
therefore, in linux-next).

This series adds this switch to the SoC's dtsi files and to the T1040RDB
board file.

Vladimir Oltean (4):
  powerpc: dts: t1040: add bindings for Seville Ethernet switch
  powerpc: dts: t1040: label the 2 MDIO controllers
  powerpc: dts: t1040rdb: put SGMII PHY under &mdio0 label
  powerpc: dts: t1040rdb: add ports for Seville Ethernet switch

 arch/powerpc/boot/dts/fsl/t1040rdb.dts      | 123 +++++++++++++++++++-
 arch/powerpc/boot/dts/fsl/t1040si-post.dtsi |  79 ++++++++++++-
 2 files changed, 194 insertions(+), 8 deletions(-)

-- 
2.25.1

