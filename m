Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF1416DC7
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 01:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfEGXM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 19:12:29 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41561 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfEGXM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 19:12:28 -0400
Received: by mail-pg1-f196.google.com with SMTP id z3so5352566pgp.8;
        Tue, 07 May 2019 16:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding:user-agent;
        bh=t+991fJXyuKUQQwkL0XKlpY3wv/FZAEDqC4Kot14BtA=;
        b=DhWdNayWQ0DUYtDPLP/TGT0af+Nm0QhDBmfY67WSbKdeX1UWpHwzh/Q7P+uDYe4EcN
         AkbuklBVS7UoRbi8wyfzD7g/mZEYeFLosQkDS26rr/aI2zw2g2dhfoT8u2ga1oq6CG3G
         TKtXYk0EPormBR8yK1Te15uGGGT+yDZPL3+zy8kQ4K8KMjZ5omfyg6wrBfvYlgpvUA2l
         +W4bL/vkTAUfXn8oy9/L085ZD0NbKoAViQG3CChuyI8xq/EwnTsEyd+HYcE3xN1ZMjpR
         ArniJr6hfneg5BwNq6x3meiQFDuuLrW8rSFNL9S90XBoDKvfyppnnEj1Eqo5ICGDt2Wp
         QhBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=t+991fJXyuKUQQwkL0XKlpY3wv/FZAEDqC4Kot14BtA=;
        b=RABut2IEtidVFgtZDUQ1uLvoFYNNmq+U9RWx/5TCy22YNCtOfNtz0lmkOpqpDaSH/z
         qW7FI1+NUuwI/OfVKeQYHbgiRHEVkjoNX/RePDOntE+1t/VyFFFt19veoYb7EMf2peWQ
         XLd4PImVMIUaHAY5v2AQgUI+mdXUeBRCxKEEibCMmdg6op4Ws26ZGVcc8Mg1wQ2bvfA+
         zXO81ld5+3jMuUngB/VBMb9fwNnDVegYhHjDt0wvs7w14z61dT0E1Uao1zd6UDtlEURI
         iDffYQNV+ajzeQhSzDToc7SmwNXDmuMVfAa5HIlu8b6ofSdchU4Zaafpahg+k/EXx87P
         F7vA==
X-Gm-Message-State: APjAAAXbtwg3T5Hu4qGZRvhcLeCgxWRdvfi+6tpCftj0ba3eXtOpsNuN
        RkhgbvTN1RrfqS74U6j7RBw=
X-Google-Smtp-Source: APXvYqxZav9qC16/BhRJT1Au4atYI1Nu0VhHUa7WgJn7qnTJqapYofDdsZAOgx99FuOgI5WHp/bxxA==
X-Received: by 2002:a63:5c1a:: with SMTP id q26mr31172530pgb.73.1557270747924;
        Tue, 07 May 2019 16:12:27 -0700 (PDT)
Received: from ip-172-31-29-54.us-west-2.compute.internal (ec2-34-219-153-187.us-west-2.compute.amazonaws.com. [34.219.153.187])
        by smtp.gmail.com with ESMTPSA id v14sm18171723pfm.95.2019.05.07.16.12.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 16:12:26 -0700 (PDT)
Date:   Tue, 7 May 2019 23:12:24 +0000
From:   Alakesh Haloi <alakesh.haloi@gmail.com>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/bpf: Fix compile warning in bpf selftest
Message-ID: <20190507231224.GA3787@ip-172-31-29-54.us-west-2.compute.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes the following compile time warning

flow_dissector_load.c: In function ‘detach_program’:
flow_dissector_load.c:55:19: warning: format not a string literal and no format arguments [-Wformat-security]
   error(1, errno, command);
                   ^~~~~~~
Signed-off-by: Alakesh Haloi <alakesh.haloi@gmail.com>
---
 tools/testing/selftests/bpf/flow_dissector_load.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/flow_dissector_load.c b/tools/testing/selftests/bpf/flow_dissector_load.c
index 77cafa66d048..7136ab9ffa73 100644
--- a/tools/testing/selftests/bpf/flow_dissector_load.c
+++ b/tools/testing/selftests/bpf/flow_dissector_load.c
@@ -52,7 +52,7 @@ static void detach_program(void)
 	sprintf(command, "rm -r %s", cfg_pin_path);
 	ret = system(command);
 	if (ret)
-		error(1, errno, command);
+		error(1, errno, "%s", command);
 }
 
 static void parse_opts(int argc, char **argv)
-- 
2.17.1

