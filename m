Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5E6D191E
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 21:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731671AbfJITle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 15:41:34 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42099 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728804AbfJITld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 15:41:33 -0400
Received: by mail-wr1-f67.google.com with SMTP id n14so4428368wrw.9;
        Wed, 09 Oct 2019 12:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y7r5Z69fE1yE+XsafCfc/oZ4rs1PL76oFBNneE1EVE8=;
        b=LwKsNBbUjphzvxLVVmv4VzwfwtPcZvTdS5KjCiLe4++bOSZD2bOs2Ec8NvYA4sJATt
         5bTyZZEynuXgqk9X3svjHdfNbkQ/YTzF8MnSOBMJmXqGXb2LznE3jsq0aC1rasDsIqTg
         YMQele48ovAMzUrz2Qe/Atjyp0/Wi6lSufvNt5UexqedsGf/CFaxrZfqBpuOTnCEWN3b
         02gKCRE4TaRRZX1OlzOGbFjBh5qxg2fJozhqqWt8DdtojE+XOFxVAgfYEixG+abptIfZ
         a64nfpB8/lCRaDFqL4NftVPnqJPqNOgIfhbDXth5yyWY6j4CpXKeNNHifS9cTkY5yZdO
         ARGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y7r5Z69fE1yE+XsafCfc/oZ4rs1PL76oFBNneE1EVE8=;
        b=tE4aq0VrcHEa7bvBA+2kGPpim8TEP+bseucHSNO6n6Rl29W3+26mk0INM+U6Hhqf1U
         5f+Ry3JxQ7lsHL2hlTYu+u8NGpXaKrijMMbY0cEuuAijpEpvKGXZkILZWcYvCsPqZa1o
         TJUY7yJkm6Dsj0AUKpSNqe8wYjzHUXNleGsBT20/HArtdqBkbJM4MtGBC1+Zb08zglP4
         7j1PZnJ7LuAqq/4espKhbb1W7K0h2VvDemRO2VzYPtcodPPQgV6NY6h7tMfh5FhXkr5y
         D2aUafCFhHHCxZe3mczZevaJr/9olJJ4jP4nAEOpDNZn1xRED5spvaYR8Yu/Mw4uZUWN
         vZzw==
X-Gm-Message-State: APjAAAXsWF6XfENOxrNWRe34scbz7PfDC6QnUz4MdBC0Q4TRLWhWv+rS
        sQUbNNTsLgVVivHegPACKA==
X-Google-Smtp-Source: APXvYqz53OW3mcjZgAtNIrgZhpJ2FXyoW9+7LUP1QsPRWht3yuwrafL+fAqC3uj0C56yDq+Q2EEAZQ==
X-Received: by 2002:adf:f40d:: with SMTP id g13mr4103031wro.368.1570650091469;
        Wed, 09 Oct 2019 12:41:31 -0700 (PDT)
Received: from ninjahub.lan (host-2-102-13-201.as13285.net. [2.102.13.201])
        by smtp.googlemail.com with ESMTPSA id t18sm3685646wmi.44.2019.10.09.12.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 12:41:31 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     outreachy-kernel@googlegroups.com
Cc:     gregkh@linuxfoundation.org, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jules Irenge <jbi.octave@gmail.com>
Subject: [PATCH] staging: qlge: correct misspelled word
Date:   Wed,  9 Oct 2019 20:41:15 +0100
Message-Id: <20191009194115.5513-1-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct misspelled word " check
 issued by checkpatch.pl tool:
"CHECK: serveral may be misspelled - perhaps several?".

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 drivers/staging/qlge/qlge_dbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 086f067fd899..097fab7b4287 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -354,7 +354,7 @@ static int ql_get_xgmac_regs(struct ql_adapter *qdev, u32 *buf,
 
 	for (i = PAUSE_SRC_LO; i < XGMAC_REGISTER_END; i += 4, buf++) {
 		/* We're reading 400 xgmac registers, but we filter out
-		 * serveral locations that are non-responsive to reads.
+		 * several locations that are non-responsive to reads.
 		 */
 		if ((i == 0x00000114) ||
 			(i == 0x00000118) ||
-- 
2.21.0

