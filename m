Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAFBCAEDDA
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 16:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393452AbfIJOyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 10:54:06 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37796 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730283AbfIJOyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 10:54:06 -0400
Received: by mail-lj1-f194.google.com with SMTP id y5so5957612lji.4
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 07:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nuroSq5xVvvzh+v0qlo9GQuTkiKTTTkV0acBTH9xBxw=;
        b=G8tnCttE8WYXmZymod5Wpj8QXNMnObna74TmAzDI0TZHGg2UXsdPql9W2EqG5PgPF9
         Uj8nmQwOtHqqq+Hb/JwU6u9cBq+XPF1LdT3c9XeY5pJywF1a+6yAjImuknUtqsN3CKDi
         QjyKjEb0eqmMgwbAiJ1zE0I0rGN8wZtMp10w3KHe4QYYVrBZzzPQZzK/oan0gujscL4Q
         gGuiEmCbVllxpW3arvdko3OWVgmL+IHZl3bNByswiNmCSxShzFOZjBsyQHwvdvgAhzdq
         p9EQGSZeykdG0xNtNvEKE0rsHPqIxc0rb6JcgjQk5k5mVq0Zxyp44J+d+BAaQRvMVYth
         8PBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=nuroSq5xVvvzh+v0qlo9GQuTkiKTTTkV0acBTH9xBxw=;
        b=MA3HbO4/FicxglQaCObuR4QUOAkmpNYGh4CpeTYaJywfEqaUKsEJgX/vMrxyl6/1NP
         wExhYww08T3EWXYrWsULhYFMcxHae9JR+3ivj1a17v5wGING1UK3CcPXNuXnleG2mMjD
         kN2kLKgFbyAZGNuh2vWwkI7KnuQUMUvNnA37c1FvMoSvJu7/N3PH8HuTcR73IuR1VuNm
         9uuca3qqulr2uTzUsCuis+NHlNzuMeJFyM7316esHLHoaoz1uIKbAefB9vCLbfS+h92n
         H5hK49oKp8ogrp781PRYLnuKp9qyaIc/XTp+jbp7OqWfTd68P3PWU+ylHNl6uC53uFsu
         Lc1A==
X-Gm-Message-State: APjAAAWVu6lkhxCZxG8rwmLTOSwObspsas9T9AExvKYLsBaRbAXtfNpY
        VTwinLKBFcQ1RzuZK0becmQxWQ==
X-Google-Smtp-Source: APXvYqzoL8vXP4WzF0c3Qvv+WB5KvvkzQvf2Y20elnufkVTtlnsX7iT/hT9XprVDLXcWFsF+OztVLA==
X-Received: by 2002:a2e:9081:: with SMTP id l1mr978301ljg.33.1568127244223;
        Tue, 10 Sep 2019 07:54:04 -0700 (PDT)
Received: from khorivan (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id l9sm3853105ljg.79.2019.09.10.07.54.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 10 Sep 2019 07:54:03 -0700 (PDT)
Date:   Tue, 10 Sep 2019 17:54:01 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH bpf-next 01/11] samples: bpf: makefile: fix HDR_PROBE
 "echo"
Message-ID: <20190910145359.GD3053@khorivan>
Mail-Followup-To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com
References: <20190910103830.20794-1-ivan.khoronzhuk@linaro.org>
 <20190910103830.20794-2-ivan.khoronzhuk@linaro.org>
 <55803f7e-a971-d71a-fcc2-76ae1cf813bf@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <55803f7e-a971-d71a-fcc2-76ae1cf813bf@cogentembedded.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 01:46:48PM +0300, Sergei Shtylyov wrote:
>Hello!
>
>On 10.09.2019 13:38, Ivan Khoronzhuk wrote:
>
>>echo should be replaced on echo -e to handle \n correctly, but instead,
>
>  s/on/with/?
s/echo/printf/ instead of s/echo/echo -e/

printf looks better.

>
>>replace it on printf as some systems can't handle echo -e.
>
>   Likewise?
Like some, better avoid ambiguity, for me it works fine - is not enough.
https://pubs.opengroup.org/onlinepubs/9699919799/utilities/echo.html
 "A string to be written to standard output. If the first operand is
 -n, or if any of the operands contain a <backslash> character, the
 results are implementation-defined"

I can guess its Mac vs Linux, but it does mean nothing if it's defined as
implementation dependent, can be any.

>
>>Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>[...]
>
>MBR, Sergei
>

-- 
Regards,
Ivan Khoronzhuk
