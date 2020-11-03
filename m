Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D9E2A5A23
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 23:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbgKCWdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 17:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730357AbgKCWdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 17:33:00 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BB1C0613D1;
        Tue,  3 Nov 2020 14:33:00 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id x7so17642984ili.5;
        Tue, 03 Nov 2020 14:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bLaMoE5mWGLn19yG8GvJ/7C3mZHkgchPhbpxvLvLVLg=;
        b=Yjoub5mtbc5gxcL3zn3qyDubboh2mM3ooeQGoA4plz5nEvxXNjMyOMAwQIHyv7Di+C
         i93tLjFus4XHK4D6CcskWuYom4bLiTZSuDG07UwSKXTV5bYN53y8TpuVoYLDMz5GVJyo
         XyK9TgQHdmgxlWSaokWO4IlJGDthI5EH7N6zvR4m4ufEcrI7xHW/U3Xv0IB7Ib00qPbd
         BG2vxJlkONpptZQnTJ3yOE8ICrQhzsnZZnc0YRqoy1HcjBJph4rd7yxQc47vqY/sibij
         aGpkM9cr2Az1tz9N8scvJrIkDqqGKmacPVX0c2O4G5tKJA7r/6+1k1i9Z9UtlBz8h+v+
         E9IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bLaMoE5mWGLn19yG8GvJ/7C3mZHkgchPhbpxvLvLVLg=;
        b=radkvgfjStq6OJauykJm8/AGok0K5fGl/WqiLsL3VPg2yeP7pkxgzak0NVbL8aLPu5
         KEDyFCvviqOkAc1QVXeme1bOFhPsSEZuyiHUbL0QMpCDFXGRMMjLKzwW7880pheC7pwi
         yTh/9xwWa2Uo0Pom2Uc1m8iHIxT9c2fWAj6y8vjiWD/J7Nrj7ac0nvvm1ujQwOsD722i
         dSdAe8OJAjwTfZr1uuz9M9v5ip6qtsHtqTYLdXfeemXHePlCiL1ORqMa6OEokSC2+Jh+
         BRFOduHyXfikpDnMW0ICcEfR909Dq49DK7SkfMW1jQ0aISsgZBlVo6BRBl7s8CstakF/
         LPjg==
X-Gm-Message-State: AOAM5309n8Du3mWGytG0N2Cfk9TjumjM5FCzWHWZ6hEzOXz5X8S+M75a
        O5s2hrZY0L6dgPs7wPM8Hnw=
X-Google-Smtp-Source: ABdhPJxtiRejlCng0cx9di8hIO6HiS865b5qrc74giGvn38kOyW/NFseE1Vg9XtYJ5sa6OUGeHHDlQ==
X-Received: by 2002:a92:dd91:: with SMTP id g17mr16297156iln.180.1604442780063;
        Tue, 03 Nov 2020 14:33:00 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:def:1f9b:2059:ffac])
        by smtp.googlemail.com with ESMTPSA id u18sm71816iob.53.2020.11.03.14.32.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 14:32:58 -0800 (PST)
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
 <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net>
 <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
Date:   Tue, 3 Nov 2020 15:32:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/20 10:47 AM, Alexei Starovoitov wrote:
> since David is deaf to technical arguments,
It is not that I am "deaf to technical arguments"; you do not like my
response.

The scope of bpf in iproute2 is tiny - a few tc modules (and VRF but it
does not need libbpf) which is a small subset of the functionality and
commands within the package.

The configure script will allow you to use any libbpf version you wish.
Standard operating procedure for configuring a dependency within a package.
