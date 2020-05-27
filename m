Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036311E4B06
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731022AbgE0Qwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbgE0Qwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 12:52:34 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD214C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:52:33 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id c185so113362qke.7
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aWZC0Maintb+XtMLW3kbxb+PUhrl3Mfx+7gwAAUpX9I=;
        b=joIJZL/k8rhWtH4b2U2RlxVdKltXFbP//lk8b8JcJopWNyIbPj1NftDi2RjCwcQWf8
         /MXzsirm5YGhmTHI638Yk9Zqvr/LkuwpGpENFKG1HoYt3WaQWX8dMpqDiAi5x1nlRetl
         9xBJOkRnn3IpYcMMMsA7bN3dJSYlNNcq1Hi16v1Yb9Az+WqS7O3bknW6XBcY5LIP+W5C
         TXgLk9qM0xXyg9JUGYZtk+Py3WtMGiYeiJdoeAtY3cCs2Pa2DZlcyk1wWF5ErKdOSFbI
         F0yEu882NlIdZ1dZK3hN0NlsqAxo8HuKyfGmtwRpeseSme999DKzIQz6ZRpkEO2UCdjI
         2LVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aWZC0Maintb+XtMLW3kbxb+PUhrl3Mfx+7gwAAUpX9I=;
        b=s4yKv1c2Av+a/qrYIvbmd392CN5gQz6WGL8KOf0Unpj6Cj9fRjeRf195/Lzwa5BSO6
         u2kIZ0KdCN6m3Fs3+Hntjr+JehyrPzDAMDrqPaD0tPE/T9cJIMEUsipqofbr4xx9CKZu
         ydSdq2j0uQvMu6lZARKuZgoifOawGjIdIk59UKWSlWOAIr0JQFwUlxNMavB81ItrjWfw
         ev6DleSmrkF7UlCLF/XeC9UBNaZoUF38rGtFki15iTFYSCpti47m4QAAtFqArie5ENKn
         gxkUlAd0QXoUwIjjspcrD44zg32qUwVfE7qv5/Lebo8Y4gSbjzk5T1sKShTxHgye4nT+
         9kAA==
X-Gm-Message-State: AOAM533SwB9OFPKTuziGWLciaR8qyTaT15DJneTcqb0MEthyuFpNVw2c
        DlvmwyP9AZp9xU0gVL3X5xBEKsGYpKk=
X-Google-Smtp-Source: ABdhPJy8y4RDUCm2OxOpdNUnKQJBr0UjfW3ZdVgp2a9LyqhKGdxzFOYt9uygE6NvWA2uIqnCLKXfCg==
X-Received: by 2002:a05:620a:20d6:: with SMTP id f22mr4851465qka.294.1590598352883;
        Wed, 27 May 2020 09:52:32 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:2840:9137:669d:d1e7? ([2601:282:803:7700:2840:9137:669d:d1e7])
        by smtp.googlemail.com with ESMTPSA id q32sm1032332qtf.36.2020.05.27.09.52.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 09:52:29 -0700 (PDT)
Subject: Re: [PATCH v2 net-next] net: add large ecmp group nexthop tests
To:     Stephen Worley <sworley@cumulusnetworks.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, sworley1995@gmail.com
References: <20200527164142.1356955-1-sworley@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fb764e86-501e-22d9-1f6a-3e3ee56c40a3@gmail.com>
Date:   Wed, 27 May 2020 10:52:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200527164142.1356955-1-sworley@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/20 10:41 AM, Stephen Worley wrote:
> Add a couple large ecmp group nexthop selftests to cover
> the remnant fixed by d69100b8eee27c2d60ee52df76e0b80a8d492d34.
> 
> The tests create 100 x32 ecmp groups of ipv4 and ipv6 and then
> dump them. On kernels without the fix, they will fail due
> to data remnant during the dump.
> 
> Signed-off-by: Stephen Worley <sworley@cumulusnetworks.com>
> ---
>  tools/testing/selftests/net/fib_nexthops.sh | 84 ++++++++++++++++++++-
>  1 file changed, 82 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>

Stephen: normally you summarize changes between versions. In this case
you only rebased so the summary would be:

v1
- rebased to top of net-next




