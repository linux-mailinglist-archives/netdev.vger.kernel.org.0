Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21DE9AE869
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 12:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406140AbfIJKiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 06:38:50 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33918 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436512AbfIJKir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 06:38:47 -0400
Received: by mail-lf1-f67.google.com with SMTP id r22so1728309lfm.1
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 03:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Jcy7fNNZJS0bHfCAktRnVFRPdGNhHeHDFWh1+uGNMgg=;
        b=TacAjaChlFJ4KM27SSs7dVz9hlSYEhjkfawLkkkl48IIQQ1wSVIYRQqMrlaTvwl5CP
         DLad2TxLl1dIZdNnUCsQoUzGEzjSHzGAoJfGcjZM4FTLbfHDJDLxnG5DAEJV3cr2Dy8K
         NohR7qiDvztBEtRRhN+sI9gFBal1gTt0bC+OvHCKzOtDlFYiVB5XXrYtgW94qEUhkp2h
         3v8a3c01/ol6w+U0kIUEzHlnI0iBQYa+7bJiSI6L+/2JnZTArU2V7S1yzvcDNRFO1VxI
         N2wy/iUyP3CgCFvDn8yQRk+j1Mob2gdE9ZGzqU5ILV7gLlW6lFvbvv5sRg6nA13I38pN
         V0kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Jcy7fNNZJS0bHfCAktRnVFRPdGNhHeHDFWh1+uGNMgg=;
        b=hf0p0qIpnVV0rWtPJTrTcwUOKXB0T+W4KjrcayZaCgxHM3g+Dp6JQQ1UCqcJ2T4qD/
         Em0uNvNiyWU/Js3NJOxUiWtgNmfZFzxku5WipT774rRJb6UUhteYuMikpUg/bvWS7jgU
         ibU6He8YnA7ll0rV8BkH6CltQowDZh4mPjtZzEwZVpr8RwbcnKl45oql16h4BcbdL2rF
         JHdKf5/S5k1djdv8KK8kV7Jd/3LCB3wWhuOkcRQpgeNHO0cMPDPvyNIOW5pISGHEW/nK
         Wv7DR25rxa+y+zj1t69uZ1kzcMBFHaaiLtykEkOYdsGg2QWRpFlRZZGgD/5q6TKBKg5G
         wqSg==
X-Gm-Message-State: APjAAAV7u0rhuaC9u4OJUktqD8o20P30KBDOFC5ZLXKvbk1w0LjIOb4U
        iJxOfY0CIPAVI0yzgy/6pz/Eow==
X-Google-Smtp-Source: APXvYqxX7XFT8xCd+TWq4vlEfFVMcJ0HVWrjeAbjcVLZkGDyrKGcSAfl5dWOTqsxAy0ogJoKl4C1Sg==
X-Received: by 2002:a19:2d19:: with SMTP id k25mr20950410lfj.76.1568111924828;
        Tue, 10 Sep 2019 03:38:44 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id g5sm4005563lfh.2.2019.09.10.03.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 03:38:44 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH bpf-next 06/11] samples: bpf: makefile: drop unnecessarily inclusion for bpf_load
Date:   Tue, 10 Sep 2019 13:38:25 +0300
Message-Id: <20190910103830.20794-7-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190910103830.20794-1-ivan.khoronzhuk@linaro.org>
References: <20190910103830.20794-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop inclusion for bpf_load -I$(objtree)/usr/include as it
is included for all objects anyway, with above line:
KBUILD_HOSTCFLAGS += -I$(objtree)/usr/include

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 samples/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 6492b7e65c08..f5dbf3d0c5f3 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -176,7 +176,7 @@ KBUILD_HOSTCFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
 KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/ -I$(srctree)/tools/include
 KBUILD_HOSTCFLAGS += -I$(srctree)/tools/perf
 
-HOSTCFLAGS_bpf_load.o += -I$(objtree)/usr/include -Wno-unused-variable
+HOSTCFLAGS_bpf_load.o += -Wno-unused-variable
 
 KBUILD_HOSTLDLIBS		+= $(LIBBPF) -lelf
 HOSTLDLIBS_tracex4		+= -lrt
-- 
2.17.1

