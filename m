Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0829B170C6C
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 00:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgBZXOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 18:14:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:51758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727749AbgBZXOW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 18:14:22 -0500
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA2252467D;
        Wed, 26 Feb 2020 23:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582758862;
        bh=cPeEnxznyjsO+KRWBxY1Af5d0w4TdhzQuejz1A4vBTY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Z9I6RuZVK98yrZKHxxl1hcX/KRbQJo8H78wR2COyyJJa695UOmqTbn4PmiNqVyR1c
         5XD/E9rdQdnzKr8ijtAsJ0pCnpaXMmQq/8oYmXfHcx0ttQ4qNtpDoD9e00Tw1B8o1G
         NwOAmaOOm5K5DRm29vIjES56tpk05AzON6bDsOiw=
Received: by mail-lj1-f182.google.com with SMTP id w19so1037742lje.13;
        Wed, 26 Feb 2020 15:14:21 -0800 (PST)
X-Gm-Message-State: ANhLgQ2iCpbaTGMWUKaZD5nyMBg7eZIpswp6WtN8QQ8SY7oBG6u9q6EY
        TNaJSkHoAs4l7raV7vYCxDFnHym3objzYbOm7fM=
X-Google-Smtp-Source: ADFU+vv4uC1qfaELK08mdFxfR6sHwgLXHvNREgNk+3P9ffLdjTHHMp6naRGiRIjYxRLdLU2Jtkz9Evi9TjtQsloCZv0=
X-Received: by 2002:a2e:804b:: with SMTP id p11mr797032ljg.235.1582758859837;
 Wed, 26 Feb 2020 15:14:19 -0800 (PST)
MIME-Version: 1.0
References: <20200226130345.209469-1-jolsa@kernel.org> <20200226130345.209469-9-jolsa@kernel.org>
In-Reply-To: <20200226130345.209469-9-jolsa@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Wed, 26 Feb 2020 15:14:08 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4eFzYT_raj1HLerLo1FN05sUDn-sqdWhPWioe_+WQW8Q@mail.gmail.com>
Message-ID: <CAPhsuW4eFzYT_raj1HLerLo1FN05sUDn-sqdWhPWioe_+WQW8Q@mail.gmail.com>
Subject: Re: [PATCH 08/18] bpf: Separate kallsyms add/del functions
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

On Wed, Feb 26, 2020 at 5:05 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Moving bpf_prog_ksym_node_add/del to __bpf_ksym_add/del
> and changing the argument to 'struct bpf_ksym' object.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>
