Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB7D8BCC0A
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 18:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404659AbfIXQDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 12:03:45 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:39174 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391683AbfIXQDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 12:03:44 -0400
Received: by mail-io1-f67.google.com with SMTP id a1so5756773ioc.6
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 09:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I9jUqbdYIbBE4dwhsKs4qvKQ+ti2oooQwrMVU8YnBUI=;
        b=JpMJ0TGImCC1ItVY6WQ0/EM8wu1WWa9myRStS9+oXdRuOQjo+K4SodAjDHk0uRqkKq
         zrlcejfYvaFnleJWg4UL0ChY0uKOUa2BTr7I4zQg+Xt5Q/iFwOb7QPuyh2ipUz6Gx+iR
         C5adrufXvqrPp6JvZVxRQTgUoc/A33qXSspdg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I9jUqbdYIbBE4dwhsKs4qvKQ+ti2oooQwrMVU8YnBUI=;
        b=JVan5zV1EsRFOjbLKGYbgHKjKkBsh+utgs4qxje7hXfrMIyO3G0Me8V9/Ai2kglIR2
         IQt3YvJIxirnzrsmJwe1+OKXiLbkT+8TFJORoq8CZ3UOAUuwgSlnly7rDUIPgSufztVH
         nkWxMZSfHDVKkP2EZmo9jPe9yg8+HLFZvtkfJjpW4D2qWps8dvX7xeEsk2Cmz55r67VZ
         Q9Vb3M164MA930Yumgf4a/0ujTJF40/ygKoO+ErXEpyRMJrZVnO3qXWb9xsrU9ctgrGI
         XIDuHHBfLC20CeYIlxmiHlSFdc74hihsuO/AHVN7SEEMtNcLIJTmpRafgeY3y/axOELY
         dgig==
X-Gm-Message-State: APjAAAV1/DigM8SAQclAn7iHGNv/k6ooASTqpm2XQBtMnfR1JKd72c2X
        blO3dZQMJhwpkGrrnyjNIJjItQ==
X-Google-Smtp-Source: APXvYqz5S6BfXdFe3fcM5AWwi16BT694HZWPRmo9VAiQilUd6B6g+F/ieItoygTR3chEVw6UXXWYYA==
X-Received: by 2002:a02:ac82:: with SMTP id x2mr4489306jan.18.1569341023584;
        Tue, 24 Sep 2019 09:03:43 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id r141sm4356434ior.53.2019.09.24.09.03.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Sep 2019 09:03:42 -0700 (PDT)
Subject: Re: Linux 5.4 - bpf test build fails
To:     Cristian Marussi <cristian.marussi@arm.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "skh >> Shuah Khan" <skhan@linuxfoundation.org>
References: <742ecabe-45ce-cf6e-2540-25d6dc23c45f@linuxfoundation.org>
 <1d1bbc01-5cf4-72e6-76b3-754d23366c8f@arm.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <34a9bd63-a251-0b4f-73b6-06b9bbf9d3fa@linuxfoundation.org>
Date:   Tue, 24 Sep 2019 10:03:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1d1bbc01-5cf4-72e6-76b3-754d23366c8f@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/19 9:52 AM, Cristian Marussi wrote:
> Hi Shuah
> 
> On 24/09/2019 16:26, Shuah Khan wrote:
>> Hi Alexei and Daniel,
>>
>> bpf test doesn't build on Linux 5.4 mainline. Do you know what's
>> happening here.
>>
>>
>> make -C tools/testing/selftests/bpf/
> 
> side question, since I'm writing arm64/ tests.
> 
> my "build-testcases" following the KSFT docs are:
> 
> make kselftest
> make TARGETS=arm64 kselftest
> make -C tools/testing/selftests/
> make -C tools/testing/selftests/ INSTALL_PATH=<install-path> install
> make TARGETS=arm64 -C tools/testing/selftests/
> make TARGETS=arm64 -C tools/testing/selftests/ INSTALL_PATH=<install-path> install
> ./kselftest_install.sh <install-path>
> 
> (and related clean targets...)
> 
> but definitely NOT
> 
> make -C tools/testing/selftests/arm64
> 
> (for simplicity....due to the subdirs structure under tools/testing/selftests/arm64/)
> 

Some people like to build their tests using:

make -C tools/testing/selftests/<testdir>

I have been continuing to support it for that reason.

Tests with subdirs can handle this case. Pleas see android and futex
tests.

thanks,
-- Shuah



