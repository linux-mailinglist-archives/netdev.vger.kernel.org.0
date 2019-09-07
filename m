Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B19D7AC384
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 02:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393302AbfIGAEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 20:04:22 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44889 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727950AbfIGAEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 20:04:21 -0400
Received: by mail-lj1-f193.google.com with SMTP id u14so7495813ljj.11;
        Fri, 06 Sep 2019 17:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zY+b9si/sYGzZHaejL2ql4KHanFrzklavCWIL1aMy6g=;
        b=IzjUXa2da5q8yt23S9bN/fHApmv2TA+ZyC7Ze9WDqHEgS/10/yGfJ7ujVGl0TwAlzV
         QuIeGS1XYGp/WlpmElBUq2xKm78x3yLRPwDR+Rd/QHd98eZQpjFcTFm52aB6vNvewJP3
         CGa0heQONR7UuiPui2H9jXLGxZOxBB97k4eeiw4rd5Xyk8azFGOGQX7m9bDWhuQx62Gv
         2pAM7yGDo/ENOiOCoqA61dMPR9L8Kl4O6WPb2SBUKDKpKc/XB2KJ7rlLRJ/8q+Hb96SX
         rsA1tcyPLZyd6ZNe46yhlDDIDX1FRTEBrmfdUKq19ZvKsT9g7E1hNro6NVonp7eqv3en
         G8+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zY+b9si/sYGzZHaejL2ql4KHanFrzklavCWIL1aMy6g=;
        b=Z5SvkJcv3XW4IYdbjaUschp3Gw1EgXpi9/FAbLKKYL1t4HmBgsRBG67Fg/ywSo/O3e
         ezT9cDT1mItqLX/d4+MGt7VaAlSVNUSaUC64Sv97SyKRbIZIhVYT8/At07fL65Oh4moe
         PZJyGqXbDAQA4f1glKNMzczw9ZdWmoMTeu3CvuLkpCW4x423P27GfILf8aYKg15j7phZ
         TlTbFuRtS8XDBLmWGspNhryAYcaMUKUM0QaaXk82yceVcj8ku6F+hRpJTtBnCe8VO8Lc
         ptQTqdQK5DWplH6G3VgtMRddX7ZZ7d/N1CuBJ0z/VDgboiMqceK1n2cqO4O3aaEBs823
         5WlA==
X-Gm-Message-State: APjAAAXJgFkeW5ZItIK46i6v8AQ07TrEIjXbNK9aVRVPWzcNaLwam+73
        AgvfcWfLs/h0BvXTcVxC7GfLGwdYOzgdL5egS0w=
X-Google-Smtp-Source: APXvYqwPInDrFO6C0NzYfa/Ii3qSRfzdSkpPyxjJh7KPs8MS6w67LQICXJX+dL0jbedJA40umb+qplWBXzTAMXxFrT8=
X-Received: by 2002:a2e:8785:: with SMTP id n5mr3727248lji.210.1567814659254;
 Fri, 06 Sep 2019 17:04:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190904212212.13052-1-ivan.khoronzhuk@linaro.org>
 <20190904212212.13052-3-ivan.khoronzhuk@linaro.org> <20190906233138.4d4fqdnlbikemhau@ast-mbp.dhcp.thefacebook.com>
 <20190906235207.GA3053@khorivan>
In-Reply-To: <20190906235207.GA3053@khorivan>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 6 Sep 2019 17:04:08 -0700
Message-ID: <CAADnVQKOT8D9156p49AQ0q0z5Zks5te4Ofi6DrBfpnitmRBgmg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/8] samples: bpf: Makefile: remove target for
 native build
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 6, 2019 at 4:52 PM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> On Fri, Sep 06, 2019 at 04:31:39PM -0700, Alexei Starovoitov wrote:
> >On Thu, Sep 05, 2019 at 12:22:06AM +0300, Ivan Khoronzhuk wrote:
> >> No need to set --target for native build, at least for arm, the
> >> default target will be used anyway. In case of arm, for at least
> >> clang 5 - 10 it causes error like:
> >>
> >> clang: warning: unknown platform, assuming -mfloat-abi=soft
> >> LLVM ERROR: Unsupported calling convention
> >> make[2]: *** [/home/root/snapshot/samples/bpf/Makefile:299:
> >> /home/root/snapshot/samples/bpf/sockex1_kern.o] Error 1
> >>
> >> Only set to real triple helps: --target=arm-linux-gnueabihf
> >> or just drop the target key to use default one. Decision to just
> >> drop it and thus default target will be used (wich is native),
> >> looks better.
> >>
> >> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> >> ---
> >>  samples/bpf/Makefile | 2 --
> >>  1 file changed, 2 deletions(-)
> >>
> >> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> >> index 61b7394b811e..a2953357927e 100644
> >> --- a/samples/bpf/Makefile
> >> +++ b/samples/bpf/Makefile
> >> @@ -197,8 +197,6 @@ BTF_PAHOLE ?= pahole
> >>  ifdef CROSS_COMPILE
> >>  HOSTCC = $(CROSS_COMPILE)gcc
> >>  CLANG_ARCH_ARGS = --target=$(notdir $(CROSS_COMPILE:%-=%))
> >> -else
> >> -CLANG_ARCH_ARGS = -target $(ARCH)
> >>  endif
> >
> >I don't follow here.
> >Didn't you introduce this bug in patch 1 and now fixing it in patch 2?
> >
>
> It looks like but that's not true.
> Previous patch adds target only for cross compiling,
> before the patch the target was used for both, cross compiling and w/o cc.
>
> This patch removes target only for native build (it's not cross compiling).
>
> By fact, it's two separate significant changes.

How so?
before first patch CLANG_ARCH_ARGS is only used under CROSS_COMPILE.
After the first patch CLANG_ARCH_ARGS is now suddenly defined w/o CROSS_COMPILE
and second patch brings it to the state before first patch.
