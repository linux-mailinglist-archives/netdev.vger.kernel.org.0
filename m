Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1393B1CB7D0
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 20:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgEHS5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 14:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726767AbgEHS5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 14:57:47 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E440FC061A0C;
        Fri,  8 May 2020 11:57:46 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id v4so1297237qte.3;
        Fri, 08 May 2020 11:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jxO+pH/N35DwgKEyBMR2PYvJOCsnH0+2WAj3aF0qPSI=;
        b=NX9AW+2cDGWZRtR89zsewiKCJcImunIGDdlKEFYKyJl6k0tsO+/EOA2Ynok7J9lLGl
         VgDHcOnCvnNSegAtBjc4IKzrG3MrfF944jNKkqO2NFRnB7LYVFQp47/SLCo66FT7iwYI
         OZGGiOgbtKlT54kGIOO+XtOSWjZKA8NGFuBo7F2qW/bcMrX6LmdpdRpnD428zRbUcr/V
         +qYgABsvfOiyM5iPh1WIbN21el2b2Xgy663Wa8NnOyXB4BYYA97kyVfNW9iLfrHJ2xeU
         7kw0LHCD2sPSNmO1k7ua+FY1yEqxxvGCcLymiE7UwOBx6hBHXP0TO8axZ+/BxHPTYhmi
         aXcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jxO+pH/N35DwgKEyBMR2PYvJOCsnH0+2WAj3aF0qPSI=;
        b=FbHDVeEtEMNgysYZy7VhLkyTIaUwPjKkn1BSyvBHUoYy2KM/niBRSiB0dDO4L3q6lb
         EMKhr7yPLoAKlkvYgJbGOgtd4+diffi/ZREYsKQLU2Sn/0jx2P/oYKwmsCTNI5abMPeA
         DEANv4MMRGC0CMjQB1o7iBD6igvPEuXB2ZIWBxvVBHbDUUVr/HVA5dF70tYkebUUCboF
         TtQhTRgYV6/3IdwLcZ30YEgtHlEL1iR0C+fHQRIkZlhYkix3zJ/9C33unbGGi/JRx4OE
         swcRObWcnrX/xrtVD2iiqGmTYIYOGY8GoD2/9KFaBjuGOIFHB7BhzxfY4p9HEH6fkodH
         URhQ==
X-Gm-Message-State: AGi0PuZ054dJ8fdWyE71rINRA/nv+t03VP1/ujQc3OW6cn3qamnfECOU
        iCYTlHktxC/bP33N2RPyJkZQqICyaqobMDlF+eD3XUpH
X-Google-Smtp-Source: APiQypK8Rw5SEScTa+vdZaEkW0xOBbW8J8EUXc2QA/y1xSHbqlNO3ZGLgm+b5sgiSqFB3+95bNgBQm+5JXNeadiuO84=
X-Received: by 2002:ac8:51d3:: with SMTP id d19mr4399390qtn.141.1588964265996;
 Fri, 08 May 2020 11:57:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200507053915.1542140-1-yhs@fb.com> <20200507053921.1542958-1-yhs@fb.com>
In-Reply-To: <20200507053921.1542958-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 May 2020 11:57:34 -0700
Message-ID: <CAEf4Bzb8YhqZM4UM8z3kYRLYCFsk96rdPCkK9JT2ZpkL9KGn2w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 06/21] bpf: create anonymous bpf iterator
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 10:39 PM Yonghong Song <yhs@fb.com> wrote:
>
> A new bpf command BPF_ITER_CREATE is added.
>
> The anonymous bpf iterator is seq_file based.
> The seq_file private data are referenced by targets.
> The bpf_iter infrastructure allocated additional space
> at seq_file->private before the space used by targets
> to store some meta data, e.g.,
>   prog:       prog to run
>   session_id: an unique id for each opened seq_file
>   seq_num:    how many times bpf programs are queried in this session
>   done_stop:  an internal state to decide whether bpf program
>               should be called in seq_ops->stop() or not
>
> The seq_num will start from 0 for valid objects.
> The bpf program may see the same seq_num more than once if
>  - seq_file buffer overflow happens and the same object
>    is retried by bpf_seq_read(), or
>  - the bpf program explicitly requests a retry of the
>    same object
>
> Since module is not supported for bpf_iter, all target
> registeration happens at __init time, so there is no
> need to change bpf_iter_unreg_target() as it is used
> mostly in error path of the init function at which time
> no bpf iterators have been created yet.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf.h            |   1 +
>  include/uapi/linux/bpf.h       |   6 ++
>  kernel/bpf/bpf_iter.c          | 129 +++++++++++++++++++++++++++++++++
>  kernel/bpf/syscall.c           |  26 +++++++
>  tools/include/uapi/linux/bpf.h |   6 ++
>  5 files changed, 168 insertions(+)
>

[...]
