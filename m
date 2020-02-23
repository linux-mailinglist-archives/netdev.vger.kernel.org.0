Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0899169ACE
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 00:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbgBWXSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 18:18:13 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38961 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727394AbgBWXSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 18:18:11 -0500
Received: by mail-wr1-f68.google.com with SMTP id y11so8225777wrt.6;
        Sun, 23 Feb 2020 15:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fPUr8jCY8JIDce77aHKLu0kesj5mi5yI8K5HlZIk77s=;
        b=umWQtF4rQ643Qg1LiBfMBoOhKtVIL5uLVM5lEckOEZTF4gFu93yUOZqUT2SSb79R6N
         NbsX2uOQCz3H6bKZ/2Ht9YiHeP5bHRxfeCpxWOYKuz3FhMEZgnd7O4/x+72Y8TbrhSDk
         B+JDguRpue+4HBlYQ6OO7qtJ606wfHWf95eKi47/FdVq0IoOyRbz1EZ7wmp0GjuLMvbq
         jld1eUMgJMKReDoqZ+I9U7dD/yPB8VEl68LZrwovEVCWPJ+U68q0FES6/ZA6yUR8uJnd
         THp2YnDws/QDxvFIjAVkx+FwvDvdggLHZzCznpEduCVtBuq0k4AlsHN3HbVne4GXbZK9
         Cb9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fPUr8jCY8JIDce77aHKLu0kesj5mi5yI8K5HlZIk77s=;
        b=kj3fjDniI4wiQM3rFoi3Z5EAZiUpLMQMzNtH5W9GJBZh6xZvodFGNYG1Y+VgP59PDJ
         PD/5nEb5JhsQ9v9uTfnvAYDFJDl48mgsBGlp2xWRE++84QblEWLrEVYZ13/5xS54l+9t
         xLmUomEt4I4/j/qptKVafnziC42Kw4rFllhSou+4TWB+Ds4xgfKAyYqeaxAzcB7/T/Jv
         uBIWbk9qDkkXtDYWRc/HuQ6wNZwDYvaFr+6ybwLkGal5+kSibhJ2ymoihUX/Nhqkc9xL
         R7KG6/4SGSm3feTc9VlqDv4MvLlfU1UtMgL1HwwmMwL2kd97FN6K40d2hLgXtwfPdYH8
         ApuA==
X-Gm-Message-State: APjAAAVhwm5aIJiH5XTJHhtPDt1VqDwkNG3loX1lVruWguegXmZREZHC
        YTlLj7tN3ouhFAFUB5GP2g==
X-Google-Smtp-Source: APXvYqzZlbx8It43QShJfKjvjpoTUrSmBRIOwdew2A0aFJvxC0n1wEo4RUyL+HsNRtPaB8C/DW+LWQ==
X-Received: by 2002:a5d:638f:: with SMTP id p15mr61891483wru.402.1582499889294;
        Sun, 23 Feb 2020 15:18:09 -0800 (PST)
Received: from ninjahost.lan (host-2-102-13-223.as13285.net. [2.102.13.223])
        by smtp.googlemail.com with ESMTPSA id q6sm8968203wrf.67.2020.02.23.15.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 15:18:08 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     boqun.feng@gmail.com
Cc:     jbi.octave@gmail.com, linux-kernel@vger.kernel.org,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        dccp@vger.kernel.org (open list:DCCP PROTOCOL),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH 14/30] dccp: Add missing annotation for dccp_child_process()
Date:   Sun, 23 Feb 2020 23:16:55 +0000
Message-Id: <20200223231711.157699-15-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200223231711.157699-1-jbi.octave@gmail.com>
References: <0/30>
 <20200223231711.157699-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports a warning at dccp_child_process()
warning: context imbalance in dccp_child_process() - unexpected unlock
The root cause is the missing annotation at dccp_child_process()
Add the missing __releases(child) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/dccp/minisocks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dccp/minisocks.c b/net/dccp/minisocks.c
index 25187528c308..c5c74a34d139 100644
--- a/net/dccp/minisocks.c
+++ b/net/dccp/minisocks.c
@@ -216,6 +216,7 @@ EXPORT_SYMBOL_GPL(dccp_check_req);
  */
 int dccp_child_process(struct sock *parent, struct sock *child,
 		       struct sk_buff *skb)
+	__releases(child)
 {
 	int ret = 0;
 	const int state = child->sk_state;
-- 
2.24.1

