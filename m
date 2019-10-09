Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAECD17F7
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 21:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731144AbfJITGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 15:06:37 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39236 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728804AbfJITGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 15:06:37 -0400
Received: by mail-qk1-f196.google.com with SMTP id 4so3232403qki.6
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 12:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JpBVfudJYQlRvLLRFQnsLItxi/YinYg39fsS6SrSYA4=;
        b=k6tzurN7NU4HrUlQI8MfTR2V97/W8UvXLk59NRYVEqW5GxRimhAIZBgWTH659PRmI0
         TlC7/ZEc2SeUDVSoj/eBBDwYu3E8zXPNHPgn4RherYmwCxDJa7MZOamMTRrdpVh8L5rj
         ExM242XldmcR1sLE4HrnKZOlSN5+jrc7sFRVPmI2Zmkcz7a785hG9Jup8c7UnwnAPtev
         9DIJvEH6T36yTHzPgtsxXEkdkRrvqEE30az3hDMXlHf0mt4QAHCztEwZ0yvhG5T7DCbR
         nsdV3Aw81+trgNdrDrnIiSNXlnzuWylo/LSa6qL5wu5EN0Z/ud0yUim8SqFuevVKge/A
         DEog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JpBVfudJYQlRvLLRFQnsLItxi/YinYg39fsS6SrSYA4=;
        b=AQ2gzLt3QlnDr62HatX2/p/UxCoPtZtTGYkAldaJr1knpeyrfeUJOnhSF5lXvtKMYl
         27e+Wh0pQZBaTgVX47oNz8/2EO2o9tDFAulez0uTFzbpqoN5I5hhfKa3raZzOEaSQnKs
         /BKYLirdv+np11DqAjCym3u0/VBwU66SYZ2IiDR7ZBDaKFRNa3+BMG0s+lwy73XuV0IW
         55ouaZ6N6sxbeoHkX7M+4mHTvOb/xQhtcC2VdPXcS2c8ShZiMv43KMzsqtVEF3UelKLu
         WyRv+YY1WYyX8UEsz87Ok55iUnKXtRaLXBBoH3qLdqoWdQK2UuEWtBG6kU+zPg45zCKE
         G22w==
X-Gm-Message-State: APjAAAUHZXmQD2e/nl/3+qdzNG5bfhVvI3BDZG95qBzxP2iLZXaH49+w
        0f8chsx1DztI+YwIkjyN5jITtw==
X-Google-Smtp-Source: APXvYqykGfcgWy1fS85p2yizfTwjlKdwn6hF/N01bkF2m5qGVk4jclTLGU9KDIzcQt2jcedioj8ITA==
X-Received: by 2002:a05:620a:896:: with SMTP id b22mr5399208qka.390.1570647996176;
        Wed, 09 Oct 2019 12:06:36 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d45sm1496520qtc.70.2019.10.09.12.06.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Oct 2019 12:06:35 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        idosch@mellanox.com, jiri@resnulli.us,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net] Documentation: net: fix path to devlink-trap-netdevsim
Date:   Wed,  9 Oct 2019 12:06:21 -0700
Message-Id: <20191009190621.27131-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

make htmldocs complains:
Documentation/networking/devlink-trap.rst:175: WARNING: unknown document: /devlink-trap-netdevsim

make the path relative.

Fixes: 9e0874570488 ("Documentation: Add description of netdevsim traps")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 Documentation/networking/devlink-trap.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink-trap.rst b/Documentation/networking/devlink-trap.rst
index 8e90a85f3bd5..70335c3ed3c3 100644
--- a/Documentation/networking/devlink-trap.rst
+++ b/Documentation/networking/devlink-trap.rst
@@ -172,7 +172,7 @@ help debug packet drops caused by these exceptions. The following list includes
 links to the description of driver-specific traps registered by various device
 drivers:
 
-  * :doc:`/devlink-trap-netdevsim`
+  * :doc:`./devlink-trap-netdevsim`
 
 Generic Packet Trap Groups
 ==========================
-- 
2.23.0

