Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1C88C08D
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbfHMS1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:27:06 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36829 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbfHMS1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 14:27:06 -0400
Received: by mail-qk1-f193.google.com with SMTP id d23so5639474qko.3
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 11:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Sww9Wrsj6KP79vUI7zopze9rLndXMZqDqkJW7tIg3g=;
        b=qt3xeYl8g4DcplB+QNDD3BsiozTUWn4onMUx8G6Z80oIeB7jK4sg5mJjx1eQ2b7WIp
         tfA5vEcew+ayjbMkf0aMmZr/uX8LrZ65IultXatmbv13PwAtL3sSuyRN+o/IB0doZ4ko
         +bpOfsPy+25sQWUPaUSGtTwmyZmD4fY9hcu9mAQWHRSslGABPJvGDv5wqkFBze3NtRf+
         BpIjj9RMkwdka+gfEo+jFeR/m0h7vNKZbelnRfI678BIarIN9yoKjH8r8VW01CG+CIRY
         IhmTspJq0MqdAeIGZj7LHf982SP5rePa2gPivDPfclF78/vQhDx1LsBlIirhx4EPlPuD
         NXfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Sww9Wrsj6KP79vUI7zopze9rLndXMZqDqkJW7tIg3g=;
        b=XpQ6j0enL9CaZzFL+qMQqDDGJM46opGjEgWK0JruJkzyOdPFgEpWYMe1JZxlUYuLhl
         +xYBbHOjLgIt8z4xguG3AqjaecgylD7E2YpPfMhFAiZfaMAKBC7JsquNjpgsxCmhWeVu
         fEavUJg+FxlaxkT8RnxyrYnlVX/XhRrUky/l1whxnUF1+U7itn7Casl7HJH9QIKuEVWe
         nyDs/i7u37jfFx8PIfSCE6JmQrnPgTXSvKn55ezREEfBgeMEEQiqTuH8ITbrl93xDKRJ
         9xdF6Lp6nOlGtS2GT87Yn1siF/JhiMlieT6ZoWtqYeFrDPa5H3ZvxMI0NU64r6z5sN6p
         414w==
X-Gm-Message-State: APjAAAVxJl7nrcOciHvjdd0bfGYrrlSj4DjyQKhj16AtCrXsyyj9agh8
        FpRNTuQs8aOVXwcOBB4x6LqHikPACuXlBuu0QLE=
X-Google-Smtp-Source: APXvYqyix0gKTjfklVhsJ9zPuSRr67DZRRIU/EwrYnmRELXOppu81KpkKb6FTKiDoqZhjhzCgEavtb5jF5QPugY8sQM=
X-Received: by 2002:a37:660d:: with SMTP id a13mr35521332qkc.36.1565720825213;
 Tue, 13 Aug 2019 11:27:05 -0700 (PDT)
MIME-Version: 1.0
References: <3FBEC3F8-5C3C-40F9-AF6E-C355D8F62722@fb.com> <20190813122420.GB9349@krava>
 <eb5cf65a-1aa0-fde4-e726-41a736cb7314@iogearbox.net>
In-Reply-To: <eb5cf65a-1aa0-fde4-e726-41a736cb7314@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 13 Aug 2019 11:26:54 -0700
Message-ID: <CAEf4BzYyj=j=EfkD1jtJm=0fDv+3nYJuDpbaaSumkX-fP7A_fg@mail.gmail.com>
Subject: Re: libbpf distro packaging
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jiri Olsa <jolsa@redhat.com>, Julia Kartseva <hex@fb.com>,
        "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Alexei Starovoitov <ast@fb.com>, Yonghong Song <yhs@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 7:14 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 8/13/19 2:24 PM, Jiri Olsa wrote:
> > On Mon, Aug 12, 2019 at 07:04:12PM +0000, Julia Kartseva wrote:
> >> I would like to bring up libbpf publishing discussion started at [1].
> >> The present state of things is that libbpf is built from kernel tree, e.g. [2]
> >> For Debian and [3] for Fedora whereas the better way would be having a
> >> package built from github mirror. The advantages of the latter:
> >> - Consistent, ABI matching versioning across distros
> >> - The mirror has integration tests
> >> - No need in kernel tree to build a package
> >> - Changes can be merged directly to github w/o waiting them to be merged
> >> through bpf-next -> net-next -> main
> >> There is a PR introducing a libbpf.spec which can be used as a starting point: [4]
> >> Any comments regarding the spec itself can be posted there.
> >> In the future it may be used as a source of truth.
> >> Please consider switching libbpf packaging to the github mirror instead
> >> of the kernel tree.
> >> Thanks
> >>
> >> [1] https://lists.iovisor.org/g/iovisor-dev/message/1521
> >> [2] https://packages.debian.org/sid/libbpf4.19
> >> [3] http://rpmfind.net/linux/RPM/fedora/devel/rawhide/x86_64/l/libbpf-5.3.0-0.rc2.git0.1.fc31.x86_64.html
> >> [4] https://github.com/libbpf/libbpf/pull/64
> >
> > hi,
> > Fedora has libbpf as kernel-tools subpackage, so I think
> > we'd need to create new package and deprecate the current
> >
> > but I like the ABI stability by using github .. how's actually
> > the sync (in both directions) with kernel sources going on?
>
> The upstream kernel's tools/lib/bpf/ is always source of truth. Meaning, changes need
> to make it upstream first and they are later synced into the GH stand-alone repo.

As I mentioned in reply to Jiri, kernel's tools/lib/bpf are the source
of truth for the sources of libbpf itself, but Github has some extra
stuff necessary to make libbpf work/build in isolation from kernel.
Plus some administrative stuff (e.g., sync script).

So if this spec is geared towards Github layout and for use with
Github projection of libbpf, maybe it makes more sense to keep it in
Github only? Is that spec going to be useful in kernel sources? Or
will it just create more confusion on why it's there?

Plus it will make it easier to synchronize version bumping/tagging of
new release on Github.

>
> Thanks,
> Daniel
