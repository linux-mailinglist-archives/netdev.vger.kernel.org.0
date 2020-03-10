Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D66A180A0E
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 22:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgCJVLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 17:11:50 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:55894 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgCJVLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 17:11:49 -0400
Received: by mail-pj1-f42.google.com with SMTP id a18so945271pjs.5;
        Tue, 10 Mar 2020 14:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=K14BUJV6CDKrklCRtkE33FK7vOUxN2QDfL3nytk5XmE=;
        b=JQ/0GYeE6eO0Nws4qL4GwUmLziZ2CuRNQlqox8i6An9UH9PeH9rvhQ1xN6vUtg3O1n
         6BejyfokoH5o0Nl8zayp1cuj2Wiqa7BjQsgyqjJa714eswiPrJd4idFfLCZ2av7SyU1S
         YxWnw3tdU2R8kY5xI6T9jrfHQvLdXTfn/zyk9pQlHQqmC3UebMO6sqDZW0CugBAySUaj
         T8ig9VMK+C8POk537dHOFR0scpVg1bQ0H3BpFNG9pG13U/31Z185oM0N9APoFDWmaxcB
         MZkABAjS84b1YKzlddVUsDFL+PCG49y8g5CNKYQmmwhwufyJLfJy8Ot4OLKgv6ewJVHq
         MRCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=K14BUJV6CDKrklCRtkE33FK7vOUxN2QDfL3nytk5XmE=;
        b=afQKMlSk6/nSxWrtxRVjdI203Rj+wm7Yvr5c4uNrjHuLUKboqMPvex67PpYtFP0LFY
         sRpNq7yunrCX73YAohE3H2jxw67jA9u6+32Gfs8jWOrW9Qi15pfhdnchiy/1jC4ZM/Xe
         fyDWq8H/OQkoBDnHR4vB8ZUUTkDF6SAUHVDygQ6bm9wl7phUFL9HMLB2KhFULGtPeDgT
         cF5nUF448+SiS5iEsJ6Y339Z31rviYGbYdIjgiGc336+XLZJx2oroIEXt2x+SaFoqwEY
         ialUktQDZ2V5GvRb9mYfvx5/I+wg6Ic1A60HMBAmNtPIHbkmeG7yM4ibc6qua/5RMdYp
         fTKQ==
X-Gm-Message-State: ANhLgQ0eN/vHwmdUiYYuCdkKOHGtW/MScysJ4i9N5RfnVTEqaGobyjj2
        fMy7HXMXp7/wRi3aB1prjBm9Nvkx
X-Google-Smtp-Source: ADFU+vu08kN+egsr40JD3OIS1Nma1va/3dow+xVq2dcvgGIw4/gMQcpDMKd0kqgZ1jr8J0AF8BKlXA==
X-Received: by 2002:a17:90a:654a:: with SMTP id f10mr3645864pjs.50.1583874708615;
        Tue, 10 Mar 2020 14:11:48 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id u6sm46393943pgj.7.2020.03.10.14.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 14:11:48 -0700 (PDT)
Date:   Tue, 10 Mar 2020 14:11:40 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <5e68028c1257a_586d2b10f16785b86f@john-XPS-13-9370.notmuch>
In-Reply-To: <20200310055147.26678-2-danieltimlee@gmail.com>
References: <20200310055147.26678-1-danieltimlee@gmail.com>
 <20200310055147.26678-2-danieltimlee@gmail.com>
Subject: RE: [PATCH bpf-next 1/2] samples: bpf: move read_trace_pipe to
 trace_helpers
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel T. Lee wrote:
> To reduce the reliance of trace samples (trace*_user) on bpf_load,
> move read_trace_pipe to trace_helpers. By moving this bpf_loader helper
> elsewhere, trace functions can be easily migrated to libbbpf.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  samples/bpf/Makefile                        |  4 ++--
>  samples/bpf/bpf_load.c                      | 20 ------------------
>  samples/bpf/bpf_load.h                      |  1 -
>  samples/bpf/tracex1_user.c                  |  1 +
>  samples/bpf/tracex5_user.c                  |  1 +
>  tools/testing/selftests/bpf/trace_helpers.c | 23 +++++++++++++++++++++
>  tools/testing/selftests/bpf/trace_helpers.h |  1 +
>  7 files changed, 28 insertions(+), 23 deletions(-)
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
