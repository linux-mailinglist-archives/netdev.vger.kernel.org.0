Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CF552997C
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 08:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239571AbiEQGXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 02:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234066AbiEQGXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 02:23:31 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0114C443E7;
        Mon, 16 May 2022 23:23:30 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id w17-20020a17090a529100b001db302efed6so1385853pjh.4;
        Mon, 16 May 2022 23:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gla1iMtLbzTLY/WsJTFU3eSt8LbkGZm2WCyjmOZ94Mk=;
        b=oUqRqNZ2yhI7CCtTnp1sMdkNPXffMF1OMTroSTHqZEF2VmvIE7r6pM9eCQqJIV735Q
         M3eWTrg4Asv5/I8Kqoz9Jpu1LQq24hElZxm4WjA7ZwG29tAxAgxt7BdpFFa4LCDjpW+O
         CnG34jWCs9wPbPhWELN0fQsNylX/8UVIrCZioPfU7CgtpZvC3gnrHkm6tmlnD5zjUVN6
         M+GsZ+F6UG8I4Uu1udu7Quc3xlICjto/fqiv0kDAC6BkxGP7Z+N5M31+vTUHNckmdBJL
         S5JbXyEXT6Tpwn4uQoh+0Gou6WQWpxrmkWXY++nA00SaImmRJskvKKFw3urQ+DoKKvbI
         V0bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gla1iMtLbzTLY/WsJTFU3eSt8LbkGZm2WCyjmOZ94Mk=;
        b=o/VJr3GGJEZDDXPCFeZnnUSqdIex9y7vW0foX4SWiv5YPmYaCcqkyayjF2fRrCU847
         odoPUq2i2w7L4pfwgjUtUdjx296Lb75XabDpYyyo93Iwovb515JrjKNdYsbjAbTtpjYf
         3XN+KdLybOdIkMm4hBKv5y2HrRbEbyRJfwNtX17lp/i7elDmSpZoM8r7eRO9XUVlVJGE
         bvw9zkxiK+NJIviFw+Sa0CcBszgwh47rKLuqf42BFnLD5U/0+PlhvfigOw3pVBn/cQ24
         LlhxCUq5ZZ/sJAZ60FLJTgu/cuQQfVt5X2EoueFli7RTtx/OIT0fli3tPQxbp2ZFofOz
         ipMg==
X-Gm-Message-State: AOAM53049ZfrKSsDV5tsPFPfYn2ZZP0W2Xk9D+ZdLd98gdhWlrc4pIHK
        B/PAEyvo/plT8NIOooObxd/OlwT+s/CkUQ==
X-Google-Smtp-Source: ABdhPJzoPDY53Qk9T1FmCGROaeQ+Brz1cXWTJe/hN7gYGyM0WYgrK96gZNKcSmnMqK+RC1+0ZebbiA==
X-Received: by 2002:a17:90b:4b4e:b0:1dc:74d0:c8d4 with SMTP id mi14-20020a17090b4b4e00b001dc74d0c8d4mr23340808pjb.138.1652768609438;
        Mon, 16 May 2022 23:23:29 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x12-20020a170902a38c00b0015e8d4eb1b6sm8111935pla.0.2022.05.16.23.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 23:23:28 -0700 (PDT)
Date:   Tue, 17 May 2022 14:23:22 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net 0/2] selftests: net: add missing tests to Makefile
Message-ID: <YoM/Wr6FaTzgokx3@Laptop-X1>
References: <20220428044511.227416-1-liuhangbin@gmail.com>
 <20220429175604.249bb2fb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220429175604.249bb2fb@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 05:56:04PM -0700, Jakub Kicinski wrote:
> On Thu, 28 Apr 2022 12:45:09 +0800 Hangbin Liu wrote:
> > I think there need a way to notify the developer when they created a new
> > file in selftests folder. Maybe a bot like bluez.test.bot or kernel
> > test robot could help do that?
> 
> Our netdev patch checks are here:
> 
> https://github.com/kuba-moo/nipa/tree/master/tests/patch
> 
> in case you're willing to code it up and post a PR.

Hi Jakub,

I checked the tools and write a draft patch. But I have a question before post
the PR. AFAIK, This bot is only used for checking patches and adding status in
patchwork. But it doesn't support sending a reply to developer, right?

For the selftest reminder, I think it would be good to let developer know
via email if the file is missing in Makefile. What do you think?

Here is the draft patch:

diff --git a/tests/patch/check_selftest/check_selftest.sh b/tests/patch/check_selftest/check_selftest.sh
new file mode 100755
index 0000000..ad7c608
--- /dev/null
+++ b/tests/patch/check_selftest/check_selftest.sh
@@ -0,0 +1,28 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+rt=0
+if ! git show --name-status --oneline | \
+	grep -P '^A\ttools/testing/selftests/net/' | \
+	grep '\.sh$'; then
+	echo "No new net selftests script" >&$DESC_FD
+	exit 0
+fi
+
+files=$(git show --name-status --oneline | grep -P '^A\ttools/testing/selftests/net/' | grep '\.sh$' | sed 's@A\ttools/testing/selftests/net/@@')
+for file in $files; do
+	if echo $file | grep forwarding; then
+		file=$(echo $file | sed 's/forwarding\///')
+		if ! grep -P "[\t| ]$file" tools/testing/selftests/net/forwarding/Makefile;then
+			echo "new test $file not in selftests/net/forwarding/Makefile" >&$DESC_FD
+			rc=1
+		fi
+	else
+		if ! grep -P "[\t| ]$file" tools/testing/selftests/net/Makefile;then
+			echo "new test $file not in selftests/net/Makefile" >&$DESC_FD
+			rc=1
+		fi
+	fi
+done
+
+exit $rc
diff --git a/tests/patch/check_selftest/info.json b/tests/patch/check_selftest/info.json
new file mode 100644
index 0000000..615779f
--- /dev/null
+++ b/tests/patch/check_selftest/info.json
@@ -0,0 +1,3 @@
+{
+  "run": ["check_selftest.sh"]
+}
-- 
2.35.1
