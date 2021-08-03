Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9983DE378
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 02:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbhHCATv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 20:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbhHCATv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 20:19:51 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEBAC06175F;
        Mon,  2 Aug 2021 17:19:41 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id f26so10622967ybj.5;
        Mon, 02 Aug 2021 17:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OPqGRE6xJS2oRkxHfvZPuffqPnTnDTuL792ckn61KPk=;
        b=rN+KaFXj75ktUapJTM921rmSl4zoKFORWRoDbfPycO/nOxwEkDiZapefNzOUUecvFv
         xWY4P4y8cWnYnxEzU4inVNHkFb7Fn+u9IsQZ9MnJIn3CSHSsDhmNtR9qJBI9FXOfkZYN
         SBnkm7+fV7DSKSKyzSpgqrBU6jFj4uoVWubLH6iycRrO8Pffv/EBqxcvkaafUW4okLMA
         1wA24tpHz9czZ08TKEJ9q/tTc9Z9R8ylijnEKV73tsO9/vjQiTpookPHDBkbqRa8tDtN
         02LHgKs/8s30LSJgwlpr1zAvPmuQLjvqBGykmky3JgPPlvoVTFeV2so8bJZz26oCg+kz
         jvuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OPqGRE6xJS2oRkxHfvZPuffqPnTnDTuL792ckn61KPk=;
        b=XNxFEea8Ib9sERted0tIph4f/ZJxNzYo9fNR1HWvkW9O+L4QfTgCWFeJWDKZwV6gN0
         dq9pkKZ7fTrpqNjUQqYNpYbwwPRMSoPzv9V0TpOPfViklcq2JQjrcsoIh5plDLy+mEpI
         B2fJJd1aMFI2DohSdbBAyE36vQ6Pk2Mje2djqhK/dtj9j7B9zeH1j94JEtXfrpc8p+FF
         sY9nODtN35U2mcrnCJ15IQvrxz19v4Jn/RaPYG1zDZcSGdXqAES8AK36k3NG2ofwBd/5
         RBbczPEg3jVkgtIowTX0pBnTC2sos6Mc63AMns0Aosq2ftJMFdiogLE4qcyuFaD7SAcT
         Dd2A==
X-Gm-Message-State: AOAM5316vUiE6g+1m0bkj2y38j7hxNemrAWZ+QE5r0ab61U35kVdWLoY
        4SOlDj9cfkI8qK/ImrFb0eFhqZur1iomzsD5IzU=
X-Google-Smtp-Source: ABdhPJy5npUMFjWRc6CLCVxkd+n1mlSweCIVwfhNXgN3n9BgByToq40It6kX/0eyRClx7c9V9iLH1sK24cS0ZnH/tRQ=
X-Received: by 2002:a25:1455:: with SMTP id 82mr24088939ybu.403.1627949980593;
 Mon, 02 Aug 2021 17:19:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210609135537.1460244-1-joamaki@gmail.com> <20210728234350.28796-1-joamaki@gmail.com>
 <20210728234350.28796-7-joamaki@gmail.com>
In-Reply-To: <20210728234350.28796-7-joamaki@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Aug 2021 17:19:29 -0700
Message-ID: <CAEf4BzbcavnGdAjV-KjTrFg8bXWF=2qN1j67+09-CgS_Ub+4TQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 6/6] selftests/bpf: Add tests for XDP bonding
To:     Jussi Maki <joamaki@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, j.vosburgh@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>, vfalico@gmail.com,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 2, 2021 at 6:24 AM <joamaki@gmail.com> wrote:
>
> From: Jussi Maki <joamaki@gmail.com>
>
> Add a test suite to test XDP bonding implementation
> over a pair of veth devices.
>
> Signed-off-by: Jussi Maki <joamaki@gmail.com>
> ---

Was there any reason not to use BPF skeleton in your new tests? And
also bpf_link-based XDP attachment instead of netlink-based?

>  .../selftests/bpf/prog_tests/xdp_bonding.c    | 467 ++++++++++++++++++
>  1 file changed, 467 insertions(+)
>

[...]
