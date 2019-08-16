Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 146288F817
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 02:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfHPApU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 20:45:20 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37623 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbfHPApP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 20:45:15 -0400
Received: by mail-wr1-f67.google.com with SMTP id z11so3803426wrt.4;
        Thu, 15 Aug 2019 17:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gA4EghheVlwLTCkXpIEYPy5tZr9mfwdcWn3E8suJuks=;
        b=JRz75JIJcjxCunTKyo2AFnHHYecc7R7edPD69KNAXKcY91FtFa0xSyXaLZ89fmnnfG
         hSLkWSWfqCBmCGeVhzBWlfbpAuDTOWR0HFTg2+VdUq/YBoI4wt5KLPt7mLp88msnM37J
         iHxKkcZfNl27a+xAJd1Xs48TqGv8/rrfLM9PcWWalTiFx1y6uS0Bm12/dXfk/jyvz3PU
         garlnuphL5+EdQbOnzfr361ha35cTwQWi90kXTZLgB4rBGVLpdD1akcLDNgBMS4GXzth
         r5S05x3N0T9K5rLf+1Q/6dRtdQkZ07NUROhZIsLgNUI29fe/0ypax7ByR8MpMHSF5fvx
         /edQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gA4EghheVlwLTCkXpIEYPy5tZr9mfwdcWn3E8suJuks=;
        b=AohsMBTUBy6Ff4BuGZsVqZaKY2yl/45Nhn/3I6JqPzYnGdkmn/W42W0hbfuHZWvJjP
         7rkCGf+qHWsCJN0bxLi5CJ1tCEAfL9cXIQuj/gcC96YY7yFd8Id3XYoVUFAP1luLxAkT
         MbCNdk/Phar3hrcquYABcmrsFIbkXedrZ0dCo2roxLTsPIO9qO7H4e9kNRB//oHaNhGL
         I/4brt83vbClwuleRQ+sE3sR50ITBWC4kI6ZOxPrBYvtUyG/YJcLm+upH6Ze0jC4rIVC
         DxhpKR/167ZZ3lxi44pkDUWC514uO3o1xeKF1xM0acFwutklltc/15TlBlZlyLPr1Z7j
         7F5Q==
X-Gm-Message-State: APjAAAV00Miaw4JgUYPal8oEZ38DbqqXuE/LyL/3csKCfOdcCfCEsZFg
        XhBUx/d21nzXCzX8Df9BcJW/mBgCmj8=
X-Google-Smtp-Source: APXvYqwF7U4q4GgDkG8suyoncsL5tJr3g2YiTFunwyeVgsgnYGWenc8ELvE/9f/VTa0O5KYTfsa4hw==
X-Received: by 2002:a5d:6ad0:: with SMTP id u16mr7872106wrw.84.1565916313393;
        Thu, 15 Aug 2019 17:45:13 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id k124sm6451204wmk.47.2019.08.15.17.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 17:45:13 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        broonie@kernel.org
Cc:     linux-spi@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH net-next 11/11] ARM: dts: ls1021a-tsn: Reduce the SJA1105 SPI frequency for debug
Date:   Fri, 16 Aug 2019 03:44:49 +0300
Message-Id: <20190816004449.10100-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190816004449.10100-1-olteanv@gmail.com>
References: <20190816004449.10100-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have a logic analyzer that cannot sample signals at a higher frequency
than this, and it's nice to actually see the captured data and not just
an amorphous mess.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 arch/arm/boot/dts/ls1021a-tsn.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ls1021a-tsn.dts b/arch/arm/boot/dts/ls1021a-tsn.dts
index 3b35e6b5977f..8fdf4c3b24c7 100644
--- a/arch/arm/boot/dts/ls1021a-tsn.dts
+++ b/arch/arm/boot/dts/ls1021a-tsn.dts
@@ -55,7 +55,7 @@
 		#size-cells = <0>;
 		compatible = "nxp,sja1105t";
 		/* 12 MHz */
-		spi-max-frequency = <12000000>;
+		spi-max-frequency = <6000000>;
 		/* Sample data on trailing clock edge */
 		spi-cpha;
 		/* SPI controller settings for SJA1105 timing requirements */
-- 
2.17.1

