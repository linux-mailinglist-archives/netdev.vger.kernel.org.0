Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD4B4EF7FB
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 18:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243350AbiDAQeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 12:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343538AbiDAQcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 12:32:52 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBD029FC6E
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 09:05:29 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id u16so4935797wru.4
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 09:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QYAmnc7x668b3Mtc5NMdeiZF/b7YzgDGFiavTzqx5m8=;
        b=gKgXzErmNosOcaf1AGPsGzv8GmZd6HqtgCK4ZUfUw8idZ7blI8Y7WQjH2J3mF5HmwL
         ODGyazxm7Rj8HWemehlqco3IRPreGlqO7R6WWncb9FrAotpOEalfsaX5nTAt1gJTn51i
         +C+8R4/oktnlOXMq5xwmEmczUlfW5WJdQjoPrMPpsHrwXz/Thnp/pQDyJp+nMwhr24KE
         6MiMO4RULfoMTY3L7ghFpPsysV6kRiWXAL5hOCbkobJ+OBLjV7aLCohQp6d6M6kQJSv2
         U3LoM5V7Ah6xWefm4RBglFaBXWIwhg8NsPs8yKrEu4Qp+fHxT+SqLhoEEuJQ48/VDOzL
         8Mlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QYAmnc7x668b3Mtc5NMdeiZF/b7YzgDGFiavTzqx5m8=;
        b=0MUuoeugDuk8ZY3pcK3ac9S/oi3ARs/lRaoIKuoOgNGVIHkJ6BMXJ7c5fDSIp3lHfh
         bjW5cW5zvU744BWEJ5leNzLXSdsFHlBPju7+l274zDj1e27Pzo6s5sVdC+eaat40XYry
         W4pXKdHoW51V4+JmhF/Dfc0mpMrym26SRmzNLdgntURs79LtDQ5on3OpJQY9xNcDfrEs
         7Ntna9lCpkys8Y/1dVZ7AIddrZ8r6SbIF6iIBBjJlg23zTFWVY3cvvneWuSlHrzlfyaW
         B28RzGxjSRA74v4ryKXjSNNC4zgOHhr2clleFpRoKqBxNphNMWUxXGev6HSFKcrzZlvT
         Y/kQ==
X-Gm-Message-State: AOAM530r5qBWDh6kxbN8Y5SlOOov5wMX1tMz3qxJBuIEk2xuwEBO8TCk
        cs+4K4cUHUKqATUHOa8UC33K1g==
X-Google-Smtp-Source: ABdhPJwVjjkeC6kliJrcb4WvZDn88XBkkBVGgIRYvygMlC4cdKLtHAUut12LgOOv0NPmpfJp/NdnZg==
X-Received: by 2002:a5d:6849:0:b0:204:975:acf1 with SMTP id o9-20020a5d6849000000b002040975acf1mr8253511wrw.557.1648829094934;
        Fri, 01 Apr 2022 09:04:54 -0700 (PDT)
Received: from [192.168.178.8] ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id h3-20020adffd43000000b00205dc8459e5sm2397843wrs.7.2022.04.01.09.04.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 09:04:54 -0700 (PDT)
Message-ID: <f2f8634f-7921-dc7d-e5cb-571ea82f487d@isovalent.com>
Date:   Fri, 1 Apr 2022 17:04:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH bpf-next 1/3] bpf/bpftool: add syscall prog type
Content-Language: en-GB
To:     Milan Landaverde <milan@mdaverde.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        davemarchevsky@fb.com, sdf@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220331154555.422506-1-milan@mdaverde.com>
 <20220331154555.422506-2-milan@mdaverde.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20220331154555.422506-2-milan@mdaverde.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-03-31 11:45 UTC-0400 ~ Milan Landaverde <milan@mdaverde.com>
> In addition to displaying the program type in bpftool prog show
> this enables us to be able to query bpf_prog_type_syscall
> availability through feature probe as well as see
> which helpers are available in those programs (such as
> bpf_sys_bpf and bpf_sys_close)
> 
> Signed-off-by: Milan Landaverde <milan@mdaverde.com>
> ---
>  tools/bpf/bpftool/prog.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> index bc4e05542c2b..8643b37d4e43 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -68,6 +68,7 @@ const char * const prog_type_name[] = {
>  	[BPF_PROG_TYPE_EXT]			= "ext",
>  	[BPF_PROG_TYPE_LSM]			= "lsm",
>  	[BPF_PROG_TYPE_SK_LOOKUP]		= "sk_lookup",
> +	[BPF_PROG_TYPE_SYSCALL]			= "syscall",
>  };
>  
>  const size_t prog_type_name_size = ARRAY_SIZE(prog_type_name);

Reviewed-by: Quentin Monnet <quentin@isovalent.com>

Thanks! This one should have been caught by CI :/. Instead it complains
when you add it. This is because BPF_PROG_TYPE_SYSCALL in the UAPI
header has a comment next to it, and the regex used in
tools/testing/selftests/bpf/test_bpftool_synctypes.py to extract the
program types does not account for it. The fix should be:

------
diff --git a/tools/testing/selftests/bpf/test_bpftool_synctypes.py
b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
index 6bf21e47882a..cd239cbfd80c 100755
--- a/tools/testing/selftests/bpf/test_bpftool_synctypes.py
+++ b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
@@ -180,7 +180,7 @@ class FileExtractor(object):
         @enum_name: name of the enum to parse
         """
         start_marker = re.compile(f'enum {enum_name} {{\n')
-        pattern = re.compile('^\s*(BPF_\w+),?$')
+        pattern = re.compile('^\s*(BPF_\w+),?( /\* .* \*/)?$')
         end_marker = re.compile('^};')
         parser = BlockParser(self.reader)
         parser.search_block(start_marker)
------

I can submit this separately as a patch.

Quentin
