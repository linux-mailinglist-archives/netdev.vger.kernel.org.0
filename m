Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40D46276D8
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 09:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbfEWHYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 03:24:55 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45930 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfEWHYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 03:24:54 -0400
Received: by mail-pf1-f196.google.com with SMTP id s11so2728277pfm.12
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 00:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=u38zJekK9kA19OWA43wigi4i1LlEMbJjn/mvkJzZjfc=;
        b=Ljey4rKGds29mYsi8HXnGW/lZ5RmZxmaB9lh0D+k2RaSq2vNRev8+BraiwklFPtiiC
         aNRY9vyobz5K8NFrrcgZDMhX4oUEwKq7I+PwQmkRomO9QLXvd8O63M6y5cCYxXK5uETd
         icrHrF0hF81Vk2u2hA6YzkztFrBH/o53aLUYnwQ7HpcyDTR8RcZDN06Hz1cLu8j97lJ7
         sxK1WCZ+oKmSrIYB5ABQB1dKbwr1a/aYN6j+XpGFyFTiAdEvJ934zwt8ohwhMbZgpg8K
         ljnv7Eu0yBP4oxou/nlwS9JpatoIlyPy3NoyEB3yBshuvrz7eyWZK9mJ1w3RgcL9ww83
         at7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=u38zJekK9kA19OWA43wigi4i1LlEMbJjn/mvkJzZjfc=;
        b=PYWRTR3iwqwUJW1GDAdhZmF4tFwhAuPfhmAEqkVpwoXf1G7cnSoMTSnUqGkUeqoC6s
         H5ah9RaOFTadBHXTJxjaJbLCoI82IuF+hOg9DFdhpOwLGhxfFMZ/Y1CtvSioTkSR1DlX
         rwws0J7BBjzgVlr9g17CGYmDch3F3LOkJt+HtvAxoXh0KvfOXlsDJx/XSb/GI0Q6YXkr
         mDXopSIe5giN6c7xIw6RAImoMDOxdC6MhIRp7xpHy260ujjBMwDljHu2kZoPEaj8onqQ
         iYCnsyW21JG9D7gau7FTZJQ+iYzr+JUqElwloOkPphd1O06hk2hqMI1cJrESxGrS+xQ1
         DXtQ==
X-Gm-Message-State: APjAAAXSe4IaPANLCfKNbVV35A1awIHkbvgiy4vIFu+IrSV4Y9UzpCe6
        m/rHEZpLSyk0fv9HMauRQQ==
X-Google-Smtp-Source: APXvYqyHfmwLCplDyz+6+dInHwMcOvxClmJCbq8e8K/CYUKz8lgq4+HHiUv4AYX8rLK+hRTBnAYLsw==
X-Received: by 2002:a62:bd11:: with SMTP id a17mr17941915pff.126.1558596293613;
        Thu, 23 May 2019 00:24:53 -0700 (PDT)
Received: from localhost.localdomain ([111.118.56.180])
        by smtp.gmail.com with ESMTPSA id q5sm32083001pfb.51.2019.05.23.00.24.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 00:24:53 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2] samples: bpf: fix style in bpf_load
Date:   Thu, 23 May 2019 16:24:48 +0900
Message-Id: <20190523072448.25269-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit fixes style problem in samples/bpf/bpf_load.c

Styles that have been changed are:
 - Magic string use of 'DEBUGFS'
 - Useless zero initialization of a global variable
 - Minor style fix with whitespace

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
Changes in v2:
  - Fix string concatenation from build-time to compile-time.

 samples/bpf/bpf_load.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/samples/bpf/bpf_load.c b/samples/bpf/bpf_load.c
index eae7b635343d..1734ade04f7f 100644
--- a/samples/bpf/bpf_load.c
+++ b/samples/bpf/bpf_load.c
@@ -40,7 +40,7 @@ int prog_cnt;
 int prog_array_fd = -1;
 
 struct bpf_map_data map_data[MAX_MAPS];
-int map_data_count = 0;
+int map_data_count;
 
 static int populate_prog_array(const char *event, int prog_fd)
 {
@@ -65,7 +65,7 @@ static int write_kprobe_events(const char *val)
 	else
 		flags = O_WRONLY | O_APPEND;
 
-	fd = open("/sys/kernel/debug/tracing/kprobe_events", flags);
+	fd = open(DEBUGFS "kprobe_events", flags);
 
 	ret = write(fd, val, strlen(val));
 	close(fd);
@@ -490,8 +490,8 @@ static int load_elf_maps_section(struct bpf_map_data *maps, int maps_shndx,
 
 		/* Verify no newer features were requested */
 		if (validate_zero) {
-			addr = (unsigned char*) def + map_sz_copy;
-			end  = (unsigned char*) def + map_sz_elf;
+			addr = (unsigned char *) def + map_sz_copy;
+			end  = (unsigned char *) def + map_sz_elf;
 			for (; addr < end; addr++) {
 				if (*addr != 0) {
 					free(sym);
-- 
2.17.1

