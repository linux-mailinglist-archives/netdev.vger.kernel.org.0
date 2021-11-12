Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F8B44EC90
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 19:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235331AbhKLS1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 13:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhKLS1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 13:27:49 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CCBC061766;
        Fri, 12 Nov 2021 10:24:57 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id m15so4842691pgu.11;
        Fri, 12 Nov 2021 10:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mkt6AP+n99P3mfOBMyYypO8TZsZpPPI9SiuJAVZuQWg=;
        b=XCGCUKQ+AbklpSSJrDxAj6X8ruoZZojsmv1PC4IDv2bxPxm//jd4nxutDzp73co98y
         H2z36YuxeXHfdVi0/BUpIYEef4hvjXhoRauLijTMgteFiP3/8eHxXMk8tpglskPMllVT
         geLxrIuq/jyApw2TZsCNiZIX2/+y7WW7KZ9C3CgfsbtoACoy1zk9BNJgDM/B2vMPFA0z
         pmLDe44f6aytnmQP3PQ9Z55MTiarwjJ0g/wmvsw5fJWli+k3BPDxT9Ppy+1stMUxhyts
         lfcMHMQNJuLbYa7fUkwHHmsjMTkzMkd3bcD1jdv1kAzq1TRFkra25iy10KToic8YXMMp
         p3aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mkt6AP+n99P3mfOBMyYypO8TZsZpPPI9SiuJAVZuQWg=;
        b=LtQJQ7LJh9XO4jtsNHlGdve0bDijGx00DJ37BS/mJWDeibOcIZuQPHU/NGs8ZNZIhv
         2SHPo5BQUyOtkktz+q6kZhOWV9dNCQLEMOjyKMrZWiBbnCytPJe5dQmxy/ZfKhMut6Qd
         81d1X2RM1LT55DCx1H85bmMIlhZakQ0gYulz5vR3V7CLSaoDmKfjX/wO5Z5byTLVj0xN
         Vo97F8A7DX4ywFXax+jel3W8YNnP+1xfUpfkT8Nyn/j+Zy2OD8K3/HEZWaUuvPFCidEp
         SrmQula54ladxkVeanc2EG/+gWCGqww5t7Rgg5bqBzuudQWHAbS74MvPfy3077HidkNe
         fakQ==
X-Gm-Message-State: AOAM531rliAkL7Yjb51qbpM1m3wVb7BVqRZxwoW63GoymuH7ZPQLTZWA
        Vm3scJdhL3ojR63b6YGVURpGklXX1iloWvxBWTA=
X-Google-Smtp-Source: ABdhPJwhD98FKUZrvKr9N3YT0ZyqZYGzhmlIyLot9V0ah5IFVT+VDzc/z/7lSVIafa0vCb8FFUkC5PB7LgHfJUggU4Q=
X-Received: by 2002:a05:6a00:1583:b0:49f:dc1c:a0fe with SMTP id
 u3-20020a056a00158300b0049fdc1ca0femr15664027pfk.46.1636741497032; Fri, 12
 Nov 2021 10:24:57 -0800 (PST)
MIME-Version: 1.0
References: <20211112150243.1270987-1-songliubraving@fb.com>
In-Reply-To: <20211112150243.1270987-1-songliubraving@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 12 Nov 2021 10:24:45 -0800
Message-ID: <CAADnVQ+YSGFqJyJUq+obYkTqTVpmFSeM499wsZoHf-p4=FP_5A@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 0/2] introduce btf_tracing_ids
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 7:07 AM Song Liu <songliubraving@fb.com> wrote:
>
> Changes v2 => v3:
> 1. Fix bug in task_iter.c. (Kernel test robot <lkp@intel.com>)
>
> Changes v1 => v2:
> 1. Add patch 2/2. (Alexei)
>
> 1/2 fixes issue with btf_task_struct_ids w/o CONFIG_DEBUG_INFO_BTF.
> 2/2 replaces btf_task_struct_ids with easier to understand btf_tracing_ids.

Applied. Thanks
