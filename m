Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E263170CDB
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 00:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgBZX5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 18:57:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:33922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728028AbgBZX5c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 18:57:32 -0500
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E85F024672;
        Wed, 26 Feb 2020 23:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582761452;
        bh=rXXJ2Bjz6Ebou0bDRrf+3buabSrIvl9Pmlr0oC9KChY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nGsrUgstMkN7VF41mFt/7UY2tvbqLbY8n6umY+iLknr1xqFKQHL+uXPKohxVB9F09
         4HYin1oEw0nwOr00gu8jvwz0mMZedALwjLbzQIHpI6BsFoLTU7jtWmKl0MlIeVS8EA
         1sgOtigaiHPbiohtx5gnUk+UXj+b6U6hVKarfkD8=
Received: by mail-lf1-f53.google.com with SMTP id n30so652567lfh.6;
        Wed, 26 Feb 2020 15:57:31 -0800 (PST)
X-Gm-Message-State: ANhLgQ3CUyiS5Pi9AzZAvNka/3Gvgkjjke/uUtPEPKIicE12X5LWf/lp
        QY0kDh/j+HE/aiU7sjElHdnruBoCEsQ8kQDquos=
X-Google-Smtp-Source: ADFU+vuujt2GZDFlSuvyF5jictR9pKfvGPVuDV+1iNkxWmlf02RUE887JLfGKI5Hq7XyGWoRnn/CbqZ1sFbUn8pitc8=
X-Received: by 2002:a05:6512:6cb:: with SMTP id u11mr551354lff.69.1582761450125;
 Wed, 26 Feb 2020 15:57:30 -0800 (PST)
MIME-Version: 1.0
References: <20200226130345.209469-1-jolsa@kernel.org> <20200226130345.209469-16-jolsa@kernel.org>
In-Reply-To: <20200226130345.209469-16-jolsa@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Wed, 26 Feb 2020 15:57:18 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5Xg3Z__-xU8_O1dXSfoAXA0r0aWWXmrGupqM9YoFC7fg@mail.gmail.com>
Message-ID: <CAPhsuW5Xg3Z__-xU8_O1dXSfoAXA0r0aWWXmrGupqM9YoFC7fg@mail.gmail.com>
Subject: Re: [PATCH 15/18] bpf: Sort bpf kallsyms symbols
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
> Currently we don't sort bpf_kallsyms and display symbols
> in proc/kallsyms as they come in via __bpf_ksym_add.
>
> Using the latch tree to get the next bpf_ksym object
> and insert the new symbol ahead of it.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>
