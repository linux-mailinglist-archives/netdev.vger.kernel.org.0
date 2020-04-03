Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECF819D1CD
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 10:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390446AbgDCIHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 04:07:40 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40013 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727854AbgDCIHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 04:07:40 -0400
Received: by mail-pl1-f193.google.com with SMTP id h11so2412175plk.7;
        Fri, 03 Apr 2020 01:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BqsejPhEsNGTkBR/V4VHlPwRYOn9PoHXki3NwPRDLyI=;
        b=RU6eH1p9bVt0qJ3ao/uc4k+J6TbgbVV5QCR6ftVCHnS+ODzh2STglo+CiyNPg3V25L
         NtbMCZTLmQE1oDVk451ykXcFYPcYdWZOWozqjCVvR5fldIGkvXdKti5ce/VvrbiwlALY
         6Vn7fWHHLCUHW+mKrc6y1alEAhTXwYd0VDsAuTyO0jmRgErN9DbH0nenwZsLkMY8H7tG
         hb/1dPxFqAphsQdP9WKpog775HALF5pWc6sb4j7r+RpZr0itVLLmZ5+Rv2N5ouFneuO0
         FoplwDh1cNcwEjgeqSYXkw9wdlTnLqA3KU/2ThajPfmNMLnulX47gLHEXGsBxYHuQxcf
         QK3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BqsejPhEsNGTkBR/V4VHlPwRYOn9PoHXki3NwPRDLyI=;
        b=MIrq5gFfaM9DQ1CdCxWJsK6+OBgfgdmxU83xXZ6OpLp5LP8YHEBqwSs4dDVnB85fo/
         gO1itnhw9mI4DeGcK5R+tHV+bthEmGafR1iBzA168AuaUy9aaCF0KZEV7BhS0JNnNTAA
         uRDbBe2LvxK0oNxughEt4OLTKy9EgQbCP81vcUBV2zKZm8Q7bNI5b0/zCSqNUipM8pc5
         7xOy2NikAaggNaY1l/0lp9QmwzlQRkXDl6yYUGHmVQJ9I+YO0VByXzDJ3Iy5FoLkPfHK
         brnP7xUSFCSvXqu62Cf6zXrb3RQVFCplez6Wbu7JHEBKiZkErxOvbDptCgJekTZdAoFE
         98Zg==
X-Gm-Message-State: AGi0PubhmN/FBAyMI+9y01ePZEPcfoi6YtC/EibWUGJwfDQ0TWlyDu8l
        RHyuNxTGJaBRyRF8w3XMJI3qsdKa
X-Google-Smtp-Source: APiQypIYASoYJ8qshnEx4durUctoWwG5Ygup6ZLhtYh5wmDyBknPpmOEgUDOpI0eF0TURpJgNQYE9w==
X-Received: by 2002:a17:90b:1b05:: with SMTP id nu5mr8299244pjb.110.1585901258717;
        Fri, 03 Apr 2020 01:07:38 -0700 (PDT)
Received: from VM_0_35_centos.localdomain ([150.109.62.251])
        by smtp.gmail.com with ESMTPSA id 13sm5314500pfn.131.2020.04.03.01.07.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Apr 2020 01:07:38 -0700 (PDT)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     kafai@fb.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH] bpf: fix a typo "inacitve" -> "inactive"
Date:   Fri,  3 Apr 2020 16:07:34 +0800
Message-Id: <1585901254-30377-1-git-send-email-hqjagain@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a typo, fix it.
s/inacitve/inactive

Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 kernel/bpf/bpf_lru_list.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/bpf_lru_list.h b/kernel/bpf/bpf_lru_list.h
index f025046..6b12f06 100644
--- a/kernel/bpf/bpf_lru_list.h
+++ b/kernel/bpf/bpf_lru_list.h
@@ -30,7 +30,7 @@ struct bpf_lru_node {
 struct bpf_lru_list {
 	struct list_head lists[NR_BPF_LRU_LIST_T];
 	unsigned int counts[NR_BPF_LRU_LIST_COUNT];
-	/* The next inacitve list rotation starts from here */
+	/* The next inactive list rotation starts from here */
 	struct list_head *next_inactive_rotation;
 
 	raw_spinlock_t lock ____cacheline_aligned_in_smp;
-- 
1.8.3.1

