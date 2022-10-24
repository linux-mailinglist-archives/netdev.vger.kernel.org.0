Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B762260983C
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 04:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiJXCcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 22:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiJXCcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 22:32:07 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530A567158
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 19:32:06 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id i3-20020a17090a3d8300b00212cf2e2af9so6843983pjc.1
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 19:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PdtKHqWe9IvOQvbTqczb1g+zPOMcQ6fBQXf4phpRQ5s=;
        b=dHVsvGzDl+Vxn5JdXyBlGeu+vYJejmz4c13K+RBojMp7n43Nt16ITJAhBG9gepXyFo
         Rs6BEa5eZi3I9I1GWatrSLaN3w09eoSOTFwh/YwLyi/fHX91qbP5PhaOBRC8xTinLI7H
         IZ7O8sQXUDHU0FB5Lou8w7OR+Qezs/B1gA3RdwC7pMm9qBcdRHIhqD3xz+2fhkWtQf96
         RID8RTG3uBHxO9DjjbHJtWPm1S0rtFrRTmd113s7gkk9xkrlJpNwI+104jPAVmTnHO8f
         WZgoi1Uxv9IHGGn0OVXIY895BdBwPXX2PfzCRQ0gYH7ruyR4APpERROMeGrv8p+TD8e0
         wpgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PdtKHqWe9IvOQvbTqczb1g+zPOMcQ6fBQXf4phpRQ5s=;
        b=qnU5N1XbfiqMPSmQtqztSG38X0w/HGoyAdY0TBd3iXBjXyikljJ3OupqOLX5Kfk5an
         JOXWHzFmTe188WQ2GUNIDaeh2QSf7vs5DS7jv9CBXZfvvGflU1fUBUi4K2l4vHahe8NQ
         DXW86WU51ydCYjtauPhU/diVgCMAfm/JyT2PTunCK8TFRCvjo3HrsxAtwPjJF0W6vGjB
         NdwYvE0y9R3NMJqyBBk3jSrYQJuMxeJlWwkJQ/zqVSUuQZwLF5DrfHk0bsVfcNNZfhLj
         wKASinmP6c2XnhOnpoo9sZp9+gxMaZwGvuQnRvnAoB4aAHhmqhkJ3BGe8EUj4eCfovSl
         Dc+w==
X-Gm-Message-State: ACrzQf1Ja6TdsDvzdalFMYfU0wVlBoDQaoV8aSS2NkYinmjeFqPY1pfK
        iB655FVbCiZW9qbY1BfHDXE=
X-Google-Smtp-Source: AMsMyM5L0LJxxroqxR+t23aY04Y0mCRQnk95F/tljKGWccdZ2ukkdAM+iqQ4fKXdt6dtciwFGuE5GQ==
X-Received: by 2002:a17:903:2285:b0:185:44df:d911 with SMTP id b5-20020a170903228500b0018544dfd911mr30879393plh.71.1666578725767;
        Sun, 23 Oct 2022 19:32:05 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y18-20020aa79e12000000b0056246403534sm19096890pfq.88.2022.10.23.19.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Oct 2022 19:32:05 -0700 (PDT)
Date:   Mon, 24 Oct 2022 10:32:01 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com
Subject: Re: [PATCH iproute2] testsuite: fix build failure
Message-ID: <Y1X5Ielc+Dcisma9@Laptop-X1>
References: <ae381380067a2db4079bd8880093d8fdb5d9f446.1666539148.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae381380067a2db4079bd8880093d8fdb5d9f446.1666539148.git.aclaudi@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 23, 2022 at 05:37:11PM +0200, Andrea Claudi wrote:
> After commit 6c09257f1bf6 ("rtnetlink: add new function
> rtnl_echo_talk()") "make check" results in:
> 
> $ make check
> 
> make -C testsuite
> make -C iproute2 configure
> make -C testsuite alltests
> make -C tools
>     CC       generate_nlmsg
> /usr/bin/ld: /tmp/cc6YaGBM.o: in function `rtnl_echo_talk':
> libnetlink.c:(.text+0x25bd): undefined reference to `new_json_obj'
> /usr/bin/ld: libnetlink.c:(.text+0x25c7): undefined reference to `open_json_object'
> /usr/bin/ld: libnetlink.c:(.text+0x25e3): undefined reference to `close_json_object'
> /usr/bin/ld: libnetlink.c:(.text+0x25e8): undefined reference to `delete_json_obj'
> collect2: error: ld returned 1 exit status
> make[2]: *** [Makefile:6: generate_nlmsg] Error 1
> make[1]: *** [Makefile:40: generate_nlmsg] Error 2
> make: *** [Makefile:130: check] Error 2
> 
> This is due to json function calls included in libutil and not in
> libnetlink. Fix this adding libutil.a to the tools Makefile, and linking
> against libcap as required by libutil itself.
> 
> Fixes: 6c09257f1bf6 ("rtnetlink: add new function rtnl_echo_talk()")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  testsuite/tools/Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/testsuite/tools/Makefile b/testsuite/tools/Makefile
> index e3e771d7..e0162ccc 100644
> --- a/testsuite/tools/Makefile
> +++ b/testsuite/tools/Makefile
> @@ -2,8 +2,8 @@
>  CFLAGS=
>  include ../../config.mk
>  
> -generate_nlmsg: generate_nlmsg.c ../../lib/libnetlink.c
> -	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) $(EXTRA_CFLAGS) -I../../include -I../../include/uapi -include../../include/uapi/linux/netlink.h -o $@ $^ -lmnl
> +generate_nlmsg: generate_nlmsg.c ../../lib/libnetlink.a ../../lib/libutil.a
> +	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) $(EXTRA_CFLAGS) -I../../include -I../../include/uapi -include../../include/uapi/linux/netlink.h -o $@ $^ -lmnl -lcap
>  
>  clean:
>  	rm -f generate_nlmsg
> -- 
> 2.37.3
> 

Thanks for the fix.

Acked-by: Hangbin Liu <liuhangbin@gmail.com>
