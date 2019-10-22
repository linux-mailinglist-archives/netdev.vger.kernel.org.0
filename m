Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDCEE0D43
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 22:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389362AbfJVUbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 16:31:33 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:36311 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389192AbfJVUba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 16:31:30 -0400
Received: by mail-pf1-f182.google.com with SMTP id y22so11361883pfr.3
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 13:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UL4YoAgVjljaV9SpY3P+fcAsvdORWO94x8YI79oYmRA=;
        b=ZOcruWNNEgQYEI4aSpGB3dCOIG9kh1AZIkeOtUTUfPqKdFF0hNY7rQCgGRHVplnzUo
         GOF730s9FoJa08WqXhMdCF8cgJyhUvS0UjxQKHSHu+xRmv05OEVVn0JEZRJygWgOUiQi
         rTvhR9UE6PHXUyj0hrWWhxzcGqT644sBEoIdssQsAy+a42UTehNdFJtsrZkV6vcgixMZ
         h3Y1Q7DimV8hhHTnwn1dKxaWNbSlyTtdhOc1IdWLnPGtHC7YP8UNvQaS8slyGZXwhJYU
         ZwKxndgEk8EIdXstEsQispJW6GDcPcCROd2NC8h62zKVjsal1zogbpih7ppnw6ES68a9
         og9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UL4YoAgVjljaV9SpY3P+fcAsvdORWO94x8YI79oYmRA=;
        b=AymZ1QSdvikymZG8RqUHCXM+zFf/uUtKAS9oRf491KFPUwwKsjoi8HtiY8sXqYJDlN
         zj0Q96w8V/sgTcgL0sh4Faxou34EQUult6S43RDhxZi/jZCn62xm4KSdsz/QXPOFSjuZ
         WDh1WLbO/+ZUa3BMAsYmWdxg7Wy3AcfsG1CPI2vDjlrGtX1Qrz58MhuLGnqb4dxSzgvs
         nuhO7KzwCwcawtGAZVLtQYOmj8JDb+U3QuoolLOhiVWwJMQ6PRDkCuiFbmdwdqSwlu9T
         Z7nwsyCKxGsm6QDBnFCYDgWBMYyJyRBptVnvWIhcRMax8QG+o/V0/fxj96rvgZC6GWiD
         pO6A==
X-Gm-Message-State: APjAAAXxBMEk3tDYdLF2mrzhcWsQl6OCMyjBktFg7WKV5IygdISWkMgQ
        PLpu2YgNBTc1PTBaf7Ud7OS6J8jAI5Y0+Q==
X-Google-Smtp-Source: APXvYqw45M230pbh3/yVHFuG1ofRRm7kzjbUi95SPp+DPDI3uTfXzG+ihU2eRhMfTfetTdfDBsFrJA==
X-Received: by 2002:a63:f916:: with SMTP id h22mr3554499pgi.423.1571776289125;
        Tue, 22 Oct 2019 13:31:29 -0700 (PDT)
Received: from driver-dev1.pensando.io.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id q143sm20754530pfq.103.2019.10.22.13.31.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2019 13:31:28 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 6/6] ionic: update driver version
Date:   Tue, 22 Oct 2019 13:31:13 -0700
Message-Id: <20191022203113.30015-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191022203113.30015-1-snelson@pensando.io>
References: <20191022203113.30015-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 5b013250f8c3..98e102af7756 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -12,7 +12,7 @@ struct ionic_lif;
 
 #define IONIC_DRV_NAME		"ionic"
 #define IONIC_DRV_DESCRIPTION	"Pensando Ethernet NIC Driver"
-#define IONIC_DRV_VERSION	"0.15.0-k"
+#define IONIC_DRV_VERSION	"0.18.0-k"
 
 #define PCI_VENDOR_ID_PENSANDO			0x1dd8
 
-- 
2.17.1

