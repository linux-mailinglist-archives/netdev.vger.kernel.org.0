Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8951D9FA8
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 20:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgESSji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 14:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgESSji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 14:39:38 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAFBEC08C5C0;
        Tue, 19 May 2020 11:39:36 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id h26so389368lfg.6;
        Tue, 19 May 2020 11:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ht18e3/b8LUg9GRO7A4JDM825wTuZwp2FHCzvB2EzRY=;
        b=atmvRw2S5iGtPzdEVtUMoZRcnfrqjmz5fTSuvApyoCQf3p2WndOOedXrLsKFyCumII
         lPqBND+7OXp1zn+i3rBm2XjkKIz1mrODo8AyZvN++tJa8l+NM8UA592Wv/xrw9jX+HDS
         hHM0lsnAgRl4K8BaowE4RzXT+6uTwIxMtv46w3GBat/0mA0V0pJBJQzQcxXFEYpgRCpQ
         ofPbkFhnhDNaj9kVui7NMYKUW3Dmy9ThCelv+tvJHJJDvX3LN0gWdcOneZ8g4xElK9ie
         9nrt5NG/z2GuOPE61c14L/Y3Oyr8RCvhVtC9mG77gSl3BdrFQrbq9A7equ1NscZiLQrf
         KV7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ht18e3/b8LUg9GRO7A4JDM825wTuZwp2FHCzvB2EzRY=;
        b=oVBTXLbBPWzcsHbaxKXzDH5lRPxc077122OYa3zNQnZRcpreBNgvjwHGjGmbJ25pYc
         iur/F8CF8szU+3LbjLCDs76YWCIJMsm2XE8Bp3ZgI0Hg67jPocGzULVOQoWSfrb+WqRp
         zk9IhPzfMF0OTqtb2oBF0y7gwZJKm1HoOR0FDE6qWsuHscJxcTpbDxmX93ZTZYVt5r9r
         ieLYXPA5SjupJLADb1QnfmFfW7gT6Tq2B1XEf8TqnPU5FbEBCUqnx83MSpcYFy784N42
         ybLY7TyB7WICEVMxd3DPrQwq+PJyRUpTHNC1EZQxWPy99RBkIG7ZM27VvN0avc7vUh/H
         PN4w==
X-Gm-Message-State: AOAM531VJtg0Y9OOEmpMOYHirtRscK+vsEH4w9aVXgqB0wvdmJabUzzP
        JRpJe+lbB6pbdWqqtvSCefhdvt2hl4OyCEFkG/M=
X-Google-Smtp-Source: ABdhPJx3q6pqAWmEllNWr6daN4nUSLjYnTst7p/cE2pOlqOMo9XftK+UVzK13vgmhOLiVHy3lQ2B/XkzM6nBJBOV4gM=
X-Received: by 2002:ac2:58d7:: with SMTP id u23mr138673lfo.119.1589913575212;
 Tue, 19 May 2020 11:39:35 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1589841594.git.daniel@iogearbox.net>
In-Reply-To: <cover.1589841594.git.daniel@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 19 May 2020 11:39:23 -0700
Message-ID: <CAADnVQ+maFHVyyA+Vh4g8PPiVuHtxCtmiacv_yB1s6BGZwLgJg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/4] Add get{peer,sock}name cgroup attach types
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 3:46 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Trivial patch to add get{peer,sock}name cgroup attach types to the BPF
> sock_addr programs in order to enable rewriting sockaddr structs from
> both calls along with libbpf and bpftool support as well as selftests.
>
> Thanks!
>
> v1 -> v2:
>   - use __u16 for ports in start_server_with_port() signature and in
>     expected_{local,peer} ports in the test case (Andrey)
>   - Added both Andrii's and Andrey's ACKs

Applied. Thanks
