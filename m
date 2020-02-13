Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27FCD15BEB6
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 13:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbgBMMwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 07:52:53 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33818 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729557AbgBMMwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 07:52:53 -0500
Received: by mail-wr1-f65.google.com with SMTP id n10so4586651wrm.1
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 04:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:references:user-agent:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=4o4iU6CJrrOi1aO0FFNaBSMLfzI4N44D53awRYFl9d4=;
        b=RllRhQqQCoilqDyxbpZiBFN6syMmiPimYFWh/8rMmo7nbJBrh16gj9VGrNVrcBwZuL
         2e+UWI0Sc4EQVU0TWAFuhHpMclrsoV5HqdLCXq59BsOBB71FO1soPiX2q0TjYmh8ZO3m
         RoGMuqqgfm8jAC3r+PvriluZuqu8ELmNBNdwZW5LGwiAeAxpJS6Fg/OYasz3y1eBH5Ia
         PWClvtcmtQ5OzsCndyZhaZqdx0ncF/3tINR+HhV34rRnq47OlESFRV7anqieTTiesMvd
         DdFMbH4Z7qJVbM4MmDvX6JDsI+3C6NUFZpoHv/1muS1DiUm4w9VvuDMbhrSvBxt5PjLm
         LZpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:user-agent:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=4o4iU6CJrrOi1aO0FFNaBSMLfzI4N44D53awRYFl9d4=;
        b=lB2I3xLjY2qdjI4pUPSh/KwBz1qiVfzFyaaZJbxpG1Ijf9/mLTt8mMdJQG+Dk0ZAd6
         +MZeQQQ+Ibufl1RP3Iz5TIJmY2Mpk9/sSdeCZ/m4Wi9GCkgFmLrKxpg2IUUojyYOtx+0
         R5oxV4s2WURoydQ4ZycbdflWt7H6DLQ2+np+1HTSRn5nQ02nTPG1gO+ZN/P3zxBxHovR
         S63uXReZQLuZUQFZVV0MkWRdFnzknt7OZchnoUfqJCNzWk3uuAG89TVECQBNOjlwEz9I
         XcVfOLxA0SYTqpc3vMYrPL6TKBW3e0HXI7CL7LquHLWT3vvvnCgUrtamgnHujBfKAKEX
         6/TQ==
X-Gm-Message-State: APjAAAUxld7fQCiwE17rwSk9/yJDj5St52nodBDC3P6mEMLr98hGa/5L
        Q3/sS0IAq+1RBln+BUbR90E=
X-Google-Smtp-Source: APXvYqyXsGPhLFPb2Eu8LrcI5d2aOpb/js5QafKQirB/8eetP1JDLN6cmgTLQ7JyRvzBJfrfgQLp7Q==
X-Received: by 2002:adf:94e3:: with SMTP id 90mr21221340wrr.268.1581598371268;
        Thu, 13 Feb 2020 04:52:51 -0800 (PST)
Received: from yaviefel (ip-213-220-234-169.net.upcbroadband.cz. [213.220.234.169])
        by smtp.gmail.com with ESMTPSA id a198sm2841493wme.12.2020.02.13.04.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 04:52:50 -0800 (PST)
From:   Petr Machata <pmachata@gmail.com>
X-Google-Original-From: Petr Machata <petrm@mellanox.com>
References: <20200213094054.27993-1-liuhangbin@gmail.com>
User-agent: mu4e 1.3.3; emacs 26.3
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] selftests: forwarding: vxlan_bridge_1d: fix tos value
In-reply-to: <20200213094054.27993-1-liuhangbin@gmail.com>
Date:   Thu, 13 Feb 2020 13:52:49 +0100
Message-ID: <87a75msl7i.fsf@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hangbin Liu <liuhangbin@gmail.com> writes:

> After commit 71130f29979c ("vxlan: fix tos value before xmit") we start
> strict vxlan xmit tos value by RT_TOS(), which limits the tos value less

I don't understand how it is OK to slice the TOS field like this. It
could contain a DSCP value, which will be mangled.

> than 0x1E. With current value 0x40 the test will failed with "v1: Expected
> to capture 10 packets, got 0". So let's choose a smaller tos value for
> testing.
>
> Fixes: d417ecf533fe ("selftests: forwarding: vxlan_bridge_1d: Add a TOS test")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
> index bb10e33690b2..353613fc1947 100755
> --- a/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
> +++ b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
> @@ -516,9 +516,9 @@ test_tos()
>  	RET=0
>
>  	tc filter add dev v1 egress pref 77 prot ip \
> -		flower ip_tos 0x40 action pass
> -	vxlan_ping_test $h1 192.0.2.3 "-Q 0x40" v1 egress 77 10
> -	vxlan_ping_test $h1 192.0.2.3 "-Q 0x30" v1 egress 77 0
> +		flower ip_tos 0x11 action pass
> +	vxlan_ping_test $h1 192.0.2.3 "-Q 0x11" v1 egress 77 10
> +	vxlan_ping_test $h1 192.0.2.3 "-Q 0x12" v1 egress 77 0

0x11 and 0x12 set the ECN bits, I think it would be better to avoid
that. It works just as well with 0x14 and 0x18.

>  	tc filter del dev v1 egress pref 77 prot ip
>
>  	log_test "VXLAN: envelope TOS inheritance"
