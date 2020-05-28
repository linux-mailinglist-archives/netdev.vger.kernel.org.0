Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE601E61D0
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 15:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390141AbgE1NKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 09:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390089AbgE1NKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 09:10:12 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971DAC05BD1E
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 06:10:12 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id k8so38090edq.4
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 06:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=qIxCM5clP0V/WHRc0bI4knedWRT4u2sYTHtbg4GlH94=;
        b=NGecVZPZgXaRfKTyLiGpMgvmTJgXSgVwnajXXcBbDSKTxoiaN9mJrKYngtuyiTiplW
         7sBKQED3uX1trxdzOIgMtv2oFb3BkeXwnRr02ZHM1HBtj7/KdEWWskSYfLKqyktYP6W8
         bNkaGBZ6vdZ6gqOWEOeb6ERt05Eo/2XAPgHvo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=qIxCM5clP0V/WHRc0bI4knedWRT4u2sYTHtbg4GlH94=;
        b=JvQXVEU0Siv5SA6lEuFt3Voho7CLQzPFF1SHJfUR9jPI5MQU2GamQ4wKNRlKhVu7uZ
         rwlemFfbll3G1jP31oIeEqaNxK557mXAk1fOqJuZcSzYyyeYDvETt8tnpjEZyUhnirpV
         G5ykpzE37tod9WM/n7VNBOIht5W3ng17REashe1rYdBRw5y6QQlOGGtbWpKg7wdmZ1G1
         SwOTxc04N4v1zCc7VWKUs7tjNBjS1G1doYyvs3owTOaaDp0plg3cSmhzzBkOYOwJmCMl
         /5fF0uBL7LSZuRXsmhhoc90FPxjeMKJHPKuVucY6xiPnOlap5QitSPgE2RXdIKX60OrJ
         yPGA==
X-Gm-Message-State: AOAM530oSdOpgalyIt1rRuwP0DO+2uHGOGmrvLCkbLBqESw47IwEcKLX
        vZKFO2g5zXyWHqu1tPfyIrJ0j+SCJ4g=
X-Google-Smtp-Source: ABdhPJwRgj9VjmRkwRk09C50qffoR5S1baecvja2acjwg/lNfnUWsFl/Z54kh9cbHqM6ukKa3cUhyA==
X-Received: by 2002:a05:6402:3076:: with SMTP id bs22mr3127605edb.161.1590671411269;
        Thu, 28 May 2020 06:10:11 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id h7sm4637066eds.43.2020.05.28.06.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 06:10:10 -0700 (PDT)
References: <20200527170840.1768178-1-jakub@cloudflare.com> <20200527170840.1768178-8-jakub@cloudflare.com> <CAEf4Bzb8cAOTc4G01020_Kd=z5p+XA+zqmtRvEj9JQsLw3-8sQ@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com
Subject: Re: [PATCH bpf-next 7/8] bpftool: Support link show for netns-attached links
In-reply-to: <CAEf4Bzb8cAOTc4G01020_Kd=z5p+XA+zqmtRvEj9JQsLw3-8sQ@mail.gmail.com>
Date:   Thu, 28 May 2020 15:10:09 +0200
Message-ID: <87mu5s2ojy.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 08:02 AM CEST, Andrii Nakryiko wrote:
> On Wed, May 27, 2020 at 12:16 PM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> Make `bpf link show` aware of new link type, that is links attached to
>> netns. When listing netns-attached links, display netns inode number as its
>> identifier and link attach type.
>>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>>  tools/bpf/bpftool/link.c | 19 +++++++++++++++++++
>>  1 file changed, 19 insertions(+)
>>
>> diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
>> index 670a561dc31b..83a17d62c4c3 100644
>> --- a/tools/bpf/bpftool/link.c
>> +++ b/tools/bpf/bpftool/link.c
>> @@ -17,6 +17,7 @@ static const char * const link_type_name[] = {
>>         [BPF_LINK_TYPE_TRACING]                 = "tracing",
>>         [BPF_LINK_TYPE_CGROUP]                  = "cgroup",
>>         [BPF_LINK_TYPE_ITER]                    = "iter",
>> +       [BPF_LINK_TYPE_NETNS]                   = "netns",
>>  };
>>
>>  static int link_parse_fd(int *argc, char ***argv)
>> @@ -122,6 +123,16 @@ static int show_link_close_json(int fd, struct bpf_link_info *info)
>>                         jsonw_uint_field(json_wtr, "attach_type",
>>                                          info->cgroup.attach_type);
>>                 break;
>> +       case BPF_LINK_TYPE_NETNS:
>> +               jsonw_uint_field(json_wtr, "netns_ino",
>> +                                info->netns.netns_ino);
>> +               if (info->netns.attach_type < ARRAY_SIZE(attach_type_name))
>> +                       jsonw_string_field(json_wtr, "attach_type",
>> +                               attach_type_name[info->netns.attach_type]);
>> +               else
>> +                       jsonw_uint_field(json_wtr, "attach_type",
>> +                                        info->netns.attach_type);
>> +               break;
>
> Can you please extract this attach_type handling into a helper func,
> it's annoying to read so many repetitive if/elses. Same for plain-text
> variant below. Thanks!

Looks easy enough. Will be done in v2.

>
>>         default:
>>                 break;
>>         }
>> @@ -190,6 +201,14 @@ static int show_link_close_plain(int fd, struct bpf_link_info *info)
>>                 else
>>                         printf("attach_type %u  ", info->cgroup.attach_type);
>>                 break;
>> +       case BPF_LINK_TYPE_NETNS:
>> +               printf("\n\tnetns_ino %u  ", info->netns.netns_ino);
>> +               if (info->netns.attach_type < ARRAY_SIZE(attach_type_name))
>> +                       printf("attach_type %s  ",
>> +                              attach_type_name[info->netns.attach_type]);
>> +               else
>> +                       printf("attach_type %u  ", info->netns.attach_type);
>> +               break;
>>         default:
>>                 break;
>>         }
>> --
>> 2.25.4
>>

