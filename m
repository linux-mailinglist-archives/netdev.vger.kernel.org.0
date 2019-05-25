Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 155EC2A26E
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 04:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfEYC5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 22:57:32 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40168 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbfEYC5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 22:57:32 -0400
Received: by mail-lj1-f194.google.com with SMTP id q62so10237833ljq.7;
        Fri, 24 May 2019 19:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=riyApgsTYeHf2zY9V/AMEGkb7h3Dl4SpcWBAI87ws7o=;
        b=Cr2EYgUjkeLHCtvqjSOGW9oFUeSPO02ig9NkKOBRRNy0fICJ7Ng/0FaVg2RY/yn8+m
         fz1gqwEe5Nghmb5/L0O5hssEIMkWS1e+FyPTKJK9O30frk2ZuXUF4A7Sv0KDahcfE8zk
         YtliVApzcXpsSSdDiNfKn6Sw5q+kJFunCzZVbDdOtbLiZwofrEhlj/bp58LcT/3UnmF0
         2/ydota/TCeN+DqRA829wZP16pG24a5l/A9vt+NrcUhcK1FAB9OpXT6DXYRCXKa5H0+K
         2rBqm9geg/dPXJDCyYojiykzXs+Q4uq2kfpSoHY55opQgPFJZNGpg74TUPicJdisQ2Ei
         eBvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=riyApgsTYeHf2zY9V/AMEGkb7h3Dl4SpcWBAI87ws7o=;
        b=SV/bm9xe+oglb96lZKDhl3ETHKm19yf2hrQqWNfwRTH/IXVqwvg/+8YNINRPB7/woN
         JIh7PmJpoMbULffmtpSyhbw+PXp4vRMd5y89fj2hXddpiYqr33hfZ8rkatvS5H08ibhU
         QRvDSnqJ4Yzw3KmrSz3/Qud/5JS8LhGUbFlNsc8CeLKyygGRJLYbfXOxaTIXh8wsV4b9
         u6oloT8zVsHRgxD9Sz9Bbn07g/ID+HIwz+NvDIa4TJonvhLaXzW0Zkk+droPIOVuvoNs
         2wV9PGbaOy96p7tPkAzGiIYfsFz5xH7hPBFy9EzNhc1V5lY0gq4WcFO/Yi4bLi8OcwIw
         zkRQ==
X-Gm-Message-State: APjAAAUnN3NaxC91uy5bz6/PCQFpbDAXp6Gp94L1HJT/FDXKHCIovS1K
        N/weBK+6J1w0iSLdu9uz0RzMhqo5aH5Tllo5jqc=
X-Google-Smtp-Source: APXvYqxnGOe4vLPIZGxJNiD7SeAsy+hRtoTVLawKiMP0eSxVoqpe33uxazI46OQ4KvRMCNOsqH+AWDLowdcftJ0FSLQ=
X-Received: by 2002:a2e:96d7:: with SMTP id d23mr1867375ljj.206.1558753049339;
 Fri, 24 May 2019 19:57:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190524235156.4076591-1-guro@fb.com>
In-Reply-To: <20190524235156.4076591-1-guro@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 24 May 2019 19:57:17 -0700
Message-ID: <CAADnVQK7uukL5=S=96BrU7YOyxidA4Pnm3rPRoGy45bJU=_8tA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 0/4] cgroup bpf auto-detachment
To:     Roman Gushchin <guro@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Kernel Team <kernel-team@fb.com>,
        "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Yonghong Song <yhs@fb.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 4:52 PM Roman Gushchin <guro@fb.com> wrote:
>
> This patchset implements a cgroup bpf auto-detachment functionality:
> bpf programs are detached as soon as possible after removal of the
> cgroup, without waiting for the release of all associated resources.
>
> Patches 2 and 3 are required to implement a corresponding kselftest
> in patch 4.
>
> v4:
>   1) release cgroup bpf data using a workqueue
>   2) add test_cgroup_attach to .gitignore

There is a conflict in tools/testing/selftests/bpf/Makefile
Please rebase
