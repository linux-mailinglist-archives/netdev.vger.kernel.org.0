Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3398214F09
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 21:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgGETva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 15:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728006AbgGETva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 15:51:30 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F184C061794;
        Sun,  5 Jul 2020 12:51:30 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id u18so782796pfk.10;
        Sun, 05 Jul 2020 12:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3mJ//dF2UdH+rMidooXAGoMJs/gWdqGSD9KZJf42iTw=;
        b=p8xZbkhs+DbIDcbMjb4gSiF+czEN1o55lIQEib7q/iq6WSsVjoh9tcuu780oo/K9b5
         fLXgr8Wr6bZBCITk7jKb1hIIx0cqCEm9k+OSETNV7afrljx9CHIDlBDdOx18GRf2SNxx
         uFJvL+4n6hT6ktayyGGdvYleeZU78Kb0aL0YlodwQSnv33L1qx7D2jC/BvJpQDk63hFX
         51ykPSIhoVcF0F5x1J79N+SsfhKjcMxwiQ/4RS8HjN/yi94IcDY9g/wDcVdn8l0iF4Nz
         gEVUT176CAxrPSDR7gA53kbAZxWMrowoNxReq71eu315UbxSPwR2Xerb3hRlFz9CB8k5
         s73A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3mJ//dF2UdH+rMidooXAGoMJs/gWdqGSD9KZJf42iTw=;
        b=e71a/CGcfP5aLi3UQwF9QQqV8afuKKBBz83P+cYY180272cZz3evPivIlBjAjZhpm0
         awLsdLugkQX+hLExZPVwf3BNFuKbFR4BKRo9DHneqGBJBUZ1AUL+DQD5okSR3izH5Eeo
         kKSDaYVRwhQTGMqm5Z2FVJe2OWjpg+ekQAadpkxwxi7Wc+5j+PEWONYst8Mu/8cd7Elb
         6XVYO96x9uRjePqynzwUus738itmf1kDig5lQU6DXbOqvwPN7QrxW43lWVgEF3cmR6tO
         Xz8RYqGVMWV5uwGL16+WDu3h0JBVGw0isH5ZGqLlMA/T3eL/oEjeeMsv3JnlaczkV0f9
         5hdw==
X-Gm-Message-State: AOAM530v9m3ZQKIemLVcfW68C0hW0fzcTf24Dc5a+uMNEoiLSQiflSqm
        xVGdcjiGEmYMgHNqV0DAWcU=
X-Google-Smtp-Source: ABdhPJy6IBNuTNcV1yL+0S/fz5uBmP+u7Vze7qmbvouZ/MIxJi2Vltxe+zo6hKV1mg5Vp2jRQQn44w==
X-Received: by 2002:a63:4521:: with SMTP id s33mr29729095pga.388.1593978689678;
        Sun, 05 Jul 2020 12:51:29 -0700 (PDT)
Received: from anarsoul-thinkpad.lan (216-71-213-236.dyn.novuscom.net. [216.71.213.236])
        by smtp.gmail.com with ESMTPSA id g9sm16072879pfm.151.2020.07.05.12.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 12:51:28 -0700 (PDT)
From:   Vasily Khoruzhick <anarsoul@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Ondrej Jirman <megous@megous.com>
Cc:     Vasily Khoruzhick <anarsoul@gmail.com>
Subject: [PATCH 0/3] arm64: allwinner: a64: add bluetooth support for Pinebook
Date:   Sun,  5 Jul 2020 12:51:07 -0700
Message-Id: <20200705195110.405139-1-anarsoul@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pinebook uses RTL8723CS for WiFi and bluetooth. Unfortunately RTL8723CS
has broken BT-4.1 support, so it requires a quirk.

Add a quirk, wire up 8723CS support in btrtl and enable bluetooth
in Pinebook dts.

Vasily Khoruzhick (3):
  Bluetooth: Add new quirk for broken local ext features max_page
  Bluetooth: btrtl: add support for the RTL8723CS
  arm64: allwinner: a64: enable Bluetooth On Pinebook

 .../dts/allwinner/sun50i-a64-pinebook.dts     |  12 ++
 drivers/bluetooth/btrtl.c                     | 128 +++++++++++++++++-
 drivers/bluetooth/btrtl.h                     |  12 ++
 drivers/bluetooth/hci_h5.c                    |   6 +
 include/net/bluetooth/hci.h                   |   7 +
 net/bluetooth/hci_event.c                     |   4 +-
 6 files changed, 165 insertions(+), 4 deletions(-)

-- 
2.27.0

