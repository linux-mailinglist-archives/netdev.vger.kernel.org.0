Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324FC3F0B71
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 21:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbhHRTHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 15:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbhHRTHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 15:07:44 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E014C06179A;
        Wed, 18 Aug 2021 12:07:08 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id r7so5191294wrs.0;
        Wed, 18 Aug 2021 12:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mBZb63SSLEPVDr6WHI9UQlUQ97X47DnKLHPVD6K6nag=;
        b=ASr2s5JJFnL15u3/P12jOQlhD5UagdZPSygAS9XhbGepJZ4MTnQo1WjgPaZTcxcSe1
         imeRJHDsf+C/8HQWv96h3W0BL6GRBaxzUQDVQrgu9HoBtiGrXibUK4gwHff7kua0HKCc
         mViI3ouR/j3VkCFbASGQfswjgBj5slptoONvNbItOgFJvOBEZEEKGUgxuu+t8VKcKDnh
         FcdKU1qV0pOugBEFY6nH9Ai99+BxVT5JDz+iuEYLyVphxX4CiGyAoO7l5ebMSQI6bgb+
         mB95nGrlZAdsZW6l19jXYNdYqCuVxkQLi9myqx9XyAOnF0/mTkhZC0yKy0ZPx0u/ULAM
         CezA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mBZb63SSLEPVDr6WHI9UQlUQ97X47DnKLHPVD6K6nag=;
        b=DF5LrreqdXWzvTFVphGUQMHwvTL5OVUUgQaYytBNu3w3B3yEyswu74Z3XvH/i3ySJa
         6CVAU224xL281qPDdAqnzGWHpAqLief/FaomB7uf6+J45sz4A70v65htGoyOTp5DQzcY
         1ly6y0/QIeaet0+6ZJ4CbdIamrEjomGDXGBn/fEGdz9pnHtpwS0DbDQD+zsTLhvWDce4
         SysU3PYAmKU4WWyxbh7+fJwVB2SBevZyYOo6TIASmxn12HX6pNScKk9Y+0UrZY8KXq+O
         +TVusXbzqpBVfVXydfIvnVRylzL0Sdw4FwWOZ3Y6hw2EvmP1+vvgJouwOHB4JyjCOmRy
         Fezg==
X-Gm-Message-State: AOAM531xnebKnAWech16GXQfQP9Y2MgE/cckS1NdDOdWWxiQIn+eM+3y
        NdJ7jTlUVKWogPFplCvmhqrcI5CD2XuEyg==
X-Google-Smtp-Source: ABdhPJyVfFkpxkHBgwdxdMCFQcX6ifkI1AmXZcsApQrNQnMnhU97MI5UBtB9HBt41tp9yenhNxtQIg==
X-Received: by 2002:a05:6000:1864:: with SMTP id d4mr12998155wri.250.1629313626710;
        Wed, 18 Aug 2021 12:07:06 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:5c16:403a:870d:fceb? (p200300ea8f0845005c16403a870dfceb.dip0.t-ipconnect.de. [2003:ea:8f08:4500:5c16:403a:870d:fceb])
        by smtp.googlemail.com with ESMTPSA id s1sm5719988wmh.46.2021.08.18.12.07.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 12:07:06 -0700 (PDT)
Subject: [PATCH 3/8] PCI/VPD: Add missing VPD RO field keywords
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f693b1ae-447c-0eb1-7a9a-d1aaf9a26641@gmail.com>
Message-ID: <58b7b0d7-4320-fe1d-4c45-7b360f7ea3d7@gmail.com>
Date:   Wed, 18 Aug 2021 21:01:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <f693b1ae-447c-0eb1-7a9a-d1aaf9a26641@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds further keywords that are defined in the PCI spec.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/linux/pci.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index a82f5910f..629c810ae 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2274,6 +2274,8 @@ int pci_enable_atomic_ops_to_root(struct pci_dev *dev, u32 cap_mask);
 #define PCI_VPD_RO_KEYWORD_MFR_ID	"MN"
 #define PCI_VPD_RO_KEYWORD_VENDOR0	"V0"
 #define PCI_VPD_RO_KEYWORD_CHKSUM	"RV"
+#define PCI_VPD_RO_KEYWORD_ECLEVEL	"EC"
+#define PCI_VPD_RO_KEYWORD_EXTCAP	"CP"
 
 /**
  * pci_vpd_lrdt_size - Extracts the Large Resource Data Type length
-- 
2.32.0


