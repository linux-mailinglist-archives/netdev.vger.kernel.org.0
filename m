Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94C8ADB5ED
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503296AbfJQSWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:22:32 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35587 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441367AbfJQSWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:22:16 -0400
Received: by mail-pf1-f195.google.com with SMTP id 205so2176275pfw.2
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AEGvKnfQeLZgTuuoBlNpjdEyPkTims2t45IzI4n8yBI=;
        b=GDC2yRrOHVLVeXuCrJZ3VmJIJ1v4JQVHaPmNBYGnz4NyF+ewC4X1zXwh9SxoGAeuFp
         wY+CpSbnMNkVuJGCvNvFrqa8sMv0ao4KdtDZL+aN5FwuHBs2683mSLzaEXdZzR6CtrFC
         PIpdKnaW5EEoaWf6X7EUzcO2+vPmEIL3jHsWQP2tR5R80feQovdeNkkvul79RyR2oCv3
         LQ6zQLkHAHwvzIqe845Tiqzz+KACfkNWexHFTcuaG210ViQge1vJb5z5EJuoq35YVGtm
         MQ6A8tf2Iff+JD6FwLeCaQiSqb9z5fIAr+466Z1Oz0G0ic50T8eScDhwu+29g58sr06U
         tRyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AEGvKnfQeLZgTuuoBlNpjdEyPkTims2t45IzI4n8yBI=;
        b=VCF/TH2FZkKOcqXDNE+1bPZZCMDrpewipJ/cK1aNvBfwqJttuArJcKUSpsNq58LbIy
         f3WRs0tSU1MW1BJdtF0qufT27HQ4+C1RzmC5VR20PArQNC1MKXInsxaJ3yajIftvSk0h
         0poHhhcYHp4+jMG5lEjamEnPPZRjN3X8Y+t8qnPcunWUH3X+nhuLEZClw/5gwqSnME37
         sok625QGiq+AKB5ZL9BLaT4jDnlaX1+tD4wTc1M7wbX9EtU/L8SjrepI4geolzASmZo0
         mNuziSiFrRQr4qkJB7HNzvxHPv/SrTPNfYdCJrAeBmHMSRUzJUq8lITAOk5JvjuNKUIX
         IQUw==
X-Gm-Message-State: APjAAAUMFCOn/y6e539LaWpOhad6/HTQDyiMXkh+oaGRs0C3v5VvgVba
        YoClQ7H2XqbbJv+UhbMMaGQ=
X-Google-Smtp-Source: APXvYqwlsHhy1HPE8ZnBjZBd3004SQpx+XWvXXajir4Pl9xb/EtO1UobN5r0y5dQedZzVRVI0vkn6Q==
X-Received: by 2002:a17:90a:bf09:: with SMTP id c9mr6113442pjs.9.1571336535304;
        Thu, 17 Oct 2019 11:22:15 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:22:14 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 27/33] fix unused parameter warning in fec_dump_regs()
Date:   Thu, 17 Oct 2019 11:21:15 -0700
Message-Id: <20191017182121.103569-27-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
In-Reply-To: <20191017182121.103569-1-zenczykowski@gmail.com>
References: <CAHo-Ooze4yTO_yeimV-XSD=AXvvd0BmbKdvUK4bKWN=+LXirYQ@mail.gmail.com>
 <20191017182121.103569-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This fixes:
  external/ethtool/fec.c:197:43: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  int fec_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: I5d53deb593d72dcfde95b62f1651dd8f5d6aa3ba
---
 fec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fec.c b/fec.c
index 01b1d34..22bc09f 100644
--- a/fec.c
+++ b/fec.c
@@ -194,7 +194,8 @@ static void fec_dump_reg_v2(int reg, u32 val)
 #undef FIELD
 #undef REG
 
-int fec_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+int fec_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+		  struct ethtool_regs *regs)
 {
 	const u32 *data = (u32 *)regs->data;
 	int offset;
-- 
2.23.0.866.gb869b98d4c-goog

