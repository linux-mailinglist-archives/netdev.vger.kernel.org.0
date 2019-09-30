Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 662E4C2AD7
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 01:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732407AbfI3X1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 19:27:45 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35049 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730573AbfI3X1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 19:27:45 -0400
Received: by mail-qt1-f194.google.com with SMTP id m15so19329746qtq.2;
        Mon, 30 Sep 2019 16:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WBjX7fi2WxuX+n58YgHhFAjpesnxSu+QXb3g58laqeA=;
        b=GYReL0fgDWBUpU0vnkdlGf1d9mNOJara6wwSieqzTv63tBZhIYUYLou9XYuh0kkmq9
         O7Cp0ngAWhcb7nZSR9dA5SLWWTFAwAUwXc1gE2CFhPPtiWIRtcgGcOoPPNt90Rppqu5n
         /qJ0p07gU1lpLOrtsdHKGdseQ+HqeOnAY/A0RUQexfJL8NgIZyuLi9uZ9i8GLWR8/fWB
         9Ae9b0Pl95N60IcEZ45m0MsFFSxF1ZtDcITgRbVINWeuYz42Sa449fdOl/5Jx7eZADOY
         Z/IeMw2sr6VbPSYh2rykIsxCttdfOY+5w0CXFLGTH3TQ1FFNC7+7bC8fsj5t7GTh0jgu
         /Bcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WBjX7fi2WxuX+n58YgHhFAjpesnxSu+QXb3g58laqeA=;
        b=jI9FxQQ4bZuM4y5JU9CxszhIrhxYAL660B90Oz4kyh8gRpiQ2zPgGOC2sq3eBkpAm0
         +FiNFz9fxdFejFawzId29Egdg+VYk2kp8fZrUBUtxTTogHYfbTnV/OL0x95e8SPbs2ci
         yiykcq7raqOIVwRZgze/rz0nhrLi0jQZbtW2tRT/7Kfl1eWoWiLYQIDKF9VgBEf/L8kd
         bqy/2qY4kmaSsO9T7kAFIu7XhuSua+TWj+uagTXRsJdTszXpSUniA5QLYMtcOdbu4hvH
         0Ljm3RPCy4K+a7REHIx5vwTU8lj9bi6YQfqn970N6sb1F9aKXnFhdinfmNxgf2yn71yV
         aHGQ==
X-Gm-Message-State: APjAAAVSof30hR7Ak6pRZXLLd7kli/bs/SNLNmVg8utDB0KN4UlV3cFo
        XveH9sLj8lrGvgYl+TaR4dl6ZuWGFccFca4+I10=
X-Google-Smtp-Source: APXvYqz6CFpsxt6SLgwYLAI5R5CRlXz2DLa23SQ51D5qAtfROgv6AOo3GCM6GJGgTL7H7ktXuCPFpJAjYeYnt3OrZN8=
X-Received: by 2002:ac8:c01:: with SMTP id k1mr27139590qti.59.1569886062718;
 Mon, 30 Sep 2019 16:27:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190930185855.4115372-1-andriin@fb.com> <20190930185855.4115372-3-andriin@fb.com>
 <CAPhsuW6RHaPceOWdqmL1w_rwz8dqq4CrfY43Gg7qVK0w1rA29w@mail.gmail.com>
 <CAEf4BzaPdA+egnSKveZ_dE=hTU5ZAsOFSRpkBjmEpPsZLM=Y=Q@mail.gmail.com> <42BABFEC-9405-45EC-8007-E5E48633CDBC@fb.com>
In-Reply-To: <42BABFEC-9405-45EC-8007-E5E48633CDBC@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Sep 2019 16:27:31 -0700
Message-ID: <CAEf4BzbaSJ_-9fWWLyaHGHaMhVD_49UTpJQ6Kr4FTYotCupXwQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h
 into libbpf
To:     Song Liu <songliubraving@fb.com>
Cc:     Song Liu <liu.song.a23@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 4:23 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Sep 30, 2019, at 3:58 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Sep 30, 2019 at 3:55 PM Song Liu <liu.song.a23@gmail.com> wrote:
> >>
> >> On Mon, Sep 30, 2019 at 1:43 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >>>
> >>> Make bpf_helpers.h and bpf_endian.h official part of libbpf. Ensure they
> >>> are installed along the other libbpf headers.
> >>>
> >>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >>
> >> Can we merge/rearrange 2/6 and 3/6, so they is a git-rename instead of
> >> many +++ and ---?
> >
> > I arranged them that way because of Github sync. We don't sync
> > selftests/bpf changes to Github, and it causes more churn if commits
> > have a mix of libbpf and selftests changes.
>
> Aha, I missed this point.
>
> > I didn't modify bpf_helpers.h/bpf_endian.h between those patches, so
> > don't worry about reviewing contents ;)
>
> Well, we need to be careful here. As headers in a library should be
> more stable than headers shipped with the code.
>
> Here, I am a little concerned with the fact that we added BPF_CORE_READ()
> to libbpf, and then changed its syntax. This is within one release, so
> it is mostly OK.

Well, I could bundle bpf_helpers move and fixing up selftests in one
commit, but I think it just makes commit unnecessarily big and
convoluted. BPF_CORE_READ in previous form was ever only used by
selftests, so it was never "released" per se, so it seems fine to do
it this way, but let me know if you disagree.

>
> Thanks,
> Song
>
