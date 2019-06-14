Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3F8454EA
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 08:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbfFNGne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 02:43:34 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37483 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbfFNGne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 02:43:34 -0400
Received: by mail-pf1-f195.google.com with SMTP id 19so818607pfa.4;
        Thu, 13 Jun 2019 23:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xVM7uHDg+KZk9kXmmDlQBSRAQfZqX9mBnZVDBrDdd2o=;
        b=JR4ci2weJXdY4Yr1rp8nmHxtc3440bSzYbiuZw1xHnCeDUFXH6+xf0XXto/oCesTtb
         SDnpT322XRNzzXh7Q9FYzx+u4n14zwN1sYUISqBx0oodXxA5lgriav8tJdaWgiCHollB
         PTDhwrF+St77uA8hyrkq6fyw1KBhxlCffvs5ubREEL1VA4wymYjiifxsNMwxSjP+dyTK
         Cd8cYMp0NYVtS8WxT27C9r6/y3dvsLouViaApv2iGqpW4uMNJL67adyb8xSDlPCkFzSl
         z5vtbNllR6slIwN31BzTuTnNnb3h2fXNZRD1m8IupoRVwsdXjY9y5SkvGGqFmI+QVjIL
         szag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xVM7uHDg+KZk9kXmmDlQBSRAQfZqX9mBnZVDBrDdd2o=;
        b=glYtZlzakwG4cm6Oak6lQQQinvdWHYtrgWiigtA5wVvjPwJZkgeoG5mqRoMgG0PUH0
         R4XDz6sKbF3XA0g/oDReglWURhO/EWrRoDXVogv+kirYSTMzmQVQtZA3gOvkoKpJuxG1
         jFbZZaYmQ/FZRtaCk1z6DTh/h5nkZry4a6oNsH1XeY3EPvLI5Vt54csDHNEfczZNzZUh
         DT4aoZoKW+54I4K7eEIb4ZVzGIHjZ2TMTYs0jxyO8Zy5JL/LLUo2wFMNffxL30XMXClX
         4p28rUat1yrWSqmkAGazXWFHQTAmNcZgHe86rFtFijpmQousTLbnM2vqL+Ji0hGvfEb5
         5ErA==
X-Gm-Message-State: APjAAAVTqKxnV5lFcIuqZpfokcigWH/JMm6V4sVc6xSbOrFoQdBij0cm
        mjMO5Mnv67W5TmZ1/75t7bM=
X-Google-Smtp-Source: APXvYqwSwHhZ3QkXqcIqULy1+Ia3M/+j3NBQfVQz1es2BhBCB07UQnuEAaSO/1LXV5MxgdONEbWCng==
X-Received: by 2002:a17:90a:e38f:: with SMTP id b15mr9610491pjz.85.1560494614123;
        Thu, 13 Jun 2019 23:43:34 -0700 (PDT)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id c130sm1701289pfc.105.2019.06.13.23.43.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 23:43:33 -0700 (PDT)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next] samples/bpf: fix include path in Makefile
Date:   Fri, 14 Jun 2019 15:43:18 +0900
Message-Id: <20190614064318.16313-1-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent commit included libbpf.h in selftests/bpf/bpf_util.h.
Since some samples use bpf_util.h and samples/bpf/Makefile doesn't
have libbpf.h path included, build was failing. Let's add the path
in samples/bpf/Makefile.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 samples/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 9eb5d733f575..34bc7e17c994 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -170,7 +170,7 @@ always += ibumad_kern.o
 always += hbm_out_kern.o
 
 KBUILD_HOSTCFLAGS += -I$(objtree)/usr/include
-KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/
+KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/bpf/
 KBUILD_HOSTCFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
 KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/ -I$(srctree)/tools/include
 KBUILD_HOSTCFLAGS += -I$(srctree)/tools/perf
-- 
2.20.1

