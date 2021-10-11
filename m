Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85BE4284AA
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 03:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbhJKBc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 21:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233376AbhJKBct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 21:32:49 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B170BC061766;
        Sun, 10 Oct 2021 18:30:47 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id y12so48120631eda.4;
        Sun, 10 Oct 2021 18:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4esTCtJZXuuOiwPupffGXoBpgDSTRt7QTWWMeZINX1g=;
        b=mGqEiPy/DAWwuaTiasu45GWV0+EBFMP5dXpqdtZhMlnshToLiK7ry5Wqx0H6PSi4oi
         Xiubd4FmDWVfOmmWGSaCt304Xm667p3tGuMbwDBO2R7l7wsg1/cRUk4vzpMicwe37Sir
         xmpqKxGkzru731NtwHel71Lbgbl3y7r1UipVAltFMyhQrc0dwVnqAjibPuH6hil+s3k2
         B0L95Dl99OvkL31TtHQfefuaV7mY9nuKZP4nWKYaL7Y4e1wKhomxBQTkoDBgeuwtlivs
         Se7wKtC3lrvaWz83TlGxeX/amQScJ8K7K4bLprbtoKrbYJ9uErK5+WCxYqDxOxobuiaP
         cIjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4esTCtJZXuuOiwPupffGXoBpgDSTRt7QTWWMeZINX1g=;
        b=Nj9ROZ89ZP14YKX5348jqIEYtHLaOHVZQZuBEtua+Zeimi5nI2j8RvW3DG/l7nRpnr
         Dk62KIZyQedFPcze7zsgyhW89V/EnwC+DIw2rUlZ6n//s8HjpCNWRQe2GSLtUzfKkDQQ
         5qGtcS8U5LB4sp3//ozP9p5wS2OzPQpTHg8NY0V1lQ2VHSZ75VqOaqcwkvbXrih70mrx
         wgnYrm982dcYDYi8GVjqzMsCFH2qdi49BBtOvV6rHx+QrQOQ54n8mWnYvulDXLAU5eiH
         uLHMpEHAuT2VrnRrzeLFjjUj42whPx4SXwXynz6s74moQKuoe+X8zThkq4zblYuABYDn
         kALg==
X-Gm-Message-State: AOAM532pJB//aQ10+o8D6RJ55rce+ortosdEMxrvJARUu+1P7BEo9JU6
        Hkhs5nNR+uUe2EoAjRETC7A=
X-Google-Smtp-Source: ABdhPJypNADk5CuDwbySjce/wowEjWl9ld1wfDaju/HaXObLg78eW+tEQLpqqfODlBQHZ1E4hwEoPQ==
X-Received: by 2002:a05:6402:34c1:: with SMTP id w1mr10184239edc.263.1633915846231;
        Sun, 10 Oct 2021 18:30:46 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m15sm21314edd.5.2021.10.10.18.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 18:30:45 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v5 04/14] dt-bindings: net: dsa: qca8k: Document support for CPU port 6
Date:   Mon, 11 Oct 2021 03:30:14 +0200
Message-Id: <20211011013024.569-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211011013024.569-1-ansuelsmth@gmail.com>
References: <20211011013024.569-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch now support CPU port to be set 6 instead of be hardcoded to
0. Document support for it and describe logic selection.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index cc214e655442..aeb206556f54 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -29,7 +29,11 @@ the mdio MASTER is used as communication.
 Don't use mixed external and internal mdio-bus configurations, as this is
 not supported by the hardware.
 
-The CPU port of this switch is always port 0.
+This switch support 2 CPU port. Normally and advised configuration is with
+CPU port set to port 0. It is also possible to set the CPU port to port 6
+if the device requires it. The driver will configure the switch to the defined
+port. With both CPU port declared the first CPU port is selected as primary
+and the secondary CPU ignored.
 
 A CPU port node has the following optional node:
 
-- 
2.32.0

