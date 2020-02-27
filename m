Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E33C1710A4
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 06:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgB0Fw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 00:52:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:54108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgB0Fwz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 00:52:55 -0500
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25E1024680;
        Thu, 27 Feb 2020 05:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582782775;
        bh=ZVaYG2q3mWiMXyHqafBEBn+Nfh7u032ddY3cVMj1SoQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EIHisrC6nf+cjUy3v3HyET8XgVQIvPDzBvg+k6D/ebCz57LKok12icKKG0f/36pcO
         m2H1N7TrWCx8+wVC8E67xOGYjGBw6CyE96ZI2r93tFCJI9+p+fvyOnVI2o2WIulCnL
         4QK77oP8Y9D8c3+VYJV+q6nNu2ZVwHKyRbXd7EdU=
Received: by mail-lf1-f45.google.com with SMTP id y17so1108555lfe.8;
        Wed, 26 Feb 2020 21:52:55 -0800 (PST)
X-Gm-Message-State: ANhLgQ1nURr/oIxLgM6Mmac72/bI6yTmHN0s4afBvDuCpmHsOUjlOtxq
        sEkDRmZQdjt47zKK0XVzZ0okd2FuVL9Ow2td80I=
X-Google-Smtp-Source: ADFU+vu/i9jT0l4BRuWXkjmpgwcQrGkD2CQcAWPJVF/FPUWxIUa9xbVYmTlTu++sT9NqD64cwrniv6iadZobW1of5nA=
X-Received: by 2002:a19:9155:: with SMTP id y21mr1189938lfj.28.1582782773280;
 Wed, 26 Feb 2020 21:52:53 -0800 (PST)
MIME-Version: 1.0
References: <20200226130345.209469-1-jolsa@kernel.org> <20200226130345.209469-18-jolsa@kernel.org>
In-Reply-To: <20200226130345.209469-18-jolsa@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Wed, 26 Feb 2020 21:52:42 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7GkNuiWjAdoAEKEa1=3wgV=jUfc144U=OiTXHn3aY=Gw@mail.gmail.com>
Message-ID: <CAPhsuW7GkNuiWjAdoAEKEa1=3wgV=jUfc144U=OiTXHn3aY=Gw@mail.gmail.com>
Subject: Re: [PATCH 17/18] perf tools: Set ksymbol dso as loaded on arrival
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 5:06 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> There's no special load action for ksymbol data on
> map__load/dso__load action, where the kernel is getting
> loaded. It only gets confused with kernel kallsyms/vmlinux
> load for bpf object, which fails and could mess up with
> the map.
>
> Disabling any further load of the map for ksymbol related dso/map.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>
