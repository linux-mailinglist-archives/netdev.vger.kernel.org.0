Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7473318304E
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 13:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgCLMep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 08:34:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40045 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgCLMeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 08:34:44 -0400
Received: by mail-wr1-f66.google.com with SMTP id f3so237253wrw.7
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 05:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d1+fOi0017/unlEfRky84Fb8uQzuaoKlQ5ncEoyZLNg=;
        b=sLkiTauDY8nkqBHDiAH0IFppuclSVlt6BhSU/ydxOesxm5uJ6fXZJQ+M3nh0MJf47E
         byYChFloxzoF7eVuSgVIxYoXIzPV9kfL6uwTuodCQwe0xQeyXlPcVhPk2qlsrBxmDON+
         tlj9eML/KXo9qs8885i7kE7AfOgEQnwvkFik46TcosxGB6Bf/TFjqPIobfq0RTVqvt0I
         xtfWc8oejgDkv9Di6Etb9iQjx5pGdf0GnlvWnh5XVLwBwB71OjHCJTi1cthyOziIARzu
         lsxjizue4QQIeF6Q7KjtEHauI2JGY0mIH+o2dHd9DU1Z0/Ioh3Lw0u+vCwDGzNe1uBlX
         ZKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d1+fOi0017/unlEfRky84Fb8uQzuaoKlQ5ncEoyZLNg=;
        b=EBMAzXtelTjoikGLB343ZjBRvs4OQQeKOBhkSoN8xdvuyCj5zrv7tLacz3YPncMMZO
         YtHIU2aEyWO5bcXs054+HU9q0nMi+JcpzLmp6EeyuxtbP5zzbsoMEOjXMBnDxQFwAfMQ
         q2bRXRPYFJYW05KYbKCvr7QYWZ813cbm7YzFP7CFYkExUlTz92diaaLOMDGkabDV9vwN
         knYlU/qNggDBPpne6xm03I3E1KRMxfR1+jyx+N/K6TkvHSyZbSQN91kkgbi3OR3QBZYF
         sPCzwWQ6+YN4FqSy2djTaDVW0Zfu3rtj1i4OU9tSu+h1w+kklCyFbKPo2LyJCo0ArgqB
         DRog==
X-Gm-Message-State: ANhLgQ3ABsK6lzE2qs9vP1hhp33f93P9kyYmkTtGpyyV1THkuso9u7j6
        LxL5QN7pFYEqCgJO+dzErvNHtg==
X-Google-Smtp-Source: ADFU+vtnj692mseVBwTQCA8hk2Sx6w1iWysC9Ys6Uoh6BVV+6avC2a+FWmlB+k3RKcH9X2kJ150Rfw==
X-Received: by 2002:a5d:5584:: with SMTP id i4mr10415126wrv.378.1584016482318;
        Thu, 12 Mar 2020 05:34:42 -0700 (PDT)
Received: from [192.168.1.10] ([194.35.118.177])
        by smtp.gmail.com with ESMTPSA id w9sm37710557wrn.35.2020.03.12.05.34.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2020 05:34:41 -0700 (PDT)
Subject: Re: [PATCH v2 bpf-next 2/3] bpftool: skeleton should depend on libbpf
From:   Quentin Monnet <quentin@isovalent.com>
To:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     john.fastabend@gmail.com, kernel-team@fb.com, ast@kernel.org,
        daniel@iogearbox.net, arnaldo.melo@gmail.com, jolsa@kernel.org
References: <20200311221844.3089820-1-songliubraving@fb.com>
 <20200311221844.3089820-3-songliubraving@fb.com>
 <bf7fdd9c-f43d-1ef5-dad3-961a4534463c@isovalent.com>
Message-ID: <bed6c51c-9a96-5957-7cd2-38f541e1dd6e@isovalent.com>
Date:   Thu, 12 Mar 2020 12:34:40 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <bf7fdd9c-f43d-1ef5-dad3-961a4534463c@isovalent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-03-12 11:46 UTC+0000 ~ Quentin Monnet <quentin@isovalent.com>
> 2020-03-11 15:18 UTC-0700 ~ Song Liu <songliubraving@fb.com>
>> Add the dependency to libbpf, to fix build errors like:
>>
>>   In file included from skeleton/profiler.bpf.c:5:
>>   .../bpf_helpers.h:5:10: fatal error: 'bpf_helper_defs.h' file not found
>>   #include "bpf_helper_defs.h"
>>            ^~~~~~~~~~~~~~~~~~~
>>   1 error generated.
>>   make: *** [skeleton/profiler.bpf.o] Error 1
>>   make: *** Waiting for unfinished jobs....
>>
>> Fixes: 47c09d6a9f67 ("bpftool: Introduce "prog profile" command")
>> Acked-by: John Fastabend <john.fastabend@gmail.com>
>> Signed-off-by: Song Liu <songliubraving@fb.com>
> 
> Reviewed-by: Quentin Monnet <quentin@isovalent.com>
> 

Sorry, I gave the tag too fast. This one is not solved on my machine,
I still observe the same error when building out of tree, e.g. if I
compile with e.g. "make O=/tmp/foo". This is because make does not
know where to find bpf_helper_defs.h in that case.

I could solve it with the additional diff:

----
diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 45a37e2fb6e6..8b765993598b 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -127,7 +127,7 @@ $(OUTPUT)_bpftool: $(_OBJS) $(LIBBPF)
        $(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(_OBJS) $(LIBS)
 
 skeleton/profiler.bpf.o: skeleton/profiler.bpf.c $(LIBBPF)
-       $(QUIET_CLANG)$(CLANG) -I$(srctree)/tools/lib -g -O2 -target bpf -c $< -o $@
+       $(QUIET_CLANG)$(CLANG) -I$(srctree)/tools/lib -I$(LIBBPF_PATH) -g -O2 -target bpf -c $< -o $@
 
 profiler.skel.h: $(OUTPUT)_bpftool skeleton/profiler.bpf.o
        $(QUIET_GEN)$(OUTPUT)./_bpftool gen skeleton skeleton/profiler.bpf.o > $@
----

tools/testing/selftests/bpf/test_bpftool_build.sh seems happy on my
setup with the above.

Best regards,
Quentin
