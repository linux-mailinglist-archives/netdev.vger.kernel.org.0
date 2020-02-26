Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5751170C81
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 00:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgBZXW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 18:22:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:53462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726413AbgBZXW1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 18:22:27 -0500
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93C4720658;
        Wed, 26 Feb 2020 23:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582759346;
        bh=eXMDit9odqgqWCuWsOwOVroSCUzYPy/v0uF4NOQ19Jw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OMJtf6Htdlh1+IwOADO5PYJH0M1xF1fhPTrD8O8b3PYRfu1v+A87bIsRUMC2YheZG
         D+hgG0H+GGbtpfV9plmMYHdp+p2KacWb+JmqqDr6TE8VuJZRXTGiGfaVGdTec6Z5LX
         q5Gevj0wSjrWdsTWbWZrcMP1XpqPsX/dAV7zWtP8=
Received: by mail-lj1-f181.google.com with SMTP id e18so1054503ljn.12;
        Wed, 26 Feb 2020 15:22:26 -0800 (PST)
X-Gm-Message-State: ANhLgQ2MUPxa2kfB45azfhDUpE9/h16FZwKqXDq/A8GqlZzZDGXiQ1ON
        3lUI3WbJaKzE5fOwuodsTTN9JkD6Oujj7Xza+y4=
X-Google-Smtp-Source: ADFU+vvjfDMTUXhGTVP3oXzZblIzopk6PtYTJ79FP3Xo61Syo1yFcXqXqVpgkgT1ONM4/84Mai1TwiRu7RlXET7F0/Q=
X-Received: by 2002:a2e:a553:: with SMTP id e19mr854314ljn.64.1582759344810;
 Wed, 26 Feb 2020 15:22:24 -0800 (PST)
MIME-Version: 1.0
References: <20200226130345.209469-1-jolsa@kernel.org> <20200226130345.209469-12-jolsa@kernel.org>
In-Reply-To: <20200226130345.209469-12-jolsa@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Wed, 26 Feb 2020 15:22:13 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5M7VLYeU6jbD4Vyui=+aU1CBBjuOevrGs=RvM8CunsvA@mail.gmail.com>
Message-ID: <CAPhsuW5M7VLYeU6jbD4Vyui=+aU1CBBjuOevrGs=RvM8CunsvA@mail.gmail.com>
Subject: Re: [PATCH 11/18] bpf: Rename bpf_tree to bpf_progs_tree
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
> Renaming bpf_tree to bpf_progs_tree and bpf_tree_ops
> to bpf_progs_tree_ops to better capture the usage of
> the tree which is for the bpf_prog objects only.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>
