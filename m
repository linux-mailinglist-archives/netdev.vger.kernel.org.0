Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06D9D1323D3
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 11:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgAGKjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 05:39:09 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:33964 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727869AbgAGKjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 05:39:08 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B40B540652;
        Tue,  7 Jan 2020 10:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578393548; bh=ftXfj3ol8b6sAtBoTU6/JkgMmMwOsKghd5YpNfzIzLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Pzmvwxh3z1B3uDvcaK+UqZFnGl21kLzs26WMg0vpzyv1QpHigUd5e0HdWVJa2HbQ4
         zNbL9/SO/m5FlGJOJiH7tnQy7xbJGFAqUwjqG6OLt7nDpO4jvMA6zUyc9GVWIZxhb5
         gYbKoFxinqlquP1eCXg9VaIMSNOLNbxUyyDlbJw82MPO2JRE9qm43ZDbX5RVOXPxzb
         USRxc3gyY/QCzC+cCRIN65lxX2FiD5idxApBb/zexC18vOnH1ktvu4mgOMFR8AWfOp
         99uBKnAvmJMLFVodYqnJKaRswNzefD6dj1I0veg1c3v18x0+MIlxHBbn6ensbw4Zjr
         Yh9dCXctXjd9w==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 6FE50A006A;
        Tue,  7 Jan 2020 10:39:06 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-doc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/3] Documentation: networking: Add stmmac to device drivers list
Date:   Tue,  7 Jan 2020 11:37:20 +0100
Message-Id: <eb6c0af8f45a54ca2db1396801b44587fcf1fd32.1578392890.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1578392890.git.Jose.Abreu@synopsys.com>
References: <cover.1578392890.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1578392890.git.Jose.Abreu@synopsys.com>
References: <cover.1578392890.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the stmmac RST file to the index.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/networking/device_drivers/index.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index c1f7f75e5fd9..4bc6ff29976a 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -25,6 +25,7 @@ Contents:
    mellanox/mlx5
    netronome/nfp
    pensando/ionic
+   stmicro/stmmac
 
 .. only::  subproject and html
 
-- 
2.7.4

