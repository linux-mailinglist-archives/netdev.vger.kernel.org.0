Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE7D2B8343
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 18:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgKRRnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 12:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727476AbgKRRnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 12:43:51 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0A2C0613D4;
        Wed, 18 Nov 2020 09:43:51 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id c198so1970217wmd.0;
        Wed, 18 Nov 2020 09:43:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mVeJqHG2em0yWD8MsCr0uHPVXUTlFKiETQWelNfSKrI=;
        b=J1kcpLv79McSIBrQFrtid7jFBA8H6I3dXaJbjBTK1pOEsvMgSTuyySUmui2kgYrA3K
         hrhGzuSy/MAUMZZyfnDRgbpUY9X2xdBcQOdm/EjRI8z2oVNY7t49Fl8wo9B0JpJZ9swt
         ZrD5XgUx61QXpfATypZ5g9Lej7X94agb2zdtHrw2m9a9bsGWyfUP7E6w+y7ktqIA88Xy
         QSoLwrsesrEDPa6ItXsdOo5s0LW0jL+5uh2CqOD4iD4qWK530J+OsHc/xdHkmZH8+MDB
         EDUok/35PMvIxZh6TXB34NJsC0DpD6hwCHwqwSxNDt9/EtqM46mtD/NmQFA0X2qzucTO
         ZgMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mVeJqHG2em0yWD8MsCr0uHPVXUTlFKiETQWelNfSKrI=;
        b=gsSgIyT/y2HCrpSawQTjoqg3NpXF0pnhZX50EMBpooFmkJKM0KUDNZndiihH2nTxCB
         wFJcqFSe4kOHKW1b5qUEmq4g9loZAZnmebLQoZCBGgqFR6cffTbbLifEkEHv+1L6sfrv
         xZOHDBV8s2Kid8Y3P/tHx73AL/ja1UrLHh/r/bsLTaTfJZeeonRPdITYpn8EVTk8v6+u
         bpNt+2wMSmYFyW6M1zK2w4BFwQeMiLVSVxEX93IsSg0mooJDd6yd1SMLERY82kokyFxB
         /VsFLHF+cRmfIFKVtQpoKLcs+t74TqSq51bhGhb4kL+Z6DnR8aOVhNm1i/KjXC7cgjXW
         Vc9Q==
X-Gm-Message-State: AOAM531KjvmvBhy/f17GXUpjWAgWSEmfUDfCnDG4iIOwrRvTMjB1iSQm
        zjL3TY0NADFzseaLMTzw3cNJFKg+TD6a0ogmmLs=
X-Google-Smtp-Source: ABdhPJyMPVwnX2jPHnJtHnaYqJDj1A0VkhVOf1AhgZKW784eyuSL8j3XC8Nd3AdMABRqC4JZ78Xs3fNXOVrIl4M8I80=
X-Received: by 2002:a7b:c77a:: with SMTP id x26mr214035wmk.63.1605721430045;
 Wed, 18 Nov 2020 09:43:50 -0800 (PST)
MIME-Version: 1.0
References: <20201118071640.83773-1-bjorn.topel@gmail.com>
In-Reply-To: <20201118071640.83773-1-bjorn.topel@gmail.com>
From:   Luke Nelson <luke.r.nels@gmail.com>
Date:   Wed, 18 Nov 2020 09:43:38 -0800
Message-ID: <CAB-e3NTv1in=QTfaRsA-J8rtLNmoEso8XZ3q_mx9ZBhAUyXkxg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/3] RISC-V selftest/bpf fixes
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Xi Wang <xi.wang@gmail.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        andrii.nakryiko@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nice, thanks for the fixes!

(For the whole series:)
Acked-by: Luke Nelson <luke.r.nels@gmail.com>
