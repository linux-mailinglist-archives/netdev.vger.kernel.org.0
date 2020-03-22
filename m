Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDB2618E916
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 14:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgCVNOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 09:14:31 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55518 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgCVNOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 09:14:30 -0400
Received: by mail-wm1-f67.google.com with SMTP id 6so11344488wmi.5
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 06:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=2V6cJg7sOI5qLxW5ZQj/fKXV1KpvZyi/4cN/6ZnE+aY=;
        b=r8kacqAsApxOtpG+QeDrgF+tyQHcHDKuCcuNsHZRGyflUI3D/phowK8XSwrPR/Vn9y
         6n1XzpeGSrZg0he2k2+0iObNXxWjt7ZkDeviMRQ3mpWS9FT49uklweMBlOXEQZBM4Abw
         ZxQuJOK85hK8PXZWA5ddWPEu0yKMgVV9JgKPO7D6EFLXspfTKszm7CGajlkVWrPqVXNV
         4EfjJ6/vr7ZHr8mW8EoQv4J1eThASzBTvnV5yqg5142C1d6brSrWhyyGLFmivT9Oc6ZJ
         2L/8JzkavB01FMEueB883av2gIK28V20j2EiXHA/VLIIDTSEwnPf9PjzikuNxUkPjqUG
         SKdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=2V6cJg7sOI5qLxW5ZQj/fKXV1KpvZyi/4cN/6ZnE+aY=;
        b=mjJDuOcjGxf2C9ZX5+NthXMcE56XqlrGA3isvop2LqxbJPt5aZZHQZWoW0BzcXOkmo
         kMaKrmqwhmbHGXOUdGsLipW94FH+6GNuAje1VH9hvxS3xacvSjjm6TUsIpI63RYla/ny
         10HAR27bfReWNNNJaYxBCZWtjYWWDFtwvjtRvt6aMkmsEEVg33PsSW5PQuVdZdDgurb9
         yRl356LM33H4TSCS1DmU4jHZR4/fKYBbgxzPrcP3pEWO4i7N7BjiMhjW2YI/Q05zcud/
         cm9aem9FvXxGkasGscN6wB4LQKHeOYMnxCHYTZx3E5XLlLeqT4urb2WNZEWfTEmlmudB
         fM4g==
X-Gm-Message-State: ANhLgQ0iQbwZXKqc02QufKG2rL0Too7aI7xdOWB3a9wOmwOFCNXpUA+f
        MsAn0Hb6g1tAbW6+bwsHV0ugV7Ss
X-Google-Smtp-Source: ADFU+vt4p0LI1XEaKhwjAPZA2tipMa0i6Ei12m4jfT1PlYq2p9AiuTFsD4nvfH41ueNTr5Ap6FiDIg==
X-Received: by 2002:a1c:9a82:: with SMTP id c124mr19709600wme.22.1584882866753;
        Sun, 22 Mar 2020 06:14:26 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:1055:511c:c4fb:f7af? (p200300EA8F2960001055511CC4FBF7AF.dip0.t-ipconnect.de. [2003:ea:8f29:6000:1055:511c:c4fb:f7af])
        by smtp.googlemail.com with ESMTPSA id d124sm13220433wmd.37.2020.03.22.06.14.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 06:14:26 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] ethtool: remove XCVR_DUMMY entries
Message-ID: <44908ff8-22dd-254e-16f8-f45f64e8e98e@gmail.com>
Date:   Sun, 22 Mar 2020 14:14:20 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The transceiver dummy entries are not used any longer, so remove them.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/uapi/linux/ethtool.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index d586ee5e1..77721ea36 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1673,9 +1673,6 @@ static inline int ethtool_validate_duplex(__u8 duplex)
 /* Which transceiver to use. */
 #define XCVR_INTERNAL		0x00 /* PHY and MAC are in the same package */
 #define XCVR_EXTERNAL		0x01 /* PHY and MAC are in different packages */
-#define XCVR_DUMMY1		0x02
-#define XCVR_DUMMY2		0x03
-#define XCVR_DUMMY3		0x04
 
 /* Enable or disable autonegotiation. */
 #define AUTONEG_DISABLE		0x00
-- 
2.25.2

