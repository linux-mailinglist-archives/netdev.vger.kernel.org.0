Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF132C68B5
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 16:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730045AbgK0P1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 10:27:42 -0500
Received: from mail-wm1-f54.google.com ([209.85.128.54]:34018 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgK0P1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 10:27:42 -0500
Received: by mail-wm1-f54.google.com with SMTP id g25so2653287wmh.1
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 07:27:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cx8sjC22UDN2FofwOzWwuJ403skCFm5jvcnaR58ncGg=;
        b=nPDDAq8FOuka9ggvSdn/ZzXBSsud7AgbACEHOOj8u1LnJqPcEfmRPr5nN5N2hIkFll
         h35wHuDEpHBXCzhNSqFLEzKmy8MS1znmDJ28xQgxsKFtd2bcTdu2sD6DOMTb7ASHmQtH
         7cOHrcvv/oniyM07bjLvJnV3P1H9nff2auuduCiya0lvibDnBXozvYZEfmW0uqdJxEyj
         ANHdVqSQliq6M80DW2pQTlWkZLtfWXA4HnGQs56TdMJGOT5T8zqaJaMQENpblGr3l3Dm
         yvZwTBSYR0rWVMwGgOXBbsjx5IVpH1pe+H4dmeYaBXK8WjO22fYd97TqkUid6L/wvxCv
         +oig==
X-Gm-Message-State: AOAM530Wfmhifg4sukDxp9VDnGPIqeq2UouRLpcdqfcHglhpmNIUfKNZ
        p6SxWRP61OWf91GCsZ0LVLoKGteOPtHnMg==
X-Google-Smtp-Source: ABdhPJxojg1KvzjxkIQwSJ9cIzjqfJiiroGMYhJ2VU9kxuZ4d08nnxILyFBlILcC75ZeTR72B9YzRA==
X-Received: by 2002:a1c:a402:: with SMTP id n2mr9942075wme.185.1606490860085;
        Fri, 27 Nov 2020 07:27:40 -0800 (PST)
Received: from localhost ([2a01:4b00:f419:6f00:e2db:6a88:4676:d01b])
        by smtp.gmail.com with ESMTPSA id d8sm15452293wrp.44.2020.11.27.07.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 07:27:39 -0800 (PST)
From:   Luca Boccassi <bluca@debian.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, Luca Boccassi <bluca@debian.org>
Subject: [PATCH iproute2] Add dcb/.gitignore
Date:   Fri, 27 Nov 2020 15:27:31 +0000
Message-Id: <20201127152731.62099-1-bluca@debian.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Luca Boccassi <bluca@debian.org>
---
 dcb/.gitignore | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 dcb/.gitignore

diff --git a/dcb/.gitignore b/dcb/.gitignore
new file mode 100644
index 00000000..3f26856c
--- /dev/null
+++ b/dcb/.gitignore
@@ -0,0 +1 @@
+dcb
-- 
2.29.2

