Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3305631441
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfEaRzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:55:20 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39708 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbfEaRzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 13:55:20 -0400
Received: by mail-wr1-f66.google.com with SMTP id x4so7078802wrt.6
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 10:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0GS4LMwezPgy2DzGEuqFbf0lz+SXLOMwav/zMSAZjO8=;
        b=KxflmlXHmw+OfSWgzqmur0MPYPFibsVAqfdqW4IxsTGcHhGUexnrnxY81dnsCxGwYU
         P8pRGunPWs5kRJhLqTxAqyEBVZjDmDsPbduHQLu/gaGQQpS0gppAuDzmhlkQ5Ci9xKMM
         m22ljGTllRd4YZQZ4u/uaLlDgjqgwDAzX6eXd3zR4rnrwoJ5Tqc5CbYyglrIErOZDKm8
         1j7rRlOY5T2mWjQ0WE3rzw+A8p14Jyi+otnsENRw4RRqA8VU7roZb7gQE+Jo5RY17xKE
         7WZdsLJEN8KmaYq9YqzCPCORXAyIjFNS815bWJBgTN13tW1Rsu1Hji7ZRd875dkjvRjf
         Nc1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0GS4LMwezPgy2DzGEuqFbf0lz+SXLOMwav/zMSAZjO8=;
        b=uTBkfUq1ibMAfV1eCDnA63GIDHG+SBviPvwEhvPdSc4Yj+PBYpe4puwmyt0/MdREUx
         VhLv5pZ6d30zvlQIugFYY0gNWEesEnMUEW6kljYO76ldL6R7iVYmJGKipi5GuSX6GUum
         uix22ommDi9vtc4/03FlaDjH0AiBN01ioCsUvuMYak1WftjlPuEl+ua4Wq7U+CUGYMxQ
         wahdhE5u00Bd4wM6hrPFz2nHxC5eyDTED8m+1diPNe10wi1GNDWThgwGB9EKCQGJYsMu
         Vgfz5jO9yyV9QMiMPJdumy0sJ9D7lcLjeI9UGoZPS0Hpoe+tvWXK/jvG9v02Vwb28PY7
         XH+w==
X-Gm-Message-State: APjAAAVQxgLpvv9/qg14PbOa0/cS73CVVzDgdIl7Lwp2XL9PWqkSQodr
        q06C4pkTTo7760O0O4D1hmiTmT18
X-Google-Smtp-Source: APXvYqxTiUyOmYUFJVJKltSQbHAMSRUBA8Z7P0th8CIGLAVt3CCs+dNfl4udFOf4L9QYEk6MV9lDcA==
X-Received: by 2002:adf:dc04:: with SMTP id t4mr7872325wri.126.1559325317897;
        Fri, 31 May 2019 10:55:17 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:2026:7a0b:4d8d:d1ce? (p200300EA8BF3BD0020267A0B4D8DD1CE.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:2026:7a0b:4d8d:d1ce])
        by smtp.googlemail.com with ESMTPSA id n1sm5202263wrx.39.2019.05.31.10.55.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 10:55:17 -0700 (PDT)
Subject: [PATCH net-next 2/3] r8169: remove struct jumbo_ops
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1e17bf2f-93a9-03ff-7101-7f680665f4a7@gmail.com>
Message-ID: <23c562d6-4594-02ec-e60e-3f0295929f45@gmail.com>
Date:   Fri, 31 May 2019 19:54:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1e17bf2f-93a9-03ff-7101-7f680665f4a7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The jumbo_ops are used in just one place, so we can simplify the code
and avoid the penalty of indirect calls in times of retpoline.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 96 +++++++++++-----------------
 1 file changed, 36 insertions(+), 60 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 3472eef75..fc58f89be 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -655,11 +655,6 @@ struct rtl8169_private {
 	const struct rtl_coalesce_info *coalesce_info;
 	struct clk *clk;
 
-	struct jumbo_ops {
-		void (*enable)(struct rtl8169_private *);
-		void (*disable)(struct rtl8169_private *);
-	} jumbo_ops;
-
 	void (*hw_start)(struct rtl8169_private *tp);
 	bool (*tso_csum)(struct rtl8169_private *, struct sk_buff *, u32 *);
 
@@ -4196,24 +4191,6 @@ static void rtl8169_init_ring_indexes(struct rtl8169_private *tp)
 	tp->dirty_tx = tp->cur_tx = tp->cur_rx = 0;
 }
 
-static void rtl_hw_jumbo_enable(struct rtl8169_private *tp)
-{
-	if (tp->jumbo_ops.enable) {
-		rtl_unlock_config_regs(tp);
-		tp->jumbo_ops.enable(tp);
-		rtl_lock_config_regs(tp);
-	}
-}
-
-static void rtl_hw_jumbo_disable(struct rtl8169_private *tp)
-{
-	if (tp->jumbo_ops.disable) {
-		rtl_unlock_config_regs(tp);
-		tp->jumbo_ops.disable(tp);
-		rtl_lock_config_regs(tp);
-	}
-}
-
 static void r8168c_hw_jumbo_enable(struct rtl8169_private *tp)
 {
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) | Jumbo_En0);
@@ -4280,55 +4257,56 @@ static void r8168b_1_hw_jumbo_disable(struct rtl8169_private *tp)
 	RTL_W8(tp, Config4, RTL_R8(tp, Config4) & ~(1 << 0));
 }
 
-static void rtl_init_jumbo_ops(struct rtl8169_private *tp)
+static void rtl_hw_jumbo_enable(struct rtl8169_private *tp)
 {
-	struct jumbo_ops *ops = &tp->jumbo_ops;
-
+	rtl_unlock_config_regs(tp);
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_11:
-		ops->disable	= r8168b_0_hw_jumbo_disable;
-		ops->enable	= r8168b_0_hw_jumbo_enable;
+		r8168b_0_hw_jumbo_enable(tp);
 		break;
 	case RTL_GIGA_MAC_VER_12:
 	case RTL_GIGA_MAC_VER_17:
-		ops->disable	= r8168b_1_hw_jumbo_disable;
-		ops->enable	= r8168b_1_hw_jumbo_enable;
+		r8168b_1_hw_jumbo_enable(tp);
 		break;
-	case RTL_GIGA_MAC_VER_18: /* Wild guess. Needs info from Realtek. */
-	case RTL_GIGA_MAC_VER_19:
-	case RTL_GIGA_MAC_VER_20:
-	case RTL_GIGA_MAC_VER_21: /* Wild guess. Needs info from Realtek. */
-	case RTL_GIGA_MAC_VER_22:
-	case RTL_GIGA_MAC_VER_23:
-	case RTL_GIGA_MAC_VER_24:
-	case RTL_GIGA_MAC_VER_25:
-	case RTL_GIGA_MAC_VER_26:
-		ops->disable	= r8168c_hw_jumbo_disable;
-		ops->enable	= r8168c_hw_jumbo_enable;
+	case RTL_GIGA_MAC_VER_18 ... RTL_GIGA_MAC_VER_26:
+		r8168c_hw_jumbo_enable(tp);
 		break;
-	case RTL_GIGA_MAC_VER_27:
-	case RTL_GIGA_MAC_VER_28:
-		ops->disable	= r8168dp_hw_jumbo_disable;
-		ops->enable	= r8168dp_hw_jumbo_enable;
+	case RTL_GIGA_MAC_VER_27 ... RTL_GIGA_MAC_VER_28:
+		r8168dp_hw_jumbo_enable(tp);
 		break;
-	case RTL_GIGA_MAC_VER_31: /* Wild guess. Needs info from Realtek. */
-	case RTL_GIGA_MAC_VER_32:
-	case RTL_GIGA_MAC_VER_33:
-	case RTL_GIGA_MAC_VER_34:
-		ops->disable	= r8168e_hw_jumbo_disable;
-		ops->enable	= r8168e_hw_jumbo_enable;
+	case RTL_GIGA_MAC_VER_31 ... RTL_GIGA_MAC_VER_34:
+		r8168e_hw_jumbo_enable(tp);
+		break;
+	default:
 		break;
+	}
+	rtl_lock_config_regs(tp);
+}
 
-	/*
-	 * No action needed for jumbo frames with 8169.
-	 * No jumbo for 810x at all.
-	 */
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_51:
+static void rtl_hw_jumbo_disable(struct rtl8169_private *tp)
+{
+	rtl_unlock_config_regs(tp);
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_11:
+		r8168b_0_hw_jumbo_disable(tp);
+		break;
+	case RTL_GIGA_MAC_VER_12:
+	case RTL_GIGA_MAC_VER_17:
+		r8168b_1_hw_jumbo_disable(tp);
+		break;
+	case RTL_GIGA_MAC_VER_18 ... RTL_GIGA_MAC_VER_26:
+		r8168c_hw_jumbo_disable(tp);
+		break;
+	case RTL_GIGA_MAC_VER_27 ... RTL_GIGA_MAC_VER_28:
+		r8168dp_hw_jumbo_disable(tp);
+		break;
+	case RTL_GIGA_MAC_VER_31 ... RTL_GIGA_MAC_VER_34:
+		r8168e_hw_jumbo_disable(tp);
+		break;
 	default:
-		ops->disable	= NULL;
-		ops->enable	= NULL;
 		break;
 	}
+	rtl_lock_config_regs(tp);
 }
 
 DECLARE_RTL_COND(rtl_chipcmd_cond)
@@ -7130,8 +7108,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_master(pdev);
 
-	rtl_init_jumbo_ops(tp);
-
 	chipset = tp->mac_version;
 
 	rc = rtl_alloc_irq(tp);
-- 
2.21.0


