Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC7323F387
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 22:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgHGUFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 16:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgHGUFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 16:05:52 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4EDC061756;
        Fri,  7 Aug 2020 13:05:51 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id i10so1225751ybt.11;
        Fri, 07 Aug 2020 13:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ncbu8GlkrfQWK2n5gVnzismSL3yMTaNqCxTEP8/0epg=;
        b=qxy15ynXpnAPdDS5Fcijz4xkzKbe8NjiPOvFk7Uf+ui4oBF5K55Tc0ewlX4IaigoUT
         mvnGfIL2DSNtNPN7E6t4tkdNn8rJoEQh/1WIRZPf7K2HpluLq3Ov8/MMtz8adsq/rNDF
         y7ekqod4dAGaEvlTqO/SMJWHD+teDOVheam8yHm1H9dLpic3DyLT+DbYGa2dDZfREnup
         9fiePYblB4rMMOJcTdc6dPEGEOEUbhOHk6jd5Ojuj3sI6p7fzjBz/aNLp3hvB2ymOjE+
         wRpiLdHdl5LmEgUSnfkwerWE41RMeAQ9G710gK1CKMi7B9GKX8hQefCng5PBuvzZFJzN
         /4Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ncbu8GlkrfQWK2n5gVnzismSL3yMTaNqCxTEP8/0epg=;
        b=DaEa5323EQKcABS2Zx/P6Lr67DY+SH54XnEp80DwLdf43TZvy6YZu9vxj+0+kqSzvV
         sfoPtoqewhuJaYK0RCkusPPc+2iGpMHW8LZqE8pLpYu5cMlruLrgvGu9yUL5Aw4XvNNS
         W3cWJ4XtAK5OSLSmnj+gmk9TVfoe1JR08AQfUFeHOtDsuFZCNmv1Jk0uRifJF/rW/xs5
         tedf4s6lpC2N4cCo2EyVY50DxTeYb8x6iOO81J/aw9KqjNeVYj0Fh9G2taQ3VLIIUw9l
         mJ3Nkwm82M/UAx73rFeG3//FXweOdoH663RxBAnvZL/yN6c+aAWg/8Zq3dvM4Zh1yzU4
         eEDg==
X-Gm-Message-State: AOAM533JU2Sb5nMjfRuM1S/j2K+a4ZFAQn3eBLdUhWJW1Ace+lS7VFwn
        h08XIa7+Z1lwQCqeRlC7IlVX0Eb0iAmPfNoeqlM=
X-Google-Smtp-Source: ABdhPJyqvSdJ+b/A1NODSqslyyWSfORo1YYQK5Fr9QnNh1dYMb53Gew/ki+d5mlcFFJIGCxMWDbqJpyrfORmo6qulok=
X-Received: by 2002:a25:37c8:: with SMTP id e191mr20087865yba.230.1596830751130;
 Fri, 07 Aug 2020 13:05:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200807094559.571260-1-jolsa@kernel.org> <20200807094559.571260-12-jolsa@kernel.org>
In-Reply-To: <20200807094559.571260-12-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 7 Aug 2020 13:05:40 -0700
Message-ID: <CAEf4BzZdTnyB2jqSfrBYiqc30H+QT5sv_cpogwEScjiRPCr7qA@mail.gmail.com>
Subject: Re: [PATCH v10 bpf-next 11/14] bpf: Update .BTF_ids section in
 btf.rst with sets info
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 7, 2020 at 2:47 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Updating btf.rst doc with info about BTF_SET_START/END macros.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  Documentation/bpf/btf.rst | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>

[...]
