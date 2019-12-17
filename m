Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09E40123A53
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 23:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfLQWzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 17:55:01 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43804 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfLQWzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 17:55:01 -0500
Received: by mail-qk1-f196.google.com with SMTP id t129so3558840qke.10;
        Tue, 17 Dec 2019 14:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lL57QSrlVk6cTiuQk1HyrMwEZXGqqzlZkbf62cArXG8=;
        b=duhypgM2wbfhjfjJ8u/CWYeg7aeo9kuoXNsKUoqufgbHkJsHV3sEyAplCgbBtmMh5E
         e0iN2A0CpJarxhFI9GNWefXJvOooWeXy49erbELcpNkR6o9s3eKOpDibjey+p3GTu2xX
         ojOI5lGdOY1UgnoiDVM0566mjrzXJB2vXaTagEuxJ5PpLBRauNzo562aIiP31sUbMEBD
         S2/HOPqlPwrDpW1G30zbinK3B0aNUWDnfVcYJVZ9If9pERI7hladXyxVE5rggJ4jNUR+
         e89Pjy8Swx/oSi3Gx/LNw0EIzV/Tt0M5cJNVVAKXD1RvRXainPMc63ppL3/Xe9/b6Ai9
         OY/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lL57QSrlVk6cTiuQk1HyrMwEZXGqqzlZkbf62cArXG8=;
        b=dt8QFLsIrYda4evEDguUda2nssr2sq3x1iCUKtaU0lZgT9MpqCZFM/z8S4AVOc4ETr
         4f+GpLlCdHncNwkl//ypSJ/I3CxrS2lOS8N3cVPpoLKq4BcDQyGUTzGG3WPZCxcLcVIZ
         DQUof7SxqhbCiLNbNoWEN4/J35Y0HAQzSuUdukrPPTgmbD/7tWhKUtI09BURjZg4Y6ru
         a72XDitNbivMsazFChKsyH+bjbgMmWH99EpGOjPcnYoltzMa8ep5uamQy+zNimZerSzs
         lF4xajm0XqAun5b/+OGwnJX3l71E6R7dOQAebCXMMso943GeOszj1x0D5uBSl+Y1wiIz
         NLjg==
X-Gm-Message-State: APjAAAWVMtRDDpEg5FI1vnjjV+/hr4foEQkhap2eunqQ2/UbcKopurnc
        wzV18ZIH4+M3fkNIWY18212zGtLYYrhJgldvUbU=
X-Google-Smtp-Source: APXvYqz/Bbg2IWpdBgB9n4mvSGL9+o8c/n1VbYAWPcaG7k4lkW3WYaVAcZSu+O/FZTY0WCDvXpdG8DRZCu8scLMniHU=
X-Received: by 2002:ae9:e809:: with SMTP id a9mr498634qkg.92.1576623300502;
 Tue, 17 Dec 2019 14:55:00 -0800 (PST)
MIME-Version: 1.0
References: <20191217053626.2158870-1-andriin@fb.com> <20191217053626.2158870-4-andriin@fb.com>
 <a722caf8-a4af-4476-d560-396dd30dfb0a@fb.com>
In-Reply-To: <a722caf8-a4af-4476-d560-396dd30dfb0a@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Dec 2019 14:54:49 -0800
Message-ID: <CAEf4BzZa9Pp+ibccmn--jEY95LdOs2UZ1AJoQ9x51FjNGsVAiA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] bpftool: add gen subcommand manpage
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 1:27 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 12/16/19 9:36 PM, Andrii Nakryiko wrote:
> > Add bpftool-gen.rst describing skeleton on the high level. Also include
> > a small, but complete, example BPF app (BPF side, userspace side, generated
> > skeleton) in example section to demonstrate skeleton API and its usage.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> When applying the patch locally (git apply <>), I see below:
> -bash-4.4$ git apply ~/p3.txt
> /home/yhs/p3.txt:183: trailing whitespace.
>
> /home/yhs/p3.txt:187: trailing whitespace.
>
> /home/yhs/p3.txt:189: space before tab in indent.
>          __uint(type, BPF_MAP_TYPE_HASH);
> /home/yhs/p3.txt:190: space before tab in indent.
>          __uint(max_entries, 128);
> /home/yhs/p3.txt:191: space before tab in indent.
>          __type(key, int);
> warning: squelched 77 whitespace errors
> warning: 82 lines add whitespace errors.
> -bash-4.4$
>
> space before tab might be fine since it is an code in the example file.
> But tailing whitespaces probably should be fixed.

I assumed that indentation in ReST's literal block has to be specified
for all lines, including the empty ones. But seems like
bpftool-btf.rst doesn't do that, and playing with some online editors
indicates it's not necessary to indent empty lines to preserve all the
code as single code block, so I'm going to remove them.

>
> With the above in mind,
>
> Acked-by: Yonghong Song <yhs@fb.com>
