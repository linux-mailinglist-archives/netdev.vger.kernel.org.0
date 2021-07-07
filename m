Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62793BE19B
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 05:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhGGDye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 23:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbhGGDyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 23:54:33 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16A9C061574;
        Tue,  6 Jul 2021 20:51:52 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id b13so1041394ybk.4;
        Tue, 06 Jul 2021 20:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P6a8rgfJKPttoVRxkbkWBVfvazQk9uZY1QQSe7LxrWU=;
        b=nwZpQ6EfkGairAflr/PxoQ0bY+kWyCtH+8+PAPchVlJJLWwcn2WnXy+8RD0E4wdoW3
         v3M2+ZgJ6s/4ab6HJXTio36eb/BF/ypCt3wVxd9m+FCeGN/8eMmmxHebGeyQ43R0Y9A9
         9X4nkCCeykj4WRnLU/m1pMZE4w3uS2xkxiWgQkQF/+vzhdm5dE2FEUThROLAksYVy0wd
         DY7S+XyczT8QYeUGIv4R7GTiEihAIMUQ1E2W3Wwih5by6tD/Fj8i+ryq04xGo8U8x98x
         4+cJwtovJwgQf8ItAWxYDo6SZEqASeuA34RiqxD53lhCnAsYpxnomAddoodWmF+vg2hY
         dYkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P6a8rgfJKPttoVRxkbkWBVfvazQk9uZY1QQSe7LxrWU=;
        b=nQjTOjJeI0aqhd9yN3sAFep/xwHSj90+MvgYHTcQMkGWH3etO+QmDHZrwIVArf6ayG
         xb8eRDhnhJkxjyejBsCEiO/agjT2GEchfIElUaD2RjhfCsFL7T5qcArCbBV0j8lMOsnO
         atxKUBiZo0U5MVPd+ULQb9PcFdZ49sVs5kS20giuV6Hyts4Eug/FeJshVFyvXywVjWYw
         i/X/qqkGCACEdzC2Cb8zalyuwHMVk3bUKFjqFtOOYqg0ml1NTT1CCfXa+RrwB3juXgSi
         5BJv1UkSUafkMiWTWFyCtgYA2E9dlQNItoW12jQHgcM6kCSg2xZEfrbngrT4pIFDrtLs
         JUzA==
X-Gm-Message-State: AOAM533JpbLJ4u+aiqnCAAOUHrARs3bXoykX3drIJf/efbJnrowvr0Fm
        6rdlvB0niFY7LzhYLME/0Zu1pH95vS9CSI8wkBY=
X-Google-Smtp-Source: ABdhPJyve9Zsvj3pMxTVK3Q+WZmQ6XHjCfbM48O8Aa18N4ePvXC33w+XvkWuEjXBJR4ZZRpE2urMT5WOrLYs4uYqo3I=
X-Received: by 2002:a25:d349:: with SMTP id e70mr29007752ybf.510.1625629911939;
 Tue, 06 Jul 2021 20:51:51 -0700 (PDT)
MIME-Version: 1.0
References: <1624092968-5598-1-git-send-email-alan.maguire@oracle.com> <1624092968-5598-4-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1624092968-5598-4-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 6 Jul 2021 20:51:41 -0700
Message-ID: <CAEf4BzZuCffvY-Ac7KYG1Qm0cyUuDB9wE3jqv0MG5+TRV_H5Bg@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 3/3] selftests/bpf: add dump type data tests
 to btf dump tests
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Bill Wendling <morbo@google.com>,
        Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 19, 2021 at 1:56 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Test various type data dumping operations by comparing expected
> format with the dumped string; an snprintf-style printf function
> is used to record the string dumped.  Also verify overflow handling
> where the data passed does not cover the full size of a type,
> such as would occur if a tracer has a portion of the 8k
> "struct task_struct".
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/btf_dump.c | 644 ++++++++++++++++++++++
>  1 file changed, 644 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
> index 1b90e68..c894201 100644
> --- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
> +++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
> @@ -232,7 +232,621 @@ void test_btf_dump_incremental(void)
>         btf__free(btf);
>  }
>
> +#define STRSIZE                                4096
> +
> +static void btf_dump_snprintf(void *ctx, const char *fmt, va_list args)
> +{
> +       char *s = ctx, new[STRSIZE];
> +
> +       vsnprintf(new, STRSIZE, fmt, args);
> +       strncat(s, new, STRSIZE);

this can cause stack corruption, because strncat doesn't take into
account the length of string in s and might copy all STRSIZE bytes
from new. What you want here is actually strlcat() variant, but I'm
not sure it's available in Linux glibc. Instead, you have to pass
STRSIZE - strlen(s) - 1 to strncat.

> +}
> +
> +/* skip "enum "/"struct " prefixes */
> +#define SKIP_PREFIX(_typestr, _prefix)                                 \
> +       do {                                                            \
> +               if (strncmp(_typestr, _prefix, strlen(_prefix)) == 0)   \
> +                       _typestr += strlen(_prefix) + 1;                \

If you expect "enum " or "struct " (not, say, "enum/"), then the test
should just pass that in explicitly instead of SKIP_PREFIX silently
ignoring an extra *any* character.


> +       } while (0)
> +

[...]

> +/* overflow test; pass typesize < expected type size, ensure E2BIG returned */
> +#define TEST_BTF_DUMP_DATA_OVER(_b, _d, _str, _type, _type_sz, _expected, ...)\
> +       do {                                                            \
> +               char __ptrtype[64] = #_type;                            \
> +               char *_ptrtype = (char *)__ptrtype;                     \
> +               _type _ptrdata = __VA_ARGS__;                           \
> +               void *_ptr = &_ptrdata;                                 \
> +               int _err;                                               \
> +                                                                       \
> +               _err = btf_dump_data(_b, _d, _ptrtype, 0, _ptr,         \
> +                                    _type_sz, _str, _expected);        \
> +               if (_err < 0)                                           \
> +                       return;                                         \

don't return, let all the validation run. It's better to see all the
failures than fix one by one, recompile, rerun, then fix another one.
Same for TEST_BTF_DUMP_DATA above.

> +       } while (0)
> +
> +#define TEST_BTF_DUMP_VAR(_b, _d, _str, _var, _type, _flags, _expected, ...) \
> +       do {                                                            \
> +               _type _ptrdata = __VA_ARGS__;                           \
> +               void *_ptr = &_ptrdata;                                 \
> +               int _err;                                               \
> +                                                                       \
> +               _err = btf_dump_data(_b, _d, _var, _flags, _ptr,        \
> +                                    sizeof(_type), _str, _expected);   \
> +               if (_err < 0)                                           \
> +                       return;                                         \

same, don't return early

> +       } while (0)
> +
> +static void test_btf_dump_int_data(struct btf *btf, struct btf_dump *d,
> +                                  char *str)
> +{
> +       /* simple int */
> +       TEST_BTF_DUMP_DATA_C(btf, d, str, int, BTF_F_COMPACT, 1234);
> +       TEST_BTF_DUMP_DATA(btf, d, str, int, BTF_F_COMPACT | BTF_F_NONAME,
> +                          "1234", 1234);
> +       TEST_BTF_DUMP_DATA(btf, d, str, int, 0, "(int)1234", 1234);
> +
> +       /* zero value should be printed at toplevel */
> +       TEST_BTF_DUMP_DATA(btf, d, str, int, BTF_F_COMPACT, "(int)0", 0);
> +       TEST_BTF_DUMP_DATA(btf, d, str, int, BTF_F_COMPACT | BTF_F_NONAME,
> +                          "0", 0);
> +       TEST_BTF_DUMP_DATA(btf, d, str, int, BTF_F_COMPACT | BTF_F_ZERO,
> +                          "(int)0", 0);
> +       TEST_BTF_DUMP_DATA(btf, d, str, int,
> +                          BTF_F_COMPACT | BTF_F_NONAME | BTF_F_ZERO,
> +                          "0", 0);
> +       TEST_BTF_DUMP_DATA_C(btf, d, str, int, BTF_F_COMPACT, -4567);
> +       TEST_BTF_DUMP_DATA(btf, d, str, int, BTF_F_COMPACT | BTF_F_NONAME,
> +                          "-4567", -4567);
> +       TEST_BTF_DUMP_DATA(btf, d, str, int, 0, "(int)-4567", -4567);
> +
> +       TEST_BTF_DUMP_DATA_OVER(btf, d, str, int, sizeof(int)-1, "", 1);

all of these validations are independent of each other, so there is no
need to return early if any one fails (see above)

> +}
> +
> +static void test_btf_dump_float_data(struct btf *btf, struct btf_dump *d,
> +                                    char *str)
> +{
> +       float t1 = 1.234567;
> +       float t2 = -1.234567;
> +       float t3 = 0.0;
> +       double t4 = 5.678912;
> +       double t5 = -5.678912;
> +       double t6 = 0.0;
> +       long double t7 = 9.876543;
> +       long double t8 = -9.876543;
> +       long double t9 = 0.0;
> +
> +       /* since the kernel does not likely have any float types in its BTF, we
> +        * will need to add some of various sizes.
> +        */
> +
> +       if (!ASSERT_GT(btf__add_float(btf, "test_float", 4), 0, "add float"))
> +               return;
> +       if (!ASSERT_OK(btf_dump_data(btf, d, "test_float", 0, &t1, 4, str,
> +                                    "(test_float)1.234567"), "dump float"))
> +               return;
> +
> +       if (!ASSERT_OK(btf_dump_data(btf, d, "test_float", 0, &t2, 4, str,
> +                                    "(test_float)-1.234567"), "dump float"))
> +               return;
> +       if (!ASSERT_OK(btf_dump_data(btf, d, "test_float", 0, &t3, 4, str,
> +                                    "(test_float)0.000000"), "dump float"))
> +               return;
> +
> +       if (!ASSERT_GT(btf__add_float(btf, "test_double", 8), 0, "add_double"))
> +               return;
> +       if (!ASSERT_OK(btf_dump_data(btf, d, "test_double", 0, &t4, 8, str,
> +                                    "(test_double)5.678912"), "dump double"))
> +               return;
> +       if (!ASSERT_OK(btf_dump_data(btf, d, "test_double", 0, &t5, 8, str,
> +                                    "(test_double)-5.678912"), "dump double"))
> +               return;
> +       if (!ASSERT_OK(btf_dump_data(btf, d, "test_double", 0, &t6, 8, str,
> +                                    "(test_double)0.000000"), "dump double"))
> +               return;
> +
> +       if (!ASSERT_GT(btf__add_float(btf, "test_long_double", 16), 0,
> +                      "add_long_double"))
> +               return;
> +       if (!ASSERT_OK(btf_dump_data(btf, d, "test_long_double", 0, &t7, 16,
> +                                    str, "(test_long_double)9.876543"),
> +                                    "dump long_double"))
> +               return;
> +       if (!ASSERT_OK(btf_dump_data(btf, d, "test_long_double", 0, &t8, 16,
> +                                    str, "(test_long_double)-9.876543"),
> +                                    "dump long_double"))
> +               return;
> +       ASSERT_OK(btf_dump_data(btf, d, "test_long_double", 0, &t9, 16,
> +                               str, "(test_long_double)0.000000"),
> +                               "dump long_double");

same, don't return, just have a list of assertions

> +}
> +

[...]

> +                          { .next = (struct list_head *)1 });
> +       /* NULL pointer should not be displayed */
> +       TEST_BTF_DUMP_DATA(btf, d, str, struct list_head, BTF_F_COMPACT,
> +                          "(struct list_head){}",
> +                          { .next = (struct list_head *)0 });
> +       TEST_BTF_DUMP_DATA(btf, d, str, struct list_head, 0,
> +"(struct list_head){\n"
> +"}",
> +                          { .next = (struct list_head *)0 });
> +
> +       /* struct with function pointers */
> +       type_id = btf__find_by_name(btf, "file_operations");
> +       if (CHECK(type_id <= 0, "find type id",

some more CHECK leftovers, please switch all CHECKs to ASSERT_xxx

> +                 "no 'struct file_operations' in BTF: %d\n", type_id))
> +               return;
> +       type_sz = btf__resolve_size(btf, type_id);
> +       str[0] = '\0';
> +
> +       ret = btf_dump__dump_type_data(d, type_id, fops, type_sz, &opts);
> +       if (CHECK(ret != type_sz,
> +                 "dump file_operations is successful",
> +                 "unexpected return value dumping file_operations '%s': %d\n",
> +                 str, ret))
> +               return;
> +
> +       cmpstr =
> +"(struct file_operations){\n"
> +"      .owner = (struct module *)0xffffffffffffffff,\n"
> +"      .llseek = (loff_t (*)(struct file *, loff_t, int))0xffffffffffffffff,";
> +
> +       if (!ASSERT_STRNEQ(str, cmpstr, strlen(cmpstr), "file_operations"))
> +               return;

same as above, even if this fails, we can still run all the other
validations safely

> +
> +       /* struct with char array */
> +       TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info, BTF_F_COMPACT,
> +                          "(struct bpf_prog_info){.name = (char[16])['f','o','o',],}",
> +                          { .name = "foo",});
> +       TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info,
> +                          BTF_F_COMPACT | BTF_F_NONAME,
> +                          "{['f','o','o',],}",
> +                          {.name = "foo",});

[...]

>  void test_btf_dump() {
> +       char str[STRSIZE];
> +       struct btf_dump_opts opts = { .ctx = str };
> +       struct btf_dump *d;
> +       struct btf *btf;
>         int i;
>
>         for (i = 0; i < ARRAY_SIZE(btf_dump_test_cases); i++) {
> @@ -245,4 +859,34 @@ void test_btf_dump() {
>         }
>         if (test__start_subtest("btf_dump: incremental"))
>                 test_btf_dump_incremental();
> +
> +       btf = libbpf_find_kernel_btf();
> +       if (CHECK(!btf, "get kernel BTF", "no kernel BTF found"))
> +               return;
> +
> +       d = btf_dump__new(btf, NULL, &opts, btf_dump_snprintf);
> +
> +       if (CHECK(!d, "new dump", "could not create BTF dump"))
> +               return;

goto clean and free dumper and btf?

> +
> +       /* Verify type display for various types. */
> +       if (test__start_subtest("btf_dump: int_data"))
> +               test_btf_dump_int_data(btf, d, str);
> +       if (test__start_subtest("btf_dump: float_data"))
> +               test_btf_dump_float_data(btf, d, str);
> +       if (test__start_subtest("btf_dump: char_data"))
> +               test_btf_dump_char_data(btf, d, str);
> +       if (test__start_subtest("btf_dump: typedef_data"))
> +               test_btf_dump_typedef_data(btf, d, str);
> +       if (test__start_subtest("btf_dump: enum_data"))
> +               test_btf_dump_enum_data(btf, d, str);
> +       if (test__start_subtest("btf_dump: struct_data"))
> +               test_btf_dump_struct_data(btf, d, str);
> +       if (test__start_subtest("btf_dump: var_data"))
> +               test_btf_dump_var_data(btf, d, str);
> +       btf_dump__free(d);
> +       btf__free(btf);
> +
> +       if (test__start_subtest("btf_dump: datasec_data"))
> +               test_btf_dump_datasec_data(str);
>  }
> --
> 1.8.3.1
>
