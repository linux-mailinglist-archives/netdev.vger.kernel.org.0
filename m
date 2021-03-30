Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0032F34EE00
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 18:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhC3Qf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 12:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbhC3QfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 12:35:00 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D36C061574;
        Tue, 30 Mar 2021 09:34:59 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id y1so20554208ljm.10;
        Tue, 30 Mar 2021 09:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qhg1AGLQpb57c6vcsn+mcC5e19hueOeeExZeb0/kg4Q=;
        b=Bk+3PDB3A4G8BvrNJ40dSC7WPDwA9IsS/6swjjaOe1XQ6ldBbi2tfWZbFqOetoSd55
         yImkLKh6UuV58u4lYh9H590ToKslO5IdMxcAVfEc/4gN5Ujvxdv29D5gvZcUwRSYE9Js
         wWjnyo1b2EQAMAAWIqpY/5fOOMtlgKPDLqJnryL3iiV2uEyXMfl0Yro+suDK6ZQdvOjU
         F7OcRM69pvfeK8btymnEawNC7hmuwMIgI1dEs8uurwDy8bOSVdEWVS1S46gZOP7hRDV9
         T2Cc4Sms+/rYji2Q0De20/f3U2+r/IJRLiIQdnqt5md+iX0qtBsTiESLGg/x6uUmEBXQ
         NbQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qhg1AGLQpb57c6vcsn+mcC5e19hueOeeExZeb0/kg4Q=;
        b=X7y8Y3puJx1FKFuTvrw+DaP2Jppu4oU56nPhBIUzC0ecSHilQaA/zzfWgO8/4UCjWq
         cEvozQXOpRY47dbcgHu5hFX92ZiO8HaxXPuhGLEYX23CAjrDWdFrGltSj0Bg7b+vCL1Z
         /HfzDRfEkKrSZ8u8EShz3M9/cTjQfmlHPlwYQa+ALVPqA+oFQwMIstQ84H54pxUZyyvI
         dfQk8lWsQxTd+Do+rYjPUe1OVSx1l0399OS48337xS3IUBBxBq4bk1pjZLft0GF6xT0n
         R5brzrTjk4M0wqWynPnv7p8ao8FDC2VU6NGQiAtwRWYfIFQ5HmlhSZ8kDASzx7m1slxK
         0vxA==
X-Gm-Message-State: AOAM532psnK/SVV4LO/a18FxH1fnMDOndNM7ce2d/oj6zXrl3hDIoKfP
        iW+9ygKROpDJNDOq4Sf9qQvx9xf6TBuLdRCQte4=
X-Google-Smtp-Source: ABdhPJystCBx/9HrK7PnXEfX7hMHU/eYHqSyimzZXjg+gJkIP+LhyGP5dmlL19+eki35NMA/EPiTEXJ5f94uT52MFPI=
X-Received: by 2002:a2e:3608:: with SMTP id d8mr21914928lja.21.1617122098335;
 Tue, 30 Mar 2021 09:34:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210329224316.17793-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20210329224316.17793-1-maciej.fijalkowski@intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 30 Mar 2021 09:34:47 -0700
Message-ID: <CAADnVQJtRaGwmL7Y-Ai8PQr96ABFPqheiGsY8bz7=YYGa24cHQ@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 00/17] AF_XDP selftests improvements & bpf_link
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Ciara Loftus <ciara.loftus@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 3:54 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> Changes since v4 (all in patch 6):
> - do not close potentially invalid bpf_link fd (Toke)
> - fix misspelling in label (Toke)
> - mask out XDP_FLAGS_UPDATE_IF_NOEXIST and XDP_FLAGS_REPLACE explicitly when
>   creating bpf_link (Toke)

Applied. Thanks
