Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7D1EB38DB
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 12:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732486AbfIPKzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 06:55:48 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39044 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732485AbfIPKyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 06:54:50 -0400
Received: by mail-lj1-f196.google.com with SMTP id s19so2609630lji.6
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 03:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ICv/vY4XAwe136r6/MDdnRXmmJJ1JFeohZKBWO948JI=;
        b=renlPhv6Vx5CNHYksA5WzO20FVIYXEGpjJn5/YGtCgnC0BCwjUvLBlAbeS2QWSwpah
         jcbI6KeCWf9WpTaXKqzoATiWjCG2prOysrOtXjGAuLCXoTntdh4Qt/9m80BBL8QN4pzD
         XadY611DPWHua3DwZGOlRJTNUpZN6TrPk0Qwv6sDmublMKNGDX/eMekRKEEMHAPLynHN
         5myrlSfFkSMecyixXnfJtcPFSkWkbeUOkkzmZn0e084lNX5MEANYr1m0mJB052RjofTA
         cKvGdlGjvGxXUcAUQef27FEQY1g72gk+N/QCID6XsEJxukpv5MfPHG1nANwRFzRONI4R
         ysPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ICv/vY4XAwe136r6/MDdnRXmmJJ1JFeohZKBWO948JI=;
        b=pbf6ZbeFdIhr7nOS1G6krIGQKIYhdda4UYtHRSHb+o7wngCfapZRMKJe/9mu2X2ZRz
         VfkWNMoR/mSJOsVptvObKlp9yGX3ANp2s+khMV/h4Ifg0Y9b0k6mhBo+57+BTP9UV8sM
         ZH50EWoTl5pWy0276Mif0UBIIMZC768PA9wGLROLBq85sCurn5B+DPgQ2LbYwyh/3l51
         YiYgLuMdI5tUtPbxIa3HEH3lTQ4P0f8mn/YN+R1HHh4rtKr2YLv9py0Tmmwys34wPDYY
         qvvJWkWtcrtFy5QiEfoE7MbWEju+mHCNYwn+e4+uSdJtahBC/OuXua9gk5RhxLRu2tEn
         H9yA==
X-Gm-Message-State: APjAAAXEzNVcyLoa52LdoWazPz7ScOyyjDL1Ng6x9/PSfUzjrNzxcMaf
        tf0mVs6rLAK+9kzCEHWuCEzttg==
X-Google-Smtp-Source: APXvYqxSBkjyrfAdAo3XLVu9mwgNU46b8BtP9TI1G+SDVPq/GRexV8qvD6bjRrTR9lMP98abCOCLiQ==
X-Received: by 2002:a2e:9881:: with SMTP id b1mr19271028ljj.134.1568631288103;
        Mon, 16 Sep 2019 03:54:48 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id v1sm8987737lfq.89.2019.09.16.03.54.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 03:54:47 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v3 bpf-next 06/14] samples: bpf: makefile: drop unnecessarily inclusion for bpf_load
Date:   Mon, 16 Sep 2019 13:54:25 +0300
Message-Id: <20190916105433.11404-7-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop inclusion for bpf_load -I$(objtree)/usr/include as it is
included for all objects anyway, with above line:
KBUILD_HOSTCFLAGS += -I$(objtree)/usr/include

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 samples/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index d3c8db3df560..9d923546e087 100644
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

