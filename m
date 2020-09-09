Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF28262A0D
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgIIITo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgIIITl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:19:41 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902A4C061755
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:19:40 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id g4so1918270wrs.5
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3Oevd7iVtCDsmoMCjCDsQDgHNREENuQUSSMZLjv8SJY=;
        b=oTUiET38UXprPQVuamW2Qi51yJm2OStVaxWSwfBBZrM+OIrPco4rVDJOpW9ZebC1tW
         0hfWTkvnGQMVyVjd0Qoc8YGYw+IIZ4ewIEToCCXcZjRHYQrCYTEo3+Ci2rjGIUhEdsTn
         jQtyvCa1SzINq+J/VEkhwFFs8WCuv9/Ue8M8mki8LTpu75uRHvLJk7PMIjdi6Z6VqMm/
         YVZekZ7m/1aEEYiCf35Wd+DW1ePa34HxPXn4oeQucAbI+OB3O2gLtHfWFliqIDYf9n9g
         2Rkm5HaYZzj9vHe5jkVLxx+xeZx5Yjau9MVN4SzXiG81ZIsjpuYflryeyM08rEjE4R5f
         pgdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3Oevd7iVtCDsmoMCjCDsQDgHNREENuQUSSMZLjv8SJY=;
        b=ZIDsUSGkvN+tOoJm5w5m4DAuz3GVNJsRJnW0IMArWkLSD/Qvsm8wFUHZb0heYOQf+C
         z/0BCYQGwFH9+C93TnMQg2qv2pVn5HXZwM+Yp4QXzMy8rXDEp6NZ71zdEehsdl9bFFAe
         NTkvCqRVoy4HcJgBRtdGeNRhSPTPxorpTAfcXQmXQGi+pqYEuJxuvY+AT3hvIdrR/1Z+
         wlPqcwU9FdaydehTTXNYYNKHQ24NlqeJ/moQQyVhBWsO0Vg/+9EjX6Gtb43JCwbGgDRh
         inrsrk9rdSMml7r5/GXGGYelUxWwGh150s26kBZTLqYURDok8Zes/DOMzrvsb3ZBhzlh
         +eJg==
X-Gm-Message-State: AOAM532BSc1zjYJbIwdfAsMGpIqueVZJ2Tbx5ajPNvJojuCUozAaDLpq
        9MoWrgRX47wJhCgOYdjnKiY/y0hppvh/eCPqjJQ=
X-Google-Smtp-Source: ABdhPJzuIUQ3D0Sn6FNu5ARK7tlponD66y4IQe7I9qqRksdNKM/7Te7pLVhcjZZfgYIPUqoxIj0o2Q==
X-Received: by 2002:adf:cc8c:: with SMTP id p12mr2876875wrj.92.1599639578773;
        Wed, 09 Sep 2020 01:19:38 -0700 (PDT)
Received: from [192.168.1.12] ([194.35.119.152])
        by smtp.gmail.com with ESMTPSA id s11sm3015593wrt.43.2020.09.09.01.19.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 01:19:38 -0700 (PDT)
Subject: Re: [PATCH bpf-next v2 1/2] tools: bpftool: clean up function to dump
 map entry
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
References: <20200907163634.27469-1-quentin@isovalent.com>
 <20200907163634.27469-2-quentin@isovalent.com>
 <CAEf4Bzb8QLVdjBY9hRCP7QdnqE-JwWqDn8hFytOL40S=Z+KW-w@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <b89b4bbd-a28e-4dde-b400-4d64fc391bfe@isovalent.com>
Date:   Wed, 9 Sep 2020 09:19:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <CAEf4Bzb8QLVdjBY9hRCP7QdnqE-JwWqDn8hFytOL40S=Z+KW-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/09/2020 04:25, Andrii Nakryiko wrote:
> On Mon, Sep 7, 2020 at 9:36 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> The function used to dump a map entry in bpftool is a bit difficult to
>> follow, as a consequence to earlier refactorings. There is a variable
>> ("num_elems") which does not appear to be necessary, and the error
>> handling would look cleaner if moved to its own function. Let's clean it
>> up. No functional change.
>>
>> v2:
>> - v1 was erroneously removing the check on fd maps in an attempt to get
>>   support for outer map dumps. This is already working. Instead, v2
>>   focuses on cleaning up the dump_map_elem() function, to avoid
>>   similar confusion in the future.
>>
>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>> ---
>>  tools/bpf/bpftool/map.c | 101 +++++++++++++++++++++-------------------
>>  1 file changed, 52 insertions(+), 49 deletions(-)
>>
>> diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
>> index bc0071228f88..c8159cb4fb1e 100644
>> --- a/tools/bpf/bpftool/map.c
>> +++ b/tools/bpf/bpftool/map.c
>> @@ -213,8 +213,9 @@ static void print_entry_json(struct bpf_map_info *info, unsigned char *key,
>>         jsonw_end_object(json_wtr);
>>  }
>>
>> -static void print_entry_error(struct bpf_map_info *info, unsigned char *key,
>> -                             const char *error_msg)
>> +static void
>> +print_entry_error_msg(struct bpf_map_info *info, unsigned char *key,
>> +                     const char *error_msg)
>>  {
>>         int msg_size = strlen(error_msg);
>>         bool single_line, break_names;
>> @@ -232,6 +233,40 @@ static void print_entry_error(struct bpf_map_info *info, unsigned char *key,
>>         printf("\n");
>>  }
>>
>> +static void
>> +print_entry_error(struct bpf_map_info *map_info, void *key, int lookup_errno)
>> +{
>> +       /* For prog_array maps or arrays of maps, failure to lookup the value
>> +        * means there is no entry for that key. Do not print an error message
>> +        * in that case.
>> +        */
> 
> this is the case when error is ENOENT, all the other ones should be
> treated the same, no?

Do you mean all map types should be treated the same? If so, I can
remove the check below, as in v1. Or do you mean there is a missing
check on the error value? In which case I can extend this check to
verify we have ENOENT.

>> +       if (map_is_map_of_maps(map_info->type) ||
>> +           map_is_map_of_progs(map_info->type))
>> +               return;
>> +
>> +       if (json_output) {
>> +               jsonw_start_object(json_wtr);   /* entry */
>> +               jsonw_name(json_wtr, "key");
>> +               print_hex_data_json(key, map_info->key_size);
>> +               jsonw_name(json_wtr, "value");
>> +               jsonw_start_object(json_wtr);   /* error */
>> +               jsonw_string_field(json_wtr, "error", strerror(lookup_errno));
>> +               jsonw_end_object(json_wtr);     /* error */
>> +               jsonw_end_object(json_wtr);     /* entry */
>> +       } else {
>> +               const char *msg = NULL;
>> +
>> +               if (lookup_errno == ENOENT)
>> +                       msg = "<no entry>";
>> +               else if (lookup_errno == ENOSPC &&
>> +                        map_info->type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY)
>> +                       msg = "<cannot read>";
>> +
>> +               print_entry_error_msg(map_info, key,
>> +                                     msg ? : strerror(lookup_errno));
>> +       }
>> +}
>> +
> 
> [...]
> 

