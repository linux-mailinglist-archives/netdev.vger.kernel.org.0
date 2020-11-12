Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1132D2B0C2E
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 19:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgKLSDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 13:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgKLSDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 13:03:43 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91525C0613D1;
        Thu, 12 Nov 2020 10:03:43 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id h16so764356pgb.7;
        Thu, 12 Nov 2020 10:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BvAoCiK7KLgbwabWYOZYPslrGTOP+khLicxt6/9UQao=;
        b=gBUZYlVKt6nz958YuHqfYqdzQUN7cat8UjeZaUfj+Bcgvb4oL804n2vMWGkA8JUSw0
         veuCHqbTMFUqwM89FaLWP5VonEvNncGOeD2BTiXanToAiDXQg+KThnf+HUBbrYzMMYYF
         HSDY1ZNBNwvsnJPtqh5WE7XDEc+WcME+JeUepvvhuxp+H/iYJZuuMjDrERhWqxubVlGM
         SwVwvTIxXCHdOcF9A1boG+H5T3B7Vl77/U25cfDxOEEjVJr38IRbt/u8Ig5jN6kDFzXW
         zyhUejutEaSgmx1JVJzPEwDAicSYL6Rc/Xb1hmqY5Zppw8fELzajW8UBXyRZ3Uxmlyqw
         DRpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BvAoCiK7KLgbwabWYOZYPslrGTOP+khLicxt6/9UQao=;
        b=iD1vgzWf9joppTawSOqfYlrPeIgMYulS7ElvaW5Zuis1xxwXcPR3FzRXLPiT4lAuTQ
         ZZrY6HIFZLHyRPSZWUSuLJmBrhWKEF8JSOLcFh6NGFpBx1gBDW1e/0DONEAHUtADl5FX
         /xT7L4+R27juk+pckA9tlwru7mtk+Mlr2NkpicGMKLBeSmQwlxqrqVrP0wZr7bs1+Q1N
         fuEskg2PHwDUFlvY7kKZKsEInO5gfu7hpKusFDWbwyFIvW5CUZEFGSf4JRWXPm+FMwhA
         /dojG2Lqnj5mDbNNBLuycc3cq20ydeUERk1aiE+Liy211GagWc58mJqfoZ93yobC8g23
         LcwA==
X-Gm-Message-State: AOAM530DA6H/yK7t+ZlQAUoWWnYklyv05XeX0/tiX5pkCJnwOefG6Ra9
        NfXawyZM3xQYCaGdlcI8pylwMZ7ut0I=
X-Google-Smtp-Source: ABdhPJzC9xr8SSs4P7+DeowiySHOY+qdu59i5+OngqZHGOYSBTZeen9iIIyXxFtCzcp/fANzHfgmxg==
X-Received: by 2002:a63:f242:: with SMTP id d2mr582679pgk.44.1605204223024;
        Thu, 12 Nov 2020 10:03:43 -0800 (PST)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id g26sm5403286pfo.57.2020.11.12.10.03.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Nov 2020 10:03:42 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf] MAINTAINERS/bpf: Update Andrii's entry.
Date:   Thu, 12 Nov 2020 10:03:40 -0800
Message-Id: <20201112180340.45265-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Andrii has been a de-facto maintainer for libbpf and other components.
Update maintainers entry to acknowledge his work de-jure.

The folks with git write permissions will continue to follow the rule
of not applying their own patches unless absolutely trivial.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cd123d0a6a2d..008ee2bf753b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3243,10 +3243,10 @@ F:	drivers/iio/accel/bma400*
 BPF (Safe dynamic programs and tools)
 M:	Alexei Starovoitov <ast@kernel.org>
 M:	Daniel Borkmann <daniel@iogearbox.net>
+M:	Andrii Nakryiko <andrii@kernel.org>
 R:	Martin KaFai Lau <kafai@fb.com>
 R:	Song Liu <songliubraving@fb.com>
 R:	Yonghong Song <yhs@fb.com>
-R:	Andrii Nakryiko <andrii@kernel.org>
 R:	John Fastabend <john.fastabend@gmail.com>
 R:	KP Singh <kpsingh@chromium.org>
 L:	netdev@vger.kernel.org
-- 
2.24.1

