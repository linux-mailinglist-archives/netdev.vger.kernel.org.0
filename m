Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF5231899
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 02:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbfFAAGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 20:06:12 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:42889 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726610AbfFAAGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 20:06:12 -0400
Received: by mail-lf1-f65.google.com with SMTP id y13so9234119lfh.9;
        Fri, 31 May 2019 17:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C+hRwbbBN+m8ROhEdOibU7+RmReDvO/cuFmPkMpA2dU=;
        b=reeFq44AouuCMnc8imHw+1E1EDmQkX6FxcCa8sP9Oa/io932d5gkNeSGUhcu1iC7j4
         tBiOL5ilGIlqktpBgsZ3qvw9r7lsROMcLbxNTtujHF8RKFbRlAuuxjLTTlLdiY5jRCy1
         5h0S0TBw/qhzCyf0MLSM2LxXqK80q19ezXqveH0ZJ2KerO2GJDHVVWwJlPCCJeRE/7s7
         KVjKrmUWhP/advYQ1IIkheCO3Q7ucIE29KDr+O+JMxnJj5H4GgpCQWOC/SmekYexy6x+
         aTWtZpZHyWiLU/UJVfatjwGPXPfQMxykDsgfNmJdoGpugYa51vyPCC+bLmMBrRPnUG54
         mAmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C+hRwbbBN+m8ROhEdOibU7+RmReDvO/cuFmPkMpA2dU=;
        b=Mn2m86e4TfKaWnvh62C0I2IzAoWYTQhuehIAQJBud/aJG5GJainvk8yTvyz/Qv0RZ+
         Zz/SMkQjj5eOMf7CyalqjOyCLB6oeYUd9MGQ0nHfFs2CVeFIAhAMf6gBAabYf9Fw4DIU
         46OXIOa7LRaEncdZkMWDK3x83ykpOfuUTVHwDzQlZ2CZr/gbZtLuTyLREqYDxr4XCUXa
         VKtirE9Ky3QE/TNNPhJtLw77GfRUx3yc1FZS8YeWejYqJxxwDrxC+C6P7CDbhMjcilWJ
         rIZZgX8noLA2SrueRlxGAs8JhHn+Dp/H0FULvAvf9cVQ0gRKLEGAMpSzxjJApJadm/00
         Zoqg==
X-Gm-Message-State: APjAAAU/FORPBfwHb9abUt+k3tivz6vPWOKiZsmbPh3IueFH7/kb35D3
        GZaQWUjcMya93Im7B3A6uSMA/sTLliUpRYiSgb4=
X-Google-Smtp-Source: APXvYqwvZ+6Rr/le388HMh+q2h1+ryUd8bKbiaL1WlnBHuv4rfMxoVDnCrL8LpYCutzN+qUrY5w6SzXWNYuEjCZm+kw=
X-Received: by 2002:ac2:4252:: with SMTP id m18mr7069498lfl.100.1559347569693;
 Fri, 31 May 2019 17:06:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190529183109.17317-1-mrostecki@opensuse.org> <CAPhsuW7KhR1XXDb6Sv54xb1OiLQUC7NH4+uf8_b3tRje7O-YUQ@mail.gmail.com>
In-Reply-To: <CAPhsuW7KhR1XXDb6Sv54xb1OiLQUC7NH4+uf8_b3tRje7O-YUQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 31 May 2019 17:05:58 -0700
Message-ID: <CAADnVQLw_8f8=P7TWxi2PeaWpEhALfSyATZD14WRg+C4g+xxkw@mail.gmail.com>
Subject: Re: [PATCH bpf v4] libbpf: Return btf_fd for load_sk_storage_btf
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Michal Rostecki <mrostecki@opensuse.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 2:34 PM Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Wed, May 29, 2019 at 11:30 AM Michal Rostecki <mrostecki@opensuse.org> wrote:
> >
> > Before this change, function load_sk_storage_btf expected that
> > libbpf__probe_raw_btf was returning a BTF descriptor, but in fact it was
> > returning an information about whether the probe was successful (0 or
> > 1). load_sk_storage_btf was using that value as an argument of the close
> > function, which was resulting in closing stdout and thus terminating the
> > process which called that function.
> >
> > That bug was visible in bpftool. `bpftool feature` subcommand was always
> > exiting too early (because of closed stdout) and it didn't display all
> > requested probes. `bpftool -j feature` or `bpftool -p feature` were not
> > returning a valid json object.
> >
> > This change renames the libbpf__probe_raw_btf function to
> > libbpf__load_raw_btf, which now returns a BTF descriptor, as expected in
> > load_sk_storage_btf.
> >
> > v2:
> > - Fix typo in the commit message.
> >
> > v3:
> > - Simplify BTF descriptor handling in bpf_object__probe_btf_* functions.
> > - Rename libbpf__probe_raw_btf function to libbpf__load_raw_btf and
> > return a BTF descriptor.
> >
> > v4:
> > - Fix typo in the commit message.
> >
> > Fixes: d7c4b3980c18 ("libbpf: detect supported kernel BTF features and sanitize BTF")
> > Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
>
> Acked-by: Song Liu <songliubraving@fb.com>

Applied. Thanks!
