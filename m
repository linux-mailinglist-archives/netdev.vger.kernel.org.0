Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC9222FB2A
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 23:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgG0VPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 17:15:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgG0VPi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 17:15:38 -0400
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4656F20809;
        Mon, 27 Jul 2020 21:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595884538;
        bh=PTIilwuR6sEMM75VxQ601RQcElanWiN3lbjoVRuThKA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=V4NATWEFNIJkNxLnIj8BlxZdc5cKCSdWkDkyFXwrEC1rpcTJasGXnJLFSpun4GkHi
         iwbOt2TVfOhov9vBSs6oId7DEmcythSw3CGVUYmfbWvRHtv11OgiAy1aNB6O1bQK/N
         dzlmL7PRQZzC3NHaOncxydqLmSU3N/LZ/mNzRtcE=
Received: by mail-lj1-f178.google.com with SMTP id 185so8616317ljj.7;
        Mon, 27 Jul 2020 14:15:38 -0700 (PDT)
X-Gm-Message-State: AOAM532oLpXfRYGshXOQ3SkzxmzJ7sLy65mfZGTqs9sl/DYS+CJqnU4O
        5wSv5px3AzKU59fAe9xNRKP7vzFH+M0n9HdEFDE=
X-Google-Smtp-Source: ABdhPJzWkrb1VP4ZjXtyc2XYTUqx0lyDpNmRsR8fp+CGVnll0H3mDZWHw1A11e06P/GWVht5do1s+DHaOEsKNUHyF88=
X-Received: by 2002:a2e:3003:: with SMTP id w3mr11142953ljw.273.1595884536576;
 Mon, 27 Jul 2020 14:15:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200724090618.16378-1-quentin@isovalent.com> <20200724090618.16378-3-quentin@isovalent.com>
In-Reply-To: <20200724090618.16378-3-quentin@isovalent.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 14:15:25 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7QvUO+23VmhDZU734LyhHmRfWVAgqiaEbJwQBom3i7+Q@mail.gmail.com>
Message-ID: <CAPhsuW7QvUO+23VmhDZU734LyhHmRfWVAgqiaEbJwQBom3i7+Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] tools: bpftool: add LSM type to array of
 prog names
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Paul Chaignon <paul@cilium.io>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 2:07 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Assign "lsm" as a printed name for BPF_PROG_TYPE_LSM in bpftool, so that
> it can use it when listing programs loaded on the system or when probing
> features.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>

Acked-by: Song Liu <songliubraving@fb.com>
