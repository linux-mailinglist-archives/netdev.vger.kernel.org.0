Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBFC4AE950
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239621AbiBIF2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:28:07 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235775AbiBIFZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 00:25:08 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D26C035444
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 21:25:12 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id z37-20020a056a001da500b004c74e3fd644so1040365pfw.1
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 21:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1uteCcqOHI/0uzMt0En4ebHH5gvzXxzw9MhZz5KXgD4=;
        b=IQmADCKRqBcDLWqGxwMOAV/ntlFvKBjJk8wBMDf2/VG5DCJCbge4vXYImJfFccc++A
         FCOIryAiTwqcPt2Ose0mF9PMjL9KBQ7/6PWrKYyj6UkAsqtHb+NZNf1XdL0X0NoThMpL
         ieO6Akmo3Mh60DeJ+NoUTjGFteZD8CATPm/I+5d/ydBFZGHCxfjMjHMtzHTk4VZEIy6h
         9n/ShJpAMFNJHtDIHkK/MEzbkec+aNII1ATfCq90CtiW6zk3EjxREHjJWmGlRo4zZuYb
         JilPpQ0FQpnOXEW+VQFDwIW5vWSALo2j8mWBZjnavFR74JID6XTPkkTdqoiHU6irUrtm
         gsaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1uteCcqOHI/0uzMt0En4ebHH5gvzXxzw9MhZz5KXgD4=;
        b=tz7QlfUN77F+jW1bHyCw+VEe3CIQeV/YCCi2jVbYegRjWYaA0NfpuKV38jL5O/azDu
         k7aO/OnuYepiEkWZ9tdINTlD2A2kyDMbzctdOAOhvRBFTt8AvrbomAFH0eBn9cdyOQ7C
         yVgq1zdLz3kG8YLZZjFoM4TtQw7GIkpe5JhFa1hpPppKHKTx5qtYo6PiwjfYU0YAtd9w
         hvck5RRSmfp91Ztk9CiZdlITg1Rqv1lYCf525KqOuPL6HCEjdviz9/aaIpMOgOq+Nm3e
         KnNTjGtPd3LE5ma0T+RbLMbXR5DTRyr6HtiJ5rIl6yh09ABsreeuNj/X9XPSZLsyov3U
         epfw==
X-Gm-Message-State: AOAM530cqfHSg1ZhLBuqINjmVFEp7MP3d3pA+Nnv18/Ke56MtNMNwuDJ
        e2AZ0uCIW4IqwdnVrVNYRZZzv42IOXBk
X-Google-Smtp-Source: ABdhPJzglferL7rdNcij5KHw2MyxXfeQS6wr03V//WCG/OaB8ZKXVTKSopF3i4fEW93Gs1qNs/mGYQwMkeNJ
X-Received: from connoro.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:a99])
 (user=connoro job=sendgmr) by 2002:a05:6a00:1a8d:: with SMTP id
 e13mr600902pfv.82.1644384311846; Tue, 08 Feb 2022 21:25:11 -0800 (PST)
Date:   Wed,  9 Feb 2022 05:21:40 +0000
Message-Id: <20220209052141.140063-1-connoro@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH bpf-next] lib/Kconfig.debug: add prompt for kernel module BTF
From:   "Connor O'Brien" <connoro@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Connor O'Brien" <connoro@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With DEBUG_INFO_BTF_MODULES enabled, a BTF mismatch between vmlinux
and a separately-built module prevents the module from loading, even
if the ABI is otherwise compatible and the module would otherwise load
without issues. Currently this can be avoided only by disabling BTF
entirely; disabling just module BTF would be sufficient but is not
possible with the current Kconfig.

Add a prompt for DEBUG_INFO_BTF_MODULES to allow it to be disabled
independently.

Signed-off-by: Connor O'Brien <connoro@google.com>
---
 lib/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1555da672275..a6bbd4bb2bde 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -334,7 +334,7 @@ config PAHOLE_HAS_BTF_TAG
 	  these attributes, so make the config depend on CC_IS_CLANG.
 
 config DEBUG_INFO_BTF_MODULES
-	def_bool y
+	bool "Generate BTF typeinfo for modules"
 	depends on DEBUG_INFO_BTF && MODULES && PAHOLE_HAS_SPLIT_BTF
 	help
 	  Generate compact split BTF type information for kernel modules.
-- 
2.35.0.263.gb82422642f-goog

