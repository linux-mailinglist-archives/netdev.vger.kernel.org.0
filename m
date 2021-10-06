Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750CF424900
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 23:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239713AbhJFVha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 17:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbhJFVh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 17:37:29 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF303C061746;
        Wed,  6 Oct 2021 14:35:36 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id d131so8660768ybd.5;
        Wed, 06 Oct 2021 14:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rR2cRFE2Mq+8LHjKOluZMaFdRd1OI9HbsQgSz23jqJw=;
        b=QYQXZjI35chblDogkAkqOqEUMKYFDf2tdJ8OpvIJ9Ezh5CYt63EiIduNWyiX2+6kTP
         UnEp4tBy3dswll/9zPmZwXzYI+DjCNhloSQcWgGEKpA8WR+DuRb3bYKe+w866eFNLqPV
         baagOvp75rElKjZcXXmVxaTu1WbUqTo9/2eLRzxmiJHaCLGlsMBmLYYr0qFDpG4YYiiL
         DyBEtea4eqL8hQMAQJyPIBI5dryKGNcMX0HmIHs0SW8oCwXap/ivS1TxuYP3HHVnr/H3
         1R+B2Oc5L011sVOY9HYj1mt+a+cNqCVEMwSpLSL+KXWXSkTJgoD0liMuSFqkwSbduRKc
         XkaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rR2cRFE2Mq+8LHjKOluZMaFdRd1OI9HbsQgSz23jqJw=;
        b=n2CqMBTrsbpHL1CKiqtghDq6XuY2m4VWGqkyC8mVCyVKPkRHnF4lZpg4KGxDGeu4/N
         XSgpfRRgjMcIyR7XeJAeSU//OBnm/9u5YXo9PIeZW0U61knvbkswpHhhea3uJGbqp/+Z
         LUfyztUjeUSTqJuXIJR6n3M4Hpxj7S/7Hd5A4EvKvuT2BtNkFXQhFe1fzijuvEqqk9IE
         C7vvYVmtIEFHM1tWjS5StMuQMSz1BFimS51RtMKqGU8dN7EIuy2NgMKVec5qMkK+bP8v
         er7crZxkkMEp/NMgDmumh63Qf4s/KM/l13r06Px/nA49DojGUaMp/lA/EOoE7CGJAvH6
         5B1Q==
X-Gm-Message-State: AOAM532BlvT2LhDMgbXBbbCJRj+rFCiP29p3Q1FRRcSpjtl2DFi3sFb0
        MPRauxdWEHFjI98QovlirSbY3gVl7U1uT+fQT0k=
X-Google-Smtp-Source: ABdhPJyy+Lu8paWW/omzRGWP62b0C2F37+ml/Dm6OW49kUUOIwknD36Qf04NJwbUjP0KjusWZPjEWA0fY0n+NZeOP3w=
X-Received: by 2002:a25:5606:: with SMTP id k6mr571631ybb.51.1633556136110;
 Wed, 06 Oct 2021 14:35:36 -0700 (PDT)
MIME-Version: 1.0
References: <20211006203135.2566248-1-songliubraving@fb.com>
In-Reply-To: <20211006203135.2566248-1-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 Oct 2021 14:35:25 -0700
Message-ID: <CAEf4BzYs=dumqCAYp-kGFwVnQdt5eT6Yq17XQ83i9vHxE0Rmwg@mail.gmail.com>
Subject: Re: [PATCH] selftests/bpf: skip get_branch_snapshot in vm
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 6, 2021 at 1:31 PM Song Liu <songliubraving@fb.com> wrote:
>
> VMs running on latest kernel support LBR. However, bpf_get_branch_snapshot
> couldn't stop the LBR before too many entries are flushed. Skip the test
> for VMs before we find a proper fix for VMs.
>
> Read the "flags" line from /proc/cpuinfo, if it contains "hypervisor",
> skip test get_branch_snapshot.
>
> Fixes: 025bd7c753aa (selftests/bpf: Add test for bpf_get_branch_snapshot)

missing quotes?

> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  .../bpf/prog_tests/get_branch_snapshot.c      | 32 +++++++++++++++++++
>  1 file changed, 32 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c b/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
> index 67e86f8d86775..bf9d47a859449 100644
> --- a/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
> +++ b/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
> @@ -6,6 +6,30 @@
>  static int *pfd_array;
>  static int cpu_cnt;
>
> +static bool is_hypervisor(void)
> +{
> +       char *line = NULL;
> +       bool ret = false;
> +       size_t len;
> +       FILE *fp;
> +
> +       fp = fopen("/proc/cpuinfo", "r");
> +       if (!fp)
> +               return false;
> +
> +       while (getline(&line, &len, fp) != -1) {
> +               if (strstr(line, "flags") == line) {

strncmp() would be more explicit. That's what you are trying to do
(prefix match), right?

> +                       if (strstr(line, "hypervisor") != NULL)
> +                               ret = true;
> +                       break;
> +               }
> +       }
> +
> +       free(line);
> +       fclose(fp);
> +       return ret;
> +}
> +
>  static int create_perf_events(void)
>  {
>         struct perf_event_attr attr = {0};
> @@ -54,6 +78,14 @@ void test_get_branch_snapshot(void)
>         struct get_branch_snapshot *skel = NULL;
>         int err;
>
> +       if (is_hypervisor()) {
> +               /* As of today, LBR in hypervisor cannot be stopped before
> +                * too many entries are flushed. Skip the test for now in
> +                * hypervisor until we optimize the LBR in hypervisor.
> +                */
> +               test__skip();
> +               return;
> +       }
>         if (create_perf_events()) {
>                 test__skip();  /* system doesn't support LBR */
>                 goto cleanup;
> --
> 2.30.2
>
