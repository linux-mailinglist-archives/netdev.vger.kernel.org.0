Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABAC91985C4
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 22:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbgC3Ups (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 16:45:48 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36455 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbgC3Upr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 16:45:47 -0400
Received: by mail-qt1-f193.google.com with SMTP id m33so16437327qtb.3;
        Mon, 30 Mar 2020 13:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FFzlxLM1vgVJfHIOAtCmkgRX5Ovtm5xzqT5SoJ3HlAU=;
        b=sNCyQM7dq5e5mkE22UbeVpP0svxqdXkfdWCtKGSczYBUKFEf0Y2bQrbN02n1BuFEX8
         fUbGOA8f09O5WiKJtUx3Go4svlrlY8d/i8BKvDoUjEl2tEkxNJ0qzcdMe9BGaS2bNJ7E
         u7xFWgVdAndjgi3fGDJg5QGJQQOQVX716szt929ZvVBJ3DYQlxDTAkYIj/bTH4aIffKf
         0o19URmrIO8AHzcQIVk5/J1MdVD/Mkrtz1O8CUcIM0+oInrtn88AA8e1KcZuUWTzuqrk
         d8lS/ib6IoCIA+j65xm9sF8O0wX8qSjsNAihz0F0qw0b5qOAhB/R2bIl7KHaza1HHqcY
         /qzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FFzlxLM1vgVJfHIOAtCmkgRX5Ovtm5xzqT5SoJ3HlAU=;
        b=afB+8v53VVqqOp3MwAVEiaSe9aBQb+LGvBY/WwOKy45i3Ncwsx5YscwYcqaCxbx3IK
         uAP/TAh/28D/v9hteqXsJSWNVA8u9X3nOGiqGQzban/jd3jrjG8rU4SiS9wigNNqjPRh
         JT0aCNSkOZU7MjkDsu6UHZQDmqo0Jw1kfMSd4FEPGEpGaWh4pXy5yyK43Vaw96vbh/A0
         HolonIwo1xQhr65kI2ZDefNlwdqqlUelH2I1OpMAW7ZOLDtWPyQ6oCZGrdx4CbWNwkoM
         XTkNJv28u8O1JvF4w1DwDF17l1kmqJV3DNYA/nvERn9XAXhvfd8GRA5kaA9DNkZ4xCkO
         eWbQ==
X-Gm-Message-State: ANhLgQ0V0bi/8X/KOAHjYunxayBGqNsyreXI50gloZPyp8290gieWa7V
        eC7vSxCM4NapMae/S09xyhk=
X-Google-Smtp-Source: ADFU+vsb9ztTQllrb6dkhXGA01Im6N8C2YiemiN6F4YGtB3Wv0IFQxE/AXfdzeCasQbYwAdE9lm8Jg==
X-Received: by 2002:ac8:60a:: with SMTP id d10mr2008212qth.140.1585601146077;
        Mon, 30 Mar 2020 13:45:46 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:6833:d88e:92a1:cac9? ([2601:282:803:7700:6833:d88e:92a1:cac9])
        by smtp.googlemail.com with ESMTPSA id l22sm11737843qkj.120.2020.03.30.13.45.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2020 13:45:45 -0700 (PDT)
Subject: Re: [PATCH v3 bpf-next 0/4] Add support for cgroup bpf_link
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>, Kernel Team <kernel-team@fb.com>
References: <20200330030001.2312810-1-andriin@fb.com>
 <c9f52288-5ea8-a117-8a67-84ba48374d3a@gmail.com>
 <CAEf4BzZpCOCi1QfL0peBRjAOkXRwGEi_DAW4z34Mf3Tv_sbRFw@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <662788f9-0a53-72d4-2675-daec893b5b81@gmail.com>
Date:   Mon, 30 Mar 2020 14:45:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZpCOCi1QfL0peBRjAOkXRwGEi_DAW4z34Mf3Tv_sbRFw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/30/20 2:20 PM, Andrii Nakryiko wrote:
>> The observability piece should go in the same release as the feature.
> You mean LINK_QUERY command I mentioned before? Yes, I'm working on
> adding it next, regardless if this patch set goes in right now or
> later.

There was also mention of a "human override" details of which have not
been discussed. Since the query is not ready either, then the
create/update should wait so that all of it can be in the same kernel
release. As it stands it is a half-baked feature.
