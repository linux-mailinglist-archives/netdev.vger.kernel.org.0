Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1AA64FD2
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 03:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbfGKBRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 21:17:34 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41371 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727463AbfGKBRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 21:17:34 -0400
Received: by mail-qk1-f194.google.com with SMTP id v22so3495499qkj.8;
        Wed, 10 Jul 2019 18:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LKDlCucLV7xEgqUUBNafyvGAb9YZ9mMSdHY5cR1gldI=;
        b=qZ+aGuiiEnrmrZoOVc4y2ZMSOcLlAw1pinPQTW2GJjvB0Ltip3YhYZQDsAF8SiQ1uB
         VuKv9InO4KPhq6DdbYpkeC1zxfvzfe5bDOCdSVPgToK1OEQhAnWTUGo2hXYhDjbEvm7C
         pfCZqIQuZRjXDTwr8OR/4FiQVLWaUY+hactRB2mgSBSe6nNHEK8sgCS8a9rEi7QlWlQK
         NGpvRuK/ksXw7CiBZFXc8N0CkqnTJJ1aOdbnMzTVU800OnMRq2//Xg+3I6PcmYDTg2+H
         GLDfBPhlXJ8F6JyjBvQ9rHqyO1I2rm20DaI8aIyJF+gLce47dp4FcQILjXzDrJG18emp
         Zcvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LKDlCucLV7xEgqUUBNafyvGAb9YZ9mMSdHY5cR1gldI=;
        b=JPYlRTYt2lAt5We8t6lRRDTVNA+FZeTmeWIbKbhmBOdyNJ0UIKUtTjNv6kI50uDSz+
         QdswmSunIlBiMjbF7k0iu9zV7bVXmbCeR2w6BFPkdHqXFhMZs4NB5cg2G8kni5lPTxrw
         i9Pu/qvciVMxKRn87iU4llsfqX1WZuW4pcrrGyHFtfm/U1tbPYcoyye85xm09XigR4Qi
         yjReJI1oN8RRJQkS+ntiRvPZy9lzkkM56tdK/xVUTen9fThtYvZNgQ+03QKwobTiJBbw
         dV7swEO5OTLEiQwFZsqRKdWEyubQ4G2JbUPRstJfa3QKzSWPFbTJLSHYnhN6bOMmabKR
         cYWg==
X-Gm-Message-State: APjAAAW17xJaPczJRADMy+BfBvdlwEn8QK/v8a0TvMFCY0MVLK2UPizV
        WMLgjpN3gh6KnRAWH8MD5ejoU5Wsbf8hxrH0E3Q=
X-Google-Smtp-Source: APXvYqw6qCezp0TnaQMDe72AthAmqSkLdTzpRxGOnEixfkCIwGBDW7s3UNpUl9A2f8lPFNejUS7g2Ky2ueXT2zelvmE=
X-Received: by 2002:a37:660d:: with SMTP id a13mr1016590qkc.36.1562807852247;
 Wed, 10 Jul 2019 18:17:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190708163121.18477-1-krzesimir@kinvolk.io> <20190708163121.18477-6-krzesimir@kinvolk.io>
In-Reply-To: <20190708163121.18477-6-krzesimir@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Jul 2019 18:17:20 -0700
Message-ID: <CAEf4BzYYdrcwJKg271ZL7kPJNYyZEGdxQeuUNbfPk=EjewuHeQ@mail.gmail.com>
Subject: Re: [bpf-next v3 05/12] selftests/bpf: Allow passing more information
 to BPF prog test run
To:     Krzesimir Nowak <krzesimir@kinvolk.io>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        xdp-newbies@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 8, 2019 at 3:42 PM Krzesimir Nowak <krzesimir@kinvolk.io> wrote:
>
> The test case can now specify a custom length of the data member,
> context data and its length, which will be passed to
> bpf_prog_test_run_xattr. For backward compatilibity, if the data
> length is 0 (which is what will happen when the field is left
> unspecified in the designated initializer of a struct), then the
> length passed to the bpf_prog_test_run_xattr is TEST_DATA_LEN.
>
> Also for backward compatilibity, if context data length is 0, NULL is
> passed as a context to bpf_prog_test_run_xattr. This is to avoid
> breaking other tests, where context data being NULL and context data
> length being 0 is handled differently from the case where context data
> is not NULL and context data length is 0.
>
> Custom lengths still can't be greater than hardcoded 64 bytes for data
> and 192 for context data.
>
> 192 for context data was picked to allow passing struct
> bpf_perf_event_data as a context for perf event programs. The struct
> is quite large, because it contains struct pt_regs.
>
> Test runs for perf event programs will not allow the copying the data
> back to data_out buffer, so they require data_out_size to be zero and
> data_out to be NULL. Since test_verifier hardcodes it, make it
> possible to override the size. Overriding the size to zero will cause
> the buffer to be NULL.
>
> Changes since v2:
> - Allow overriding the data out size and buffer.
>
> Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> ---
>  tools/testing/selftests/bpf/test_verifier.c | 105 +++++++++++++++++---
>  1 file changed, 93 insertions(+), 12 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> index 1640ba9f12c1..6f124cc4ee34 100644
> --- a/tools/testing/selftests/bpf/test_verifier.c
> +++ b/tools/testing/selftests/bpf/test_verifier.c
> @@ -54,6 +54,7 @@
>  #define MAX_TEST_RUNS  8
>  #define POINTER_VALUE  0xcafe4all
>  #define TEST_DATA_LEN  64
> +#define TEST_CTX_LEN   192
>
>  #define F_NEEDS_EFFICIENT_UNALIGNED_ACCESS     (1 << 0)
>  #define F_LOAD_WITH_STRICT_ALIGNMENT           (1 << 1)
> @@ -96,7 +97,12 @@ struct bpf_test {
>         enum bpf_prog_type prog_type;
>         uint8_t flags;
>         __u8 data[TEST_DATA_LEN];
> +       __u32 data_len;
> +       __u8 ctx[TEST_CTX_LEN];
> +       __u32 ctx_len;
>         void (*fill_helper)(struct bpf_test *self);
> +       bool override_data_out_len;
> +       __u32 overridden_data_out_len;
>         uint8_t runs;
>         struct {
>                 uint32_t retval, retval_unpriv;
> @@ -104,6 +110,9 @@ struct bpf_test {
>                         __u8 data[TEST_DATA_LEN];
>                         __u64 data64[TEST_DATA_LEN / 8];
>                 };
> +               __u32 data_len;
> +               __u8 ctx[TEST_CTX_LEN];
> +               __u32 ctx_len;
>         } retvals[MAX_TEST_RUNS];
>  };
>
> @@ -818,21 +827,35 @@ static int set_admin(bool admin)
>  }
>
>  static int do_prog_test_run(int fd_prog, bool unpriv, uint32_t expected_val,
> -                           void *data, size_t size_data)
> +                           void *data, size_t size_data, void *ctx,
> +                           size_t size_ctx, u32 *overridden_data_out_size)
>  {
> -       __u8 tmp[TEST_DATA_LEN << 2];
> -       __u32 size_tmp = sizeof(tmp);
> -       int saved_errno;
> -       int err;
>         struct bpf_prog_test_run_attr attr = {
>                 .prog_fd = fd_prog,
>                 .repeat = 1,
>                 .data_in = data,
>                 .data_size_in = size_data,
> -               .data_out = tmp,
> -               .data_size_out = size_tmp,
> +               .ctx_in = ctx,
> +               .ctx_size_in = size_ctx,
>         };
> +       __u8 tmp[TEST_DATA_LEN << 2];
> +       __u32 size_tmp = sizeof(tmp);
> +       __u32 size_buf = size_tmp;
> +       __u8 *buf = tmp;
> +       int saved_errno;
> +       int err;
>
> +       if (overridden_data_out_size)
> +               size_buf = *overridden_data_out_size;
> +       if (size_buf > size_tmp) {
> +               printf("FAIL: out data size (%d) greater than a buffer size (%d) ",
> +                      size_buf, size_tmp);
> +               return -EINVAL;
> +       }
> +       if (!size_buf)
> +               buf = NULL;
> +       attr.data_size_out = size_buf;
> +       attr.data_out = buf;
>         if (unpriv)
>                 set_admin(true);
>         err = bpf_prog_test_run_xattr(&attr);
> @@ -956,13 +979,45 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
>         if (!alignment_prevented_execution && fd_prog >= 0) {
>                 uint32_t expected_val;
>                 int i;
> +               __u32 size_data;
> +               __u32 size_ctx;
> +               bool bad_size;
> +               void *ctx;
> +               __u32 *overridden_data_out_size;
>
>                 if (!test->runs) {
> +                       if (test->data_len > 0)
> +                               size_data = test->data_len;
> +                       else
> +                               size_data = sizeof(test->data);
> +                       if (test->override_data_out_len)
> +                               overridden_data_out_size = &test->overridden_data_out_len;
> +                       else
> +                               overridden_data_out_size = NULL;
> +                       size_ctx = test->ctx_len;
> +                       bad_size = false;

I hated all this duplication of logic, which with this patch becomes
even more expansive, so I removed it. Please see [0]. Can you please
apply that patch and add all this new logic only once?

  [0] https://patchwork.ozlabs.org/patch/1130601/

>                         expected_val = unpriv && test->retval_unpriv ?
>                                 test->retval_unpriv : test->retval;
>
> -                       err = do_prog_test_run(fd_prog, unpriv, expected_val,
> -                                              test->data, sizeof(test->data));
> +                       if (size_data > sizeof(test->data)) {
> +                               printf("FAIL: data size (%u) greater than TEST_DATA_LEN (%lu) ", size_data, sizeof(test->data));
> +                               bad_size = true;
> +                       }
> +                       if (size_ctx > sizeof(test->ctx)) {
> +                               printf("FAIL: ctx size (%u) greater than TEST_CTX_LEN (%lu) ", size_ctx, sizeof(test->ctx));

These look like way too long lines, wrap them?

> +                               bad_size = true;
> +                       }
> +                       if (size_ctx)
> +                               ctx = test->ctx;
> +                       else
> +                               ctx = NULL;

nit: single line:

ctx = size_ctx ? test->ctx : NULL;

> +                       if (bad_size)
> +                               err = 1;
> +                       else
> +                               err = do_prog_test_run(fd_prog, unpriv, expected_val,
> +                                                      test->data, size_data,
> +                                                      ctx, size_ctx,
> +                                                      overridden_data_out_size);
>                         if (err)
>                                 run_errs++;
>                         else
> @@ -970,14 +1025,40 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
>                 }
>
>                 for (i = 0; i < test->runs; i++) {
> +                       if (test->retvals[i].data_len > 0)
> +                               size_data = test->retvals[i].data_len;
> +                       else
> +                               size_data = sizeof(test->retvals[i].data);
> +                       if (test->override_data_out_len)
> +                               overridden_data_out_size = &test->overridden_data_out_len;
> +                       else
> +                               overridden_data_out_size = NULL;
> +                       size_ctx = test->retvals[i].ctx_len;
> +                       bad_size = false;
>                         if (unpriv && test->retvals[i].retval_unpriv)
>                                 expected_val = test->retvals[i].retval_unpriv;
>                         else
>                                 expected_val = test->retvals[i].retval;
>
> -                       err = do_prog_test_run(fd_prog, unpriv, expected_val,
> -                                              test->retvals[i].data,
> -                                              sizeof(test->retvals[i].data));
> +                       if (size_data > sizeof(test->retvals[i].data)) {
> +                               printf("FAIL: data size (%u) at run %i greater than TEST_DATA_LEN (%lu) ", size_data, i + 1, sizeof(test->retvals[i].data));
> +                               bad_size = true;
> +                       }
> +                       if (size_ctx > sizeof(test->retvals[i].ctx)) {
> +                               printf("FAIL: ctx size (%u) at run %i greater than TEST_CTX_LEN (%lu) ", size_ctx, i + 1, sizeof(test->retvals[i].ctx));
> +                               bad_size = true;
> +                       }
> +                       if (size_ctx)
> +                               ctx = test->retvals[i].ctx;
> +                       else
> +                               ctx = NULL;
> +                       if (bad_size)
> +                               err = 1;
> +                       else
> +                               err = do_prog_test_run(fd_prog, unpriv, expected_val,
> +                                                      test->retvals[i].data, size_data,
> +                                                      ctx, size_ctx,
> +                                                      overridden_data_out_size);
>                         if (err) {
>                                 printf("(run %d/%d) ", i + 1, test->runs);
>                                 run_errs++;
> --
> 2.20.1
>
