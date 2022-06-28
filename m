Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9362555D4DC
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242088AbiF1H2L convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Jun 2022 03:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242985AbiF1H1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 03:27:37 -0400
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C165B2CE26;
        Tue, 28 Jun 2022 00:27:35 -0700 (PDT)
Received: by mail-qv1-f41.google.com with SMTP id i17so18728446qvo.13;
        Tue, 28 Jun 2022 00:27:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hwgLtruPC06mcRCnQAsf+kJqHCP1mf00hTNnpiQ34M0=;
        b=3tQxdeTXaeHedyn+zuV/55ACvAhAXmWcP4mEBFJ7jzsyYq6RsSgMON/8hhCXyPFuse
         MLSN3K1iygLYNzbYfsEUEZlABb1G1eppIZbae+40fb4YMxpctrE+lrJz3qET/ldo5zGd
         37edeyXGnan1cSc5wL4OCPTZESLkJDeXBVsf5Jitdq4F2SUoLicy4d+r65QQwFBoAQaF
         rVmUy/gVspn4buiPbwq5cSH0lOm6yf061HBv7eJrhJeCu9Xa08CHGXWzt6wFcbBU42zO
         cc0C2wJwrVFqggLP3rTWVXzc4tL0SV7qsxw7pHWn+6UvTIPwY9qNnceTZYR/8yu6Ppqr
         0hkQ==
X-Gm-Message-State: AJIora91XfpVhN+yRTRlxkAy8ZQagB28kxgOh0hSO/dgpIY4a+cEmxEM
        RRrXPZ914wNJxYzvqW7oNwha7fO41WOfPA==
X-Google-Smtp-Source: AGRyM1vuyurBth3w/1QAUlj3nOiF8B4hIrD4wqWY4IUnkxCMfrPNbOyI3fDTEu0sS0pUw3shJaj5og==
X-Received: by 2002:a05:622a:647:b0:306:6b30:bd0a with SMTP id a7-20020a05622a064700b003066b30bd0amr12004710qtb.327.1656401254977;
        Tue, 28 Jun 2022 00:27:34 -0700 (PDT)
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com. [209.85.128.182])
        by smtp.gmail.com with ESMTPSA id f14-20020a05620a408e00b006a5d2eb58b2sm11643530qko.33.2022.06.28.00.27.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 00:27:34 -0700 (PDT)
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-3176b6ed923so107319457b3.11;
        Tue, 28 Jun 2022 00:27:33 -0700 (PDT)
X-Received: by 2002:a81:a092:0:b0:318:5c89:a935 with SMTP id
 x140-20020a81a092000000b003185c89a935mr20762801ywg.383.1656401253054; Tue, 28
 Jun 2022 00:27:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220627180432.GA136081@embeddedor>
In-Reply-To: <20220627180432.GA136081@embeddedor>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 28 Jun 2022 09:27:21 +0200
X-Gmail-Original-Message-ID: <CAMuHMdU27TG_rpd=WTRPRcY22A4j4aN-6d_8OmK2aNpX06G3ig@mail.gmail.com>
Message-ID: <CAMuHMdU27TG_rpd=WTRPRcY22A4j4aN-6d_8OmK2aNpX06G3ig@mail.gmail.com>
Subject: Re: [PATCH][next] treewide: uapi: Replace zero-length arrays with
 flexible-array members
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>, dm-devel@redhat.com,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-can@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux1394-devel@lists.sourceforge.net, io-uring@vger.kernel.org,
        lvs-devel@vger.kernel.org,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        nvdimm@lists.linux.dev,
        NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, linux-perf-users@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        scsi <linux-scsi@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gustavo,

Thanks for your patch!

On Mon, Jun 27, 2022 at 8:04 PM Gustavo A. R. Silva
<gustavoars@kernel.org> wrote:
> There is a regular need in the kernel to provide a way to declare
> having a dynamically sized set of trailing elements in a structure.
> Kernel code should always use “flexible array members”[1] for these
> cases. The older style of one-element or zero-length arrays should
> no longer be used[2].

These rules apply to the kernel, but uapi is not considered part of the
kernel, so different rules apply.  Uapi header files should work with
whatever compiler that can be used for compiling userspace.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
