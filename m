Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C695E55872
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbfFYULT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:11:19 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34539 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfFYULT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 16:11:19 -0400
Received: by mail-qt1-f193.google.com with SMTP id m29so19949094qtu.1;
        Tue, 25 Jun 2019 13:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OreAjeo9rrM6a/pymdVC27g7/glSRs4XsmsvRn5Wlv0=;
        b=qHYkRVMejJygBI04ejSMnFsWlYPZzSJcgnlC8GxG57WsIGxauRH7DexUSO0UkpFHh6
         7bIqgWFPoFaafvVwoeKzX3Yh/BIbO4ClaNLPcA3MH9tkRcgHVQo5VpgR6/wPgXWRq5Pi
         4dxgA37hbvZNz69o2J1ZdHplP3BWwpSc93KE8FDFBKbA+VD8/r0ZIgI3at4N1KzwpSUb
         jp53WhB4b7UJWtJpu4adVaZ4C/2F9yLAkfYEH0NcLI4mR6Pel/io34CC4xKeJ4XAsxgO
         Dm4uH+WxM2gfPtuTVRThD5xwe2V+lUeFtjTGOhLtFpfLYXhTsDlVlpYY8Zxcrlt4tPxe
         ZblQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OreAjeo9rrM6a/pymdVC27g7/glSRs4XsmsvRn5Wlv0=;
        b=YPq5oWRaXDjW2w4wUuwtqJ/bzSn3lQrDmw70xH5LPK+Y9EiEgvmwTpLSAL73TKpPEr
         iJ2zO9Ce3aqY+k9NegDlveqR8u2ef1c3bMYtZYiYmGFvuecL6DSA1d/mhDy7njIuy9KH
         i1CkbMbbeLbm7Yb9EAQsf7oVfgKOGJTsnBwhqCla/G+LLOqGLwGn3++1z68bicBQImlC
         yOZtMvxRHK6+8EHWr4o6dd6QnFmCyBrmQstOkmXmyrtYe2g17V6OSNsDMSRa6WbfbnwR
         7j9l5mSWuxD0LYmxCcN/eeHlSC0QwXw3smHSqAqk8fhH8x5EFZtFw6jGHN+lXeASPiY8
         QfgA==
X-Gm-Message-State: APjAAAVhmCHSNbfOLVbfQGIEuKRE44wZ9qtcMJ/Ax8DunO2/lMHcvZg6
        9QbOF0RYkk5Z9r/Ut5beyuqtWbFqH0l7rTNgS+4O9E5h
X-Google-Smtp-Source: APXvYqzj4E8O6NOXZEf3TigjEJsxuMWSRrzGNtfWhGlGdks/5kYCVaWLEzkqyw1TG4JkjHceepT71RGVPFwXIR6Vca4=
X-Received: by 2002:ac8:1af4:: with SMTP id h49mr181457qtk.183.1561493477818;
 Tue, 25 Jun 2019 13:11:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190625172717.158613-1-allanzhang@google.com> <20190625172717.158613-3-allanzhang@google.com>
In-Reply-To: <20190625172717.158613-3-allanzhang@google.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Tue, 25 Jun 2019 13:11:06 -0700
Message-ID: <CAPhsuW6gcigZbB8FH4Yw=HYdTVnrjGEaFZ=xrcRakuVERBBWeg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/2] bpf: Add selftests for bpf_perf_event_output
To:     allanzhang <allanzhang@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 12:45 PM allanzhang <allanzhang@google.com> wrote:
>
> Software event output is only enabled by a few prog types.
> This test is to ensure that all supported types are enbled for
> bpf_perf_event_output sucessfully.

Please fix these typos highlighted by Daniel.
enbled
sucessfully

>
> v4:
> * Reformating log message
> v3:
> * Reformating log message
> v2:
> * Reformating log message
>
> Signed-off-by: allanzhang <allanzhang@google.com>
> ---
>  tools/testing/selftests/bpf/test_verifier.c   | 33 ++++++-
>  .../selftests/bpf/verifier/event_output.c     | 94 +++++++++++++++++++
>  2 files changed, 126 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/verifier/event_output.c
>
> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> index c5514daf8865..901a188e1eea 100644
> --- a/tools/testing/selftests/bpf/test_verifier.c
> +++ b/tools/testing/selftests/bpf/test_verifier.c
> @@ -50,7 +50,7 @@
>  #define MAX_INSNS      BPF_MAXINSNS
>  #define MAX_TEST_INSNS 1000000
>  #define MAX_FIXUPS     8
> -#define MAX_NR_MAPS    18
> +#define MAX_NR_MAPS    19
>  #define MAX_TEST_RUNS  8
>  #define POINTER_VALUE  0xcafe4all
>  #define TEST_DATA_LEN  64
> @@ -84,6 +84,7 @@ struct bpf_test {
>         int fixup_map_array_wo[MAX_FIXUPS];
>         int fixup_map_array_small[MAX_FIXUPS];
>         int fixup_sk_storage_map[MAX_FIXUPS];
> +       int fixup_map_event_output[MAX_FIXUPS];
>         const char *errstr;
>         const char *errstr_unpriv;
>         uint32_t retval, retval_unpriv, insn_processed;
> @@ -604,6 +605,28 @@ static int create_sk_storage_map(void)
>         return fd;
>  }
>
> +static int create_event_output_map(void)
> +{
> +       struct bpf_create_map_attr attr = {
> +               .name = "test_map",
> +               .map_type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
> +               .key_size = 4,
> +               .value_size = 4,
> +               .max_entries = 1,
> +       };
> +       int fd, btf_fd;
> +
> +       btf_fd = load_btf();
> +       if (btf_fd < 0)
> +               return -1;
> +       attr.btf_fd = btf_fd;
> +       fd = bpf_create_map_xattr(&attr);
> +       close(attr.btf_fd);
> +       if (fd < 0)
> +               printf("Failed to create event_output\n");
> +       return fd;
> +}
> +
>  static char bpf_vlog[UINT_MAX >> 8];
>
>  static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
> @@ -627,6 +650,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
>         int *fixup_map_array_wo = test->fixup_map_array_wo;
>         int *fixup_map_array_small = test->fixup_map_array_small;
>         int *fixup_sk_storage_map = test->fixup_sk_storage_map;
> +       int *fixup_map_event_output = test->fixup_map_event_output;
>
>         if (test->fill_helper) {
>                 test->fill_insns = calloc(MAX_TEST_INSNS, sizeof(struct bpf_insn));
> @@ -788,6 +812,13 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
>                         fixup_sk_storage_map++;
>                 } while (*fixup_sk_storage_map);
>         }
> +       if (*fixup_map_event_output) {
> +               map_fds[18] = create_event_output_map();
> +               do {
> +                       prog[*fixup_map_event_output].imm = map_fds[18];
> +                       fixup_map_event_output++;
> +               } while (*fixup_map_event_output);
> +       }
>  }
>
>  static int set_admin(bool admin)
> diff --git a/tools/testing/selftests/bpf/verifier/event_output.c b/tools/testing/selftests/bpf/verifier/event_output.c
> new file mode 100644
> index 000000000000..b25eabcfaa56
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/verifier/event_output.c
> @@ -0,0 +1,94 @@
> +/* instructions used to output a skb based software event, produced
> + * from code snippet:
> +struct TMP {
> +  uint64_t tmp;
> +} tt;
> +tt.tmp = 5;
> +bpf_perf_event_output(skb, &connection_tracking_event_map, 0,
> +                     &tt, sizeof(tt));
> +return 1;
> +
> +the bpf assembly from llvm is:
> +       0:       b7 02 00 00 05 00 00 00         r2 = 5
> +       1:       7b 2a f8 ff 00 00 00 00         *(u64 *)(r10 - 8) = r2
> +       2:       bf a4 00 00 00 00 00 00         r4 = r10
> +       3:       07 04 00 00 f8 ff ff ff         r4 += -8
> +       4:       18 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00    r2 = 0ll
> +       6:       b7 03 00 00 00 00 00 00         r3 = 0
> +       7:       b7 05 00 00 08 00 00 00         r5 = 8
> +       8:       85 00 00 00 19 00 00 00         call 25
> +       9:       b7 00 00 00 01 00 00 00         r0 = 1
> +      10:       95 00 00 00 00 00 00 00         exit
> +
> +    The reason I put the code here instead of fill_helpers is that map fixup is
> +    against the insns, instead of filled prog.
> +*/

Please prefix every line in the comment section with space_star_space: " * ".
This makes it obvious that this is a comment.

Thanks,
Song

> +
> +#define __PERF_EVENT_INSNS__                                   \
> +       BPF_MOV64_IMM(BPF_REG_2, 5),                            \
> +       BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -8),         \
> +       BPF_MOV64_REG(BPF_REG_4, BPF_REG_10),                   \
> +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_4, -8),                  \
> +       BPF_LD_MAP_FD(BPF_REG_2, 0),                            \
> +       BPF_MOV64_IMM(BPF_REG_3, 0),                            \
> +       BPF_MOV64_IMM(BPF_REG_5, 8),                            \
> +       BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,               \
> +                    BPF_FUNC_perf_event_output),               \
> +       BPF_MOV64_IMM(BPF_REG_0, 1),                            \
> +       BPF_EXIT_INSN(),
> +{
> +       "perfevent for sockops",
> +       .insns = { __PERF_EVENT_INSNS__ },
> +       .prog_type = BPF_PROG_TYPE_SOCK_OPS,
> +       .fixup_map_event_output = { 4 },
> +       .result = ACCEPT,
> +       .retval = 1,
> +},
> +{
> +       "perfevent for tc",
> +       .insns =  { __PERF_EVENT_INSNS__ },
> +       .prog_type = BPF_PROG_TYPE_SCHED_CLS,
> +       .fixup_map_event_output = { 4 },
> +       .result = ACCEPT,
> +       .retval = 1,
> +},
> +{
> +       "perfevent for lwt out",
> +       .insns =  { __PERF_EVENT_INSNS__ },
> +       .prog_type = BPF_PROG_TYPE_LWT_OUT,
> +       .fixup_map_event_output = { 4 },
> +       .result = ACCEPT,
> +       .retval = 1,
> +},
> +{
> +       "perfevent for xdp",
> +       .insns =  { __PERF_EVENT_INSNS__ },
> +       .prog_type = BPF_PROG_TYPE_XDP,
> +       .fixup_map_event_output = { 4 },
> +       .result = ACCEPT,
> +       .retval = 1,
> +},
> +{
> +       "perfevent for socket filter",
> +       .insns =  { __PERF_EVENT_INSNS__ },
> +       .prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
> +       .fixup_map_event_output = { 4 },
> +       .result = ACCEPT,
> +       .retval = 1,
> +},
> +{
> +       "perfevent for sk_skb",
> +       .insns =  { __PERF_EVENT_INSNS__ },
> +       .prog_type = BPF_PROG_TYPE_SK_SKB,
> +       .fixup_map_event_output = { 4 },
> +       .result = ACCEPT,
> +       .retval = 1,
> +},
> +{
> +       "perfevent for cgroup skb",
> +       .insns =  { __PERF_EVENT_INSNS__ },
> +       .prog_type = BPF_PROG_TYPE_CGROUP_SKB,
> +       .fixup_map_event_output = { 4 },
> +       .result = ACCEPT,
> +       .retval = 1,
> +},
> --
> 2.22.0.410.gd8fdbe21b5-goog
>
