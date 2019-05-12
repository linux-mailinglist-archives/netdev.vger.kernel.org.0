Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9111AA2C
	for <lists+netdev@lfdr.de>; Sun, 12 May 2019 05:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfELDul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 23:50:41 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:54393 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbfELDuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 May 2019 23:50:40 -0400
Received: by mail-it1-f194.google.com with SMTP id a190so15384028ite.4;
        Sat, 11 May 2019 20:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KOEOI6gIRHaf5FORd84rjIs4AdvD824fbBk5i+JcVC4=;
        b=sp/d354XUziiUlWOFirNHHht+x2j4uJyHrHkiJTJu8duyD4CJ4hl+tBgzolY4WdYUF
         FcN3Y3QiUHGNEO92Q2ivtn0quwPpEBkMtSvjeYlWzGZnnv1N9AvTQcZKg6SknS01X4dx
         Zv3BH6yW12uflvYmJhS7YkA/tv0uMq3yb1pu06m7RnYq0KER7eRia2dQQw8QzUr/j22t
         ugsphAV7bCJQm2Qb32Sth8zgpPI6hvBYiNBCPzppTlN3tIP65VdGvjt+cw59ndSZ5yrT
         2SE2CnteyZD5tU32mLVZjH52PJU2xcSk6fhVtGDRAap3w1FmeqwVH+NY6TtgfcPIVaFG
         JZDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KOEOI6gIRHaf5FORd84rjIs4AdvD824fbBk5i+JcVC4=;
        b=JzEhZ/alnmzg9UV/EcWIwAayH2pNc4tJ5yqELWnTaya0HwE1YKn6Jq7wZkV+1CN5UN
         9aBGEv51gVyFN/Lpa5QPmt8HEdpfCXBSQ5cOCfM+EH/axw3khhgBOpN+05urJ+GQImi8
         4wGFLkIUmm+IshglGkKMVkrEOT0KSQ6oh+CN6ApMU3bNCc+6jiVQgOF1kuxEyAxAor91
         vwlJL0cDEmFh2rXFjqrBSytuwVqBUMPxxj+uEoW5c/nLejGvhXd1TKPWgiPzmxJA4yrr
         f1m51g65SuYLmUCovdYho20Fu+0hAFKMp/6TjcPWkTl4A+XdJU2bXL9EOt58W8TefWI+
         646w==
X-Gm-Message-State: APjAAAV2ykV4fJ8p925Z9nBaXrlTCa6cmRIfYEYNn50J6PDNVp0y0ehx
        jxA7icrA/xK48lxiKq1EHuY=
X-Google-Smtp-Source: APXvYqxtTdajmXEk7zEWki12uocFR3Eg8/Dsh5oU+jKO+JRTGnIwUcHTfehdKW27tlPY6Wv0Xkf4mw==
X-Received: by 2002:a24:3f85:: with SMTP id d127mr13281932ita.38.1557633039846;
        Sat, 11 May 2019 20:50:39 -0700 (PDT)
Received: from localhost.localdomain (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id k76sm4248746ita.6.2019.05.11.20.50.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 May 2019 20:50:38 -0700 (PDT)
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Kelsey Skunberg <skunberg.kelsey@gmail.com>
Subject: [PATCH] selftests: bpf: Add files generated when compiled to .gitignore
Date:   Sat, 11 May 2019 21:50:09 -0600
Message-Id: <20190512035009.25451-1-skunberg.kelsey@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following files are generated when /selftests/bpf/ is compiled and
should be added to .gitignore:

	- libbpf.pc
	- libbpf.so.0
	- libbpf.so.0.0.3

Signed-off-by: Kelsey Skunberg <skunberg.kelsey@gmail.com>
---
 tools/testing/selftests/bpf/.gitignore | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 41e8a689aa77..ceb11f98fe4f 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -32,3 +32,6 @@ test_tcpnotify_user
 test_libbpf
 test_tcp_check_syncookie_user
 alu32
+libbpf.pc
+libbpf.so.0
+libbpf.so.0.0.3
--
2.20.1

