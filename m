Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7B9AEB51
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 15:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732035AbfIJNTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 09:19:20 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37948 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731895AbfIJNTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 09:19:16 -0400
Received: by mail-io1-f68.google.com with SMTP id k5so12093591iol.5;
        Tue, 10 Sep 2019 06:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=849o91yGt5jrZZIi8LC13Ut3Cl2Y81Etzv/w6RPtCGk=;
        b=ImGQIRy5R3E58ARwHYy3bxOVecENV/vSe4RImjtdCR0ryWMfS6ZzsmkETb5QTxV0Kc
         kpD6QMj2HVdzmGVBiZcDXRcIQc/c7y9OjB9EBR3hKaCLq2uayXXiR+zqDYvdt63Eyn1j
         2ODvnm152zwm9ieGJClpPGqc19id6xQcmpiIGMlpxB72GnILVmq19PsrSzH0W+hQ4BNG
         b3EtpVc5r2uLCqEgYgLzT1v8BHpAovLRAxSpMlpzzry6Gt9Lxup8j2c7uLc/Wx9D8/Ok
         DHkfJnI9DYUW4E39JS7yKzQxuONrRBB4s9wL+5fhpgjz4DgUhhTAn6QQxRAy5azMEQgh
         qzhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=849o91yGt5jrZZIi8LC13Ut3Cl2Y81Etzv/w6RPtCGk=;
        b=WgoUkOoDoVzJSgXGKlckuJhmzm1MzMvpEPexRvZcymZZydx5qcmApWe6+AyILFtXZV
         DFClAIZvFMSJOO2y57KHBqEhHVYNuLE0Anir+4TVIrSVg/oerBb6IgvnUBGrkOsHMZ1h
         pEz2x1VgqyD1TtI8OKv6TDHqifATfDoC3CqgfC79qLodJdv2tvafYhKGk8F1VP8BrZBw
         laH0MxpHdDIN4XGZXDmVjjsQmySeTPAkY7/Ta3fGaGQFBDzA0ZFfn6pVLNXE3M+4YPWT
         RisnKjCAIyw9QZt0aK+EehYzaWFLOZH9jsBQ2H8Onmq9hN81RtBZS/cDFcwYEP5ewdjL
         g55Q==
X-Gm-Message-State: APjAAAXF96ypo+3MZHLEy88MNhgiRi/ELiXpyvf3qbSkpZdNOo5JjrE5
        hF3hPGrSSTaN89G2OG0vmYjL8FUO4w==
X-Google-Smtp-Source: APXvYqxbeW4rhJKhkXroWYNTN5OxXBvOBf4ysg2Oh8hocFuWn+MqfXtn5mARzADizM/0QyFrtu7GLQ==
X-Received: by 2002:a6b:ec18:: with SMTP id c24mr34124578ioh.72.1568121555004;
        Tue, 10 Sep 2019 06:19:15 -0700 (PDT)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id f7sm13642740ioc.31.2019.09.10.06.19.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 06:19:14 -0700 (PDT)
From:   George McCollister <george.mccollister@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marek Vasut <marex@denx.de>, linux-kernel@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v2 3/3] net: dsa: microchip: remove NET_DSA_TAG_KSZ_COMMON
Date:   Tue, 10 Sep 2019 08:18:36 -0500
Message-Id: <20190910131836.114058-4-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190910131836.114058-1-george.mccollister@gmail.com>
References: <20190910131836.114058-1-george.mccollister@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the superfluous NET_DSA_TAG_KSZ_COMMON and just use the existing
NET_DSA_TAG_KSZ. Update the description to mention the three switch
families it supports. No functional change.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
Reviewed-by: Marek Vasut <marex@denx.de>
---

Changes since v1:
	- Added Reviewed-by.

 net/dsa/Kconfig  | 9 ++-------
 net/dsa/Makefile | 2 +-
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 2f69d4b53d46..29e2bd5cc5af 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -73,16 +73,11 @@ config NET_DSA_TAG_MTK
 	  Say Y or M if you want to enable support for tagging frames for
 	  Mediatek switches.
 
-config NET_DSA_TAG_KSZ_COMMON
-	tristate
-	default n
-
 config NET_DSA_TAG_KSZ
-	tristate "Tag driver for Microchip 9893 family of switches"
-	select NET_DSA_TAG_KSZ_COMMON
+	tristate "Tag driver for Microchip 8795/9477/9893 families of switches"
 	help
 	  Say Y if you want to enable support for tagging frames for the
-	  Microchip 9893 family of switches.
+	  Microchip 8795/9477/9893 families of switches.
 
 config NET_DSA_TAG_QCA
 	tristate "Tag driver for Qualcomm Atheros QCA8K switches"
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index c342f54715ba..2c6d286f0511 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_NET_DSA_TAG_BRCM_COMMON) += tag_brcm.o
 obj-$(CONFIG_NET_DSA_TAG_DSA) += tag_dsa.o
 obj-$(CONFIG_NET_DSA_TAG_EDSA) += tag_edsa.o
 obj-$(CONFIG_NET_DSA_TAG_GSWIP) += tag_gswip.o
-obj-$(CONFIG_NET_DSA_TAG_KSZ_COMMON) += tag_ksz.o
+obj-$(CONFIG_NET_DSA_TAG_KSZ) += tag_ksz.o
 obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
 obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o
 obj-$(CONFIG_NET_DSA_TAG_QCA) += tag_qca.o
-- 
2.11.0

