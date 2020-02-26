Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E95F170CB7
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 00:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgBZXpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 18:45:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:57864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726413AbgBZXpP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 18:45:15 -0500
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB1762467B;
        Wed, 26 Feb 2020 23:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582760715;
        bh=Sv+LmLJtw+PBAxjhRmaZRrLPXGFfvBAi2CgXi8EIkhE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LhLR3nyCFJPUqCWm27k6u/t7P/ouI5yXypGlZRx8JDk40Ojit3zZOsqLcjCeuLN44
         xzsPR/cQ9wPm5zDOV66e6u4oUMD19zoFxSf8pjJAiAB3+BYB3vGoyalZUEW8zA3k1g
         dpStVoa3HJuxrDvK7NsanrMQuPexEBSlh3d3qWAs=
Received: by mail-lj1-f178.google.com with SMTP id 143so1023869ljj.7;
        Wed, 26 Feb 2020 15:45:14 -0800 (PST)
X-Gm-Message-State: ANhLgQ1t4Zd7WD9OFUr+8ICQMfjFozunsbL723H1mJ06KAEJ3rk3knBb
        D/PKlgJnVc753eYeglQCzAzsTr3nPszZb0tuN8U=
X-Google-Smtp-Source: ADFU+vt+cYR78F23kjHsAxI9s3HpA5qDtmQc8/nLWmP85Kjr6zM6tPxZlbmM/bJrcoG4VWZb1YTnKGfzuerRRoea5gM=
X-Received: by 2002:a05:651c:239:: with SMTP id z25mr862592ljn.48.1582760712812;
 Wed, 26 Feb 2020 15:45:12 -0800 (PST)
MIME-Version: 1.0
References: <20200226130345.209469-1-jolsa@kernel.org> <20200226130345.209469-14-jolsa@kernel.org>
In-Reply-To: <20200226130345.209469-14-jolsa@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Wed, 26 Feb 2020 15:45:01 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4LABLRwdtOFZrw3O2quLcaiqZYWwp4x85W43Bdx-ojpQ@mail.gmail.com>
Message-ID: <CAPhsuW4LABLRwdtOFZrw3O2quLcaiqZYWwp4x85W43Bdx-ojpQ@mail.gmail.com>
Subject: Re: [PATCH 13/18] bpf: Return error value in bpf_dispatcher_update
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
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

On Wed, Feb 26, 2020 at 5:07 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> We don't currently propagate error value from
> bpf_dispatcher_update function. This will be
> needed in following patch, that needs to update
> kallsyms based on the success of dispatcher
> update.
>
> Suggested-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>
