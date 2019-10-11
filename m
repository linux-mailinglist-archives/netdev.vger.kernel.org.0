Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F815D3B8A
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 10:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbfJKIrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 04:47:11 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33832 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbfJKIrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 04:47:11 -0400
Received: by mail-lj1-f193.google.com with SMTP id j19so9041161lja.1
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 01:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R43F48mYqD+CZbcetRaA+1V2MQ8XuiZoYmoUv8JpK8k=;
        b=ezYaY82/J9AEKnbhS0iaVYBnF+7IqOkKDm+TPrFrWWTtSJjSyBf8Q93AdN+YtFFhBX
         C6smQKGHnKGSoBjTqN5gwGE5MJBYB5es2UVUoQ2dlJpJTlbcaXwAwqieGrOP2WIylXJ6
         Nj+d/u2c6DsyEuAVVVZnwhqAQth/MA9zdXcOWfCBdoFVm3hhsQeQuNXxfTi6qh8BBcn2
         wkWFtBXnGRsA7PirHdwJXgRzYIm9y7iCNvfDln2oWXaQfs/RZtH7yfUFRrRJYghdGHIC
         4OevXEhz8ibQf8CKBwBUH4D9+/g9vWubACh2fbMPXg+BwqKzlS7/ilfRRubBnBArhSML
         OXig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R43F48mYqD+CZbcetRaA+1V2MQ8XuiZoYmoUv8JpK8k=;
        b=AcbVIaYkmcSNoNAOBqDcfmFNos/U+MFRIgBJ2eKHP8KA+w7Y6ql3SI9iduIZNkdoSI
         poy2FfJCPmMm6SzfgZhTSsiWwiNG/k+vnqxEtYsI5zBZ8GwqZ+wBBoqUYghAPrvJOJMO
         bgW8J3/8eH8aBGN72jYwlC083UvlAbWFL8jUq0qeLP99qtx6L6ei979iM866gp5SvonE
         dP57cFyxJDnOGbV1xztZd8zux61qR8HD1t3p3+LZM4HzuehpA+N7zUqbCtnARM34amqo
         hICMqAJTIuUFFTQcsxSFeA7jIOnKauQ/n5G1ihxvVnlp1+D3KRR0/FBy1Q+SPGB4DjGb
         fmlg==
X-Gm-Message-State: APjAAAVpPLELLGxBHrIABWGm15A+IXwV+TPpIqwJwoZLpSweoc3f+h8a
        RISanftZYwXLcB+aMpk5klWrSg==
X-Google-Smtp-Source: APXvYqxWcvVB/uUogguw/YCZ0JOD0O65A5qmHRdvHwk9Nz2UGxOUC8CVMn9PB0Xq2xsTTF9B13U+lA==
X-Received: by 2002:a2e:9bc1:: with SMTP id w1mr3267256ljj.136.1570783629230;
        Fri, 11 Oct 2019 01:47:09 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:86c:2e5e:9033:59d0:e194:cd55? ([2a00:1fa0:86c:2e5e:9033:59d0:e194:cd55])
        by smtp.gmail.com with ESMTPSA id u21sm1984557lje.92.2019.10.11.01.47.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 01:47:08 -0700 (PDT)
Subject: Re: [PATCH v5 bpf-next 05/15] samples/bpf: use __LINUX_ARM_ARCH__
 selector for arm
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        ilias.apalodimas@linaro.org
References: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
 <20191011002808.28206-6-ivan.khoronzhuk@linaro.org>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <fa252372-b518-213c-b6f1-60520831e677@cogentembedded.com>
Date:   Fri, 11 Oct 2019 11:46:54 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191011002808.28206-6-ivan.khoronzhuk@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

    Sorry, didn't comment on v4...

On 11.10.2019 3:27, Ivan Khoronzhuk wrote:

> For arm, -D__LINUX_ARM_ARCH__=X is min version used as instruction
> set selector and is absolutely required while parsing some parts of
> headers. It's present in KBUILD_CFLAGS but not in autoconf.h, so let's
> retrieve it from and add to programs cflags. In another case errors

    From where? And it's program's, no?

> like "SMP is not supported" for armv7 and bunch of other errors are
> issued resulting to incorrect final object.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
[...]

MBR, Sergei
