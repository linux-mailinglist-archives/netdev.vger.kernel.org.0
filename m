Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D113D276691
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 04:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgIXCmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 22:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgIXCmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 22:42:03 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF39C0613CE
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 19:42:02 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id z25so1690822iol.10
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 19:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Eg84LwRtp3d1sbQSPErNoEZ19NchOftM6zwgElSj2CY=;
        b=BjXOR3NsaC3c1u6IOc1vApsSF1stkvNQIyH5Z3b3jZjP2xu4rFa91WG2TnNQ/mglNn
         EvHce5vUQWYSt11LH561kStXfKpkM9WP9OzaVRNTORBDB5m5aeZTcXrP+k4qScf52m4V
         h1OB5k+HY7C/RUNwwjoB5B91/qVNa5JUcvXYIMrezQWM5Br+VI+yy5kP9sMfEA7T6r5Y
         Az7ScfGWXYotK7OiQw5syl/Kb4ob6zk6l8KQWBvX+zzgNbl9j0wvVEZYjlbP4rq5WOev
         XFWhhD9//FUK1244m1TMVcyyQT2RWAKIWHxEUZ8uhsqFieYYn9Zmj+3plp6nH/riBX5S
         C2rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Eg84LwRtp3d1sbQSPErNoEZ19NchOftM6zwgElSj2CY=;
        b=Z2gOZ9GCjwjzZrdNb9wfgc9cfJek54uDw0f3QqZHmm/F4dk2gzlWGGRVl0MjZCZJI2
         fU8g94DonU63Dx7BqGECpFYB395xA/Xv5xsY8sj5UmsplS1u8jMm5s+goYKIhYX4OeNm
         QAia/U/wufEpzFnoe6JXaU4Qs0hawPrVzHJNexFBuL6RgeymClN7a3ZWGgJuHsAZSseh
         aFshIE/PQJQKhirTFtpmRxwCAkHYY3PuCnzfoh1vWy3ebw8O2PbR8IzYW6MeyS9HWBb5
         jC9U/SCgam28/5TRJh8OOveM0XVEZG5eLO+bzovuN6QAkY/WSPVMgBdxtk6ARqYiIAeM
         loWg==
X-Gm-Message-State: AOAM533s8KZN0VWZiaVdBfkPTeSJEfFJ64bYytjceAVtPPXWxu2tT1Ao
        DXomij4KhdMbJerySpGXwdzELHQn17rJvuCasMXiXA==
X-Google-Smtp-Source: ABdhPJwRbMvtoAsBULzmZC7W1QHwQ7akF61ejeD8Uo6BCz3vsaJMZRFQ7oSX5Tc2oyzzmb+ewxm3T56JJYdtZM/umwg=
X-Received: by 2002:a02:b70c:: with SMTP id g12mr1905063jam.62.1600915321181;
 Wed, 23 Sep 2020 19:42:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200924022557.16561-1-bimmy.pujari@intel.com>
In-Reply-To: <20200924022557.16561-1-bimmy.pujari@intel.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Wed, 23 Sep 2020 19:41:48 -0700
Message-ID: <CANP3RGc7HjqydxF5vBQtzqUe72Ag1KvxVF5kHft0ceZRnjAbQQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/2] bpf: Add bpf_ktime_get_real_ns
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

On Wed, Sep 23, 2020 at 7:26 PM <bimmy.pujari@intel.com> wrote:
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
> index 5bb144435c16..649015fef3c1 100644
> --- a/drivers/media/rc/bpf-lirc.c
> +++ b/drivers/media/rc/bpf-lirc.c
> @@ -105,6 +105,8 @@ lirc_mode2_func_proto(enum bpf_func_id func_id, const=
 struct bpf_prog *prog)
>                 return &bpf_ktime_get_ns_proto;
>         case BPF_FUNC_ktime_get_boot_ns:
>                 return &bpf_ktime_get_boot_ns_proto;
> +       case BPF_FUNC_ktime_get_real_ns:
> +               return &bpf_ktime_get_real_ns_proto;
>         case BPF_FUNC_tail_call:
>                 return &bpf_tail_call_proto;
>         case BPF_FUNC_get_prandom_u32:
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index fc5c901c7542..18c4fdce65c8 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1757,6 +1757,7 @@ extern const struct bpf_func_proto bpf_get_numa_nod=
e_id_proto;
>  extern const struct bpf_func_proto bpf_tail_call_proto;
>  extern const struct bpf_func_proto bpf_ktime_get_ns_proto;
>  extern const struct bpf_func_proto bpf_ktime_get_boot_ns_proto;
> +extern const struct bpf_func_proto bpf_ktime_get_real_ns_proto;
>  extern const struct bpf_func_proto bpf_get_current_pid_tgid_proto;
>  extern const struct bpf_func_proto bpf_get_current_uid_gid_proto;
>  extern const struct bpf_func_proto bpf_get_current_comm_proto;
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
> index c4811b139caa..0dbbda9b743b 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -2208,6 +2208,7 @@ const struct bpf_func_proto bpf_get_smp_processor_i=
d_proto __weak;
>  const struct bpf_func_proto bpf_get_numa_node_id_proto __weak;
>  const struct bpf_func_proto bpf_ktime_get_ns_proto __weak;
>  const struct bpf_func_proto bpf_ktime_get_boot_ns_proto __weak;
> +const struct bpf_func_proto bpf_ktime_get_real_ns_proto __weak;
>
>  const struct bpf_func_proto bpf_get_current_pid_tgid_proto __weak;
>  const struct bpf_func_proto bpf_get_current_uid_gid_proto __weak;
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 5cc7425ee476..300db9269996 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -166,6 +166,17 @@ const struct bpf_func_proto bpf_ktime_get_boot_ns_pr=
oto =3D {
>         .gpl_only       =3D false,
>         .ret_type       =3D RET_INTEGER,
>  };
> +BPF_CALL_0(bpf_ktime_get_real_ns)
> +{
> +       /* NMI safe access to clock realtime */
> +       return ktime_get_real_fast_ns();
> +}
> +
> +const struct bpf_func_proto bpf_ktime_get_real_ns_proto =3D {
> +       .func           =3D bpf_ktime_get_real_ns,
> +       .gpl_only       =3D false,
> +       .ret_type       =3D RET_INTEGER,
> +};
>
>  BPF_CALL_0(bpf_get_current_pid_tgid)
>  {
> @@ -657,6 +668,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
>                 return &bpf_ktime_get_ns_proto;
>         case BPF_FUNC_ktime_get_boot_ns:
>                 return &bpf_ktime_get_boot_ns_proto;
> +       case BPF_FUNC_ktime_get_real_ns:
> +               return &bpf_ktime_get_real_ns_proto;
>         case BPF_FUNC_ringbuf_output:
>                 return &bpf_ringbuf_output_proto;
>         case BPF_FUNC_ringbuf_reserve:
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 36508f46a8db..8ea2a0e50041 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1167,6 +1167,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, co=
nst struct bpf_prog *prog)
>                 return &bpf_ktime_get_ns_proto;
>         case BPF_FUNC_ktime_get_boot_ns:
>                 return &bpf_ktime_get_boot_ns_proto;
> +       case BPF_FUNC_ktime_get_real_ns:
> +               return &bpf_ktime_get_real_ns_proto;
>         case BPF_FUNC_tail_call:
>                 return &bpf_tail_call_proto;
>         case BPF_FUNC_get_current_pid_tgid:
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

Reviewed-by: Maciej =C5=BBenczykowski <maze@google.com>
