Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 935321299FD
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 19:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfLWS6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 13:58:46 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46804 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbfLWS6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 13:58:46 -0500
Received: by mail-pf1-f195.google.com with SMTP id n9so1726069pff.13
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 10:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:subject:cc:to:in-reply-to:references:message-id
         :mime-version:content-transfer-encoding;
        bh=lIkfNzutQK9Bj9rFooxKTKdVtXGyYz+rNewW1wA17Aw=;
        b=ZGATKd0RvWQI2HVDGWaXaF1TR+UcDeDd67KlLekeczpG7cwFRnGXX+CcE2QDpQbuXr
         I01VgASVpl30NQg+wOpaNyQnJLotUsIm87yQ5WQHWDzj7PInlFAtlOTFj8r6jr/QTHas
         9ONDjMD4qdj7WNTdTICNDMpBjmSUwnsDw4MmdWUFRAgSYkrjuR9so3KiNH/w6hN9AJxy
         ZW5DV3563cdYPpiDoN8IPypk0chtKfbfAXAAFoihgpO9NOSWcj2VOUrHdWndxCb7GRxG
         cVCOQpDbiOQJ3wkEsvFBiNVCfv6ezbs98a8s65hYlkVWDG+AKRc7+FwbEfzE/6GZYYnW
         JxjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:cc:to:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=lIkfNzutQK9Bj9rFooxKTKdVtXGyYz+rNewW1wA17Aw=;
        b=ljYz74OGQXQgqIED1I9IycEteAiGpIcsG5ARsNnGjZeJsgsx/mpBt5W1EfH8qp8NAR
         jQ+KFJiOxWRwB/XVr6znHGkdmysMk0qNzQRbjRTPNmb/K0PMDqQP9v7jCQ8cECq3Z3a3
         /7cMcxDj1YDMY31j9ESuI0SkEI/uJi/RzwbEjveY+YLZVqmuRbdDAgmHhA5LlK5jjdru
         pX3tdcKljQAoXTORabIMk4gQGD8xATKOd14A+DN6aF3475Wg6g68Gq6cAw2fiu0+25E1
         kZZTCZmVdTs+mY8Lw813MPwckllItlhUksw7cOI25SFbmPgN3DWWlTYw/wPPxBw5yaXe
         lr6Q==
X-Gm-Message-State: APjAAAUg1ioMEXrXW/bAR+4OXSVQ42QX9VLGWwyB/DKJ/3icu2Pr47Tx
        EgMoqUgugLJ7k9VgUFIs2eS42w==
X-Google-Smtp-Source: APXvYqy0KD1kPcm05h4K7KX8z3fMmvq6k8M8rPuQH7j0C79k0M9uYnWpV53namsUX3Ae63dG01BLwQ==
X-Received: by 2002:a62:6407:: with SMTP id y7mr34645171pfb.49.1577127525094;
        Mon, 23 Dec 2019 10:58:45 -0800 (PST)
Received: from localhost ([2620:0:1000:2514:7f69:cd98:a2a2:a03d])
        by smtp.gmail.com with ESMTPSA id p28sm23433216pgb.93.2019.12.23.10.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Dec 2019 10:58:44 -0800 (PST)
Date:   Mon, 23 Dec 2019 10:58:44 -0800 (PST)
X-Google-Original-Date: Mon, 23 Dec 2019 10:58:16 PST (-0800)
From:   Palmer Dabbelt <palmerdabbelt@google.com>
X-Google-Original-From: Palmer Dabbelt <palmer@dabbelt.com>
Subject:     Re: [PATCH bpf-next v2 8/9] riscv, bpf: add missing uapi header for BPF_PROG_TYPE_PERF_EVENT programs
CC:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org,
        Bjorn Topel <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org, bpf@vger.kernel.org
To:     Bjorn Topel <bjorn.topel@gmail.com>
In-Reply-To: <20191216091343.23260-9-bjorn.topel@gmail.com>
References: <20191216091343.23260-9-bjorn.topel@gmail.com>
  <20191216091343.23260-1-bjorn.topel@gmail.com>
Message-ID: <mhng-4cae5715-7736-45b9-911b-5281d60f576d@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Dec 2019 01:13:42 PST (-0800), Bjorn Topel wrote:
> Add missing uapi header the BPF_PROG_TYPE_PERF_EVENT programs by
> exporting struct user_regs_struct instead of struct pt_regs which is
> in-kernel only.
>
> Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
> ---
>  arch/riscv/include/uapi/asm/bpf_perf_event.h | 9 +++++++++
>  tools/include/uapi/asm/bpf_perf_event.h      | 2 ++
>  2 files changed, 11 insertions(+)
>  create mode 100644 arch/riscv/include/uapi/asm/bpf_perf_event.h
>
> diff --git a/arch/riscv/include/uapi/asm/bpf_perf_event.h b/arch/riscv/include/uapi/asm/bpf_perf_event.h
> new file mode 100644
> index 000000000000..6cb1c2823288
> --- /dev/null
> +++ b/arch/riscv/include/uapi/asm/bpf_perf_event.h
> @@ -0,0 +1,9 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _UAPI__ASM_BPF_PERF_EVENT_H__
> +#define _UAPI__ASM_BPF_PERF_EVENT_H__
> +
> +#include <asm/ptrace.h>
> +
> +typedef struct user_regs_struct bpf_user_pt_regs_t;
> +
> +#endif /* _UAPI__ASM_BPF_PERF_EVENT_H__ */
> diff --git a/tools/include/uapi/asm/bpf_perf_event.h b/tools/include/uapi/asm/bpf_perf_event.h
> index 13a58531e6fa..39acc149d843 100644
> --- a/tools/include/uapi/asm/bpf_perf_event.h
> +++ b/tools/include/uapi/asm/bpf_perf_event.h
> @@ -2,6 +2,8 @@
>  #include "../../arch/arm64/include/uapi/asm/bpf_perf_event.h"
>  #elif defined(__s390__)
>  #include "../../arch/s390/include/uapi/asm/bpf_perf_event.h"
> +#elif defined(__riscv)
> +#include "../../arch/riscv/include/uapi/asm/bpf_perf_event.h"
>  #else
>  #include <uapi/asm-generic/bpf_perf_event.h>
>  #endif

Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>
Acked-by: Palmer Dabbelt <palmerdabbelt@google.com>
