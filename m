Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F56734F08A
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 20:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbhC3SJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 14:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232543AbhC3SJE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 14:09:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F034561935;
        Tue, 30 Mar 2021 18:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617127744;
        bh=GpBafQQUYpT+5UqkCEVMSPco1e1rMWJC1fsHFjjtCXQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ru5oT8wVsiEU/bV+dKCwfychY9CYHpBn2jTEHcu0UUzjojxS+Sb9WMucBwfkiXp0O
         Jp4vd00L8tpPKG0lfxpx4X2Q0Qg//fIEA9bNM9yvjGfS8gC6/+fIvRLQ9lIf0S+A/m
         gH1bv4Os9OAZSMN/vGEMFss24RWGacyeXkOQXGD+5ICy3ipWbd6efCWnNUVPhypSho
         OGaudnc0TGYO9sImR2iPvLXd5ueuN73qFbRNFSPwvnDpZ8wP6pvmYJwIGwE2sJkT14
         ZaVZyz+Eto4iGHyrqMJSRbJznxKX5b8w8q1EHpBsOKyXH0GEZwEj6qF20EkRPOwzDD
         wa1KwoQFD7C8A==
Received: by mail-lj1-f178.google.com with SMTP id a1so20937842ljp.2;
        Tue, 30 Mar 2021 11:09:03 -0700 (PDT)
X-Gm-Message-State: AOAM531r12aAFx5e8IIqRuv05nsoKHPkSI2F8I+m0aGFPKbs+rljeU+k
        oyH5KxoaOQbRYdbyaGR6zbioHa/mdzjirrwT59o=
X-Google-Smtp-Source: ABdhPJxLyHuuSSlK6a8At590Axckhg2NruxNqEvnE9AtjNhgaxX0EPTWIYmgl/XGaIx0zxH0W3OqCuRlkYQ/yMg4T54=
X-Received: by 2002:a2e:9a96:: with SMTP id p22mr20974644lji.167.1617127742236;
 Tue, 30 Mar 2021 11:09:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210330024843.3479844-1-hefengqing@huawei.com>
In-Reply-To: <20210330024843.3479844-1-hefengqing@huawei.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 30 Mar 2021 11:08:51 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6fuP7HWZ0g8Sxb1+A52Qr7ks8q=VhPe70VUco6OhozKg@mail.gmail.com>
Message-ID: <CAPhsuW6fuP7HWZ0g8Sxb1+A52Qr7ks8q=VhPe70VUco6OhozKg@mail.gmail.com>
Subject: Re: [Patch bpf-next] net: filter: Remove unused bpf_load_pointer
To:     He Fengqing <hefengqing@huawei.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, ongliubraving@fb.com,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 7:11 PM He Fengqing <hefengqing@huawei.com> wrote:
>
> Remove unused bpf_load_pointer function in filter.h
>
> Signed-off-by: He Fengqing <hefengqing@huawei.com>

Acked-by: Song Liu <songliubraving@fb.com>

[...]
