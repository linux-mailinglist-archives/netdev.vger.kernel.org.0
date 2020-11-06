Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE4A2A90F1
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 09:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgKFIEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 03:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgKFIEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 03:04:22 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1ABDC0613CF;
        Fri,  6 Nov 2020 00:04:21 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id u4so333229pgr.9;
        Fri, 06 Nov 2020 00:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IfU3/CU1AdH87+GtFKI7/7gtMjHfHgkK9/+d0aU89dk=;
        b=r1zhPVlh+UJLh9AID112eb+bDe5u7mDZqKju7VlMokWNIx57pz33LCnwYsuCkXspJ9
         Kur+/b+tv7rYi1hTacn4Suf6d6oA0LnnS4g6G9C4SYW4S+F5UTHRzsjDWkN1Nzq7tJ1F
         TNvAjaGkaMD/dS4MVkC1O+WXb9l2Wr5X+JXPYlUR6/FhdoQOTOai/HlBWIddrk3D93YR
         A9tWzez6oEBqxAJJ0Jf/aF/BPvdBLrcsd12B/pOPkOjNQoHbNgLRM9zw0C8JG0Q9uTmd
         6zSsCrtTUgf9XDUmwUgWjkLJl6YjL23ui2SxKZKOhKoMGF+DG8cZkUfL1V5wXWb7lruF
         DxfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IfU3/CU1AdH87+GtFKI7/7gtMjHfHgkK9/+d0aU89dk=;
        b=FpDZ7xctpwgzCB13aD2827xRb4FghtX65XIzyH82lJvl53fLiKMC0wcX/CmqS4Pbns
         emDfHlHXj28Y/xBKY3ZIyRjuHKDmkge+gZMukQXjidmQIlw1ZPu3QuxzUMtXtEcdplgL
         HwaJSenPxpXqCtkGq8EDTLWOEJpv/2bAZwG4qQSCeRl1UmRAbsdcWfvHQ0f0n5II02IS
         prtIV/HaQfCz2UHz/db232W2D4ajXrpKmC0EKcHjeGpNVY63Ntuy2ncm2YC+yYRI/raq
         SqUmsEa1FGM+5ixJ4Dv5rA8MXGuTVzI0wJ3hl8LSy3zZ4gpTMuC2/kCg1f7knXFB4iyl
         2svg==
X-Gm-Message-State: AOAM531E7wdj7vwpeyG7VgE7180Q2JJPcfVgB+HjvFEM+t/mbPKbUqnH
        V0MG1f7sNa0s/jhv7/uB5LA=
X-Google-Smtp-Source: ABdhPJzMhoy7UYxrEjyR6jOW8tkdAuPIdktWw68nqvTA9BV/lwOTZFoTJDZjVBYUcOJjhAB9SdJckg==
X-Received: by 2002:a63:fe0f:: with SMTP id p15mr757017pgh.343.1604649861449;
        Fri, 06 Nov 2020 00:04:21 -0800 (PST)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a123sm1011800pfd.218.2020.11.06.00.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 00:04:21 -0800 (PST)
Date:   Fri, 6 Nov 2020 16:04:11 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 2/2] selftest/bpf: remove unused bpf tunnel
 testing code
Message-ID: <20201106080411.GU2531@dhcp-12-153.nay.redhat.com>
References: <20201103042908.2825734-1-liuhangbin@gmail.com>
 <20201103042908.2825734-3-liuhangbin@gmail.com>
 <20201106073035.w2x4szk7m6nkx5yj@kafai-mbp.dhcp.thefacebook.com>
 <20201106075536.GT2531@dhcp-12-153.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106075536.GT2531@dhcp-12-153.nay.redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 06, 2020 at 03:55:47PM +0800, Hangbin Liu wrote:
> > > -	key.remote_ipv6[0] = bpf_htonl(0x2401db00);
> > > -	key.tunnel_ttl = 64;
> 
> The code logic is same. It set tunnel remote addr to dst IPv6 address, as
> they are both testing IP(v4 or v6) over IPv6 tunnel.

OK, I decide to keep the kernel ip6ip6 code as using ipip6_set_tunnel obj in
ip6ip6 testing may cause user confused.

Thanks
Hangbin
