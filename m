Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8488B3228AD
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 11:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbhBWKNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 05:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbhBWKNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 05:13:47 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0143BC061574
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 02:13:01 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id h125so10323406lfd.7
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 02:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J/LuwTXoQO6jvKbzdrCDlo4TVXiV1s6U/zT2nfH4wUo=;
        b=FPv96nKrO3ZcNri+Ayz2U12l2pEPI/lw0/tV7tLSR3XfC/LRI7gNshjvChWIVBHTCe
         BI5/1feI2Ws1J5Dn/U7X5l55dsH0HirpU7aDqLPE5WPdY6KMzyeLjdPTqcyLrgF4FFyS
         VwbhoW4938AyHp0cRXnyeanZcov/zDW+aDsFY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J/LuwTXoQO6jvKbzdrCDlo4TVXiV1s6U/zT2nfH4wUo=;
        b=rX3NaVHAeUvjC38ixiWWejyJW2r5vO93eQc1QnkJxQ0A48QU9B3/MgmqtVec9p0K4N
         StcpSjyAkUJqeal9h/JCW/OMYvOh0jYFrJo0RmEVKL1V4tHeBNLI8ggw42DEknI9gV44
         YG0CnJ4DFeHCiBV6rkglVagDMmcbnGoia5a8FQ28cqCcXshy0igCiJyf5CAlEdN1MZFC
         X172HeOUJWETwIkU3s3MpGDop55fVmZ/czxgStJcrn+R/RzftvgOphLhdIAuQkAXfRWM
         XuVRTaZQXMczvWLkxDmW4H0hxgfVG7A3it5QWWeTch+Jbaf2h2lEquEhk0gJCsdZc7Q+
         VTqQ==
X-Gm-Message-State: AOAM533+8lDYIhO1z+BvKSDImZgSiODfIwPzJ3CbYN5ktdmmyWHkiuKl
        ow2umTahaf9siPbnXko3327fA8WQnc47vx7PPsKGzw==
X-Google-Smtp-Source: ABdhPJwp2c34zaYgmMqQNop0GDw3Dz3h2Gyz1Ym94wDGqDMGBmWfcLJvfeUOyxvf7JEqLJKTDEHFuUKJvUW0XK6MpDc=
X-Received: by 2002:a05:6512:22c9:: with SMTP id g9mr16966939lfu.325.1614075180451;
 Tue, 23 Feb 2021 02:13:00 -0800 (PST)
MIME-Version: 1.0
References: <20210216105713.45052-1-lmb@cloudflare.com> <CAEf4BzYuvE-RsT5Ee+FstZ=vuy3AMd+1j7DazFSb56+hfPKPig@mail.gmail.com>
In-Reply-To: <CAEf4BzYuvE-RsT5Ee+FstZ=vuy3AMd+1j7DazFSb56+hfPKPig@mail.gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 23 Feb 2021 10:12:49 +0000
Message-ID: <CACAyw98gTrzf8+cPnBEC5A3_rg70UUrJxtV9a_w-dMpKn0Wicg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/8] PROG_TEST_RUN support for sk_lookup programs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        kernel-team <kernel-team@cloudflare.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Feb 2021 at 07:29, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> Curious, is there any supported architecture where this is not the
> case? I think it's fine to be consistent, tbh, and use int. Worst
> case, in some obscure architecture we'd need to create a copy of an
> array. Doesn't seem like a big deal (and highly unlikely anyways).

Ok, thanks! I'm not super familiar with C platform differences, so I wanted
to be on the safe side. I'll take this up depending on the outcome of the
conversation with Alexey, maybe I don't need to add this after all.

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
