Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C29B314855D
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 13:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388732AbgAXMqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 07:46:00 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40901 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388692AbgAXMqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 07:46:00 -0500
Received: by mail-lj1-f193.google.com with SMTP id n18so2340515ljo.7
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 04:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=4XkP3XLOh0nhayuHg8yQANWqL4XcErc8i0KEhWGVI5w=;
        b=pJ2traqMIEBz89vTlCvmqNCjxA0dgLCemW0DuwXv7HCJPmpmz4D6FQXOIJuwcmkWVN
         ZBsAd3wxZtIAiDigSmxi4/m2a+Ck2JgKflDV1wiFmhJ5b4QMcPRMfoBaO6bthqhrYYyE
         xbxi52IMmgUdz4EX8iXPFUp9Yl2u6w3xkBHCk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=4XkP3XLOh0nhayuHg8yQANWqL4XcErc8i0KEhWGVI5w=;
        b=FvzP/hvW14Bx3DUIhCQtqQW9bdpj5zgOukqt+gdclKERM8Z/MA1Z+zI3COqynr4DDG
         ufC46+7f8H47gsWdbUEwuuNFmv+cq0fWqJGicLE2Aw4qyAWbSzkOX32NtObWA+KCGFjb
         6m6BrTn7OT0q0VJ/PJKnEwZhdvTGcYA4DU9fKAIvYajFpNjJPJr4ILnNGl4AokVhfURF
         YmQFD9pbB04/EPyHTB2H/wkS7qlrK5hZqTSkNNAIJF54V9TJHt/VBGoePy/crvZdBdph
         6CvzhCBadR0ieu9Pj715ts5/ZdqROwqfjACleVU1M/AubRWO5xZP60iFyQuuH5hL+/9V
         qqaA==
X-Gm-Message-State: APjAAAXmxwICKLRrrbRZ9oZXfbjCbf77AJ1kdTYqljq2AKrbhms8zGL7
        stJRRFP9jcj1x6knwABJvAcEtQ==
X-Google-Smtp-Source: APXvYqxSA7g27hjTyBey14Cy6XKoiAAJfwkh7rb8FJPBpBaJm+8bvoRFgntL7BvazURh9RFylGJtng==
X-Received: by 2002:a2e:9804:: with SMTP id a4mr2011803ljj.10.1579869957666;
        Fri, 24 Jan 2020 04:45:57 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id s2sm3001343lji.53.2020.01.24.04.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 04:45:56 -0800 (PST)
References: <20200123165934.9584-1-lmb@cloudflare.com> <20200124112754.19664-1-lmb@cloudflare.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 0/4] Various fixes for sockmap and reuseport tests
In-reply-to: <20200124112754.19664-1-lmb@cloudflare.com>
Date:   Fri, 24 Jan 2020 13:45:55 +0100
Message-ID: <871rrp2fb0.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 24, 2020 at 12:27 PM CET, Lorenz Bauer wrote:
> I've fixed the commit messages, added Fixes tags and am submitting to bpf-next instead
> of the bpf tree.
>
> There is still the question whether patch #1 needs to preserve O_RDONLY, which John
> can hopefully answer.
>
> Lorenz Bauer (4):
>   selftests: bpf: use a temporary file in test_sockmap
>   selftests: bpf: ignore FIN packets for reuseport tests
>   selftests: bpf: make reuseport test output more legible
>   selftests: bpf: reset global state between reuseport test runs
>
>  .../bpf/prog_tests/select_reuseport.c         | 44 ++++++++++++++++---
>  .../bpf/progs/test_select_reuseport_kern.c    |  6 +++
>  tools/testing/selftests/bpf/test_sockmap.c    | 15 +++----
>  3 files changed, 49 insertions(+), 16 deletions(-)

For the series:

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
