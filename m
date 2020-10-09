Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3A12898C7
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 22:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391570AbgJIUIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 16:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391698AbgJIUHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 16:07:41 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44ACC0613DD;
        Fri,  9 Oct 2020 13:06:31 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id l16so10278500ilt.13;
        Fri, 09 Oct 2020 13:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=YZkhJ3zLL3unnY2khtCvmLdTmx+8lDPbcz5UWxUwniw=;
        b=Oeu8a+jw3ev7MAOvRVTpbMfI9veQqql0gprJSq2RkA+bfwldDqEq7Kpr21KGexB0so
         ElFlJygzUTm8KocSFdKxd2ATb4ldsgkaDmjsoyxoxHMQH36vrbxxFlIme8Zi7zSavTXY
         xG6u/lssUUYomhVDpTBYi9W7RuSLK9ri67OnMMnYhwd9ududQtz5hEKchvxsraK46JuJ
         +7MALPirq2CsWwmyTXSWCzl9/O1WkDHCKM5LLLts94PjkxwfSefuPMlu+NnKe938TtRD
         A0wiB47Tbup+Tnbo74YR7eYnnWWHODBxOONVFLGw5400MU6sZEz243QfqT9C7EX/oTrP
         eBKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=YZkhJ3zLL3unnY2khtCvmLdTmx+8lDPbcz5UWxUwniw=;
        b=eTElh+D17XRLfN65XL5yQnEWv6GrUJ0V28sN898n0Fm2UiQUGsRhC1ttmvI/lfzG2m
         4iVjhmF+zJhQt/eqQZmDLxitBmHsTTo2gAXOgjS0t1pEvhqiyD/a2n+mxzfwTaoSqqlN
         zl3tLWY/DakqDhMUirtd8N4734YKUc7m2T4XsdjZ+PAmtKscN8HZZ9yKczDfDaYdaQVP
         ceCDqxI7+NsWfMD/+1B5eNxjqjimHA3aHLKBmlncdMUmry88GQGDZObRnxsaj4NoN55/
         QI/moXPA0upTbpjtPn5DWwtZPVRGziUwJ5k8afDkVCg/thB5jOYc1IL/dVBQImZOVuwq
         hqBA==
X-Gm-Message-State: AOAM531deZ7BTKck+qm7Dj9w2htrOLE+WXzaybBRZ5ioTSm83DgGrPIf
        Iwo9dzkZIQahpWnvyBaZ18A=
X-Google-Smtp-Source: ABdhPJzR9dLH1fWQ6sFv99rqMEKbzjNJKrSR4muSdwWnGbyEMpd8lRnEuu8dQf/dH2mokFvh9ha0ig==
X-Received: by 2002:a92:ddcb:: with SMTP id d11mr12268425ilr.228.1602273991264;
        Fri, 09 Oct 2020 13:06:31 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id c9sm2035612iow.1.2020.10.09.13.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 13:06:30 -0700 (PDT)
Date:   Fri, 09 Oct 2020 13:06:22 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Message-ID: <5f80c2be10b0d_ed742081f@john-XPS-13-9370.notmuch>
In-Reply-To: <20201009011240.48506-5-alexei.starovoitov@gmail.com>
References: <20201009011240.48506-1-alexei.starovoitov@gmail.com>
 <20201009011240.48506-5-alexei.starovoitov@gmail.com>
Subject: RE: [PATCH v2 bpf-next 4/4] selftests/bpf: Asm tests for the verifier
 regalloc tracking.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Add asm tests for register allocator tracking logic.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  .../testing/selftests/bpf/verifier/regalloc.c | 243 ++++++++++++++++++
>  1 file changed, 243 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/verifier/regalloc.c
> 

I'm writing some extra tests now for a few things so I'll probably also add
some to track the bounds for non-const through stack spill today or
monday.

Acked-by: John Fastabend <john.fastabend@gmail.com>
