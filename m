Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7792A4D00
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbgKCRco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728970AbgKCRcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:32:41 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9C1C0617A6;
        Tue,  3 Nov 2020 09:32:41 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id u19so19322774ion.3;
        Tue, 03 Nov 2020 09:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ry3XixsGN9DZhazMEEr/FShPsajm2T6AhmyTPRTG07c=;
        b=V/Z7NqzFFNchES0OEXbbsw6k8/kFsQKBGcQEk6gSaTF3fGnt0FJBpoFW6SdFZWe7NU
         CtAJQ1QLfUjJy0d70JptX0X0nZmd0cO5sPDtGHf9yKNF/GoKiovLkkqY7ssRXaq7jd7j
         jOxYnaJIxGy4itoSioYz0vxa1RTDfrhlnofGFOkbLgRysZw4GQa0F9n0btARpdCXbWuy
         ZdXyoN+LOvMrDrFZTDQJM0UHkWz6HwYkaJDxq7N6TcD6VSyPywTvsnk1vo+Am/1DF80j
         fJ+8eWU11BKYYnD3MTVGEaKKVmXLxY2YhZVzUM+EzY303z3df/lcMf/PxGZ16IRL6x2Z
         wphw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ry3XixsGN9DZhazMEEr/FShPsajm2T6AhmyTPRTG07c=;
        b=LRVlBBm+I8DAharCAChZ7DhabGrKC/JmP4g+nPF3076UIcrnAu7UicYHl0kc8u99nP
         v71ao1cQ27KRAC82mmZmOjjiREg/4ccGekWHKpYpTFjtI6CyMa+9K32ozz8DatjVTPPh
         9enFhomkVupyKcmDue0OPXxYRmLmE82wAtC+g7baZvS2XwTQzKHydGIvbNiFMOcB5at6
         8vgya23OLmqkaBhAwoUELzxcljV8GCQhFZn6XlT4ffwoEK07BIsra4j79+HJq58anfb4
         Tgy2B0VBE+smB4y5gIvHVR2U19u5Y/R7uEdX2zHQriAO4rGpmKQWiqm8U5DeQh0XOLp0
         fwEg==
X-Gm-Message-State: AOAM530WsgWjXewjgCzO5r/GvNaIR9JbiGwTgG4FmHX2PQJCQlr2wD6z
        PJH/fZQ/eHUd8E3Z7/QxH3A=
X-Google-Smtp-Source: ABdhPJw+l29fcvur16a7SGZgij0JdtrPGAjAPSb+8zFKH7oa7gxmB5ln5XVBM0sXZEl8jeTM7bTotg==
X-Received: by 2002:a6b:f808:: with SMTP id o8mr14819473ioh.136.1604424761003;
        Tue, 03 Nov 2020 09:32:41 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:def:1f9b:2059:ffac])
        by smtp.googlemail.com with ESMTPSA id c80sm14430806ill.20.2020.11.03.09.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 09:32:40 -0800 (PST)
Subject: Re: [PATCHv3 iproute2-next 1/5] configure: add check_libbpf() for
 later libbpf support
To:     Hangbin Liu <haliu@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <20201029151146.3810859-2-haliu@redhat.com>
 <78c5df29-bf06-0b60-d914-bdab3d65b198@gmail.com>
 <20201103055419.GI2408@dhcp-12-153.nay.redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e3368c04-2887-3daf-8be8-8717960e9a18@gmail.com>
Date:   Tue, 3 Nov 2020 10:32:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201103055419.GI2408@dhcp-12-153.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/20 10:54 PM, Hangbin Liu wrote:
> On Mon, Nov 02, 2020 at 08:37:37AM -0700, David Ahern wrote:
>> On 10/29/20 9:11 AM, Hangbin Liu wrote:
>>> This patch adds a check to see if we support libbpf. By default the
>>> system libbpf will be used, but static linking against a custom libbpf
>>> version can be achieved by passing LIBBPF_DIR to configure. FORCE_LIBBPF
>>> can be set to force configure to abort if no suitable libbpf is found,
>>> which is useful for automatic packaging that wants to enforce the
>>> dependency.
>>>
>>
>> Add an option to force libbpf off and use of the legacy code. i.e, yes
>> it is installed, but don't use it.
>>
>> configure script really needs a usage to dump options like disabling libbpf.
>>
> 
> Shouldn't we use libbpf by default if system support? The same like libmnl.
> There is no options to force libnml off.
> 

configure scripts usually allow you to control options directly,
overriding the autoprobe.
