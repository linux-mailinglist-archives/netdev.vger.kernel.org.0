Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0105A39C547
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 04:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbhFECxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 22:53:21 -0400
Received: from mail-yb1-f172.google.com ([209.85.219.172]:33781 "EHLO
        mail-yb1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhFECxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 22:53:20 -0400
Received: by mail-yb1-f172.google.com with SMTP id f84so16466466ybg.0;
        Fri, 04 Jun 2021 19:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0hYX+6HpwYRLBNWPsV5sxWxfLC9QpEMY3Fh+1yVFR3w=;
        b=UP0zp4J/OzxSbXR5i5L+h5s9e+ZVyYJ+lw8IOKs/KpB3kTtsAkrjHOxAQXfzUprrFK
         WDFkuMeRqJ7Q247W3EwxRY1QK8zDg7VMWxQtlv4e6tXxGONlCnhF3cvnPyOmJRZzf8HV
         BR0hBSAb1YWhnLL5KAPlp8bTty2kMOqA4sHVqVg/lOixHVj9WJNoMRkWyK1NXzN58iZf
         93zHe2+FoV/tYbXTni6n6mvs4TaAivF0spVuSGcoffEyp4aIfdL2362AEf1J1JFdX+UI
         iLjazUQLWZ284cMrCLq27ARmALwalYDTrrGxyhcAVRKfafsHeiqDtwe5U73ds+13mdvC
         Qe/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0hYX+6HpwYRLBNWPsV5sxWxfLC9QpEMY3Fh+1yVFR3w=;
        b=dn1hTqvkWxCScmFlQnLrTS204NGKN5/fr4BvR8MjRfLaWNHmNBGLfGvL7A5Vyeirqo
         cjcrrTq2UkbmdzIRiLOuWxGLXrxoxQw9iXQlA4YNjv5gTs8SqqssCM05Uvm9g919C/K+
         4oWq3NPMh+Ha7bA0Ms7+WQ9SnSQqWO0IbpWEGew/yiK26t0wy1tCamXwO3e/2XvbRpAg
         kh/rpwX2KJGj2jIXQTmvUaCsLeye9Gh9R8jIGUrz0eol69M+WDwbJeo5+l6hVJdQAQLg
         p1ZlsE/nxJjmdM6ViiPB7Auss5rMPuRHHquF/wqcnmDzxHuTRofkW/CSo24ZauIkh2rP
         BnZA==
X-Gm-Message-State: AOAM530R6AQo0d6du0FrYSF0obVB53ESIiizrUfhSmjvE19prJf7YW2Y
        v0iVXfy8qtKJNuGagtFzsTb8H7ZMnJ/EXIgO9wg=
X-Google-Smtp-Source: ABdhPJwX+rzB6J1wsG+3/7kkYLlbOf83gienRlRx4GnyTLTD5wELbVLx0rPXr8TXddMRUV9JRUX2FODhCmfp/yYX3w4=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr8865985ybg.459.1622861418815;
 Fri, 04 Jun 2021 19:50:18 -0700 (PDT)
MIME-Version: 1.0
References: <1622558220-2849-1-git-send-email-alan.maguire@oracle.com> <1622558220-2849-3-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1622558220-2849-3-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Jun 2021 19:50:07 -0700
Message-ID: <CAEf4BzY8KTxsuKMb+CtU5xMftf+kmy6dpCAYSwCmmdmCeU=ONg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 2/2] selftests/bpf: add dump type data tests
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

On Tue, Jun 1, 2021 at 7:37 AM Alan Maguire <alan.maguire@oracle.com> wrote:
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
>  tools/testing/selftests/bpf/prog_tests/btf_dump.c | 638 ++++++++++++++++++++++
>  1 file changed, 638 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
> index 1b90e68..b78c308 100644
> --- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
> +++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
> @@ -232,6 +232,642 @@ void test_btf_dump_incremental(void)
>         btf__free(btf);
>  }
>
> +#define STRSIZE                                4096
> +
> +void btf_dump_snprintf(void *ctx, const char *fmt, va_list args)

static

> +{
> +       char *s = ctx, new[STRSIZE];
> +
> +       vsnprintf(new, STRSIZE, fmt, args);
> +       strncat(s, new, STRSIZE);
> +}
> +
> +/* skip "enum "/"struct " prefixes */
> +#define SKIP_PREFIX(_typestr, _prefix)                                 \
> +       do {                                                            \
> +               if (strncmp(_typestr, _prefix, strlen(_prefix)) == 0)   \
> +                       _typestr += strlen(_prefix) + 1;                \
> +       } while (0)
> +
> +int btf_dump_data(struct btf *btf, struct btf_dump *d,
> +                 char *name, __u64 flags, void *ptr,
> +                 size_t ptrsize, char *str, const char *expectedval)

static

naming nit: expected_val is much easier to read than expected_val,
same for ptrsize vs ptr_size; I'm also totally fine with shorter names
using common abbreviations (exp_val, ptr_sz, etc).

> +{
> +       DECLARE_LIBBPF_OPTS(btf_dump_type_data_opts, opts);
> +       int ret = 0, cmp;
> +       size_t typesize;
> +       __s32 type_id;
> +
> +       if (flags & BTF_F_COMPACT)
> +               opts.compact = true;
> +       if (flags & BTF_F_NONAME)
> +               opts.skip_names = true;
> +       if (flags & BTF_F_ZERO)
> +               opts.emit_zeroes = true;

nothing wrong with this, but just as an FYI, you could have combined
that with DECLARE_LIBBPF_OPTS above:

DECLARE_LIBBPF_OPTS(btf_dump_type_data_opts, opts,
    .compact = flags & BTF_F_COMPACT,
    .skip_names = flags & BTF_F_NONAME,
    .emit_zeroes = flags & BTF_F_ZERO,
);

> +       SKIP_PREFIX(name, "enum");
> +       SKIP_PREFIX(name, "struct");
> +       SKIP_PREFIX(name, "union");
> +       type_id = btf__find_by_name(btf, name);
> +       if (CHECK(type_id <= 0, "find type id",
> +                 "no '%s' in BTF: %d\n", name, type_id)) {

see all the variations of ASSERT_XXX() macros, they are shorter, have
more natural checks and they output argument values automatically if
condition doesn't hold. So this one would be

if (!ASSERT_GT(type_id, 0, "type_id")) {
    err = -ENOENT;
    goto err;
}

> +               ret = -ENOENT;
> +               goto err;
> +       }
> +       typesize = btf__resolve_size(btf, type_id);
> +       str[0] = '\0';
> +       ret = btf_dump__dump_type_data(d, type_id, ptr, ptrsize, &opts);
> +       if (typesize <= ptrsize) {
> +               if (CHECK(ret != typesize, "btf_dump__dump_type_data",
> +                         "failed/unexpected typesize: %d\n", ret))
> +                       goto err;
> +       } else {
> +               if (CHECK(ret != -E2BIG, "btf_dump__dump_type_data -E2BIG",
> +                         "failed to return -E2BIG: %d\n", ret))
> +                       goto err;
> +               ret = 0;
> +       }
> +
> +       cmp = strcmp(str, expectedval);
> +       if (CHECK(cmp, "ensure expected/actual match",
> +                 "'%s' does not match expected '%s': %d\n",
> +                 str, expectedval, cmp))
> +               ret = -EFAULT;

here ASSERT_STREQ() is useful

> +err:
> +       if (ret < 0)
> +               btf_dump__free(d);
> +       return ret;
> +}
> +
> +#define TEST_BTF_DUMP_DATA(_b, _d, _str, _type, _flags, _expected, ...)        \
> +       do {                                                            \
> +               char __ptrtype[64] = #_type;                            \
> +               char *_ptrtype = (char *)__ptrtype;                     \
> +               _type _ptrdata = __VA_ARGS__;                           \
> +               void *_ptr = &_ptrdata;                                 \
> +               int _err;                                               \
> +                                                                       \
> +               _err = btf_dump_data(_b, _d, _ptrtype, _flags, _ptr,    \
> +                                    sizeof(_type), _str, _expected);   \
> +               if (_err < 0)                                           \
> +                       return _err;                                    \
> +       } while (0)
> +
> +/* Use where expected data string matches its stringified declaration */
> +#define TEST_BTF_DUMP_DATA_C(_b, _d, _str, _type, _flags, ...)         \
> +       TEST_BTF_DUMP_DATA(_b, _d, _str, _type, _flags,                 \
> +                          "(" #_type ")" #__VA_ARGS__, __VA_ARGS__)
> +
> +/* overflow test; pass typesize < expected type size, ensure E2BIG returned */
> +#define TEST_BTF_DUMP_DATA_OVER(_b, _d, _str, _type, _typesize, _expected, ...)\
> +       do {                                                            \
> +               char __ptrtype[64] = #_type;                            \
> +               char *_ptrtype = (char *)__ptrtype;                     \
> +               _type _ptrdata = __VA_ARGS__;                           \
> +               void *_ptr = &_ptrdata;                                 \
> +               int _err;                                               \
> +                                                                       \
> +               _err = btf_dump_data(_b, _d, _ptrtype, 0, _ptr,         \
> +                                    _typesize, _str, _expected);       \
> +               if (_err < 0)                                           \
> +                       return _err;                                    \
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
> +                       return _err;                                    \
> +       } while (0)
> +
> +int test_btf_dump_int_data(struct btf *btf, struct btf_dump *d, char *str)

static here and in a bunch of places below

> +{
> +       /* simple int */
> +       TEST_BTF_DUMP_DATA_C(btf, d, str, int, BTF_F_COMPACT, 1234);
> +       TEST_BTF_DUMP_DATA(btf, d, str, int, BTF_F_COMPACT | BTF_F_NONAME,
> +                          "1234", 1234);
> +       TEST_BTF_DUMP_DATA(btf, d, str, int, 0, "(int)1234\n", 1234);

do you think it's a good idea to append \n? it seems so simple for
user to do that, if necessary; on the other hand, if user doesn't want
it, they would need to do strlen() and overwriting last character,
which seems like a hassle

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
> +       TEST_BTF_DUMP_DATA(btf, d, str, int, 0, "(int)-4567\n", -4567);
> +
> +       TEST_BTF_DUMP_DATA_OVER(btf, d, str, int, sizeof(int)-1, "", 1);
> +
> +       return 0;
> +}
> +
> +/* since the kernel does not likely have any float types in its BTF, we
> + * will need to add some of various sizes.
> + */
> +#define TEST_ADD_FLOAT(_btf, _name, _sz)                               \
> +       do {                                                            \
> +               int _err;                                               \
> +                                                                       \
> +               _err = btf__add_float(_btf, _name, _sz);                \
> +               if (CHECK(_err < 0, "btf__add_float",                   \
> +                         "could not add float of size %d: %d",         \
> +                         _sz, _err))                                   \
> +                       return _err;                                    \
> +       } while (0)
> +
> +#define TEST_DUMP_FLOAT(_b, _d, _str, _type, _flags, _data, _sz,       \
> +                       _expectedval)                                   \
> +       do {                                                            \
> +               int _err;                                               \
> +                                                                       \
> +               _err = btf_dump_data(_b, _d, _type, _flags,             \
> +                                    _data, _sz, _str, _expectedval);   \
> +               if (CHECK(_err < 0, "btf_dump float",                   \
> +                         "could not dump float data: %d\n", _err))     \
> +                       return _err;                                    \
> +       } while (0)
> +
> +int test_btf_dump_float_data(struct btf *btf, struct btf_dump *d, char *str)
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
> +       TEST_ADD_FLOAT(btf, "test_float", 4);

I don't get this love for macros. It makes debugging experience much
harder. It makes following the code harder. It doesn't save much
typing at all. TEST_BTF_DUMP_DATA at least adds some convenience, but
TEST_ADD_FLOAT and TEST_DUMP_FLOAT are completely useless, see below.

> +       TEST_DUMP_FLOAT(btf, d, str, "test_float", 0, &t1, 4,
> +                       "(test_float)1.234567\n");
> +       TEST_DUMP_FLOAT(btf, d, str, "test_float", 0, &t2, 4,
> +                       "(test_float)-1.234567\n");
> +       TEST_DUMP_FLOAT(btf, d, str, "test_float", 0, &t3, 4,
> +                       "(test_float)0.000000\n");

ASSERT_OK(btf_dump_data(btf, d, "test_float", 0, &t1, 4, str,
"(test_float)1.234567\n"));
ASSERT_OK(btf_dump_data(btf, d, "test_float", 0, &t2, 4, str,
"(test_float)-1.234567\n"));
ASSERT_OK(btf_dump_data(btf, d, "test_float", 0, &t3, 4, str,
"(test_float)0.000000\n"));

It even saved some lines of code.

> +
> +       TEST_ADD_FLOAT(btf, "test_double", 8);
> +       TEST_DUMP_FLOAT(btf, d, str, "test_double", 0, &t4, 8,
> +                       "(test_double)5.678912\n");
> +       TEST_DUMP_FLOAT(btf, d, str, "test_double", 0, &t5, 8,
> +                       "(test_double)-5.678912\n");
> +       TEST_DUMP_FLOAT(btf, d, str, "test_double", 0, &t6, 8,
> +                       "(test_double)0.000000\n");
> +

[...]

> +       TEST_BTF_DUMP_DATA(btf, d, str, struct btf_enum,
> +                          BTF_F_COMPACT | BTF_F_NONAME,
> +                          "{}",
> +                          { .name_off = 0, .val = 0,});
> +       TEST_BTF_DUMP_DATA(btf, d, str, struct btf_enum, 0,
> +                          "(struct btf_enum){\n}\n",
> +                          { .name_off = 0, .val = 0,});
> +       TEST_BTF_DUMP_DATA(btf, d, str, struct btf_enum,
> +                          BTF_F_COMPACT | BTF_F_ZERO,
> +                          "(struct btf_enum){.name_off = (__u32)0,.val = (__s32)0,}",
> +                          { .name_off = 0, .val = 0,});
> +       TEST_BTF_DUMP_DATA(btf, d, str, struct btf_enum,
> +                          BTF_F_ZERO,
> +                          "(struct btf_enum){\n\t.name_off = (__u32)0,\n\t.val = (__s32)0,\n}\n",

while for primitive types and enums above are expected strings are
pretty easy to follow, for structs it starts to break apart. For
instance, I find

"(struct btf_enum){\
        .name_off = (__u32)0,\
        .val = (__s32)0,\
}\
",

much more legible (I can mentally ignore \ at the end quite easily).
This single line \n\t stuff just gets messier for bigger structs.

> +                          { .name_off = 0, .val = 0,});
> +
> +       /* struct with pointers */
> +       TEST_BTF_DUMP_DATA(btf, d, str, struct list_head, BTF_F_COMPACT,
> +                          "(struct list_head){.next = (struct list_head *)0x1,}",
> +                          { .next = (struct list_head *)1 });
> +       TEST_BTF_DUMP_DATA(btf, d, str, struct list_head, 0,
> +                          "(struct list_head){\n\t.next = (struct list_head *)0x1,\n}\n",
> +                          { .next = (struct list_head *)1 });
> +       /* NULL pointer should not be displayed */
> +       TEST_BTF_DUMP_DATA(btf, d, str, struct list_head, BTF_F_COMPACT,
> +                          "(struct list_head){}",
> +                          { .next = (struct list_head *)0 });
> +       TEST_BTF_DUMP_DATA(btf, d, str, struct list_head, 0,
> +                          "(struct list_head){\n}\n",
> +                          { .next = (struct list_head *)0 });
> +
> +       /* struct with function pointers */
> +       type_id = btf__find_by_name(btf, "file_operations");
> +       if (CHECK(type_id <= 0, "find type id",
> +                 "no 'struct file_operations' in BTF: %d\n", type_id))
> +               return -ENOENT;
> +       typesize = btf__resolve_size(btf, type_id);
> +       str[0] = '\0';
> +
> +       ret = btf_dump__dump_type_data(d, type_id, fops, typesize, &opts);
> +       if (CHECK(ret != typesize,
> +                 "dump file_operations is successful",
> +                 "unexpected return value dumping file_operations '%s': %d\n",
> +                 str, ret))
> +               return -EINVAL;
> +
> +       cmpstr = "(struct file_operations){\n\t.owner = (struct module *)0xffffffffffffffff,\n\t.llseek = (loff_t(*)(struct file *, loff_t, int))0xffffffffffffffff,";
> +       cmp = strncmp(str, cmpstr, strlen(cmpstr));
> +       if (CHECK(cmp != 0, "check file_operations dump",
> +                 "file_operations '%s' did not match expected\n",

cmpstr logging is missing here. But I also think it's not the first
time there was a need to validate only portiong of string equality, so
I wonder if we should just add ASSERT_STRNEQ(actual, expected, len)
variant, it should be trivial to add.

> +                 str))
> +               return -EINVAL;
> +
> +       /* struct with char array */
> +       TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info, BTF_F_COMPACT,
> +                          "(struct bpf_prog_info){.name = (char[])['f','o','o',],}",
> +                          { .name = "foo",});
> +       TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info,
> +                          BTF_F_COMPACT | BTF_F_NONAME,
> +                          "{['f','o','o',],}",
> +                          {.name = "foo",});
> +       TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info, 0,
> +                          "(struct bpf_prog_info){\n\t.name = (char[])[\n\t\t'f',\n\t\t\'o',\n\t\t'o',\n\t],\n}\n",
> +                          {.name = "foo",});
> +       /* leading null char means do not display string */
> +       TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info, BTF_F_COMPACT,
> +                          "(struct bpf_prog_info){}",
> +                          {.name = {'\0', 'f', 'o', 'o'}});
> +       /* handle non-printable characters */
> +       TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_prog_info, BTF_F_COMPACT,
> +                          "(struct bpf_prog_info){.name = (char[])[1,2,3,],}",
> +                          { .name = {1, 2, 3, 0}});
> +
> +       /* struct with non-char array */
> +       TEST_BTF_DUMP_DATA(btf, d, str, struct __sk_buff, BTF_F_COMPACT,
> +                          "(struct __sk_buff){.cb = (__u32[])[1,2,3,4,5,],}",
> +                          { .cb = {1, 2, 3, 4, 5,},});
> +       TEST_BTF_DUMP_DATA(btf, d, str, struct __sk_buff,
> +                          BTF_F_COMPACT | BTF_F_NONAME,
> +                          "{[1,2,3,4,5,],}",
> +                          { .cb = { 1, 2, 3, 4, 5},});
> +       TEST_BTF_DUMP_DATA(btf, d, str, struct __sk_buff, 0,
> +                          "(struct __sk_buff){\n\t.cb = (__u32[])[\n\t\t1,\n\t\t2,\n\t\t3,\n\t\t4,\n\t\t5,\n\t],\n}\n",

As you can see above in my example patch, emit_type_decl would emit
this array type as __u32[5]. I think drgn that was used as an
inspiration for this format also does that. So I think it's good to
stick to __u32[5] here.

> +                          { .cb = { 1, 2, 3, 4, 5},});
> +       /* For non-char, arrays, show non-zero values only */
> +       TEST_BTF_DUMP_DATA(btf, d, str, struct __sk_buff, BTF_F_COMPACT,
> +                          "(struct __sk_buff){.cb = (__u32[])[0,0,1,0,0,],}",
> +                          { .cb = { 0, 0, 1, 0, 0},});
> +       TEST_BTF_DUMP_DATA(btf, d, str, struct __sk_buff, 0,
> +                          "(struct __sk_buff){\n\t.cb = (__u32[])[\n\t\t0,\n\t\t0,\n\t\t1,\n\t\t0,\n\t\t0,\n\t],\n}\n",
> +                          { .cb = { 0, 0, 1, 0, 0},});
> +
> +       /* struct with bitfields */
> +       TEST_BTF_DUMP_DATA_C(btf, d, str, struct bpf_insn, BTF_F_COMPACT,
> +               {.code = (__u8)1,.dst_reg = (__u8)0x2,.src_reg = (__u8)0x3,.off = (__s16)4,.imm = (__s32)5,});
> +       TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_insn,
> +                          BTF_F_COMPACT | BTF_F_NONAME,
> +                          "{1,0x2,0x3,4,5,}",
> +                          { .code = 1, .dst_reg = 0x2, .src_reg = 0x3, .off = 4,
> +                            .imm = 5,});
> +       TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_insn, 0,
> +                          "(struct bpf_insn){\n\t.code = (__u8)1,\n\t.dst_reg = (__u8)0x2,\n\t.src_reg = (__u8)0x3,\n\t.off = (__s16)4,\n\t.imm = (__s32)5,\n}\n",
> +                          {.code = 1, .dst_reg = 2, .src_reg = 3, .off = 4, .imm = 5});
> +
> +       /* zeroed bitfields should not be displayed */
> +       TEST_BTF_DUMP_DATA(btf, d, str, struct bpf_insn, BTF_F_COMPACT,
> +                          "(struct bpf_insn){.dst_reg = (__u8)0x1,}",
> +                          { .code = 0, .dst_reg = 1});
> +
> +       /* struct with enum bitfield */
> +       type_id = btf__find_by_name(btf, "nft_cmp_expr");

This nft_cmp_expr breaks our CI ([0]) because we don't build kernels
with CONFIG_NF_TABLES=y. Can you please find some other struct that
would be in a core kernel configuration? If not, you can just do the
same trick as with floats and generate your own struct with bitfields.

  [0] https://travis-ci.com/github/kernel-patches/bpf/builds/227876698

> +       if (CHECK(type_id <= 0, "find nft_cmp_expr",
> +                 "no 'struct nft_cmp_expr' in BTF: %d\n", type_id))
> +               return -ENOENT;
> +       typesize = btf__resolve_size(btf, type_id);
> +       str[0] = '\0';
> +

[...]

> +void test_btf_dump_data(void)
> +{
> +       struct btf *btf = libbpf_find_kernel_btf();
> +       char str[STRSIZE];
> +       struct btf_dump_opts opts = { .ctx = str };
> +       struct btf_dump *d;
> +
> +       if (CHECK(!btf, "get kernel BTF", "no kernel BTF found"))
> +               return;
> +
> +       d = btf_dump__new(btf, NULL, &opts, btf_dump_snprintf);
> +
> +       if (CHECK(!d, "new dump", "could not create BTF dump"))
> +               return;
> +
> +       /* Verify type display for various types. */
> +       if (test_btf_dump_int_data(btf, d, str))
> +               return;
> +       if (test_btf_dump_float_data(btf, d, str))
> +               return;
> +       if (test_btf_dump_char_data(btf, d, str))
> +               return;
> +       if (test_btf_dump_typedef_data(btf, d, str))
> +               return;
> +       if (test_btf_dump_enum_data(btf, d, str))
> +               return;
> +       if (test_btf_dump_struct_data(btf, d, str))
> +               return;
> +       if (test_btf_dump_var_data(btf, d, str))
> +               return;

it would be more convenient for each of those to be a subtest, and
there is no need to exit early if one of them fails, so don't return
early.

> +       btf_dump__free(d);
> +       btf__free(btf);
> +
> +       /* verify datasec display */
> +       if (test_btf_dump_datasec_data(str))
> +               return;
> +
> +}
> +
>  void test_btf_dump() {
>         int i;
>
> @@ -245,4 +881,6 @@ void test_btf_dump() {
>         }
>         if (test__start_subtest("btf_dump: incremental"))
>                 test_btf_dump_incremental();
> +       if (test__start_subtest("btf_dump: data"))

so instead of testing subtest name here, just do it for every
test_btf_dump_*_data above

> +               test_btf_dump_data();
>  }
> --
> 1.8.3.1
>
