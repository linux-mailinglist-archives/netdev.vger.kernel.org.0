Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00A75ABEA0
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 19:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395178AbfIFRXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 13:23:05 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45891 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729928AbfIFRXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 13:23:05 -0400
Received: by mail-lj1-f196.google.com with SMTP id l1so6680479lji.12;
        Fri, 06 Sep 2019 10:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nn6TPGTw/Cq8S+I4wR0SeuE0g0BvA7xFJW8E5r8GuMI=;
        b=KV8oU3wTBVeUfjUO9qrWp30S0Cbuz71e5CDH4Mz+R19ArQ9CyYn4xrZhlo93H73waZ
         p7rG9w74vhh/7F5gUK4PIZLxqdC8n4rtSa3dgTIyLuVHG3cWQcIU3uWtMn9Iv+hoVJEs
         zMTPTti/x/+2IQIcUuijyicADVdHwUvkODI/gcYNRMnjoWLmBUw8kbxgFdBci/+Gqegn
         sC5HjQy2FB0SuJ0msK66rk+e3HKzi4QvbPtbOcTt4AcLVeobky0zSyBocojL8AAYE/xg
         Iswyc+jl3ndFJTHYDt4yzxlo5/DQt3xplVaXQt3j0b+egjCdwEIieEUDlxTAOAJWl+MO
         zd0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nn6TPGTw/Cq8S+I4wR0SeuE0g0BvA7xFJW8E5r8GuMI=;
        b=uaH5t7zXjY5iDAwbaAlNkDxBLEdJ8fvbCN7xTeYO+qdJWwcdyUT+NkyLP+LAmKR9C9
         D02kuRrAlzJ0jd1I/ZILIvVvm0vDFYi7dfUYP/w2IgKn5mMN8k/rMSWxdO0Q/zlK8txC
         13gG6j0ZX7xIXHC3KAJGRxMsSJbvg5l6eMfUoFtCTVv6vjWdf+o/y3ZC4z86gt+NIdMB
         ltNVXgduOTcvvSNRQ8hny5b8aTKhJ7NBxruZ8/NXpV7sWlV/2wUXfX5YHKmzEgNRAQzM
         JXu3A4K5PgnVkPUcMhXNorz+MSFSf2+Px/bcdf9lBNB16bFSMcPS67kxaw/pG4Tsfrkt
         gHPg==
X-Gm-Message-State: APjAAAXCi7FJ7J76PpZI4d0ic5hvJCeWII+KbASig6Axc4CHTxRrZTY/
        D1+KGjMkSqbKZ0irPkaS0xI6Zp5AkcsfmZ2CBqU=
X-Google-Smtp-Source: APXvYqxQheupr1KnzUmF5yhsKYroyEi/wLBbUUS031ou0X8DvBtA3ymvVS/xo3whND+ydZtvmZTSPzxLXK9wDiupNec=
X-Received: by 2002:a2e:9955:: with SMTP id r21mr6421858ljj.58.1567790583048;
 Fri, 06 Sep 2019 10:23:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190904184335.360074-2-ast@kernel.org> <201909070002.v6gbdPOK%lkp@intel.com>
In-Reply-To: <201909070002.v6gbdPOK%lkp@intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 6 Sep 2019 10:22:51 -0700
Message-ID: <CAADnVQ+D9JTgqMbx4mfX-9ShpLEdzKpxf1R4Sq9r5-bH+aADZg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/3] bpf: implement CAP_BPF
To:     kbuild test robot <lkp@intel.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, kbuild-all@01.org,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 6, 2019 at 9:21 AM kbuild test robot <lkp@intel.com> wrote:
>
> Hi Alexei,
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on bpf-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Alexei-Starovoitov/capability-introduce-CAP_BPF-and-CAP_TRACING/20190906-215814
> base:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git master
> config: x86_64-allmodconfig (attached as .config)
> compiler: gcc-7 (Debian 7.4.0-11) 7.4.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>    kernel//bpf/syscall.c: In function 'bpf_prog_test_run':
> >> kernel//bpf/syscall.c:2087:6: warning: the address of 'capable_bpf_net_admin' will always evaluate as 'true' [-Waddress]
>      if (!capable_bpf_net_admin)
>          ^

argh. fixing and rebasing.
