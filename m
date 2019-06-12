Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4E9425C5
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 14:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438685AbfFLM3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 08:29:40 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43400 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbfFLM3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 08:29:40 -0400
Received: by mail-pg1-f193.google.com with SMTP id f25so8851799pgv.10;
        Wed, 12 Jun 2019 05:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WFcM32SS6XaD8HSCn00NiHqd+wcd7qBRLAizzgTZVxY=;
        b=Y5ihkDG2CTC5uDcLFLVuhq8mJ16YaC9ICO39gSxNlGpbmCnDIiAfbPqIQF2Gca5+Ml
         GK1oVU3LgZTkLnWXBh3hjs2Fs3Zp6FYzsw3Nk1Pp+JuecJeh16b8AhxsQ1l6QSlVX/JO
         SIMMiP0QKEX05LnnY3C5JwauagNbOYdrg9zRe5sfpzCEK+zqKqQMjMxPMG55oyiNJYNr
         aKhxxSoINBvHAo0Biht/1CnrO2EmUpxxuMTSuOaGu+kO2QSci6XYIffhg9UvZ6fkW1dG
         2qEGgWc+FYHiRN4L3MXMwgBgiRdmVpd58V2+4i1atT3dnz6vZpk7IrySBS+uxgaJbTca
         q/bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WFcM32SS6XaD8HSCn00NiHqd+wcd7qBRLAizzgTZVxY=;
        b=HpBN4VOyPfoYJJpTA6tndS3D8PlwXU1IzDhqjfsvb476HL2uWC8OES106TqPhxQdpm
         YtBqtq8y7KhpjzjJD5escvyhfNxSQOqw9dVqt/woZ0h0M/GkozztHTI4vG2aYNJA2mxi
         8WPHsg1dhDSkFNR1qLUyfKKqHiO9iJyWT4e9/TOiyQ1JyAtEGYTOvMnYY2fJnY4GBltM
         vfvB1EJ4It6ZYwH05j9rlKD70DPkC2dv7r1dOdM+nMiwRhh/Prz/ydPCgtvs71dysijE
         xwkTjd6m+rHpHdTBFZCUR0T7+mECsexCNUBxkW/H7YXKTsbNQVzerVj7q6G3eNE51DZN
         07qw==
X-Gm-Message-State: APjAAAWfGE+2D4twMEi34nOPRZml9X9TwZEJnZd7fIRX5OKPib4kMylJ
        VFHJCkKBY69WvL2BsrCkYgE=
X-Google-Smtp-Source: APXvYqy/SY9OVqCPDYbiHArI3JT+x/0Z0xR5oGUlcaPHGqGLYEZFSqG2z2BlJ1c9lItzkcr9REzpfg==
X-Received: by 2002:a62:e917:: with SMTP id j23mr80596145pfh.55.1560342579591;
        Wed, 12 Jun 2019 05:29:39 -0700 (PDT)
Received: from masabert (150-66-71-0m5.mineo.jp. [150.66.71.0])
        by smtp.gmail.com with ESMTPSA id b26sm14993505pfo.129.2019.06.12.05.29.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 05:29:39 -0700 (PDT)
Received: by masabert (Postfix, from userid 1000)
        id 5FF482011BF; Wed, 12 Jun 2019 21:29:35 +0900 (JST)
From:   Masanari Iida <standby24x7@gmail.com>
To:     santosh.shilimkar@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc:     Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] linux-next: DOC: RDS: Fix a typo in rds.txt
Date:   Wed, 12 Jun 2019 21:29:34 +0900
Message-Id: <20190612122934.3515-1-standby24x7@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a spelling typo in rds.txt

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/networking/rds.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/rds.txt b/Documentation/networking/rds.txt
index 0235ae69af2a..f2a0147c933d 100644
--- a/Documentation/networking/rds.txt
+++ b/Documentation/networking/rds.txt
@@ -389,7 +389,7 @@ Multipath RDS (mprds)
   a common (to all paths) part, and a per-path struct rds_conn_path. All
   I/O workqs and reconnect threads are driven from the rds_conn_path.
   Transports such as TCP that are multipath capable may then set up a
-  TPC socket per rds_conn_path, and this is managed by the transport via
+  TCP socket per rds_conn_path, and this is managed by the transport via
   the transport privatee cp_transport_data pointer.
 
   Transports announce themselves as multipath capable by setting the
-- 
2.22.0

