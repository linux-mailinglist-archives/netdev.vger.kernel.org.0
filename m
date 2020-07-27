Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C2622E869
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgG0JG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:06:27 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53760 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727869AbgG0JGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 05:06:21 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595840780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CFXeNC91SxBOO4xdiyX5qzGycn8QKF10EOPz9JU+8V0=;
        b=HUQWJkhfPA52c1XvXaQAisLVxJfVoEtq2l8HiwIn6DVwFyFGxBBq8F/nipcjuVdU4Zfncv
        QllZIWfZ1u6n/PAVv33wbmD9hFmIUghYx/bfT8SoxiQAF/Y13Fx36ln1uboSCCS+pan/DH
        EibuPSoczscE+pY8LBfFyBKG+cYD1a31mkA3yAItEhUiHSIaNMzeyMBVmRf4gQDRyJuY/u
        qixyi5p9vJ/6G6uiF+Zmm5lbhj7pWXuEGRXjjTm7Uc/nXxrIcFVxsctX72v434QMyVG6zt
        zptBNSAMiLWuUoejwcLhQd8DMEbAwpn6wLxGkIl+02ZLy3bnq8B8ATiZbqSJiA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595840780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CFXeNC91SxBOO4xdiyX5qzGycn8QKF10EOPz9JU+8V0=;
        b=cpgQc8pB04qNjeYqAdEZC6K+pZE3Lt21cxkVBLTCyEC+peweKPkeMO0HzygCzl5exUkA+J
        Ts77EGQ1zqmx7cBQ==
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
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v2 9/9] ptp: Remove unused macro
Date:   Mon, 27 Jul 2020 11:06:01 +0200
Message-Id: <20200727090601.6500-10-kurt@linutronix.de>
In-Reply-To: <20200727090601.6500-1-kurt@linutronix.de>
References: <20200727090601.6500-1-kurt@linutronix.de>
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
index e13f9c6150ad..d75ae03cd601 100644
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

