Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760EB21E2D8
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 00:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgGMWHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 18:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgGMWHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 18:07:42 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A25EC061755;
        Mon, 13 Jul 2020 15:07:42 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id y18so10096886lfh.11;
        Mon, 13 Jul 2020 15:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0DqOeuvMvgOG1fi+hX0/mTw8jeFBumsX73UVgduYAUg=;
        b=uREvi7vpjIcBz7Mk7w6xVU8eX1YYsSBHXHej4Zz+G5km+L7hxU+v8h+ea9pTGE9VXz
         r+g+z09am3R4hz3p0W6lkMKpaKUo9k0VDnxxOzUmCtqOLxoCdHXAuQniX6Yd52yFcWh1
         bdgA2rbqc/mjG29K40cof8+BiS53zoRLnyi3FjfxZDR/6pdiPqJd4EfflDoc70cD6bdw
         4IPk1GtEL3BbXR6XSTLnyqEmUAavpeDsNUvvrEKBoxbJul2XieeSYuKRovUoYZIPFc/h
         iO4fjt1TtKf60RUHoUv/unIuBEabuc8YT29YEJJoBDevSiqa8YZtYaX1Qkn0YNF62tO0
         JlNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0DqOeuvMvgOG1fi+hX0/mTw8jeFBumsX73UVgduYAUg=;
        b=UcQQT1sokSY1Eh2fUaA6ap2CLbKljSLhUc768v8qJ5SIDO2HX51tCtCMnGGtHDhv5S
         9pHSh5/gPNtxzphbVgV0+TnQH5HHf2AuL45OSlWQ2oaYltU5F4GRi3cQIchA7uahZVL6
         3XM39MpGEYkHBLttV5FKIVEB2GcFhMfg2r6UZwmQKsZMbphREVBiFCZn9cjm1AsY+QfC
         PPfEp25Ze7uFuQgi4ZUMEIi2uMTOcidDdoxmZpwj7ol2CrXGa1FCSMfw0BePpz8B9I6Q
         JkEc3BqGH4/zMtXM3HQzD/JpqoEKFB4lsQv7rF+AKuSc2l/EO/bNJ/MPnl7WRhdwT8JO
         wI3A==
X-Gm-Message-State: AOAM530/MpIs4ndudzx2VAy8AXrOFLjNDAscjUl4sH0np8MgFkT99rt2
        M18j/Y7/1PFu2Rh1bv1b9v1Y6Ywo3eUCQfktXBs=
X-Google-Smtp-Source: ABdhPJyPddgL2CH3CkW+aWDI/hqCrEW9ym320u0pevasTugOh8SUGNP1nVfUdj2o9Mf3zWLU9Xt5wo09y2gT7Q4iAhY=
X-Received: by 2002:a19:8497:: with SMTP id g145mr575586lfd.73.1594678060333;
 Mon, 13 Jul 2020 15:07:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200711215329.41165-1-jolsa@kernel.org>
In-Reply-To: <20200711215329.41165-1-jolsa@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 13 Jul 2020 15:07:28 -0700
Message-ID: <CAADnVQK4z0EmQZ77d2+nb4XY8AJaveT3fxkWi=ptkRqZh1UtYQ@mail.gmail.com>
Subject: Re: [PATCH v7 bpf-next 0/9] bpf: Add d_path helper - preparation changes
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 11, 2020 at 2:53 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> hi,
> this patchset does preparation work for adding d_path helper,
> which still needs more work, but the initial set of patches
> is ready and useful to have.
>
> This patchset adds:
>   - support to generate BTF ID lists that are resolved during
>     kernel linking and usable within kernel code with following
>     macros:
>
>       BTF_ID_LIST(bpf_skb_output_btf_ids)
>       BTF_ID(struct, sk_buff)
>
>     and access it in kernel code via:
>       extern u32 bpf_skb_output_btf_ids[];
>
>   - resolve_btfids tool that scans elf object for .BTF_ids
>     section and resolves its symbols with BTF ID values
>   - resolving of bpf_ctx_convert struct and several other
>     objects with BTF_ID_LIST
>
> v7 changes:
>   - added more acks [Andrii]
>   - added some name-conflicting entries and fixed resolve_btfids
>     to process them properly [Andrii]
>   - changed bpf_get_task_stack_proto to use BTF_IDS_LIST/BTF_ID
>     macros [Andrii]
>   - fixed selftest build for resolve_btfids test

Applied. Thanks!
