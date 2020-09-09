Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7822263241
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731081AbgIIQiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730999AbgIIQib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:38:31 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55899C061755
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 09:38:31 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id a17so3682712wrn.6
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 09:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zlCXoh4+Ps5LZ1bOVi6YNpKFwSqs0eP8KynQVhmz8P4=;
        b=Sa5VHmkxINSOFcyX8cPwMwajgLrPWoQmJAX/wtk1zMqefh1s7Fr0mBcV4uZkofVMHg
         4QBUgtQ8Ck1f02mCQ0b92ZlMke/kiRjfMMabRYKQsdTZjiRClnit6bQxif0Tipyx86fx
         pXXWSqlBhXN596jFVkkY2C/rw/yFtjMuKUE3sjYP2wqu+PmYeHJ1olqCBrJCewbFkQJ7
         7pGW50TJkx7UcVbf0PlX8GsOZObOQSMelKznWwRymjXs2px79Bq8+WQ1ZiH34Og5YzXU
         maZI3K7C/BrsucorI0dh8PMMDRZFsMGHHR6cKcZ0nxFl7D1cnYGsgI7OGmEejE/9r/xz
         mLvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zlCXoh4+Ps5LZ1bOVi6YNpKFwSqs0eP8KynQVhmz8P4=;
        b=k6KZ6NvwzUAIWO0jyfZDPUTZ5oYdYM1JHAQKBSc9RRZE1uw35J8VyWUafPlFU/AxlD
         NRHwb7x03sI2OGJMfkaJ5x2Fh2QRUSPoNS/dhfuUE6ZS7DwU0e73xRoL8iKzSSRPhKEe
         /CGgW+bSEHvsCHDumYREaBLfKwM3DN51fDMJdZPkGjHwv5bi5iQPiqbVz9hxnJZ65Aoe
         NE4ZyG3WN5NNrzCbmquxyTo5bkzGfVLm5edDO5Vzl2YOl5l3HqS3CWOhW3U+PS/yjl/O
         62evXfseSHG7pU9YA8e0sHpfJYIdMws7xX011BMbsGn6MBoXh8B30QidmsnPYotWcjSu
         xxnQ==
X-Gm-Message-State: AOAM533HJQIAl2cSHXljAi1xNcwsT3mD82yyMwoxZmt3De/CzT49IbMO
        fjH8uMwE8hYqQymRh/U27jQXZfeT5XtTr7RQ5JY=
X-Google-Smtp-Source: ABdhPJz7Mz5jcXKUlqug9CTRpyVNEXXSlw6WqNMsDHUP7/ajJc+L+sNtxpbWS6zUHCnYK8/qx9FHxg==
X-Received: by 2002:a5d:6301:: with SMTP id i1mr4484462wru.323.1599669509449;
        Wed, 09 Sep 2020 09:38:29 -0700 (PDT)
Received: from [192.168.1.12] ([194.35.119.95])
        by smtp.gmail.com with ESMTPSA id u66sm4773675wme.12.2020.09.09.09.38.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 09:38:28 -0700 (PDT)
Subject: Re: [PATCH bpf-next v2 1/2] tools: bpftool: clean up function to dump
 map entry
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
References: <20200907163634.27469-1-quentin@isovalent.com>
 <20200907163634.27469-2-quentin@isovalent.com>
 <CAEf4Bzb8QLVdjBY9hRCP7QdnqE-JwWqDn8hFytOL40S=Z+KW-w@mail.gmail.com>
 <b89b4bbd-a28e-4dde-b400-4d64fc391bfe@isovalent.com>
 <CAEf4Bzb0SdZBfDfd2ZBXOBgpneAc6mKFhzULj_Msd0MoNSG5ng@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <5a002828-c082-3cd7-9ee3-7d783cce2a2a@isovalent.com>
Date:   Wed, 9 Sep 2020 17:38:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <CAEf4Bzb0SdZBfDfd2ZBXOBgpneAc6mKFhzULj_Msd0MoNSG5ng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/09/2020 17:30, Andrii Nakryiko wrote:
> On Wed, Sep 9, 2020 at 1:19 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> On 09/09/2020 04:25, Andrii Nakryiko wrote:
>>> On Mon, Sep 7, 2020 at 9:36 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>>>
>>>> The function used to dump a map entry in bpftool is a bit difficult to
>>>> follow, as a consequence to earlier refactorings. There is a variable
>>>> ("num_elems") which does not appear to be necessary, and the error
>>>> handling would look cleaner if moved to its own function. Let's clean it
>>>> up. No functional change.
>>>>
>>>> v2:
>>>> - v1 was erroneously removing the check on fd maps in an attempt to get
>>>>   support for outer map dumps. This is already working. Instead, v2
>>>>   focuses on cleaning up the dump_map_elem() function, to avoid
>>>>   similar confusion in the future.
>>>>
>>>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>>>> ---
>>>>  tools/bpf/bpftool/map.c | 101 +++++++++++++++++++++-------------------
>>>>  1 file changed, 52 insertions(+), 49 deletions(-)
>>>>
>>>> diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
>>>> index bc0071228f88..c8159cb4fb1e 100644
>>>> --- a/tools/bpf/bpftool/map.c
>>>> +++ b/tools/bpf/bpftool/map.c
>>>> @@ -213,8 +213,9 @@ static void print_entry_json(struct bpf_map_info *info, unsigned char *key,
>>>>         jsonw_end_object(json_wtr);
>>>>  }
>>>>
>>>> -static void print_entry_error(struct bpf_map_info *info, unsigned char *key,
>>>> -                             const char *error_msg)
>>>> +static void
>>>> +print_entry_error_msg(struct bpf_map_info *info, unsigned char *key,
>>>> +                     const char *error_msg)
>>>>  {
>>>>         int msg_size = strlen(error_msg);
>>>>         bool single_line, break_names;
>>>> @@ -232,6 +233,40 @@ static void print_entry_error(struct bpf_map_info *info, unsigned char *key,
>>>>         printf("\n");
>>>>  }
>>>>
>>>> +static void
>>>> +print_entry_error(struct bpf_map_info *map_info, void *key, int lookup_errno)
>>>> +{
>>>> +       /* For prog_array maps or arrays of maps, failure to lookup the value
>>>> +        * means there is no entry for that key. Do not print an error message
>>>> +        * in that case.
>>>> +        */
>>>
>>> this is the case when error is ENOENT, all the other ones should be
>>> treated the same, no?
>>
>> Do you mean all map types should be treated the same? If so, I can
>> remove the check below, as in v1. Or do you mean there is a missing
>> check on the error value? In which case I can extend this check to
>> verify we have ENOENT.
> 
> The former, probably. I don't see how map-in-map is different for
> lookups and why it needs special handling.

I didn't find a particular reason in the logs. My guess is that they may
be more likely to have "empty" entries than other types, and that it
might be more difficult to spot the existing entries in the middle of a
list of "<no entry>" messages.

But I agree, let's get rid of this special case and have the same output
for all types. I'll respin.

Thanks again,
Quentin
