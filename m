Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBF32145E31
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 22:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgAVVid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 16:38:33 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34661 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgAVVid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 16:38:33 -0500
Received: by mail-pl1-f195.google.com with SMTP id c9so385955plo.1;
        Wed, 22 Jan 2020 13:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=3E7X73xg9mVGaMBnkhjdZyGK2FJzEs1xLTciPJX8yqs=;
        b=pa2tb7KnasOh43I8SlVKHjE4RJcrp4TyCwnWXBrxcGZYgPLp14T5JWpdXGn5M6VO1u
         GoLh3xEBIHBfO+1YEoUbnW73Kucn0Qt5hmvC8Rac0MO01Vb977u/WF6fl2d9RWXgi9g2
         yjbTW3UOuLNM1A3B8L41dGna69sNlVwSNJOrWSkH/A0d+rrKWC1inwz4eTztyUsXNZNG
         2bUv1ThZELHeMcM44iq+xmjJ89I0O0Gtkl3Op2+vrC4G294fRWA2EBevagAJWgIfOjaI
         xz4eSzd4uYrJYjoeHQOkgmrTVMsbBfgcRE6f6zPUwdlvSfupRMtOICVRLP+Z+kERbGvZ
         +YSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3E7X73xg9mVGaMBnkhjdZyGK2FJzEs1xLTciPJX8yqs=;
        b=F4FlivY4hHqnbZSLLQ66CZ+ezppFdUzJTRU7JGqa+iLhSJ1Pg0FcUIXE9TmnScWSxf
         B2lKxaufRO0wtQ9pEDViClK8iwUiEiJlB5sd+Lzj3zCr89wAVot6pIcJqRLL+nQW1odl
         NGNSAh5ZGLqGPOwM4yVSHHs6QygS28bgq2KWXh9ND09GdPhV7yRGElqorb2YFaD9C7C6
         6bvp1D/64+nJr8rsiqacculD4SAdJVlyyltqPD6xX9lFUQo4PZXCCHshGOPfNe6Qcx8Z
         5T38Vp6jCxgb0w+LtLggllPuxmnvNW8gzff0g86jGK9F605OWFlWmt036JbmK/GRccxD
         Svbg==
X-Gm-Message-State: APjAAAW/hYU4JE218oTUdVvBfcMP/Dtjf4oVwumYsyImCogiclWG5lUw
        9MJ0lI4KIRLXCV3nagkqnHM=
X-Google-Smtp-Source: APXvYqxcZGNwvvRY8VEPC9PavXKK8gJ8+C5l6iOd8jtUFlCzq2HvJ7etDB1yuD8lnaAt+GvyP53rSg==
X-Received: by 2002:a17:90a:191a:: with SMTP id 26mr559479pjg.111.1579729112842;
        Wed, 22 Jan 2020 13:38:32 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id y76sm49645547pfc.87.2020.01.22.13.38.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 13:38:32 -0800 (PST)
Subject: Re: WARNING in bpf_warn_invalid_xdp_action
To:     syzbot <syzbot+8ce4113dadc4789fac74@syzkaller.appspotmail.com>,
        andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        corbet@lwn.net, daniel@iogearbox.net, davem@davemloft.net,
        dsahern@gmail.com, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kuba@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <00000000000068843f059cc0d214@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a10a25dd-fa53-0e7f-d394-d0123bc95df9@gmail.com>
Date:   Wed, 22 Jan 2020 13:38:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <00000000000068843f059cc0d214@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/22/20 1:01 PM, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit 58956317c8de52009d1a38a721474c24aef74fe7
> Author: David Ahern <dsahern@gmail.com>
> Date:   Fri Dec 7 20:24:57 2018 +0000
> 
>     neighbor: Improve garbage collection
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=124a5985e00000
> start commit:   d0f41851 net, ip_tunnel: fix namespaces move
> git tree:       net
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=114a5985e00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=164a5985e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
> dashboard link: https://syzkaller.appspot.com/bug?extid=8ce4113dadc4789fac74
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f99369e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d85601e00000
> 
> Reported-by: syzbot+8ce4113dadc4789fac74@syzkaller.appspotmail.com
> Fixes: 58956317c8de ("neighbor: Improve garbage collection")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 

bisection looks bogus...

It would be nice to have alternative helpers to conveniently replace some WARN_ON/WARN_ONCE/...
and not having to hand-code stuff like :

diff --git a/net/core/filter.c b/net/core/filter.c
index 538f6a735a19f017df8e10149cb578107ddc8cbb..633988f7c81b3b4f015d827ccb485e8b227ad20b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6913,11 +6913,15 @@ static bool xdp_is_valid_access(int off, int size,
 
 void bpf_warn_invalid_xdp_action(u32 act)
 {
+       static bool __section(.data.once) warned;
        const u32 act_max = XDP_REDIRECT;
 
-       WARN_ONCE(1, "%s XDP return value %u, expect packet loss!\n",
-                 act > act_max ? "Illegal" : "Driver unsupported",
-                 act);
+       if (!warned) {
+               warned = true;
+               pr_err("%s XDP return value %u, expect packet loss!\n",
+                      act > act_max ? "Illegal" : "Driver unsupported", act);
+               dump_stack();
+       }
 }
 EXPORT_SYMBOL_GPL(bpf_warn_invalid_xdp_action);
