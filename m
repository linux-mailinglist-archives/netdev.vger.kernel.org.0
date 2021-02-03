Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E29230E501
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 22:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbhBCVck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 16:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbhBCVcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 16:32:32 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC3DC0613D6;
        Wed,  3 Feb 2021 13:31:51 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id g9so664169ilc.3;
        Wed, 03 Feb 2021 13:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=7GrgHNpUFSgq2Ni0af/cRNZE8SE1LdkzocQjKexWFf4=;
        b=DUV3yG8sqNTrWl4rS+DcJqE/BrN/d5N/9a4M9ndqnxVqKvM2LTmIqocbKiLRYLDGuG
         RYqrYQZ7L14+Nf3YH14kT44DEdyz8KEUpnpy1EyaLdle6X2aoybUCXHsNnuvnvb1CbR6
         M2/qsgspPW7xk/JpIdc/182M9a0cqovaCaa4ynfIYQgHocYaU7lu2HpBpLYgp8rpdUl0
         XjqZoAF1ysBNsH9KLhanzmM7bPNMkoPVj74cluXl294BsZRcj3y/BpU9esalj74iLLts
         dIRCIvJcptcndR/e9h99dkOrckYNYoYKb8zd+fTQ8vpdYWPSG3IueKVUfLzmjAgUSb1E
         kuxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=7GrgHNpUFSgq2Ni0af/cRNZE8SE1LdkzocQjKexWFf4=;
        b=mDfnnNoQLL0ZAPKTXdB0jgvEI4zbnnwGbg0nWzd/K0U5mKJz1Hn/2C9MTJtidycK1v
         kLX/Q9KLF3LXJTFo/nQt1vMesV1dN7+1f13n2alhfMKvvoPY0I5QSRhUVXNyCFY4Cy+M
         a9pbQ3CTom+xojcMT++PMAQJCJga+BhRFH2rPoz+77fwyIUNAV0y04BYRKW8vcs28iNa
         52qadGrL0PumdNb5Vyrhw3RQwh2N0SLxugDuiitMt74hZ2HVffLHOSCesBtgRXLuxyiG
         kHODcTiozbCwIFP3gXZJRjkA86ONzJ9dPjw30Wv5seJNgG/NpX8rDKsupdFIF9oXaix4
         O13g==
X-Gm-Message-State: AOAM530SUBUGPtoaJGf9CB0ePUbtQOEpq6B61BqDllBJt+fdfHIavEnt
        cehHTp2hEgvP7CP0Vjjcqtg=
X-Google-Smtp-Source: ABdhPJypEUGK8gFQ/ByMHquSna5ZkgdMB3KpxCstu57nFna1iL1N9W8EsAaKnfrlwRQ5hpcKsf/sPQ==
X-Received: by 2002:a92:130e:: with SMTP id 14mr4087442ilt.58.1612387911142;
        Wed, 03 Feb 2021 13:31:51 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id q25sm1640046iob.7.2021.02.03.13.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 13:31:50 -0800 (PST)
Date:   Wed, 03 Feb 2021 13:31:42 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii@kernel.org, kernel-team@fb.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>
Message-ID: <601b163e1bc2b_4e26f20898@john-XPS-13-9370.notmuch>
In-Reply-To: <20210203203445.3356114-1-andrii@kernel.org>
References: <20210203203445.3356114-1-andrii@kernel.org>
Subject: RE: [PATCH bpf-next] libbpf: stop using feature-detection Makefiles
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Libbpf's Makefile relies on Linux tools infrastructure's feature detection
> framework, but libbpf's needs are very modest: it detects the presence of
> libelf and libz, both of which are mandatory. So it doesn't benefit much from
> the framework, but pays significant costs in terms of maintainability and
> debugging experience, when something goes wrong. The other feature detector,
> testing for the presernce of minimal BPF API in system headers is long
> obsolete as well, providing no value.
> 
> So stop using feature detection and just assume the presence of libelf and
> libz during build time. Worst case, user will get a clear and actionable
> linker error, e.g.:
> 
>   /usr/bin/ld: cannot find -lelf
> 
> On the other hand, we completely bypass recurring issues various users
> reported over time with false negatives of feature detection (libelf or libz
> not being detected, while they are actually present in the system).
> 
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  tools/lib/bpf/.gitignore |  1 -
>  tools/lib/bpf/Makefile   | 47 ++++------------------------------------
>  2 files changed, 4 insertions(+), 44 deletions(-)

I've also hit these annoying cases at least once or twice.

Acked-by: John Fastabend <john.fastabend@gmail.com>
