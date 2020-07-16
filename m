Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A502219BC
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 04:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgGPCK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 22:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbgGPCK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 22:10:28 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8E6C061755;
        Wed, 15 Jul 2020 19:10:28 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id e12so3690111qtr.9;
        Wed, 15 Jul 2020 19:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y8kgHimiHeOOKPqIdglsBsLhb06PIDiTCDV57sAQzZk=;
        b=YTQZV/GI4YAYUYKHqOJ1mEYQoYXZiTFmLVixda6PyAsr45J1NnS+Ws35JVWSidrOgF
         S5976VRwFxxdGWiEBI3vHPsg/+KEviwRekQ/vuaG22ON5cw19LOgUpcyZ3Xr2yDFENAL
         ybgssqJRGcNZLwj0XJ5hXO0w4q2bUXWqqPnLgYkXInzVmr90CVVtDhyncNMDMnjEaigp
         ny5VWbueMGKTYHMakBnzTiq73NJgFUOd0hTRtYeuHxmdCa2qBhGTOrQKEf1mtk1wieAI
         HesxxZ2Oy1MTKcNmPRT9Yjml0i26nlpszLiPzZeKZ7oACNzaStYiCu8NQqn7QJitRmjQ
         yIOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y8kgHimiHeOOKPqIdglsBsLhb06PIDiTCDV57sAQzZk=;
        b=XAsVgprkhavGtzbzzbecDhghVyyuU6bmgI/f8WfG0+lOPV7mwkRk17ftfGePTgEfiv
         FgUnARw9omiimDhMY3A+5x7oHkzcF/B+eucyV+JLCKxigg0ek/2n4Lb+ozwGcTFFqxZh
         Wl0htvtYE0FffS5J+3hODZawMNHSMXnYEFhRpjhVurPwaF/9Fm9/Fe/pVS1stYpVNuhK
         vJQNlo6LnzxJAR/tiXCIPI2vc9RMrtDCUCBUcTzyYzOJoF6E9gDbAHjW1HQGYdW7uhCT
         VysaVh2ah+vm47q8WL6ansMaFDRdW5YACpue/2s3346gAAr7cVbDNaaOUxDy4wWwnndt
         qLCQ==
X-Gm-Message-State: AOAM533n/nZgQ7dYFByWjgLm4lGYXnT3BDQOu8nWCm2ACVweGmbCVnoE
        YGSbZynDBCpqaJLC0USoRSdjHIw0BT97H9hq4Ew=
X-Google-Smtp-Source: ABdhPJz3qCbRW/re6gbgPrOJX84si4SXuHchRW3pGRjWXotPK12ULMEtDU6BqoeLpMvpZYFsXhnUSOf11dNeL/eBqR0=
X-Received: by 2002:ac8:19c4:: with SMTP id s4mr2898672qtk.117.1594865426744;
 Wed, 15 Jul 2020 19:10:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200713174654.642628-1-jakub@cloudflare.com> <20200713174654.642628-14-jakub@cloudflare.com>
In-Reply-To: <20200713174654.642628-14-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Jul 2020 19:10:15 -0700
Message-ID: <CAEf4BzZaWEqv9o=mBTjB_Z0TzVudxH+UR4FhxSmz+XntDBNRTw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 13/16] tools/bpftool: Add name mappings for
 SK_LOOKUP prog and attach type
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 10:48 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Make bpftool show human-friendly identifiers for newly introduced program
> and attach type, BPF_PROG_TYPE_SK_LOOKUP and BPF_SK_LOOKUP, respectively.
>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

You should probably also update bash-completion file, but please do it
as a follow-up.

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]
