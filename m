Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0550F170C65
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 00:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgBZXMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 18:12:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:51410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727749AbgBZXMe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 18:12:34 -0500
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A68BC222C2;
        Wed, 26 Feb 2020 23:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582758754;
        bh=jz+cNEEhyvLoqhg3Fmp8vsvky6lu2/UHmmpJaWK99rI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nNYYpDgsnw2UNBYGJ4sxVUUEkmDPWCF4PBTGcRVt1G39zmoP0Mgg1xOkSj/V8xTvK
         9u1zX3ydxrHhOK7CpQ9i+v9sVjXZtY7HAm/Z8ARa8gaAV8HOr/3GQZ6IL9/nbAiVD4
         7uVQt/A0E27T6hk21WNMU7bFkqHV/00sq+gssmYo=
Received: by mail-lj1-f171.google.com with SMTP id 143so949508ljj.7;
        Wed, 26 Feb 2020 15:12:33 -0800 (PST)
X-Gm-Message-State: ANhLgQ0Ub7srt/k0ALwfO512y8zF3Fz+CxjTLRwptOJG781XD2/KlCcK
        n1MhGQdebPBRN9ycBCiauv7BYJVaTeRIl6yQnio=
X-Google-Smtp-Source: ADFU+vs13WPtwXw1d3QCX3AwSe9TprjdtVMCQmGK5cMg0uBvNSNvNsf9PcSAeZTDYXD3qzt6dNDI2Gg/zEOc8aMRY7s=
X-Received: by 2002:a05:651c:239:: with SMTP id z25mr799619ljn.48.1582758751875;
 Wed, 26 Feb 2020 15:12:31 -0800 (PST)
MIME-Version: 1.0
References: <20200226130345.209469-1-jolsa@kernel.org> <20200226130345.209469-8-jolsa@kernel.org>
In-Reply-To: <20200226130345.209469-8-jolsa@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Wed, 26 Feb 2020 15:12:20 -0800
X-Gmail-Original-Message-ID: <CAPhsuW748h4+sAthYvPk6n9-8rbv8xTn2vVmDrtyfgR2htnQdw@mail.gmail.com>
Message-ID: <CAPhsuW748h4+sAthYvPk6n9-8rbv8xTn2vVmDrtyfgR2htnQdw@mail.gmail.com>
Subject: Re: [PATCH 07/18] bpf: Move bpf_tree add/del from bpf_prog_ksym_node_add/del
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

On Wed, Feb 26, 2020 at 5:04 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Moving bpf_tree add/del from bpf_prog_ksym_node_add/del,
> because it will be used (and renamed) in following patches
> for bpf_ksym objects. The bpf_tree is specific for bpf_prog
> objects.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>
