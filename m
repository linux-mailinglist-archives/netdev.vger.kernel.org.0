Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97E6E46CFD
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 01:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfFNXnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 19:43:53 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:35058 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfFNXnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 19:43:53 -0400
Received: by mail-qk1-f193.google.com with SMTP id l128so2812368qke.2;
        Fri, 14 Jun 2019 16:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xJP8PPoAP8r7kaAAybEx4rwl+7jp0GqNz9cJuvREu4w=;
        b=cy1l53EEUjQ96xI4ecZzikc8ifXIMJLymjZcR3ktedrmxZhXSpT7Ssn7fNIqn3jmkU
         vpKkRw3MNnmmPyFPUENbWQPjZmrTrzXtGTVNdc7gTum9zvFdq+luRc+vNWb/F9jhBakD
         N3Mrw9DYzE5eH5bXlTbd36nrHLq4HMZEl+aLuHrCazFBm9ejHqlBpgANPZoiosmdPxKk
         04DlwPYO2Nb2gGAyOfGBce4fozQcnNB39X5zBgV8b8Uc1EsxXAijB1YoRcARDid8n4/J
         xjqwKQQx37SciDVkFcJQh4IU3g6CDf4OIZaO68AAgVZq70HvOsT0d7XTK7zEBOegQAjS
         jINw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xJP8PPoAP8r7kaAAybEx4rwl+7jp0GqNz9cJuvREu4w=;
        b=c5nInkQ+paCj2xxb99kloSbHVEwb5fFOvBoAMMTjbWPGDtMoP1PVFtRkkj4Yblz9XT
         2/2wIu+qBc9chfCOEuxFdJ4KYM2T3RzG93/IUrORPG4UArzuxEEXO63E9GwTktnIcG97
         vbWnimqrhcy9YER5gVPwMw4PMyBEt4aM3AQIUyWbmKLlwkC2vWMIpS/ZaZPYNRU51Fop
         ohh+hK2UZT9I7CIBr1MZ7o3KI9OhZ1PGNw1go4vIkcUyJhJ/K5dT/RAoll1DufSTyO8y
         8jA60tRJz1ZxBvLNqy/KVuHENm0FXQ5TnvMue2l0IwsSdzsCrioYCVn7W7vqJJVfOc5t
         qpBw==
X-Gm-Message-State: APjAAAUaVFB3wqIBTe1mh7tmaN99MvA+BCanJhXyFzitBaiEzXnRdhnS
        LRjEbpqGSFQoPtuHQXAKav3k8Pzx7jfSS0zbKy7JLZW+
X-Google-Smtp-Source: APXvYqwCN6MxhnCE5U+1nP/fXMYZShHoZGYTNsYWOWMEbc/6mjZynOFpout8lY0zthY8aVmk9UdFSy4tEIiDQI/BSTk=
X-Received: by 2002:a05:620a:14a8:: with SMTP id x8mr22990751qkj.35.1560555832116;
 Fri, 14 Jun 2019 16:43:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190611044747.44839-1-andriin@fb.com> <20190611044747.44839-9-andriin@fb.com>
 <20190614232329.GF9636@mini-arch>
In-Reply-To: <20190614232329.GF9636@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 14 Jun 2019 16:43:41 -0700
Message-ID: <CAEf4BzZ5itJ+toa-3Bm3yNxP=CyvNm=CZ5Dg+=nhU=p4CSu=+g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 8/8] selftests/bpf: switch tests to BTF-defined
 map definitions
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 4:23 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 06/10, Andrii Nakryiko wrote:
> > Switch test map definition to new BTF-defined format.
> Reiterating my concerns on non-RFC version:
>
> Pretty please, let's not convert everything at once. Let's start
> with stuff that explicitly depends on BTF (spinlocks?).

How about this approach. I can split last commit into two. One
converting all the stuff that needs BTF (spinlocks, etc). Another part
- everything else. If it's so important for your use case, you'll be
able to just back out my last commit. Or we just don't land last
commit.

>
> One good argument (aside from the one that we'd like to be able to
> run tests internally without BTF for a while): libbpf doesn't
> have any tests as far as I'm aware. If we don't have 'legacy' maps in the
> selftests, libbpf may bit rot.

I left few legacy maps exactly for that reason. See progs/test_btf_*.c.

>
> (Andrii, feel free to ignore, since we've already discussed that)
>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---


<snip>
