Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 660F719542A
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 10:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgC0JhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 05:37:23 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:55403 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727185AbgC0JhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 05:37:23 -0400
Received: by mail-wm1-f51.google.com with SMTP id z5so10689376wml.5
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 02:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=hlrOdL1KnO3xQYV3oaqWV4hvkH1Bg456h/MxyKV3WFw=;
        b=AXAQWqDQYNqaDWIB7CeKYUxw7hETFRXiqsTm5GB6QuYNBPcelQSsGJHp5Mo0Yzih1c
         lrlAc3KiLzp3YkpOC6c3Mz/9hoEhRlL5pdmKXHqAwue6fV/58S6mEPvZud5Hpbj+OVrL
         PXAq1h2zG9WxnOaZBbuLpJxycu836WvG3jPT0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hlrOdL1KnO3xQYV3oaqWV4hvkH1Bg456h/MxyKV3WFw=;
        b=HX7qePqEqXOijunhHPkHxHyHbegSdwwCp7CfGObWuJa/uCrhRrg274PYo4dyc85+H8
         uVKUD6TrwDKnjWFa+K7QoTsA+DzPZkLiSAJDKuyum2UuvkASJ6mOSt6t5rOvlGzK9dvK
         4HkfH1DAQ/v90EiAwDcGZdu9LCNY9gGHGruZvf/OIEdiU1wkPaGJas6LQ/xnaoU7AKT5
         XU43agKu5WZN6mijF3X6nXvNknahjEw0VJVBaAIBZR3zaTBBRziTbr90O/BtmGSC9gVa
         27LuJaBP52AULaRb6TNZ2GB2O5WcrUFfPjt3I+UbphfE3dyuT3WXyuCkAk+sEbiMDdFc
         K5Ww==
X-Gm-Message-State: ANhLgQ1ROR7UD54CyXb+k1YgWUO4o9PLqw2oZSxL2xPkWIIDONx5wPdt
        KapLt5W3Mqa2ovdezib42dCvDQ==
X-Google-Smtp-Source: ADFU+vv4F5R+JWGZ1eIAV+JFzPo2e5u1Lqpct/x33oPVKbpnLmrECscGOG3PCYUbJ81mLewUU0adqQ==
X-Received: by 2002:a1c:4684:: with SMTP id t126mr4328407wma.128.1585301841143;
        Fri, 27 Mar 2020 02:37:21 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b82sm7246600wmb.46.2020.03.27.02.37.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Mar 2020 02:37:20 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     linux-pci@vger.kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH v4 net-next 3/6] PCI: Add new PCI_VPD_RO_KEYWORD_SERIALNO macro
Date:   Fri, 27 Mar 2020 15:05:32 +0530
Message-Id: <1585301732-26004-1-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new macro for serial number keyword.

Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 include/linux/pci.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index fc54b89..a048fba 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2184,6 +2184,7 @@ bool pci_acs_path_enabled(struct pci_dev *start,
 #define PCI_VPD_INFO_FLD_HDR_SIZE	3
 
 #define PCI_VPD_RO_KEYWORD_PARTNO	"PN"
+#define PCI_VPD_RO_KEYWORD_SERIALNO	"SN"
 #define PCI_VPD_RO_KEYWORD_MFR_ID	"MN"
 #define PCI_VPD_RO_KEYWORD_VENDOR0	"V0"
 #define PCI_VPD_RO_KEYWORD_CHKSUM	"RV"
-- 
1.8.3.1

