Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F2A193E8E
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 13:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728221AbgCZME5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 08:04:57 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:44727 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbgCZME5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 08:04:57 -0400
Received: by mail-wr1-f50.google.com with SMTP id m17so7392337wrw.11
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 05:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=hlrOdL1KnO3xQYV3oaqWV4hvkH1Bg456h/MxyKV3WFw=;
        b=Q8ZNzEZVj4ArJZlQsTgtY9lOUnlyrjbwDCPmwhCzy/kdC558hxZTevND6O0OgNGkJS
         OnTFBIt67m9AxzuozNxFFR7z4Jc0ZvygewWGgTZ4jkfSlHybK0BrXtYYFwDhogXZQwZ+
         85bvI73TElLPMHddpnggqt5NFZ3A0hmP1cw2M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hlrOdL1KnO3xQYV3oaqWV4hvkH1Bg456h/MxyKV3WFw=;
        b=s+0uQVLBgYEUQXOl1cA3+PBePqzzwIbsZoTtwgwflQkcidD2q9awMWjh+csZTPgcpP
         YnW44gU2q1E6vTKkt8TBuCmF+RBzfTXB7NiLYrPT5clK6AUYZghY/EJPY9sc7wbk6apm
         IXrnHONz13CTMdHK0QbBuLhWyFMsv/IulTSUjU6cGpiikEfmhW4/WqGARKrZDB1vRxgT
         ySRF1+JdnhvRpD3gNNJmURaKZ1Q/PEUcOFKS0N3liAn8uQNfcqmbRvu5C9+IKeQsKbfD
         8erJ30g3U6FfZBgGRVXFapO2jQ3I1I/IO5tHkVfAH0nx51+l75jtGxg1jFnhF//+wEyc
         2zbQ==
X-Gm-Message-State: ANhLgQ2I1tepML5ewrGEdS4knbK4AH3qgfcivHBsJ8UtuZxB+34C9TEv
        QdnDlzC3lpkxqvwAMvBgc5w2OA==
X-Google-Smtp-Source: ADFU+vsVbQ4V97PRcWPdmYDtrRV3SMhggAZwTyXthYHZNz2Np81nIX+ln0eeRDTXutm8RL6olkccvg==
X-Received: by 2002:adf:b6a5:: with SMTP id j37mr9041267wre.412.1585224295334;
        Thu, 26 Mar 2020 05:04:55 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id w9sm3660279wrk.18.2020.03.26.05.04.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Mar 2020 05:04:53 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     linux-pci@vger.kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH v3 net-next 3/5] PCI: Add new PCI_VPD_RO_KEYWORD_SERIALNO macro
Date:   Thu, 26 Mar 2020 17:33:11 +0530
Message-Id: <1585224191-11920-1-git-send-email-vasundhara-v.volam@broadcom.com>
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

