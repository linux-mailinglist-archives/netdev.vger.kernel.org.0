Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802D7232CC7
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 10:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbgG3IBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 04:01:01 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48736 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728898AbgG3IBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 04:01:00 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1596096058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fxs0RuNV0kU+KFLUSNh5ecANfQU4v98Fy8pcIy8R6to=;
        b=eZb3eT6EakJ+vrErm0piNPuBtusSbsHF5ktAu6oNG4+Fdst8N/syyxCH3uG6GR3t9tvHOh
        XGivdsQFczY5Fck6ICWoZlJs5m98hEhyKRM5jvLIfNjb9ZZ+Yl02ZfYkmHAC98QKXLcc/q
        mqCo1HwVDULRDEDzZF6yW6ZBchOyfTsm9TACoXnb2WHv059JP629t6a32z0efT6wUtbrlb
        5jEpQwjIdg404C76skroLDc8WArOjzg1QPkQBiE/YWAUuw9aME7/+4AkNV3QRUKGQxy0SW
        HKRVhlZm4pDASRBW4ZxPbSXb46QRHKpuXiO1KOWIwXOhm2ytv1HrIwKdsq97CA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1596096058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fxs0RuNV0kU+KFLUSNh5ecANfQU4v98Fy8pcIy8R6to=;
        b=MmfXvXEd9iEpNWs2tTEh/kllddgBDMo8OVYe1fD6WV1vp53QV4b3fFaCYik45fIG9qdqsi
        WlIm66VdP++u+aCw==
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Petr Machata <petrm@mellanox.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v3 9/9] ptp: Remove unused macro
Date:   Thu, 30 Jul 2020 10:00:48 +0200
Message-Id: <20200730080048.32553-10-kurt@linutronix.de>
In-Reply-To: <20200730080048.32553-1-kurt@linutronix.de>
References: <20200730080048.32553-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The offset for the control field is not needed anymore. Remove it.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 include/linux/ptp_classify.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
index f4dd42fddc0c..88408fbb0ab6 100644
--- a/include/linux/ptp_classify.h
+++ b/include/linux/ptp_classify.h
@@ -36,7 +36,6 @@
 
 #define OFF_PTP_SOURCE_UUID	22 /* PTPv1 only */
 #define OFF_PTP_SEQUENCE_ID	30
-#define OFF_PTP_CONTROL		32 /* PTPv1 only */
 
 /* Below defines should actually be removed at some point in time. */
 #define IP6_HLEN	40
-- 
2.20.1

