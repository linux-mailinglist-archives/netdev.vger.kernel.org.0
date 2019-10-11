Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54A13D3604
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbfJKA3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:29:33 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41055 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727601AbfJKA2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 20:28:31 -0400
Received: by mail-lj1-f193.google.com with SMTP id f5so8028788ljg.8
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 17:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZXAfjdX+WvsCZ4Putv4iaBG542bdy+GxK4sst7rF5S0=;
        b=U8B4vmxpgfJnzBiDJsbyyQvQCGTuwkGq440RprVd0W/jBwPaWulfeCmeD7ZzaIVdWh
         PBT2V1HNzKuxn9toI+ubYWKykuXxFguzRYTDd8aU43+pbuXMFAXCOFHgx8OTesJKeHiP
         u8fxXTOmnvuWqXYlx3MeAD2HpWswrvkvtw0QVFQ1TgcOPxhyNo1fHUaNodXg+eVN8lHz
         lyUqk+Nwewllbi0cPmn0R28no3ae8PrTbX1i54WHZxoYPkI0ILgtCmFu+vOGKLD3Eskz
         vjscmyBfhit3N498RUoFIS4ShuUVwWFD8rcLhkMAMURHLcw3iCv8D598o9x/C5n1OoqD
         dIFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZXAfjdX+WvsCZ4Putv4iaBG542bdy+GxK4sst7rF5S0=;
        b=EtuZwmwpeTeBp5tHRvXP7Kba7AaNoE1rcjb3EyavTROFwTYtoaw64rxAmKlIW3HAU8
         dVhmwXP+ZRMXAh2ecOFhrKvC9yH99wEtnQt/l9aSMQKYBlzwHGOeR8L3F8sS768QHrJ1
         KJv3c8Go9X4wIZQB+tWjWHCB+v6ahZCLtB0tYGjOeMMK+xGOLf8gMrBLfTiPQwmo+ek2
         kQTGak6Nua+CV6rvUY61YysBvrUWnLEZGJKwS/ghKBqv2HGNEgcvVZE6TyT4ZIhAdEei
         GrdqfZh7ZnDmtrthjylXF/o1l2b3KYzgaFfmZOtod1Govd/6c1oD7tpS+xV6uhlpOngY
         3p+w==
X-Gm-Message-State: APjAAAWIqmBsu+JSaL+qAu3v32SR1EEIx2Av2++WpgvwywacG4qeWCVh
        bBAFcp0mnr194xpcpq0FdoCKdA==
X-Google-Smtp-Source: APXvYqwArHNK6yFOGfNBm56dLOLa/ki3fV+x83BMbZjybbtZFF/vhXt8lhYHjA0KBaEmMKXer8mkYA==
X-Received: by 2002:a2e:9890:: with SMTP id b16mr7075689ljj.153.1570753709112;
        Thu, 10 Oct 2019 17:28:29 -0700 (PDT)
Received: from localhost.localdomain (88-201-94-178.pool.ukrtel.net. [178.94.201.88])
        by smtp.gmail.com with ESMTPSA id 126sm2367010lfh.45.2019.10.10.17.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 17:28:28 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        ilias.apalodimas@linaro.org, sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v5 bpf-next 06/15] samples/bpf: drop unnecessarily inclusion for bpf_load
Date:   Fri, 11 Oct 2019 03:27:59 +0300
Message-Id: <20191011002808.28206-7-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
References: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop inclusion for bpf_load -I$(objtree)/usr/include as it is
included for all objects anyway, with above line:
KBUILD_HOSTCFLAGS += -I$(objtree)/usr/include

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 samples/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 9b33e7395eac..bb2d976e824e 100644
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

