Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED48CDB5E1
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441348AbfJQSWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:22:08 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33210 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438745AbfJQSWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:22:05 -0400
Received: by mail-pf1-f194.google.com with SMTP id q10so2185541pfl.0
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WzbJgNu/35/StaO5oBQslYgxZwxjFtROIsrVEJk3vYo=;
        b=seqi+DvNfqwRh7UggSSXwGCho/G72n7+t+ULxQ9EQFP0X+7Uch6Ag6kxL8s/1X42EP
         zoJ2uvJnD+Xox4hpKdOTU5fykI68YtxR3in3BwMVQbyfHQWGSE0P5LzEMcfID1+jzryI
         u1lfwpL+LaVqpo83RoxyhpYaNdV3/HBbkzK7Qb2XUIWAWIguRrHIeO7y5ZX/tXLs/6bP
         Lodl918iy9gSIfjH3G0Pvg1GekbI85KXzAe+Oc2gPNFs6Cw72rKiIEsBljkyqs8CQLCs
         dF8TumIBvHOZ1QanuOu/nCu8v7W9KsAS3w2ch0a2KS9u5oDtAwDaFPX1c4NIrBzO1sDb
         Nk3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WzbJgNu/35/StaO5oBQslYgxZwxjFtROIsrVEJk3vYo=;
        b=R2185YFfu4c/BoRSKSS18zpVMWsVTrrst1OzNP+lXLg1iZI9jswAh0UfjXytkNB/5g
         YFwBwzxOmCQkJZNZQXb1BqEasptKaMDNg+2rkiWczOAvZLhOtmWFxMGvNRL3FpH1raPY
         qr52g/n2OUzq2RhoNiTeu1dcVUXGuxn4/r5aYYLSeJLR6cEpc18SFoSVscM1iqpWnpQz
         YIu0l3dyF52EGUXBLIcrj1gztTv+02EIOmabzchnlMWxzJUS8ciq17/k3zHYAoVXfPdK
         tHyGceBKqfiCbK9yD5iADq7CObAqyKa7/ZCfs5OlxlpL8h79uYHGvYYSLIqBUslsRVPp
         K6SA==
X-Gm-Message-State: APjAAAXv9mQIIYAfcF3c8bBrpMCZqBglyPOFs/ZB7Hee0S+MhkgYuqNQ
        Td5gkyq4XOLISxTJjinx6BE=
X-Google-Smtp-Source: APXvYqxcANl4NLTKLqmjAUwHyCM9YEBUa4xB4s/iYvGceBUhVpHLBzXldZzifJC7JevB3bSLz/p8IQ==
X-Received: by 2002:a63:5d06:: with SMTP id r6mr5633777pgb.216.1571336524455;
        Thu, 17 Oct 2019 11:22:04 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:22:02 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 20/33] fix unused parameter warning in vioc_dump_regs()
Date:   Thu, 17 Oct 2019 11:21:08 -0700
Message-Id: <20191017182121.103569-20-zenczykowski@gmail.com>
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
  external/ethtool/vioc.c:14:44: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  int vioc_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: I2b25a5c4d23af281616847ceb75ca8c70dfb44d0
---
 vioc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/vioc.c b/vioc.c
index eff533d..ef163ab 100644
--- a/vioc.c
+++ b/vioc.c
@@ -11,7 +11,8 @@ struct regs_line {
 
 #define VIOC_REGS_LINE_SIZE	sizeof(struct regs_line)
 
-int vioc_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+int vioc_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+		   struct ethtool_regs *regs)
 {
 	unsigned int	i;
 	unsigned int	num_regs;
-- 
2.23.0.866.gb869b98d4c-goog

