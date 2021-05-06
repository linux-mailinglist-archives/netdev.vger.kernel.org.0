Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1BB374F11
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 07:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbhEFFza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 01:55:30 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:42638 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbhEFFz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 01:55:28 -0400
Received: by mail-wr1-f50.google.com with SMTP id l2so4212673wrm.9;
        Wed, 05 May 2021 22:54:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fZFNMndNVaBhyUia9c6L9GGITkvd1krOQV1BdK3Tt/Y=;
        b=RJhjtPlVArXiueF2x8ZSeWoDNIOUlw40plfB9F+SwYC5VxOEQVWzgpHx973o9EhaZU
         68aHEshcttsJ9pZNI+jEJJNU2j7Ov7Zi3jeBTbWCqfdsRu6MP0B6vtQ6ctF84qkZMNpH
         i15AOSR2dhq9+fKCUMnA+cPET1xICF5Q6snFGhg0Ergu6G7met1d6y22S4/64Pf6UPNJ
         7q0K8tPGk/NlJaXHRhKcRUut1OPisMtkuGBpTMQd6EpAQSzOujNlhx23XIRl0r9saf56
         PDdgP7VQvI/9rBIhkzVH1Ty7lkQdCAvSRmjDK/aVbbYK8AfgO3/+qPSB9B8ji6ARc7Uh
         Fx9A==
X-Gm-Message-State: AOAM531chZpm8Yjl4J5aXehMofWz7/VB+45OLsJH+mx/eOCMCv8vH1rz
        3R0b6sIai8iiMzqQjWMLSm4=
X-Google-Smtp-Source: ABdhPJyjyx3cZYxO2KbrMGYpBa9eBhrDdyULSsYBaCe2XoZp4EOe3EmTe5fnSnIqsYrujwQ/dFCjcQ==
X-Received: by 2002:adf:ef90:: with SMTP id d16mr2804825wro.359.1620280468760;
        Wed, 05 May 2021 22:54:28 -0700 (PDT)
Received: from ?IPv6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id y14sm2342252wrs.64.2021.05.05.22.54.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 22:54:28 -0700 (PDT)
Subject: Re: linux-next failing build due to missing cubictcp_state symbol
From:   Jiri Slaby <jirislaby@kernel.org>
To:     =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>,
        Jiri Olsa <jolsa@redhat.com>
Cc:     Yonghong Song <yhs@fb.com>, linux-kernel@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
References: <20210423130530.GA6564@kitsune.suse.cz>
 <316e86f9-35cc-36b0-1594-00a09631c736@fb.com>
 <20210423175528.GF6564@kitsune.suse.cz>
 <20210425111545.GL15381@kitsune.suse.cz>
 <20210426113215.GM15381@kitsune.suse.cz>
 <20210426121220.GN15381@kitsune.suse.cz>
 <20210426121401.GO15381@kitsune.suse.cz>
 <49f84147-bf32-dc59-48e0-f89241cf6264@fb.com> <YIbkR6z6mxdNSzGO@krava>
 <YIcRlHQWWKbOlcXr@krava> <20210505135612.GZ6564@kitsune.suse.cz>
 <5a225970-32a2-1617-b264-bc40a2179618@kernel.org>
Message-ID: <09399b84-0ee3-bd18-68ed-290851bc63f6@kernel.org>
Date:   Thu, 6 May 2021 07:54:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <5a225970-32a2-1617-b264-bc40a2179618@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06. 05. 21, 6:31, Jiri Slaby wrote:
>>>> this one was reported by Jesper and was fixed by upgrading pahole
>>>> that contains the new function generation fixes (v1.19)
>>
>> It needs pahole 1.21 here, 1.19 was not sufficient. Even then it
>> regressed again after 5.12 on arm64:
> 
> Could you try against devel:tools? I've removed the ftrace filter from 
> dwarves there (sr#890247 to factory).

Yes, works for me.

>>    LD      vmlinux
>> ld: warning: -z relro ignored
>>    BTFIDS  vmlinux
>> FAILED unresolved symbol cubictcp_state
>> make[1]: *** 
>> [/home/abuild/rpmbuild/BUILD/kernel-vanilla-5.12.0.13670.g5e321ded302d/linux-5.12-13670-g5e321ded302d/Makefile:1196: 
>> vmlinux] Error 255
>> make: *** [../Makefile:215: __sub-make] Error 2


-- 
js
