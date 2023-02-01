Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB1C686EB7
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 20:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbjBATL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 14:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbjBATLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 14:11:55 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1FD7FA33
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 11:11:52 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 7so13244486pga.1
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 11:11:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JaFJ6lfmiEOeqK1wUmWFrA+rVDHx+5X0IrxYjtJOOto=;
        b=Z4v97FJ86GWbRsbi4GrZLuTg3sIrHR1Sbm1OfL/qFWK1KYRorVITOASXg4gtG0YZBJ
         C+zr7rDxOrVZoy/yweCLujB4U9t2x/QGYXHbMlx2CgW+SwLrdFMDdUzO/0ngnlb+VHmu
         xWIv2WXQSkfptuX/v5OqwZI/XGTQES5kOb4SAAAv6+NqnIFXzVugkSWbgSPnuj9TdOpt
         xxMiHE1VbhDBJNCZY56ldQzOh/xeXLVwuPO/qHIHIzquNs7TTwK2SpXVuaPTYSPG9N8z
         kccPQt7o3pBxUjQ6Pl6+PxkVRcLFrLT22SmQPBHdRJaXtZLNdpibHscZhg5rv090OoNG
         MUaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JaFJ6lfmiEOeqK1wUmWFrA+rVDHx+5X0IrxYjtJOOto=;
        b=z0uE6c4mt9b2tw0IXHR1x7kVjd7zi7CRKFJPfa0OxqkmJHdjelKtgm9+LOq904zzSA
         5PEcSu154u6+o5FsOEOzLWZQzTx0DngHyCCJxb99/z7/IV1jjBydKlOj1YqzC+FrNHK2
         UI6kldC+7CCG1d4Cg9uBkn9/byAW00+Bd/RDBk1nKoWVuizJpJGTOxqGNPqfgEQCV/IN
         ydNsir9NJjTlQQKYV1ZBjO/fE5jRzHezipeEMblIQYvqGIBA4Ui2TvVd/GqlSaCxQkAs
         1c5xJqW9VoamFHPFwEeNgo8+mPQ/ObSN4H/HHJE0otxEH9wJxNA5nZupqogRAd4XOkoO
         aoCw==
X-Gm-Message-State: AO0yUKXMqb3pVN0Jg5LLbhQkE3XxaTBqpa3VDZbZaL6dmWfgoAMskfKn
        FRFg8cQzttTLAUv683t3CHdDPRqUjKHv+hk1Rp+/sw==
X-Google-Smtp-Source: AK7set/BrCLpRYtW3zs8noXFyKSstv0WRPWCOWVbXfLGuZy9m2ASlLqzuS9+cqILw+ZJ6UOMEEDZ6nyMcALiiSD6D10=
X-Received: by 2002:aa7:94b9:0:b0:593:1253:2ff5 with SMTP id
 a25-20020aa794b9000000b0059312532ff5mr803043pfl.14.1675278711984; Wed, 01 Feb
 2023 11:11:51 -0800 (PST)
MIME-Version: 1.0
References: <167527267453.937063.6000918625343592629.stgit@firesoul>
In-Reply-To: <167527267453.937063.6000918625343592629.stgit@firesoul>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 1 Feb 2023 11:11:40 -0800
Message-ID: <CAKH8qBtCr4BYYwB=zhCGc4bu3NmCQZKJLL_9m5GRE6cKzBH7OA@mail.gmail.com>
Subject: Re: [PATCH bpf-next V2 0/4] selftests/bpf: xdp_hw_metadata fixes series
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, dsahern@gmail.com, willemb@google.com,
        void@manifault.com, kuba@kernel.org, xdp-hints@xdp-project.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 1, 2023 at 9:31 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
> This series contains a number of small fixes to the BPF selftest
> xdp_hw_metadata that I've run into when using it for testing XDP
> hardware hints on different NIC hardware.
>
> Fixes: 297a3f124155 ("selftests/bpf: Simple program to dump XDP RX metadata")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Thank you!

Acked-by: Stanislav Fomichev <sdf@google.com>

> ---
>
> Jesper Dangaard Brouer (4):
>       selftests/bpf: xdp_hw_metadata clear metadata when -EOPNOTSUPP
>       selftests/bpf: xdp_hw_metadata cleanup cause segfault
>       selftests/bpf: xdp_hw_metadata correct status value in error(3)
>       selftests/bpf: xdp_hw_metadata use strncpy for ifname
>
>
>  .../selftests/bpf/progs/xdp_hw_metadata.c     |  6 +++-
>  tools/testing/selftests/bpf/xdp_hw_metadata.c | 34 +++++++++----------
>  2 files changed, 22 insertions(+), 18 deletions(-)
>
> --
>
