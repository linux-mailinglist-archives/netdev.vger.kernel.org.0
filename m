Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85E6F16B609
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 00:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgBXXt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 18:49:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:34182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgBXXt7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 18:49:59 -0500
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 465A722464;
        Mon, 24 Feb 2020 23:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582588198;
        bh=wEZx6Wr2uWik4AOst03hDKWtf8o3tRHVJ6Eciu8f1KM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=O9Tav6Vt/tHOnqzc/WLhyEn4ZpL6JNH3yTVWOLzTtp3xClQ8J+Zhz8Bt5nxt54QYz
         yv9VDlpLJKpZI/tgFctM7OBiNpPIX7mXVKEzXASyjhf07XkweoDXEOcvmfg5FhOMNX
         lVHxB1aMEnSQa2iRiallA+ttWVLJTIIrZL1YG0/U=
Received: by mail-lj1-f176.google.com with SMTP id n18so12042648ljo.7;
        Mon, 24 Feb 2020 15:49:58 -0800 (PST)
X-Gm-Message-State: APjAAAVya+2hr5nYKyf9/L82BvXA0fbtrr0vXchhc48usg1ZsKwkQhlk
        eFbIItdkf1I44F2wcXfknVKumLPc8ejrk8DSk3I=
X-Google-Smtp-Source: APXvYqxS8VfAZM+dokFYk0cJfwCLHX4zxDwGDT+atu2OwALc/n+OBOLVW4W+x/m7QzFDBdT0HRfNmaeRBldIMnmqju8=
X-Received: by 2002:a2e:89d4:: with SMTP id c20mr31073604ljk.228.1582588196396;
 Mon, 24 Feb 2020 15:49:56 -0800 (PST)
MIME-Version: 1.0
References: <07e2568e-0256-29f5-1656-1ac80a69f229@iogearbox.net>
 <20200220071054.12499-1-forrest0579@gmail.com> <20200220071054.12499-3-forrest0579@gmail.com>
In-Reply-To: <20200220071054.12499-3-forrest0579@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 24 Feb 2020 15:49:45 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4-MC4yAOwUAuEUHCgKHG16MyjW5oLc4D056zt30Q_cQg@mail.gmail.com>
Message-ID: <CAPhsuW4-MC4yAOwUAuEUHCgKHG16MyjW5oLc4D056zt30Q_cQg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/3] bpf: Sync uapi bpf.h to tools/
To:     Lingpeng Chen <forrest0579@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Petar Penkov <ppenkov.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 11:11 PM Lingpeng Chen <forrest0579@gmail.com> wrote:
>
> This patch sync uapi bpf.h to tools/.
>
> Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>
