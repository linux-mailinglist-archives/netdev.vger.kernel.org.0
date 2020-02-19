Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6F55163AAF
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbgBSDDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:03:05 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42100 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728202AbgBSDDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 22:03:05 -0500
Received: by mail-lj1-f196.google.com with SMTP id d10so25405036ljl.9;
        Tue, 18 Feb 2020 19:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7wV059MxZJL/ceXzJdSzbWhMkKat8X1C7CgUxvhC/Fs=;
        b=PKNhjIBs6bvXetw2vIHXvTsf3L5yW59GXkcSVok4M/uU2jBYLgZexysQZkbBtOlWAn
         hkSwVsB6durXBAeziSw5lmgLLR12XHSqrfQ5TqvMS66rdkUxRz1T6eXc11RynMpCK59n
         cJkvJOoodL9Enc6a/92XE2LAG8Vwuwi2f/bkfGx0d7CSYsbRajkcxoqdWqw3YGxT6Xsy
         le4BR7c0aEHEYSl2xelPy2iRFBEHWwsg6Vg3CWX+QYRgNcQMkjPTpc31ZNl5N+iRoXDL
         CWioCtrHVMHt3S1sq2sCCLlDRKSRNMBTgRTcUUM39p4Cjc8dkI54ZClZtkbvFiSHcz3F
         a6VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7wV059MxZJL/ceXzJdSzbWhMkKat8X1C7CgUxvhC/Fs=;
        b=d+NFftlbFSCL5r2AE0Y0FUpoQl6agmUvnrdbIJsSP2eztrnN69LDlVw/QzdGwQpm27
         OtWphXRAaj1Iwb66ZpJApW4/fED58wd4Xnh1XWzUDfvOrKxcNAhuW6weXl6LjZtepN/f
         gjYtDXi2qEpSnUXytBLIESGMshj1/BvWOsZBBQ0SERdhMaDB9W/ewupVFe0YflLIEHSA
         BBJMUFUpn/RIYuTAJzb0dK2wPmePCw6TrQjNgNszFSAmuFhrgoiNmZcwUjQ1zDmP4FLM
         BblM58igcW8RZyTqlKkhW2liVn6rzA4QUY8OSDj01ZlAHxeHlN/EvHimDDMP0OiOJCOb
         dBYg==
X-Gm-Message-State: APjAAAUazwtX+BFY8dVyjXF3049zDqPF3QYkC6qYNkCI3UQYe8AnK5fH
        YsH4VuGVMbe5aM01VITM0cOHmHEKQTGagC0Ijk1YGA==
X-Google-Smtp-Source: APXvYqxwmc9iUV03II2uPqdKueW1KryDeg2UkbKuQpAQnmh0IThI3w3k66upIYSWld8XP8vU0N5CZgxMyIxFT+W5fOM=
X-Received: by 2002:a2e:a404:: with SMTP id p4mr15029723ljn.234.1582081382464;
 Tue, 18 Feb 2020 19:03:02 -0800 (PST)
MIME-Version: 1.0
References: <20200218190224.22508-1-mrostecki@opensuse.org>
In-Reply-To: <20200218190224.22508-1-mrostecki@opensuse.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 18 Feb 2020 19:02:49 -0800
Message-ID: <CAADnVQJm_tvMGjhHyVn66feA3rHLSXTdzqCCABu+9tKer89LVA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/6] bpftool: Allow to select sections and filter probes
To:     Michal Rostecki <mrostecki@opensuse.org>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 11:02 AM Michal Rostecki <mrostecki@opensuse.org> wrote:
>
> This patch series extend the "bpftool feature" subcommand with the
> new positional arguments:
>
> - "section", which allows to select a specific section of probes (i.e.
>   "system_config", "program_types", "map_types");
> - "filter_in", which allows to select only probes which matches the
>   given regex pattern;
> - "filter_out", which allows to filter out probes which do not match the
>   given regex pattern.
>
> The main motivation behind those changes is ability the fact that some
> probes (for example those related to "trace" or "write_user" helpers)
> emit dmesg messages which might be confusing for people who are running
> on production environments. For details see the Cilium issue[0].
>
> [0] https://github.com/cilium/cilium/issues/10048

The motivation is clear, but I think the users shouldn't be made
aware of such implementation details. I think instead of filter_in/out
it's better to do 'full or safe' mode of probing.
By default it can do all the probing that doesn't cause
extra dmesgs and in 'full' mode it can probe everything.
