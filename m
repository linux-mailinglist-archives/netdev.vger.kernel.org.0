Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34DCF121ED
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 20:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbfEBSeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 14:34:06 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34017 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfEBSeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 14:34:05 -0400
Received: by mail-pg1-f194.google.com with SMTP id c13so1458106pgt.1;
        Thu, 02 May 2019 11:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=mk/kGskailcPgv1xLAgJYzt+1XdBtBMAZELXcKnVAUg=;
        b=VCsJo6rVoqMjXiL8qeB1gUZPpIy/keGZR52p0D2xIZHHh5nYv/Uf6B/rUc+mwt8Q6u
         DdIz5UJ50kYSvSBVIWSxzD+v1IjDpaWwvQnX50Sbs/47YpgggPM6x3s5iMhtgVotDRlm
         wfTpezH8BFqJpvRC0C2D00tO9F0SMHpj0zMo9y3P1YTBK8mDzyVknd3wG/5C0m7jwk8A
         4Za+1yPf+azD/X5kd8Ys5IkjwawBHCVE38viuaopT+2iAwOIUdh3R4AxTBxpqLclweaI
         5AG/ISdnuFx8f815C4aDx/Na9UDgg9SMWZ3P7UBpfbKHxg91CEqDtIZ4BQl9clMWKGLl
         bUxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=mk/kGskailcPgv1xLAgJYzt+1XdBtBMAZELXcKnVAUg=;
        b=b8xpwPeM47HIHZjccZgj4HGb6MNYStuVkwDl6W1Il7M2O/uNBId+NLx2zcTbQaWDjn
         8sU6iCVkULl/Po9FIp2j93oaP5XZ7U8nXhK+F75Ze8PYMUzmnTO6SWGVxaJgE8yUi1R7
         xjN4foC8ivN2Apu52w3IdDEjXJ9oHdCe1c4A5SpQy7Jw5VwbwTZ9+aYNrQi7r9oUq+3s
         cedEFJvZxb1vsRH8TlkM7uzp/cvpfd2PQfQG3oExZAlxLiJ81cO7yTMR+Ygg2S91aHNp
         7dYeqQBx6o2vleCFQuY0dGGYZyAUiTIIulWYYSA/BThY0ViQfsCaxm/ZUcmLWbAzeGhY
         5cPw==
X-Gm-Message-State: APjAAAVtIK6yXpz6lC4Hb7hRYSodFP7l0YsRlz7sXHMG9f7GtKnAqgI8
        fTptZ7xTgDcuoQ4bWd/Ww0k=
X-Google-Smtp-Source: APXvYqxS8KWrUN9AhDp5dJulydSnq2OeWs2mN7lSrwyYoQFuM5RC7PA7655APc8actXaiBEKJd554Q==
X-Received: by 2002:a65:51c5:: with SMTP id i5mr5543273pgq.189.1556822045172;
        Thu, 02 May 2019 11:34:05 -0700 (PDT)
Received: from sc9-mailhost3.vmware.com ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id v82sm98324501pfa.170.2019.05.02.11.34.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 02 May 2019 11:34:04 -0700 (PDT)
From:   William Tu <u9012063@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, magnus.karlsson@intel.com, blp@ovn.org
Subject: [PATCH bpf] libbpf: add libbpf_util.h to header install.
Date:   Thu,  2 May 2019 11:33:38 -0700
Message-Id: <1556822018-75282-1-git-send-email-u9012063@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The libbpf_util.h is used by xsk.h, so add it to
the install headers.

Reported-by: Ben Pfaff <blp@ovn.org>
Signed-off-by: William Tu <u9012063@gmail.com>
---
 tools/lib/bpf/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index c6c06bc6683c..f91639bf5650 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -230,6 +230,7 @@ install_headers:
 		$(call do_install,bpf.h,$(prefix)/include/bpf,644); \
 		$(call do_install,libbpf.h,$(prefix)/include/bpf,644); \
 		$(call do_install,btf.h,$(prefix)/include/bpf,644); \
+		$(call do_install,libbpf_util.h,$(prefix)/include/bpf,644); \
 		$(call do_install,xsk.h,$(prefix)/include/bpf,644);
 
 install_pkgconfig: $(PC_FILE)
-- 
2.7.4

