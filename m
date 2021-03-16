Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8497833D7FC
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237282AbhCPPq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237322AbhCPPq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 11:46:29 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB92C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 08:46:29 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so1656721pjv.1
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 08:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=y5cTsgNCgHlNBZ7EFWQzHkHpsu2o7RST9agxWXKu7To=;
        b=mTe9tZnObCwDW6nH1b0Z5v5bkafFRxdUp/20vmIEkk8+RWUjWqPdi8EzWpfpvt16w7
         jW1gPynWwLENxQyohZ1dW1aK7k6zC9Wjro3omMLvLgpi6vt57SyL/XLHz1YDiPa9eYVV
         RGCtng0XzaF3MbkO/Pzb9SDZw/rIKssgggECmT7BemgfjvUFoKAkDY/Z4MdgdbcF5Ldq
         vWGFLJt2GFn+exGtRoNqyY25S+us61XUg7JDZvxhXMNBX1XNe5mnVn40lN7ZlVwl7jnI
         TVlGV8GQnpUqswkbHkiisX0zh+TPC9AlFDhb4lOBaiD9XLV1Sf+79cGLNzhPDw5hSu4D
         dZpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=y5cTsgNCgHlNBZ7EFWQzHkHpsu2o7RST9agxWXKu7To=;
        b=s5IUwplkWy1h3mWGTzb3SgDhptBZg0KFW6sLJ5Oqy72vH7MG85NP3XbHdgee9+itiG
         9LUOIUCl89v6Nyg257A7eCq62nbX0dyg7D2fzQRwyfp+hfsBraKhKzimgOtkFuINwjbZ
         D7mHZ/X103uPwL7rlYL8kedCYROhRJA3aZACd8xc5TGEefIbyK95YZO0TBTgFrE0NXBI
         kg+usx96hW67DQ2A0gVsBVNPoTIPIrf/HfpiG7sBOXJpzrN/FtXhXIVWZLoLqthoLYrC
         Aa+9vQypFsFiUH2mRMZe9Bdv80WyNvVpb7JbKR0uM1gxpUsrVwC5KD2Rid1lkUgIhIsg
         gkYQ==
X-Gm-Message-State: AOAM530/4dIY7d+NJc0ATn9uPYd6NSged+/ARVf+sJSO00vJYD5Ui2P6
        OfqovfOJkT2F7JuQjB/Gh60KZsh3so5Jew==
X-Google-Smtp-Source: ABdhPJw+7r2qn0AMKsPmjSU0s/dRlhoejgwxvmNRYSo5trKCBuKZfv3ArBGZGB2FcEkP1CWLLHC9dg==
X-Received: by 2002:a17:90a:cca:: with SMTP id 10mr267516pjt.103.1615909588297;
        Tue, 16 Mar 2021 08:46:28 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id o13sm17537783pgv.40.2021.03.16.08.46.27
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 08:46:28 -0700 (PDT)
Date:   Tue, 16 Mar 2021 08:46:19 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 212299] New: RK3288-RTL8211E ethernet driver error
Message-ID: <20210316084619.40d673fb@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Tue, 16 Mar 2021 06:39:54 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 212299] New: RK3288-RTL8211E ethernet driver error


https://bugzilla.kernel.org/show_bug.cgi?id=212299

            Bug ID: 212299
           Summary: RK3288-RTL8211E ethernet driver error
           Product: Networking
           Version: 2.5
    Kernel Version: 5.11.6
          Hardware: ARM
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: msubair@hotmail.com
        Regression: No

RK3288 board which has RTL8211E ethernet chip and ACT8846 PMU controller.
The dts file has following info, and it includes rk3288.dtsi
----------------------------------------------------------------------------
&gmac {
        assigned-clocks = <&cru SCLK_MAC>;
        assigned-clock-parents = <&ext_gmac>;
        clock_in_out = "input";
        pinctrl-names = "default";
        pinctrl-0 = <&rgmii_pins>, <&phy_rst>, <&phy_pmeb>, <&phy_int>;
        phy-supply = <&vcc_lan>;
        phy-mode = "rgmii";
        snps,reset-active-low;
        snps,reset-delays-us = <0 10000 100000>;
        snps,reset-gpio = <&gpio4 RK_PB0 GPIO_ACTIVE_LOW>;
        tx_delay = <0x30>;
        rx_delay = <0x10>;
        status = "okay";
};
----------------------------------------------------------------------------
The ethernet never comes up and giving below error.

root@LXCNAME:~# dmesg | grep eth
[    2.519105] rk_gmac-dwmac ff290000.ethernet: IRQ eth_lpi not found
[    2.526163] rk_gmac-dwmac ff290000.ethernet: PTP uses main clock
[    2.532916] rk_gmac-dwmac ff290000.ethernet: phy regulator is not available
yet, deferred probing
[    2.574228] usbcore: registered new interface driver cdc_ether
[    3.358577] rk_gmac-dwmac ff290000.ethernet: IRQ eth_lpi not found
[    3.358633] rk_gmac-dwmac ff290000.ethernet: PTP uses main clock
[    3.358851] rk_gmac-dwmac ff290000.ethernet: clock input or output? (input).
[    3.358857] rk_gmac-dwmac ff290000.ethernet: TX delay(0x30).
[    3.358861] rk_gmac-dwmac ff290000.ethernet: RX delay(0x10).
[    3.358868] rk_gmac-dwmac ff290000.ethernet: integrated PHY? (no).
[    3.358895] rk_gmac-dwmac ff290000.ethernet: cannot get clock clk_mac_speed
[    3.358898] rk_gmac-dwmac ff290000.ethernet: clock input from PHY
[    3.363906] rk_gmac-dwmac ff290000.ethernet: init for RGMII
[    3.364096] rk_gmac-dwmac ff290000.ethernet: User ID: 0x10, Synopsys ID:
0x35
[    3.364104] rk_gmac-dwmac ff290000.ethernet:         DWMAC1000
[    3.364107] rk_gmac-dwmac ff290000.ethernet: DMA HW capability register
supported
[    3.364111] rk_gmac-dwmac ff290000.ethernet: RX Checksum Offload Engine
supported
[    3.364114] rk_gmac-dwmac ff290000.ethernet: COE Type 2
[    3.364118] rk_gmac-dwmac ff290000.ethernet: TX Checksum insertion supported
[    3.364121] rk_gmac-dwmac ff290000.ethernet: Wake-Up On Lan supported
[    3.364157] rk_gmac-dwmac ff290000.ethernet: Normal descriptors
[    3.364160] rk_gmac-dwmac ff290000.ethernet: Ring mode enabled
[    3.364164] rk_gmac-dwmac ff290000.ethernet: Enable RX Mitigation via HW
Watchdog Timer
[    8.156632] rk_gmac-dwmac ff290000.ethernet eth0: validation of rgmii with
support 0000000,00000000,00006280 and advertisement 0000000,00000000,00006280
failed: -22
[    8.157755] rk_gmac-dwmac ff290000.ethernet eth0: stmmac_open: Cannot attach
to PHY (error: -22)
root@LXCNAME:~# dmesg | grep sdmmac
root@LXCNAME:~# dmesg | grep stmmac
[    3.466622] libphy: stmmac: probed
[    3.490765] mdio_bus stmmac-0:00: attached PHY driver [unbound]
(mii_bus:phy_addr=stmmac-0:00, irq=POLL)
[    3.504573] mdio_bus stmmac-0:01: attached PHY driver [unbound]
(mii_bus:phy_addr=stmmac-0:01, irq=POLL)
[    3.567118] mdio_bus stmmac-0:02: attached PHY driver [unbound]
(mii_bus:phy_addr=stmmac-0:02, irq=POLL)
[    3.577736] mdio_bus stmmac-0

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
