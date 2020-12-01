Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA962CAB45
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 20:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgLATBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 14:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgLATBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 14:01:44 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12247C0613D4
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 11:00:58 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id i199so2363940qke.5
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 11:00:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5tlE5Jblik4GDxepHE/1dKI5Z0R3PByV7Gz0UqUgPSU=;
        b=BjabgmXFD9JkEAH5KbhGsuL6EfQ6J8inoWlDJ6dTIoHYgO9GwaEDdVzr6mq23wR22M
         MTueCmGfBmOnlmN7ab59P1SVo9CghId6fCpGPrMGVUIRkD3MDbS1RUoIPEZgG2I4HbB9
         jptJiotUeVqFB4oBS/Ks+7h5vq3R09CaXPiP4hyeF+cZlN0jiBzmIsbSP1uIqkwaZzmT
         ymKzoFKfKwl9B8ZyqHSyYEarfV2xMifTUAZaL9mGfnn62et9/HWBNRMcuZu7t9ALQnbM
         Bo0UzPub3ajsZxGtouvXDgmVsau8/PnVO52tIdbv5BdfPaMn4I88QNryPHafmxkgqLXm
         RwRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5tlE5Jblik4GDxepHE/1dKI5Z0R3PByV7Gz0UqUgPSU=;
        b=E+vJ4X+rNm32vCFlxYmLamFiUqbmAGTdmNX2NMpTYII8Wlk0eN9z/La+zIx49f9yDG
         16bCfXWKOlYZBF0MGsBswLdR4PX6LGIEN3h+SWEJku19/POXE2f5PEtISpSwwweIDWEB
         6E8JH8MSzv65a3oLSTL4oZH49Mc0FTR4rulBq2Vma1y6ItGBVNuJg0OTw9m0PwrvlrQa
         tMyYGn/nksPVpIhICNK9NnSMbK1JYtq/YqLyw82YRthJ7zt+sjJyr3FRiXb3bLZy2FyG
         zw1/5gwl8CNvrx+PUTxWS/9guwESX6nenm+c9EyHrinh7oQ3Mo6z4U6tqhEjzTb9F8sv
         yHNQ==
X-Gm-Message-State: AOAM531w0glUlzSQ+wVsuyUPu6ArolOd8QvhzEeOVNqlm2uCqUTlWYaf
        ZwqHUZIE8RY4kftIDCJorA==
X-Google-Smtp-Source: ABdhPJwmTIT7VXcduOHre+hOYAD/Qxcn6b1jbJOobXwJbxHw02n/+WKHlUgG7AhYuMBrLlUIrBCgIQ==
X-Received: by 2002:a37:8e47:: with SMTP id q68mr4229030qkd.240.1606849257196;
        Tue, 01 Dec 2020 11:00:57 -0800 (PST)
Received: from ICIPI.localdomain ([136.56.89.69])
        by smtp.gmail.com with ESMTPSA id q18sm495948qkn.96.2020.12.01.11.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 11:00:56 -0800 (PST)
Date:   Tue, 1 Dec 2020 14:00:55 -0500
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: VRF NS for lladdr sent on the wrong interface
Message-ID: <20201201190055.GA16436@ICIPI.localdomain>
References: <20201124002345.GA42222@ubuntu>
 <c04221cc-b407-4b30-4631-b405209853a3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c04221cc-b407-4b30-4631-b405209853a3@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 06:15:06PM -0700, David Ahern wrote:
> On 11/23/20 5:23 PM, Stephen Suryaputra wrote:
> > Hi,
> > 
> > I'm running into a problem with lladdr pinging all-host mcast all nodes
> > addr. The ping intially works but after cycling the interface that
> > receives the ping, the echo request packet causes a neigh solicitation
> > being sent on a different interface.
> > 
> > To repro, I included the attached namespace scripts. This is the
> > topology and an output of my test.
> > 
> > # +-------+     +----------+   +-------+
> > # | h0    |     |    r0    |   |    h1 |
> > # |    v00+-----+v00    v01+---+v10    |
> > # |       |     |          |   |       |
> > # +-------+     +----------+   +-------+
> > 
> 
> 
> 
> after setup,
> 
> ip netns exec h0 ping -c 1 ff02::1%h0_v00
> 
> works, but
> 
>  ip netns exec h1 ping -c 1 ff02::1%h1_v10
> 
> does not. No surprise then that cycling v00 in r0 causes the reverse.
> The problem is the route order changes:
> 
> root@ubuntu-c-2-4gib-sfo3-01:~# diff -U3 /tmp/1 /tmp/2
> --- /tmp/1	2020-12-01 01:07:39.795361392 +0000
> +++ /tmp/2	2020-12-01 01:07:51.991808848 +0000
> @@ -1,6 +1,6 @@
>  local fe80::8466:b3ff:fecc:3a4f dev r0_v01 table 10 proto kernel metric
> 0 pref medium
>  local fe80::b4ec:a8ff:fec3:33d9 dev r0_v00 table 10 proto kernel metric
> 0 pref medium
> -fe80::/64 dev r0_v00 table 10 proto kernel metric 256 pref medium
>  fe80::/64 dev r0_v01 table 10 proto kernel metric 256 pref medium
> -ff00::/8 dev r0_v00 table 10 metric 256 pref medium
> +fe80::/64 dev r0_v00 table 10 proto kernel metric 256 pref medium
>  ff00::/8 dev r0_v01 table 10 metric 256 pref medium
> +ff00::/8 dev r0_v00 table 10 metric 256 pref medium
> 
> With your patch does ping from both hosts work?

Yes, it does.

> What about all of the tests in
> tools/testing/selftests/net/fcnal-test.sh? specifically curious about
> the 'LLA to GUA' tests (link local to global). Perhaps those tests need
> a second interface (e.g., a dummy) that is brought up first to cause the
> ordering to be different.

The script needs nettest to be in the path...

Thanks,

Stephen.
