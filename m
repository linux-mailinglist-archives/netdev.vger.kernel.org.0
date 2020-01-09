Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3B25135F47
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 18:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388111AbgAIR1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 12:27:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:51284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728444AbgAIR1j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 12:27:39 -0500
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 352B1206ED;
        Thu,  9 Jan 2020 17:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578590858;
        bh=G7fm2aOiqB15WSbDOO/6Efnwsn1ynfNPyOky+BBEQ/4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qM2IIu80AxrENYrbfam/fOuLNPJ6pzgGXGEgHkAzsIHa9xMOWdd02hKJXUL3iTXLO
         RiazmjbKSJI+qsxCX+cq6UxaucfW/IFSEw8ahTa2G8pvBBRO6D06omXkapxF1rvVdp
         G0BjVPo3llYrS4MyS55YSDw0fHmra6nEt7we0MjQ=
Received: by mail-qv1-f42.google.com with SMTP id dc14so3283150qvb.9;
        Thu, 09 Jan 2020 09:27:38 -0800 (PST)
X-Gm-Message-State: APjAAAUSxY5l9Zhl2420gA63XWS8h/HdDs5WfGCRvs7ygkdEG1o68bii
        Osmtk2KqoEqIv3BHg0ESVmxnyVYlFRjXxlvbmTA=
X-Google-Smtp-Source: APXvYqxIg/+n2oyOt0Rp23NunbNC2kRcjb63OfcVyITyeUcfnPpEa+f+sOLPb+6AEZJzO0q/Xz0DQhEFRS1VZXDIqkw=
X-Received: by 2002:ad4:580b:: with SMTP id dd11mr9694536qvb.242.1578590857321;
 Thu, 09 Jan 2020 09:27:37 -0800 (PST)
MIME-Version: 1.0
References: <20200109063745.3154913-1-ast@kernel.org> <20200109063745.3154913-8-ast@kernel.org>
In-Reply-To: <20200109063745.3154913-8-ast@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Thu, 9 Jan 2020 09:27:26 -0800
X-Gmail-Original-Message-ID: <CAPhsuW67HfWZ7JLMWtXSURc97SSP4MOT7d65F+r075qGqpW9Cg@mail.gmail.com>
Message-ID: <CAPhsuW67HfWZ7JLMWtXSURc97SSP4MOT7d65F+r075qGqpW9Cg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 7/7] selftests/bpf: Add unit tests for global functions
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 8, 2020 at 10:39 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> test_global_func[12] - check 512 stack limit.
> test_global_func[34] - check 8 frame call chain limit.
> test_global_func5    - check that non-ctx pointer cannot be passed into
>                        a function that expects context.
> test_global_func6    - check that ctx pointer is unmodified.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  .../bpf/prog_tests/test_global_funcs.c        | 81 +++++++++++++++++++
>  .../selftests/bpf/progs/test_global_func1.c   | 45 +++++++++++
>  .../selftests/bpf/progs/test_global_func2.c   |  4 +
>  .../selftests/bpf/progs/test_global_func3.c   | 65 +++++++++++++++
>  .../selftests/bpf/progs/test_global_func4.c   |  4 +
>  .../selftests/bpf/progs/test_global_func5.c   | 31 +++++++
>  .../selftests/bpf/progs/test_global_func6.c   | 31 +++++++
>  7 files changed, 261 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_global_func1.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_global_func2.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_global_func3.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_global_func4.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_global_func5.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_global_func6.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c b/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
> new file mode 100644
> index 000000000000..bc588fa87d65
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
> @@ -0,0 +1,81 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Facebook */
> +#include <test_progs.h>
> +
> +const char *err_str;
> +bool found;
> +
> +static int libbpf_debug_print(enum libbpf_print_level level,
> +                             const char *format, va_list args)
> +{
> +       char *log_buf;
> +
> +       if (level != LIBBPF_WARN ||
> +           strcmp(format, "libbpf: \n%s\n")) {
> +               vprintf(format, args);
> +               return 0;
> +       }
> +
> +       log_buf = va_arg(args, char *);
> +       if (!log_buf)
> +               goto out;
> +       if (strstr(log_buf, err_str) == 0)
> +               found = true;
> +out:
> +       printf(format, log_buf);
> +       return 0;
> +}

libbpf_debug_print() looks very useful. Maybe we can move it to some
header files?

Thanks,
Song
