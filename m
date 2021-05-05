Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C2E37470E
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235123AbhEERmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238767AbhEERkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 13:40:25 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2F5C061249;
        Wed,  5 May 2021 10:12:55 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id 33so799364uaa.7;
        Wed, 05 May 2021 10:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sYEeOLVMdJz3if+0nTi25SGNzwSnRfdV3Io7PzqsWAY=;
        b=ZtjRg+nBEQtSEGpfHLS23h0b7Js4SstedcRvMYmTQmw9adHOXbdEDxVOs1iXVtsGYQ
         AH426lOZWMolKltecv5N9iBRcegwpilm4/5FK2IMcZH8O0fCRrUVnDjZV2b0grg7Ckt+
         kCYWuhMFZdwJo9pWe2C78cQVYAeIwIC7uqw0mnP21spaCIsgC7jZsHGNCUOY9HnhkPQx
         Bi6LuFrcmnBhMdC5VSCPTmo4lZqOM146iPX8k04A+rmIbY4HGNseRnnpt+NSgaBzxKNU
         0BpBySW9TgESuhsoojyBRkHRNEioPNbuNEfsgaZNnuipUINcXx6eFV0kvJsl43l+awrD
         MJ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sYEeOLVMdJz3if+0nTi25SGNzwSnRfdV3Io7PzqsWAY=;
        b=V8BByElrppG/axbvFHM4RHXSzCLF8lVzlG1Qtf9GQIcfIqfQVQP2ub/In+YJAZBXbx
         XLgdfEKXYzKcPE64CstRA0fatHVZiX9Gmnm6kRe0lEwOU3GSYJzfdmJ+nO09eJLKx8PB
         mfeI0/EPhN/Sypbp2ruhf9u9LC8FO+O1hejTVXaBKnQpb8aECCn6K9hC478252HW4Z/t
         iIwRQTUvZPHs6ZatfjJtp/lnE1m+bWmIzcYv0AbL69tCY/XXRkkLRAYys0Zq8dC7Q6qx
         sTz/BOE5hN6we7m6jsbX/xB/7zHQn4SbD7asg9dspNXUzKKjESoCUDKC/2UbTtvmIvfU
         M9uA==
X-Gm-Message-State: AOAM532yqt45M/08fXCIqMnDcYGPIBXs20mEo1GBsMjdo07HgjKOKF0Q
        K8+APwAKdm1Ns/xlHr6zvOc=
X-Google-Smtp-Source: ABdhPJxrl6CVBgay6XwS8cB/nO+08T3TYNuo4ah7Z3BMR9/JWosO831NgUUU1N02XZJqzIfRjatvsg==
X-Received: by 2002:ab0:4757:: with SMTP id i23mr62507uac.87.1620234774254;
        Wed, 05 May 2021 10:12:54 -0700 (PDT)
Received: from localhost.localdomain ([65.48.163.91])
        by smtp.gmail.com with ESMTPSA id a16sm5968uak.1.2021.05.05.10.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 10:12:53 -0700 (PDT)
From:   Sean Gloumeau <sajgloumeau@gmail.com>
To:     Jiri Kosina <trivial@kernel.org>
Cc:     Sean Gloumeau <sajgloumeau@gmail.com>, kbingham@kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        linux-mtd@lists.infradead.org, Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Gloumeau <sajgloumeau@protonmail.com>
Subject: [PATCH v2 3/3] Add entries for words with stem "eleminat"
Date:   Wed,  5 May 2021 13:12:19 -0400
Message-Id: <b636dedea2c2ed230bb3d53f45a523eb0f5dfbc0.1620234395.git.sajgloumeau@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <6a526dbf75f6445f3711df0a201a48f8ac3149cd.1620185393.git.sajgloumeau@gmail.com>
References: <6a526dbf75f6445f3711df0a201a48f8ac3149cd.1620185393.git.sajgloumeau@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Entries are added to spelling.txt in order to prevent spelling mistakes
involving words with stem "eliminat" from occurring again.

Signed-off-by: Sean Gloumeau <sajgloumeau@gmail.com>
---
 scripts/spelling.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/spelling.txt b/scripts/spelling.txt
index 7b6a01291598..4400f71a100c 100644
--- a/scripts/spelling.txt
+++ b/scripts/spelling.txt
@@ -547,6 +547,9 @@ efficently||efficiently
 ehther||ether
 eigth||eight
 elementry||elementary
+eleminate||eliminate
+eleminating||eliminating
+elemination||elimination
 eletronic||electronic
 embeded||embedded
 enabledi||enabled
-- 
2.31.1

