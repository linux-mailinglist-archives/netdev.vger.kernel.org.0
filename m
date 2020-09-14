Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1013A268706
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 10:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgINIRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 04:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbgINIQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 04:16:52 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36652C061788
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 01:16:37 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id o5so17586181wrn.13
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 01:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BptE3On/LJmJ4sL9/9Gwb4y6QCQ62szdfp22yq3uqAA=;
        b=fSwjBxxMQb+FPE7hR2DXOkxfG2GO2gkoM/xvE4e8VyMviLoGi+PwZdhJHCH1q/4L+I
         9tQxS6XepRATsPDkpP+fSWekB9O5/hjP0mvkpfVL5sdaj12ihcVuoc5UuV0VyeQWNvHJ
         kThyMDVH7ZYc/83syTg2XH4dHSivMS/HTYG4oQQyDeHxt8/HIQPpZgUT/g0X7LhlkCr8
         tkjHqmcvJ99ab1y2eA53nAfPYjnJe7SojGV2TpgQWU0xMEF4LRwbce8Q/ucwpUZezTZF
         us24d7Gn5XobWjbcCDZCX5Ow9pXmwEdonfu732wHZ+uPFVcE/4ENahsK3fi17O20xHJ4
         aPgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BptE3On/LJmJ4sL9/9Gwb4y6QCQ62szdfp22yq3uqAA=;
        b=ffKOCDDdaZvXFZTyFeR3fQAh/PHKbe/pHK4PCAX0vvmm4BAgYEMG4295lIhtVM/Z3o
         Kpq3kvJarIRsOjNWuIzRwrItfrEs8W49fEoQBNkxDnXJKpdnUAHZs+SULv54OvtsnXH8
         nudYRkcLQ2GEuphxaUF6lZUF6gd/KTZH3w+fhuObPK6Lznr/LZkIdQ6jx+v6hiXc9uhk
         NPukhwGZwHs4A61+pWMgfeKk9Wbg4gF2Fbwj7H6O8rbZMu06sMXe1NV0ZgIZRDdzHcUI
         kSzpoQlgTmUCAW3Ra1WWE/Y9OzuNjRNfSOZ3FZO5CnqFQAq8Pw+vJKL9ssmzwQZ5y92t
         udKw==
X-Gm-Message-State: AOAM533FbrrtkWlDVt/0nFRPcwhm5UIgWbn1BSI1Jx5o5kq+wUg3Yl1f
        WWJ9g7ivzGXcPG8+4SwKfRm7vA==
X-Google-Smtp-Source: ABdhPJyf25RMQLS3r9mkoqt7KU6Xoa6kWey+o2NH6A6zUynRNbiQuiXsDqAzqAmwyKjYMkwFkLft1g==
X-Received: by 2002:adf:ec47:: with SMTP id w7mr15580790wrn.175.1600071395346;
        Mon, 14 Sep 2020 01:16:35 -0700 (PDT)
Received: from [192.168.1.12] ([194.35.119.129])
        by smtp.gmail.com with ESMTPSA id l8sm19445125wrx.22.2020.09.14.01.16.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2020 01:16:34 -0700 (PDT)
Subject: Re: [PATCH bpf-next] bpftool: fix build failure
To:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
References: <20200914061206.2625395-1-yhs@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <b942625c-7140-0a57-337e-3a95020cfa99@isovalent.com>
Date:   Mon, 14 Sep 2020 09:16:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200914061206.2625395-1-yhs@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/09/2020 07:12, Yonghong Song wrote:
> When building bpf selftests like
>   make -C tools/testing/selftests/bpf -j20
> I hit the following errors:
>   ...
>   GEN      /net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-gen.8
>   <stdin>:75: (WARNING/2) Block quote ends without a blank line; unexpected unindent.
>   <stdin>:71: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>   <stdin>:85: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>   <stdin>:57: (WARNING/2) Block quote ends without a blank line; unexpected unindent.
>   <stdin>:66: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>   <stdin>:109: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>   <stdin>:175: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>   <stdin>:273: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>   make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-perf.8] Error 12
>   make[1]: *** Waiting for unfinished jobs....
>   make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-iter.8] Error 12
>   make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-struct_ops.8] Error 12
>   ...
> 
> I am using:
>   -bash-4.4$ rst2man --version
>   rst2man (Docutils 0.11 [repository], Python 2.7.5, on linux2)
>   -bash-4.4$
> 
> Looks like that particular version of rst2man prefers to have a blank line
> after literal blocks. This patch added block lines in related .rst files
> and compilation can then pass.
> 
> Cc: Quentin Monnet <quentin@isovalent.com>
> Fixes: 18841da98100 ("tools: bpftool: Automate generation for "SEE ALSO" sections in man pages")
> Signed-off-by: Yonghong Song <yhs@fb.com>


Hi Yonghong, thanks for the fix! I didn't see those warnings on my
setup. For the record my rst2man version is:

	rst2man (Docutils 0.16 [release], Python 3.8.2, on linux)

Your patch looks good, but instead of having blank lines at the end of
most files, could you please check if the following works?

------

diff --git a/tools/bpf/bpftool/Documentation/Makefile
b/tools/bpf/bpftool/Documentation/Makefile
index 4c9dd1e45244..01b30ed86eac 100644
--- a/tools/bpf/bpftool/Documentation/Makefile
+++ b/tools/bpf/bpftool/Documentation/Makefile
@@ -32,7 +32,7 @@ RST2MAN_OPTS += --verbose

 list_pages = $(sort $(basename $(filter-out $(1),$(MAN8_RST))))
 see_also = $(subst " ",, \
-       "\n" \
+       "\n\n" \
        "SEE ALSO\n" \
        "========\n" \
        "\t**bpf**\ (2),\n" \
