Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30491B13FD
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgDTSHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgDTSH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 14:07:29 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DBBC061A0C;
        Mon, 20 Apr 2020 11:07:29 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id np9so202596pjb.4;
        Mon, 20 Apr 2020 11:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SN+5NQh5GO88eOTvwunTZ0nqR3Nb9UtRYbfk0MSr7bY=;
        b=Qx09VHFf98yTcYTnvwSEuiXgDBGzA2cEh9hU+9fXyRF1r89n7O02AEfWo5K9PIvT97
         ipXJkS8m8TogUQn4xmopNWZ3kuVEe5N6YObvYzyF8SM715dpnFc/5i2WuGB+baGzeek8
         YlGaq7Ue7v399Sg+sF9eQGfdn7ROXy8EfBugSnZfoTL67KORaSMipCbw7zwh4GX8FIfC
         wHirEn7BdWoBJzL4GIQ5xCfAM0J9mvd1PLzr9+cdVgY5UcDhQG2TQnKLINk13Pcm6CRe
         XOL4fWem4bD7yVEAe3AJu8KdDaYvJ5GAJMPDMP7uPsxOzeortooI+FTxDVL1Ri5tni+J
         L7hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SN+5NQh5GO88eOTvwunTZ0nqR3Nb9UtRYbfk0MSr7bY=;
        b=NVXwL89j8es/OEmkH1PFPE4gKsfnjclLnAv6L0vluG8CeRZEvPm+iZvfb090LK4WkX
         1QMt1HB/PHzBqZoeqUoVeidBIAqhjwxb7/dyusuvLS0c/0PhI+TludT1OXYmhhVwu40I
         1Kmtv+2osupc1B1+G+kWT06wCcHDUclCnd/l3X82GHLYmyKUb0o8uqURTc16mdlrRKse
         hndSwOSWxY+IT2Ww7KL1DeW2+q8iy978MWD2e0G9URwINZ5Al8rJTg+TjyaV+zWmLmcW
         ot+JRu1VeYbxsR2v8hQ8cKYaJ32voa2KokCn9zycl8b+K4xDLmdYExs0jibeWspygpH3
         Xbgg==
X-Gm-Message-State: AGi0PubYlFvTxKMsMRkUT78BtGi3nTvo3FmXdmqR1ocDFDYpyKs5amPX
        v2eUsP9KXS7rD8tiMQh0vHGo4z7S
X-Google-Smtp-Source: APiQypKalceZVtLrFMB4bapQ/qPhpIz0IoQfWZ4qPleh/uBeWC28RetThiV9xgvcWA+j1JMS/KyVcA==
X-Received: by 2002:a17:90a:1946:: with SMTP id 6mr789203pjh.42.1587406048026;
        Mon, 20 Apr 2020 11:07:28 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id e7sm131193pfh.161.2020.04.20.11.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 11:07:26 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v3 0/3] dt-bindings: net: mdio.yaml fixes
Date:   Mon, 20 Apr 2020 11:07:20 -0700
Message-Id: <20200420180723.27936-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch series documents some common MDIO devices properties such as
resets (and delays) and broken-turn-around. The second patch also
rephrases some descriptions to be more general towards MDIO devices and
not specific towards Ethernet PHYs.

Changes in v3:

- corrected wording of 'broken-turn-around' in ethernet-phy.yaml and
  mdio.yaml, add Andrew's R-b tag to patch #3

Florian Fainelli (3):
  dt-bindings: net: Correct description of 'broken-turn-around'
  dt-bindings: net: mdio: Document common properties
  dt-bindings: net: mdio: Make descriptions more general

 .../devicetree/bindings/net/ethernet-phy.yaml |  3 +-
 .../devicetree/bindings/net/mdio.yaml         | 38 ++++++++++++++++---
 2 files changed, 35 insertions(+), 6 deletions(-)

-- 
2.19.1

