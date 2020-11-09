Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083082AB172
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 07:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729458AbgKIG42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 01:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728873AbgKIG41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 01:56:27 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A673EC0613CF;
        Sun,  8 Nov 2020 22:56:27 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id t16so9189397oie.11;
        Sun, 08 Nov 2020 22:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=3t7z1OAnLWIsPyyWvxu3btLtZGPdXzBYbO08I/vW1XE=;
        b=vFNffQDPYoC8d9yH0F7tB8VxujK2VuzRgqedXii9CykLmRunrXKLD/mstB81zVdJrL
         0nMorH20GVVcQLidQPoHEFeDP2uuimXFVUg3dMyTrfUoDg/jb7CRdAsKqsSi67Gob/Qb
         +Hwc79/nsnLx4D3VWsNUlFsSnU5b5hXh/2+DpqgXQHCyr/gCG33r2B4TitKCyN7//lhS
         nHAsVBMA8cu99V6NkyRWMcusXJh8zYWto2j4W4YdC2ZYgbaHPe3tNYkeSIBalVGGr/+/
         3eAHfj5IrCnEsJoONcMK27w4lW3b3jVgzOSG0XaidIwrO4SuAnRC2zU9t3WRW713EH8q
         goaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=3t7z1OAnLWIsPyyWvxu3btLtZGPdXzBYbO08I/vW1XE=;
        b=NWMrLGZ77hdcZv8VdxvJYCCVCsQ53hLZSd9zhpicpvXca2H7DhsgHM6LDzHHiDalUM
         NpQPNcPQjVoOa+4/QRaW80BkbMR565vbn+CeiPK7XacDsYi96ZvQvaRRteGkq9qs2Pbe
         5VPwRVZlkaTaeJU0HkwL3etQJ8Yl+LpoiFyeaK7p+7E4m0CjSdRgMOqKN1kIv6RhOMTE
         mwTE3ngPFWcQ6tPdSwCShbBMkJf6zJLExqOWX45X0j8lu6GJ1T2gp/DcxIfLGocFosLU
         4/Fx23Y4625nj1PjXUdwK9xzb+XfvkLAWA7T+oHXYZ9RYoaXD/lfWDoYTNYfE9GXmCBz
         GNRA==
X-Gm-Message-State: AOAM530i721miAbsA/TODxtFm6k/AV5OZsJaj2BSc5s7ZmpJzMIY5IlJ
        p5OgFfkw4Q1TyTMXweV+EM8=
X-Google-Smtp-Source: ABdhPJxkYM+rvylKuuImJoojFPmrvGjCnvNyfRukNxRbJJxFuzWiNQpF4gN3vCSsh3czexY4RVHn7Q==
X-Received: by 2002:aca:d9c5:: with SMTP id q188mr7914042oig.155.1604904987198;
        Sun, 08 Nov 2020 22:56:27 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 186sm2232310ooe.20.2020.11.08.22.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 22:56:26 -0800 (PST)
Date:   Sun, 08 Nov 2020 22:56:19 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        netdev@vger.kernel.org
Message-ID: <5fa8e81395e0f_2056c20834@john-XPS-13-9370.notmuch>
In-Reply-To: <20201106225402.4135741-1-kafai@fb.com>
References: <20201106225402.4135741-1-kafai@fb.com>
Subject: RE: [PATCH bpf-next] bpf: selftest: Use static globals in
 tcp_hdr_options and btf_skc_cls_ingress
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau wrote:
> Some globals in the tcp_hdr_options test and btf_skc_cls_ingress test
> are not using static scope.  This patch fixes it.
> 
> Targeting bpf-next branch as an improvement since it currently does not
> break the build.
> 
> Fixes: ad2f8eb0095e ("bpf: selftests: Tcp header options")
> Fixes: 9a856cae2217 ("bpf: selftest: Add test_btf_skc_cls_ingress")
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  .../selftests/bpf/prog_tests/btf_skc_cls_ingress.c   |  2 +-
>  .../selftests/bpf/prog_tests/tcp_hdr_options.c       | 12 ++++++------
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
