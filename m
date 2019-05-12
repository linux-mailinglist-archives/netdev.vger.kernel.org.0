Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 149451AB01
	for <lists+netdev@lfdr.de>; Sun, 12 May 2019 09:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbfELHaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 May 2019 03:30:08 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:52097 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfELHaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 May 2019 03:30:08 -0400
Received: by mail-it1-f196.google.com with SMTP id s3so15749067itk.1;
        Sun, 12 May 2019 00:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xJcbnbRCFHDxn85Bix7DuDcwvbDnsag2TKw0s1y1+D4=;
        b=ZvcDWa/0gaOmHTp40plWp6wHVhUZ7DaSbFt8LZNzuDKl3l71jmVY2RlIFPfItSsOh7
         TlVHkOuk5kzvvvV9TwHnOw1ZThdsM3WgOKwfI9VpgXxa1kH8BAIvsYjGtt5tOf335gdr
         mvsLJrmvrdL6AFXWbk4GLZvyub/5UJX6WilEOil0QILDbJ/6tROnN5s/mizRUmxJ+SV6
         lq++vumR16y9hsV+eVKTk1DXecNTTzUMI3sfh5ymPAAz1lB6phjsoQu8gq0ILYKDqXzc
         aT9JHaY2AXZKVMz7Otf3P3Gz8npw9FYIZlWIU8qRecBfz4urk9YBaUnqSKVNyH1Nvn6L
         N/SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xJcbnbRCFHDxn85Bix7DuDcwvbDnsag2TKw0s1y1+D4=;
        b=FujfFvZPfjiortujoQ2OtGJOMASPBMBo5ovVEI+cLNNyZW2EWk1zjrbUf1X8SrcA+d
         IjGDpB16RPkxa9l/P+I2laHkpa42GYUbtB2dMBtu5+Jc4oJuDNxpWPHTQ+4bWJo+Z9uj
         hIsOUOGCMMsrz46H+oK5RKkGkObpmXfs1RJbwxlkAlOOovZGYF7MCy+O3rn5vxG+joXK
         jgb6DKYTqh5ZqbznRRppOC1eH10i/T35Xydo4c5BsorOjXjDLnmR3ztFUP9ZaLH77iR1
         xDrckDRfCd1JriJXQjhuAwJiz0q8vCN/r8q7f33E4Ibq6EldwOARaUap8RFthX3bg88W
         Pwvg==
X-Gm-Message-State: APjAAAUj6LqjbW6rS7M5BCytEjQy6VQFAQKfTBuYNPcgVZ3SXC+4qPKL
        6qtJKg1YHd6vvTAXfLofkrs=
X-Google-Smtp-Source: APXvYqxql4ZEzOTXhn8Q5t9SelqnaUHvHVKGVLbNYmd0+1u5x1CE1WwwYOXsl7BSQ2gjcnQLXPEZvg==
X-Received: by 2002:a02:cc8d:: with SMTP id s13mr10962955jap.115.1557646207259;
        Sun, 12 May 2019 00:30:07 -0700 (PDT)
Received: from localhost.localdomain (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id k76sm4405065ita.6.2019.05.12.00.30.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 May 2019 00:30:06 -0700 (PDT)
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Cc:     Kelsey Skunberg <skunberg.kelsey@gmail.com>
Subject: [PATCH v2] selftests: bpf: Add files generated after build to .gitignore
Date:   Sun, 12 May 2019 01:29:18 -0600
Message-Id: <20190512072918.10736-1-skunberg.kelsey@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following files are generated after building /selftests/bpf/ and
should be added to .gitignore:

	- libbpf.pc
	- libbpf.so.*

Signed-off-by: Kelsey Skunberg <skunberg.kelsey@gmail.com>
---
Change since v1:
        - Add libbpf.so.* in replace of libbpf.so.0 and
          libbpf.so.0.0.3
        - Update commit log to reflect file change

 tools/testing/selftests/bpf/.gitignore | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 41e8a689aa77..a877803e4ba8 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -32,3 +32,5 @@ test_tcpnotify_user
 test_libbpf
 test_tcp_check_syncookie_user
 alu32
+libbpf.pc
+libbpf.so.*
--
2.20.1

