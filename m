Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C64F1B5DE9
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 16:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgDWOfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 10:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726458AbgDWOfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 10:35:47 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF2CC08ED7D;
        Thu, 23 Apr 2020 07:35:46 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x17so6379125wrt.5;
        Thu, 23 Apr 2020 07:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=x6IGIVHimLN6wXXRyErAIS+MRNtXI4hH2CwyG6Xff30=;
        b=vf8Ep7drlVFpFPiDnXCutY0TNWGrNo8Xncv2udOcbey1cXFppOGy4CONEDFgH3iI/j
         cPG+bOr+DeXb9D5cEFTkQ/ApdoEGgKqnH0Mfdj3rMaYdt3PTzrGkZrqpN9M0jfx2jxK7
         +JtJBwVUMmkszV9SZkHhv/V3keBtmCQt6INjSdmLaGrUaF71Dfw3ph0q02qvZDqa7xjG
         sDXh9fdNg/3xYeeQ04KaI9+jlD5B2UVwz9eDT4sQKg4gQrQe+CDLnuHIi6e0iploviqL
         CWzqSckSWzdDxZ7qCmtwoLGia8OJL2fNk/KGo7+B6nJnlch+YdQNE9a0nlwCv7DfSFvO
         hMaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=x6IGIVHimLN6wXXRyErAIS+MRNtXI4hH2CwyG6Xff30=;
        b=VJKUBldEpK7IztpBN9wQt9kMjggaRpf8ru5RlxCEUfm9z3hGzp7vTyAvfxiS+ya0tD
         4TjqcagQiWsBopD0tuv+4117VOz6bNqIfrvgKL5y3B/lA6Ah+zgNueb35YOtgjZ0pGLq
         gaBNf5Ewo5d8blwGkS5xNt+oT2niUQd8TzfB50fUfiKnT76BDAAiJTrNBr6E3aSMbGOj
         7F9arKNjQQpjKz86QJ/EmpAlK3vnrWoZfJstComeZJKGBcYQP+EhWro/Slnout22bdgE
         0CCTsYqtqcoR3niUelLzmUAsPz5xpXsRPyTXECL2Xyct2+YkFAX/1lHWt77JNISOsiMp
         nqEA==
X-Gm-Message-State: AGi0PuarU7ABaCOFnfIPPd6AhoQ4PYiO0U5kQxq6jDHlPjGHr27HMCl+
        WSHV3gyUq6xWP9ifiEJZvxxOoUCufgOGbQ==
X-Google-Smtp-Source: APiQypLIUH9cLSTf94KBbNXeLc8HmzzTpjl+Y2L4JZrTFpsXOzsPlyUs45ikzIJWhNEC7Yfw6+4rqg==
X-Received: by 2002:adf:eecc:: with SMTP id a12mr5225266wrp.112.1587652544894;
        Thu, 23 Apr 2020 07:35:44 -0700 (PDT)
Received: from net.saheed (563BD1A4.dsl.pool.telekom.hu. [86.59.209.164])
        by smtp.gmail.com with ESMTPSA id c20sm4420321wmd.36.2020.04.23.07.35.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 07:35:44 -0700 (PDT)
Subject: Re: [PATCH] docs: Fix WARNING - Title underline too short
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Stephen Kitt <steve@sk2.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Eric Biggers <ebiggers@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20200423114517.18074-1-refactormyself@users.noreply.github.com>
 <20200423070230.3fd863ba@lwn.net>
From:   Saheed Bolarinwa <refactormyself@gmail.com>
Message-ID: <41072c85-7157-a3b8-17b5-9b4ab38f14ca@gmail.com>
Date:   Thu, 23 Apr 2020 15:35:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200423070230.3fd863ba@lwn.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/23/20 3:02 PM, Jonathan Corbet wrote:
> On Thu, 23 Apr 2020 13:45:17 +0200
> Bolarinwa Olayemi Saheed <refactormyself@gmail.com> wrote:
>
>> From: Bolarinwa Olayemi Saheed <refactormyself@gmail.com>
>>
>> There were two instances of "Title underline too short" and they were
>> increased to match the title text.
>>
>> Signed-off-by: Bolarinwa Olayemi Saheed <refactormyself@gmail.com>
>> ---
>>   Documentation/admin-guide/sysctl/kernel.rst | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
> These warnings are caused by a patch entering linux-next via the -mm tree;
> Randy has already sent a patch to fix them.
>
> [Next time you might want to examine the recipient list a bit; this patch
> was broadcast a bit more widely than was really necessary.]
>
>

Noted, sorry about that.

Thank you.

Saheed

