Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C78AEFCEF
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 17:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbfD3Pca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 11:32:30 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43343 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfD3Pca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 11:32:30 -0400
Received: by mail-io1-f68.google.com with SMTP id v9so12549278iol.10;
        Tue, 30 Apr 2019 08:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eLDkIzsjwVQgbRC7hgZ0h0+iaew69eR0WaFa0IuIgHI=;
        b=hRtgRrlyIelgvhFNOI3jzwsUduYkDSpXDvvJNCsiXS37slSQBuyFbJIXVAzzezQwoe
         vSLw2KoHVQ2hIQFv+hO7VSFcq1TngAeVx7D6uZT61ugu38b2GLOiZD7RoCYJXCMPBULN
         8qp2lwNg4S6CxH4x1ghngAdYG4trUFuYGugdUWbqc3mSEJtF3nTrST0+AKv7+70GEa4P
         BPulojiGzx0WUOwltTk5MQGuTQ6G+KDYkWyfIRpkDDxUwjnAQar7FVau1l6j9huGWzlP
         2MUxVPlwIZbrgUjwryi/AUCDFOyxUzux+wNyXKOgCJzISLkmhAiVZrX1Sg/9KvrMKc9D
         rdNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eLDkIzsjwVQgbRC7hgZ0h0+iaew69eR0WaFa0IuIgHI=;
        b=qQU9IbxU6fQVjjk2EmUkVcAlYVxqFKzy4+fSwcRYNHnJFrjxPaQzP9mSdI9rjNV/8+
         TTgt5isG3rGZ811HIIURm8lZh4b481kJqWNcIaPSnsS+4lYeN5l9h3pD3YEuWxCws/Bp
         6YsDTJh5A4+OSKjbyz3s+TYL33dVSBZ6jKYlb68yeB3gMVsCk0ig6QzgybMgJGQxYl0r
         2+Pwnct4PFeYfHM4Keqnin7c1/qbq2bVbGMQcJq7nWsRJJ5DsxSt0gwZqeGXDhYup5Aq
         RlST78DmklfK41tgJDDVQhis+85ofUw4oWy6Kw1wy0nZ/J7p93oS85yLrsQmDK9eZG8w
         P+kw==
X-Gm-Message-State: APjAAAU3tjzwFRKo8wfvxg6ny2oi3WQW+u0fXwsGnDDM/rFuvfwlFxa5
        UMhfu/mcnGwx/626hzn72+6s6LZFM8EqVy/taIM=
X-Google-Smtp-Source: APXvYqxZxd67mzubF8J7mV7rZHgkn6QdXB7OQoA7KdRYdejNsgsbTuO9J229qcDwNBfaq3ZXHL2iza+FbKIO6dWLGXg=
X-Received: by 2002:a6b:5910:: with SMTP id n16mr20021252iob.140.1556638349154;
 Tue, 30 Apr 2019 08:32:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190429095227.9745-1-quentin.monnet@netronome.com>
 <20190429095227.9745-2-quentin.monnet@netronome.com> <CAH3MdRUQn=ycpcDLbLxGAZwGhnVMoD-avPPcSCopAtwof4czNw@mail.gmail.com>
 <d4f761c3-d133-4f89-44c2-a96c7f917571@netronome.com>
In-Reply-To: <d4f761c3-d133-4f89-44c2-a96c7f917571@netronome.com>
From:   Y Song <ys114321@gmail.com>
Date:   Tue, 30 Apr 2019 08:31:53 -0700
Message-ID: <CAH3MdRXFBsBdrmTc36yBs0Y0wcz4tOk-cBY4q6_s9bmtdnctyA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/6] tools: bpftool: add --log-libbpf option to
 get debug info from libbpf
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 30, 2019 at 2:34 AM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> Hi Yonghong,
>
> 2019-04-29 16:32 UTC-0700 ~ Y Song <ys114321@gmail.com>
> > On Mon, Apr 29, 2019 at 2:53 AM Quentin Monnet
> > <quentin.monnet@netronome.com> wrote:
> >>
> >> libbpf has three levels of priority for output: warn, info, debug. By
> >> default, debug output is not printed to stderr.
> >>
> >> Add a new "--log-libbpf LOG_LEVEL" option to bpftool to provide more
> >> flexibility on the log level for libbpf. LOG_LEVEL is a comma-separated
> >> list of levels of log to print ("warn", "info", "debug"). The value
> >> corresponding to the default behaviour would be "warn,info".
> >
> > Do you think option like "warn,debug" will be useful for bpftool users?
> > Maybe at bpftool level, we could allow user only to supply minimum level
> > for log output, e.g., "info" will output "warn,info"?
> I've been pondering this, too. Since we allow to combine all levels for
> the verifier logs it feels a bit odd to be less flexible for libbpf. And
> we could imagine a user who wants verifier logs (so libbpf "debug") but
> prefers to limit libbpf output (so no "info")... Although I admit this
> might be a bit far-fetched.
>
> I can resend a version with the option taking only the minimal log
> level, as you describe, if you think this is best.

Thanks, I think providing a single minimum level for output probably
better.

Yonghong

>
> Quentin
>
> >
> >>
> >> Internally, we simply use the function provided by libbpf to replace the
> >> default printing function by one that prints logs for all required
> >> levels.
> >>
> >> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
> >> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
