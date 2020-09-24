Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961A82765D6
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgIXB2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbgIXB2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 21:28:30 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF2DC0613D1
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 18:20:01 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id s88so1486158ilb.6
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 18:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TMWuBC4tRmsRpp4tOqDs8M5DMoiKXZzShTqcZzqc5eM=;
        b=o2IuKA1/+NBH2QcyaxCnlHJ3WW0ycZ2vhiowgChUevwqlMjwxvXE/1W0YaZOeRXEZf
         yzH+JK37TMpOsFRBQ6ximrz3lCSz3ricrWXF1ce0Z8Fm8Y3wSyiAP2zuFu7Ty9Zo/lr+
         qvBgKdSaqoup+kgJVhbaUqF8D2g67oJX1quhnPnuvMGlG9O1Rsom4Yd794BSWVzYWt3N
         Ko3DVagfdUTqIWIEQ4ydDnuZECgPOWRKdRoTtT2q1fbF7ZrNvvRXo0LyIIRm5JQPWuu7
         EWshhk5r/Sim6J3ZQYN8yVsLqX13/RTB1CyVrgm5H1HuuAnT8QMVKEF3v4zeGZlLyTvk
         4IRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TMWuBC4tRmsRpp4tOqDs8M5DMoiKXZzShTqcZzqc5eM=;
        b=SIctPji8IYJn29xnfGoeLnLn6aSEFO4rWomzu7xhw/Q/+qIasiL9cG1JBTEjoFZKic
         AMfsC+wmZcFWumq7UphO+cSbXhiUrtD7yjOIL1VOhrbjdAuQwIISTch4nZK0fhnsLy86
         iG+fAzSXCPg9bFrvdowwtBs3W0CtkjwaPkNLF/7OIhBbwamx5Q+HFIGOXqihRXz7M6vc
         NORcEmYVNDhLLM1gQLiIm9iRD7foLJFwWxkxLATgma3Nd6d9NZgToFNvs7xyfGvERUJB
         eKjhG0YOB5hyOAs93wKJwsi62p4sysmOa8GC4fnHvAXnhN0cU7ha24VD9qOI+Jh6Emk1
         tygw==
X-Gm-Message-State: AOAM532RT7VoHWS1Fof7KuHrWIVPJo4Y+y0McRtIvE7dptJok4V00baB
        3ROuWEDt+zaz5MFLmUkwGIGnKiQNuTqp1wNfCVCiHg==
X-Google-Smtp-Source: ABdhPJxTYLEtSQufGMvGFPH/rXFygkckRxUmLxfSdKUrEqqkRtY7nzaH0Ey8ZYuG4x3ixZC3ijaK++RJOxz6jxEtUbA=
X-Received: by 2002:a92:1503:: with SMTP id v3mr2074505ilk.56.1600910400137;
 Wed, 23 Sep 2020 18:20:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200924000326.8913-1-bimmy.pujari@intel.com>
In-Reply-To: <20200924000326.8913-1-bimmy.pujari@intel.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Wed, 23 Sep 2020 18:19:48 -0700
Message-ID: <CANP3RGf-rDPkf2=YoLEn=jcHyFEDcrNrQO27RdZRCoa_xi8-4Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/2] bpf: Add bpf_ktime_get_real_ns
To:     bimmy.pujari@intel.com
Cc:     bpf <bpf@vger.kernel.org>, Linux NetDev <netdev@vger.kernel.org>,
        mchehab@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, ashkan.nikravesh@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 5:03 PM <bimmy.pujari@intel.com> wrote:
>
> From: Bimmy Pujari <bimmy.pujari@intel.com>
>
> The existing bpf helper functions to get timestamp return the time
> elapsed since system boot. This timestamp is not particularly useful
> where epoch timestamp is required or more than one server is involved
> and time sync is required. Instead, you want to use CLOCK_REALTIME,
> which provides epoch timestamp.
> Hence add bfp_ktime_get_real_ns() based around CLOCK_REALTIME.
>
> Signed-off-by: Ashkan Nikravesh <ashkan.nikravesh@intel.com>
> Signed-off-by: Bimmy Pujari <bimmy.pujari@intel.com>
> ---
>  drivers/media/rc/bpf-lirc.c    |  2 ++
>  include/linux/bpf.h            |  1 +
>  include/uapi/linux/bpf.h       |  8 ++++++++
>  kernel/bpf/core.c              |  1 +
>  kernel/bpf/helpers.c           | 13 +++++++++++++
>  kernel/trace/bpf_trace.c       |  2 ++
>  tools/include/uapi/linux/bpf.h |  8 ++++++++
>  7 files changed, 35 insertions(+)
>
> diff --git a/drivers/media/rc/bpf-lirc.c b/drivers/media/rc/bpf-lirc.c
> index 5bb144435c16..1cae0cfdcbaf 100644
> --- a/drivers/media/rc/bpf-lirc.c
> +++ b/drivers/media/rc/bpf-lirc.c
> @@ -103,6 +103,8 @@ lirc_mode2_func_proto(enum bpf_func_id func_id, const=
 struct bpf_prog *prog)
>                 return &bpf_map_peek_elem_proto;
>         case BPF_FUNC_ktime_get_ns:
>                 return &bpf_ktime_get_ns_proto;
> +       case BPF_FUNC_ktime_get_real_ns:
> +               return &bpf_ktime_get_real_ns_proto;
>         case BPF_FUNC_ktime_get_boot_ns:
>                 return &bpf_ktime_get_boot_ns_proto;
>         case BPF_FUNC_tail_call:
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index fc5c901c7542..3179fcc4ef53 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1756,6 +1756,7 @@ extern const struct bpf_func_proto bpf_get_smp_proc=
essor_id_proto;
>  extern const struct bpf_func_proto bpf_get_numa_node_id_proto;
>  extern const struct bpf_func_proto bpf_tail_call_proto;
>  extern const struct bpf_func_proto bpf_ktime_get_ns_proto;
> +extern const struct bpf_func_proto bpf_ktime_get_real_ns_proto;
>  extern const struct bpf_func_proto bpf_ktime_get_boot_ns_proto;
>  extern const struct bpf_func_proto bpf_get_current_pid_tgid_proto;
>  extern const struct bpf_func_proto bpf_get_current_uid_gid_proto;
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index a22812561064..198e69a6508d 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3586,6 +3586,13 @@ union bpf_attr {
>   *             the data in *dst*. This is a wrapper of **copy_from_user*=
*\ ().
>   *     Return
>   *             0 on success, or a negative error in case of failure.
> + *
> + * u64 bpf_ktime_get_real_ns(void)
> + *     Description
> + *             Return the real time in nanoseconds.
> + *             See: **clock_gettime**\ (**CLOCK_REALTIME**)
> + *     Return
> + *             Current *ktime*.
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -3737,6 +3744,7 @@ union bpf_attr {
>         FN(inode_storage_delete),       \
>         FN(d_path),                     \
>         FN(copy_from_user),             \
> +       FN(ktime_get_real_ns),          \
>         /* */
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index c4811b139caa..af38af5ffc8b 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -2207,6 +2207,7 @@ const struct bpf_func_proto bpf_get_prandom_u32_pro=
to __weak;
>  const struct bpf_func_proto bpf_get_smp_processor_id_proto __weak;
>  const struct bpf_func_proto bpf_get_numa_node_id_proto __weak;
>  const struct bpf_func_proto bpf_ktime_get_ns_proto __weak;
> +const struct bpf_func_proto bpf_ktime_get_real_ns_proto __weak;
>  const struct bpf_func_proto bpf_ktime_get_boot_ns_proto __weak;
>
>  const struct bpf_func_proto bpf_get_current_pid_tgid_proto __weak;
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 5cc7425ee476..776ff58f969d 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -155,6 +155,17 @@ const struct bpf_func_proto bpf_ktime_get_ns_proto =
=3D {
>         .ret_type       =3D RET_INTEGER,
>  };
>
> +BPF_CALL_0(bpf_ktime_get_real_ns)
> +{
> +       /* NMI safe access to clock realtime */
> +       return ktime_get_real_fast_ns();
> +}
> +
> +const struct bpf_func_proto bpf_ktime_get_real_ns_proto =3D {
> +       .func           =3D bpf_ktime_get_real_ns,
> +       .gpl_only       =3D true,

imho should be false, this is normally accessible to userspace code
via syscall, no reason why it should be gpl only for bpf

> +       .ret_type       =3D RET_INTEGER,
> +};
>  BPF_CALL_0(bpf_ktime_get_boot_ns)
>  {
>         /* NMI safe access to clock boottime */
> @@ -655,6 +666,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
>                 return &bpf_tail_call_proto;
>         case BPF_FUNC_ktime_get_ns:
>                 return &bpf_ktime_get_ns_proto;
> +       case BPF_FUNC_ktime_get_real_ns:
> +               return &bpf_ktime_get_real_ns_proto;
>         case BPF_FUNC_ktime_get_boot_ns:
>                 return &bpf_ktime_get_boot_ns_proto;
>         case BPF_FUNC_ringbuf_output:
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 36508f46a8db..18b644fff0be 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1165,6 +1165,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, co=
nst struct bpf_prog *prog)
>                 return &bpf_map_peek_elem_proto;
>         case BPF_FUNC_ktime_get_ns:
>                 return &bpf_ktime_get_ns_proto;
> +       case BPF_FUNC_ktime_get_real_ns:
> +               return &bpf_ktime_get_real_ns_proto;
>         case BPF_FUNC_ktime_get_boot_ns:
>                 return &bpf_ktime_get_boot_ns_proto;

should probably be here to stay alpha sorted more or less (also
applies to other places)

>         case BPF_FUNC_tail_call:
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
> index a22812561064..198e69a6508d 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -3586,6 +3586,13 @@ union bpf_attr {
>   *             the data in *dst*. This is a wrapper of **copy_from_user*=
*\ ().
>   *     Return
>   *             0 on success, or a negative error in case of failure.
> + *
> + * u64 bpf_ktime_get_real_ns(void)
> + *     Description
> + *             Return the real time in nanoseconds.
> + *             See: **clock_gettime**\ (**CLOCK_REALTIME**)
> + *     Return
> + *             Current *ktime*.
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -3737,6 +3744,7 @@ union bpf_attr {
>         FN(inode_storage_delete),       \
>         FN(d_path),                     \
>         FN(copy_from_user),             \
> +       FN(ktime_get_real_ns),          \
>         /* */
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
> --
> 2.17.1
>
Maciej =C5=BBenczykowski, Kernel Networking Developer @ Google
