Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0E92C947F
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 02:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729947AbgLABPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 20:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbgLABPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 20:15:55 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727EEC0613CF
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 17:15:09 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id z10so78786ilu.3
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 17:15:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=oBt7upMTs7rPQ2sQuOM6Nty5chBgvR4otwZEdU2VJxU=;
        b=esdJPAEC3aftJc2UjRbQYb3bFUlBnswUpDosCXn2EfToR/g3eY9VrDAb+4Ntx6jZo8
         blcBUxwV3/218Ao969cjDwPf/qTes7w8tGVMEdtSMOvQCOlOotTgcNz0naEUM7bOwk0h
         xbv6UcQ+WlLZjlcPCrgz9a8qYOaI8Ejyni/K+dnsnMzeJZypy6DBhCWYFhgBukI4YR1v
         /BHmtnAkIwV2nluh8Ymnox85bx+e4qPXgNmKXwPpNUqS7f7MGfJNmBZRBfwjvclzacK0
         hkhj6jQWsGDvEmts3PP7e79r8tBldmbDxquGBqPyXIiJnqYodpqGmsp9TmG71JIhnqNh
         v6gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oBt7upMTs7rPQ2sQuOM6Nty5chBgvR4otwZEdU2VJxU=;
        b=R5//IX8/o6loToei33KrFnJ2EQuyO2KwwxHsaUJ0vkD+bo2CMcKBIvpEVJb60kJyOZ
         nLPaZOdy33eiyn4+uuKpS6PhvcdexNDraWGrJaTXaj1XTjqqjpB2zmA14AuoqvYA0AaY
         tZVrlZtkCCFTwoS1ighPS3Ogvl9ltDhmBG2GZbbbsGg8ziyVExBj4zTucacQ1zCgpboP
         q98hdQlYrhNvPR2PHUoZqijj4FW5HUwJoKcOAP5OR03cPOnjUSmQTzxy54zYO7tR97fM
         Gvi4hKmWrFeVc6OV7ntql5w4i7/Eu9q+NEeFVJakAJ3djQz/Gcbf2tcYu5XjJq4/oMtt
         zORQ==
X-Gm-Message-State: AOAM530gaO8aRJgQeJXDxoOMb7ozrCB66USROVTNlkltm7Lo9Shr0/Gw
        H74YC4lJHiEfI68aHEjoL+SUDbcJaUo=
X-Google-Smtp-Source: ABdhPJztmxJYUNm8wosZ1ny8trSr3zPPfC3QGYvCo4phXOUv+2Gt3ZygPcQ2z5eENF9EzWBbjhZSMA==
X-Received: by 2002:a92:155b:: with SMTP id v88mr411786ilk.303.1606785308614;
        Mon, 30 Nov 2020 17:15:08 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:f4ef:fcd1:6421:a6de])
        by smtp.googlemail.com with ESMTPSA id b15sm13320iow.5.2020.11.30.17.15.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 17:15:07 -0800 (PST)
Subject: Re: VRF NS for lladdr sent on the wrong interface
To:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org
References: <20201124002345.GA42222@ubuntu>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c04221cc-b407-4b30-4631-b405209853a3@gmail.com>
Date:   Mon, 30 Nov 2020 18:15:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201124002345.GA42222@ubuntu>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/20 5:23 PM, Stephen Suryaputra wrote:
> Hi,
> 
> I'm running into a problem with lladdr pinging all-host mcast all nodes
> addr. The ping intially works but after cycling the interface that
> receives the ping, the echo request packet causes a neigh solicitation
> being sent on a different interface.
> 
> To repro, I included the attached namespace scripts. This is the
> topology and an output of my test.
> 
> # +-------+     +----------+   +-------+
> # | h0    |     |    r0    |   |    h1 |
> # |    v00+-----+v00    v01+---+v10    |
> # |       |     |          |   |       |
> # +-------+     +----------+   +-------+
> 



after setup,

ip netns exec h0 ping -c 1 ff02::1%h0_v00

works, but

 ip netns exec h1 ping -c 1 ff02::1%h1_v10

does not. No surprise then that cycling v00 in r0 causes the reverse.
The problem is the route order changes:

root@ubuntu-c-2-4gib-sfo3-01:~# diff -U3 /tmp/1 /tmp/2
--- /tmp/1	2020-12-01 01:07:39.795361392 +0000
+++ /tmp/2	2020-12-01 01:07:51.991808848 +0000
@@ -1,6 +1,6 @@
 local fe80::8466:b3ff:fecc:3a4f dev r0_v01 table 10 proto kernel metric
0 pref medium
 local fe80::b4ec:a8ff:fec3:33d9 dev r0_v00 table 10 proto kernel metric
0 pref medium
-fe80::/64 dev r0_v00 table 10 proto kernel metric 256 pref medium
 fe80::/64 dev r0_v01 table 10 proto kernel metric 256 pref medium
-ff00::/8 dev r0_v00 table 10 metric 256 pref medium
+fe80::/64 dev r0_v00 table 10 proto kernel metric 256 pref medium
 ff00::/8 dev r0_v01 table 10 metric 256 pref medium
+ff00::/8 dev r0_v00 table 10 metric 256 pref medium

With your patch does ping from both hosts work?

What about all of the tests in
tools/testing/selftests/net/fcnal-test.sh? specifically curious about
the 'LLA to GUA' tests (link local to global). Perhaps those tests need
a second interface (e.g., a dummy) that is brought up first to cause the
ordering to be different.
