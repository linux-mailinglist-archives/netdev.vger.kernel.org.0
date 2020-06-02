Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7BC1EB8A1
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 11:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgFBJhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 05:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbgFBJhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 05:37:12 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49060C061A0E
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 02:37:12 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id o15so12048601ejm.12
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 02:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=yH03CJIHckJVBkbjqZkuGweYUGX1vX1nVQpBmI8JtJQ=;
        b=MkZn0Oc2YPIO9mo8lV9QP55Ifa0/gh9tYDne0Wx4SRxG2KAwBSWT3NGcBW7QaaUdWS
         r8swF+qu6NLsi+rZFalbNf2NtCnMdSDZ8h6CMGBl/DZLwBATsbaNuk0VmSrEgz5IQRzJ
         rQumCeirSFF9ON+0NEQynrukCEuhrRMp0TlEM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=yH03CJIHckJVBkbjqZkuGweYUGX1vX1nVQpBmI8JtJQ=;
        b=KdVZFKaFC21FRJ5ac/iwFKP/W/hozY+0GoGEEZlNoerRNjC2Q0gDQzLCWX+Dl1tMqf
         nAVWaMnSFQ8xPweeulJP+RIQVaZgM6jFGHcFeXYOothBaokCpYEQU2L9KahkHjSWurxu
         s/x0FqEcwsB8gsY6eSwyOpzbm8q/eHXZSfIXzO1QqyinS0UjpSuBEnQ3pJ0IHDDIYVru
         Xvcdpw2vvJe3vp2iepem+W2aXjCscQ75/Qc+fVobNcZszvptqC1Rl/maQqfSvaMwauEc
         ILV4rqvEqu+75mYYkKlVpDzo1KQLRuyrAtu3KdsJZTNmUxvra6PGDPCFcGEOGqUEf9s1
         lErQ==
X-Gm-Message-State: AOAM530sVL/AkowjQ7npqfD8ULA76Kljl6aWOknfS0sBz622Cp9DaLhQ
        SqD5b/6TjB64CrbDlcNlHM8QNw==
X-Google-Smtp-Source: ABdhPJykkk+ugrzAeS/7I7eJvWYkPvMZtXL8s4/Uc71P9D/a1e/3PMyCiWB4ocdOftx5+rTeGZRE4g==
X-Received: by 2002:a17:906:af84:: with SMTP id mj4mr16937690ejb.473.1591090630825;
        Tue, 02 Jun 2020 02:37:10 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id u23sm1271702eds.73.2020.06.02.02.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 02:37:10 -0700 (PDT)
References: <20200531082846.2117903-1-jakub@cloudflare.com> <20200531082846.2117903-8-jakub@cloudflare.com> <CAEf4BzZqtuA_45g_87jyuAdmvid=XuLGekgBdWY8i94Pnztm7Q@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com, Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next v2 07/12] bpftool: Extract helpers for showing link attach type
In-reply-to: <CAEf4BzZqtuA_45g_87jyuAdmvid=XuLGekgBdWY8i94Pnztm7Q@mail.gmail.com>
Date:   Tue, 02 Jun 2020 11:37:09 +0200
Message-ID: <87eeqx3j22.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 02, 2020 at 12:35 AM CEST, Andrii Nakryiko wrote:
> On Sun, May 31, 2020 at 1:32 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> Code for printing link attach_type is duplicated in a couple of places, and
>> likely will be duplicated for future link types as well. Create helpers to
>> prevent duplication.
>>
>> Suggested-by: Andrii Nakryiko <andriin@fb.com>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>
> LGTM, minor nit below.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
>
>>  tools/bpf/bpftool/link.c | 44 ++++++++++++++++++++--------------------
>>  1 file changed, 22 insertions(+), 22 deletions(-)
>>
>> diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
>> index 670a561dc31b..1ff416eff3d7 100644
>> --- a/tools/bpf/bpftool/link.c
>> +++ b/tools/bpf/bpftool/link.c
>> @@ -62,6 +62,15 @@ show_link_header_json(struct bpf_link_info *info, json_writer_t *wtr)
>>         jsonw_uint_field(json_wtr, "prog_id", info->prog_id);
>>  }
>>
>> +static void show_link_attach_type_json(__u32 attach_type, json_writer_t *wtr)
>
> nit: if you look at jsonw_uint_field/jsonw_string_field, they accept
> json_write_t as a first argument, because they are sort of working on
> "object" json_writer_t. I think that's good and consistent. No big
> deal, but if you can adjust it for consistency, it would be good.

I followed show_link_header_json example here. I'm guessing the
intention was to keep show_link_header_json and show_link_header_plain
consistent, as the former takes an extra arg (wtr).

>
>> +{
>> +       if (attach_type < ARRAY_SIZE(attach_type_name))
>> +               jsonw_string_field(wtr, "attach_type",
>> +                                  attach_type_name[attach_type]);
>> +       else
>> +               jsonw_uint_field(wtr, "attach_type", attach_type);
>> +}
>> +
>
> [...]
