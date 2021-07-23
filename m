Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A964C3D37B9
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 11:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbhGWIus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 04:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhGWIur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 04:50:47 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4C5C061757
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 02:31:20 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id b9so784663wrx.12
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 02:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ULEN3AF9y2KBfuSZET2D57IROuZfXaP5RAdmvwCafsQ=;
        b=OhpfGXZM9pyr07U9oikG8sZ8qa4lJe+DnSyMwCwxeM2LdOA1OtVArihKt5uXzQV9W3
         bIbXGGElH7gHM1sewzEtZyHlpY/jtLjTKkfcwGpJAGsZKK13QKh4oFW/VxArpyWJxwCD
         UQ5T/b5WApWXXuh8YXRPVtmfnj4Fba5tdgH7PD+pFSVFAwNnkE7i2fWSRtDEYVxNjqvN
         DGy3F8wscXMtDm2muIOCgfkVCc0gzmHArZUQ6TC9RUQ/NnA8A7c7EtGFFgrAxz/qtvhg
         cAp3AWn/oSqTbrQRkg/OOI/PcHarROs7MFUYvKTHd0mJJkhN73JesygbpREkpdZ6wvCE
         KC8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ULEN3AF9y2KBfuSZET2D57IROuZfXaP5RAdmvwCafsQ=;
        b=qD1p3Euyrvf3V4jCKV83nPxb/nDWrvzULkqtqxkf476UbrN5csNq8OKOtZlOPh33Ky
         tu75LRO93m0WUVSzOrw1exzkdEiFDqkTyMeZIAilhn11t2nEdTAdgHNRyireQnUAEKqF
         jguBWY98J8eLpS2iJYq7XqucEmu4ZguYdIWSSJPPLKJtgLWXrMYbomwzEbcoXTaNHFZw
         j+8+PqThC7KyXY9SZb0TEdGBZPk8J4141GAjRumZxlwvq0GZhRNSP6Fz2yuBmtxRkdok
         q0Ccccmw/sfOTQ8EjZZarTcR0vbb4ZpToaTd0vAz2hRV8ErLwzV2jKrPatoM32mxbFXj
         WZfQ==
X-Gm-Message-State: AOAM533U09TQVdMLmcaaPOcS8eUEYPIW8xP/v2q256AcUmVcXm5Bu/KD
        M8NwQb5BkhZRgUk2/3XC6DRt0A==
X-Google-Smtp-Source: ABdhPJxgh6pxnRcnHBhLb1rPmzNOcdIbhacj+NE08wUryBm7Ulk0nVYCxvklUbWQObfU6xiomwA/eQ==
X-Received: by 2002:adf:d84b:: with SMTP id k11mr202405wrl.135.1627032679155;
        Fri, 23 Jul 2021 02:31:19 -0700 (PDT)
Received: from [192.168.1.8] ([149.86.77.94])
        by smtp.gmail.com with ESMTPSA id g138sm32616967wmg.32.2021.07.23.02.31.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 02:31:18 -0700 (PDT)
Subject: Re: [PATCH bpf-next v2 2/5] libbpf: rename btf__get_from_id() as
 btf__load_from_kernel_by_id()
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
References: <20210721153808.6902-1-quentin@isovalent.com>
 <20210721153808.6902-3-quentin@isovalent.com>
 <CAEf4BzZqEZLt0_qgmniY-hqgEg7q0ur0Z5U0r8KFTwSz=2StSg@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <88d3cd19-5985-ad73-5f23-4f6f7d1b1be2@isovalent.com>
Date:   Fri, 23 Jul 2021 10:31:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZqEZLt0_qgmniY-hqgEg7q0ur0Z5U0r8KFTwSz=2StSg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-07-22 17:39 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> On Wed, Jul 21, 2021 at 8:38 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> Rename function btf__get_from_id() as btf__load_from_kernel_by_id() to
>> better indicate what the function does. Change the new function so that,
>> instead of requiring a pointer to the pointer to update and returning
>> with an error code, it takes a single argument (the id of the BTF
>> object) and returns the corresponding pointer. This is more in line with
>> the existing constructors.
>>
>> The other tools calling the deprecated btf__get_from_id() function will
>> be updated in a future commit.
>>
>> References:
>>
>> - https://github.com/libbpf/libbpf/issues/278
>> - https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#btfh-apis
>>
>> v2:
>> - Instead of a simple renaming, change the new function to make it
>>   return the pointer to the btf struct.
>> - API v0.5.0 instead of v0.6.0.
> 
> We generally keep such version changes to cover letters. It keeps each
> individual commit clean and collects full history in the cover letter
> which becomes a body of merge commit when the whole patch set is
> applied. For next revision please consolidate the history in the cover
> letter. Thanks!

OK will do.
I've seen other folks detailing the changes on individual patches, and
done so in the past, although it's true the current trend is to have it
in the cover letter (and I understand the motivation).

> 
>>
>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>> Acked-by: John Fastabend <john.fastabend@gmail.com>
>> ---
>>  tools/lib/bpf/btf.c      | 25 +++++++++++++++++--------
>>  tools/lib/bpf/btf.h      |  1 +
>>  tools/lib/bpf/libbpf.c   |  5 +++--
>>  tools/lib/bpf/libbpf.map |  1 +
>>  4 files changed, 22 insertions(+), 10 deletions(-)
>>
>> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
>> index 7e0de560490e..6654bdee7ad7 100644
>> --- a/tools/lib/bpf/btf.c
>> +++ b/tools/lib/bpf/btf.c
>> @@ -1383,21 +1383,30 @@ struct btf *btf_get_from_fd(int btf_fd, struct btf *base_btf)
>>         return btf;
>>  }
>>
>> +struct btf *btf__load_from_kernel_by_id(__u32 id)
>> +{
>> +       struct btf *btf;
>> +       int btf_fd;
>> +
>> +       btf_fd = bpf_btf_get_fd_by_id(id);
>> +       if (btf_fd < 0)
>> +               return ERR_PTR(-errno);
> 
> please use libbpf_err_ptr() for consistency, see
> bpf_object__open_mem() for an example

I can do that, but I'll need to uncouple btf__get_from_id() from the new
function. If it calls btf__load_from_kernel_by_id() and
LIBBPF_STRICT_CLEAN_PTRS is set, it would change its return value.

> 
>> +
>> +       btf = btf_get_from_fd(btf_fd, NULL);
>> +       close(btf_fd);
>> +
>> +       return libbpf_ptr(btf);
>> +}
>> +
>>  int btf__get_from_id(__u32 id, struct btf **btf)
>>  {
>>         struct btf *res;
>> -       int err, btf_fd;
>> +       int err;
>>
>>         *btf = NULL;
>> -       btf_fd = bpf_btf_get_fd_by_id(id);
>> -       if (btf_fd < 0)
>> -               return libbpf_err(-errno);
>> -
>> -       res = btf_get_from_fd(btf_fd, NULL);
>> +       res = btf__load_from_kernel_by_id(id);
>>         err = libbpf_get_error(res);
>>
>> -       close(btf_fd);
>> -
>>         if (err)
>>                 return libbpf_err(err);
>>
>> diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
>> index fd8a21d936ef..3db9446bc133 100644
>> --- a/tools/lib/bpf/btf.h
>> +++ b/tools/lib/bpf/btf.h
>> @@ -68,6 +68,7 @@ LIBBPF_API const void *btf__get_raw_data(const struct btf *btf, __u32 *size);
>>  LIBBPF_API const char *btf__name_by_offset(const struct btf *btf, __u32 offset);
>>  LIBBPF_API const char *btf__str_by_offset(const struct btf *btf, __u32 offset);
>>  LIBBPF_API int btf__get_from_id(__u32 id, struct btf **btf);
>> +LIBBPF_API struct btf *btf__load_from_kernel_by_id(__u32 id);
> 
> let's move this definition to after btf__parse() to keep all
> "constructors" together (we can move btf__get_from_id() there for
> completeness as well, I suppose).

I thought about that but wasn't sure, OK will do.

> 
>>  LIBBPF_API int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
>>                                     __u32 expected_key_size,
>>                                     __u32 expected_value_size,
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index 242e97892043..eff005b1eba1 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -9576,8 +9576,8 @@ static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_fd)
>>  {
>>         struct bpf_prog_info_linear *info_linear;
>>         struct bpf_prog_info *info;
>> -       struct btf *btf = NULL;
>>         int err = -EINVAL;
>> +       struct btf *btf;
>>
>>         info_linear = bpf_program__get_prog_info_linear(attach_prog_fd, 0);
>>         err = libbpf_get_error(info_linear);
>> @@ -9591,7 +9591,8 @@ static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_fd)
>>                 pr_warn("The target program doesn't have BTF\n");
>>                 goto out;
>>         }
>> -       if (btf__get_from_id(info->btf_id, &btf)) {
>> +       btf = btf__load_from_kernel_by_id(info->btf_id);
>> +       if (libbpf_get_error(btf)) {
> 
> there seems to be a bug in existing code and you are keeping it. On
> error err will be 0. Let's fix it. Same for above if (!info->btf_id),
> please fix that as well while you are at it.

Oh right, I saw that err was initialised at -EINVAL and did not notice
it was changed for the info_linear. I'll address it.
