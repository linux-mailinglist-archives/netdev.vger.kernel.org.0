Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8821A85E3
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 18:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440661AbgDNQvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 12:51:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440548AbgDNQvJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 12:51:09 -0400
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 560FF2078A;
        Tue, 14 Apr 2020 16:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586883069;
        bh=5ItLj3pw8ICgMslGV/jzi2WlPetpysNmexshbAM8+2Y=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fny7C1Jr3lw6DvYP3P4R/o+BB7IEzN+oPJXzrc6U328xcACnDY2lLYiQIQ1D8udlH
         RsdBhYsL48o0lluaI4x/l7MwmKNVmKRfkBokxULYNsrxOKBzJuJnj6lOyW5qD5A2/K
         httZqYXw2vxiorpan5JMiddA56UtrnQzai215yAc=
Received: by mail-lf1-f53.google.com with SMTP id t11so306501lfe.4;
        Tue, 14 Apr 2020 09:51:09 -0700 (PDT)
X-Gm-Message-State: AGi0PuY9/+ju+XMBFLeorHKUymefpM0xCQfmOe2oPIuxbpyk+8X6hKVg
        WYG0YtYaA3papQwoO57o4VZZcnhvj+ivQDB7szQ=
X-Google-Smtp-Source: APiQypI19J8K19veT4EiqcGOziMyMfMCR+Dx1XPgW3Ct5WFJ5x80TGUvwNRUHbxW2Cp528PxmLqewLF8/DF94ZOVYag=
X-Received: by 2002:a19:494f:: with SMTP id l15mr434803lfj.33.1586883067437;
 Tue, 14 Apr 2020 09:51:07 -0700 (PDT)
MIME-Version: 1.0
References: <1586779076-101346-1-git-send-email-zou_wei@huawei.com>
In-Reply-To: <1586779076-101346-1-git-send-email-zou_wei@huawei.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 14 Apr 2020 09:50:56 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7CmnBE4xaS6zUBwXuRN5h-ofwpOBQ9ZU0OFPn0Re-kag@mail.gmail.com>
Message-ID: <CAPhsuW7CmnBE4xaS6zUBwXuRN5h-ofwpOBQ9ZU0OFPn0Re-kag@mail.gmail.com>
Subject: Re: [PATCH-next] bpf: Verifier, remove unneeded conversion to bool
To:     Zou Wei <zou_wei@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 10:15 PM Zou Wei <zou_wei@huawei.com> wrote:
>
> This issue was detected by using the Coccinelle software:
>
> kernel/bpf/verifier.c:1259:16-21: WARNING: conversion to bool not needed here
>
> The conversion to bool is unneeded, remove it
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zou Wei <zou_wei@huawei.com>

Acked-by: Song Liu <songliubraving@fb.com>
