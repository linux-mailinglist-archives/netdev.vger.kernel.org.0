Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A442A7607
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 04:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387723AbgKEDUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 22:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728511AbgKEDUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 22:20:19 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC86C0613CF;
        Wed,  4 Nov 2020 19:20:19 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id j18so273315pfa.0;
        Wed, 04 Nov 2020 19:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RWhsZukF3wxR9G9dqgPdfhoRJe3o6eJlTweOM5Ck3ks=;
        b=A4sDp2GiKP/OR35CMFeLLO3H0LSZzOyH3UowTbYxB9E5oEJHq66Q4tC/ZLwJCg+2p4
         Ev0ZHMVJyDwzmhT/poKEnHu0ndNG3EUV7vVwS7KGWGq/3Bo1hHX3E6oYvt96tHIqKFbl
         2ADRT8Q7tG+ohf8/YANchRvUl46xQ7UxnqXTPJJuyTHHroik8OposMQc8mkTW+R7yWEY
         73GfX0xnA0c7UBtHEEx6F6d/KYRHRaKwtIq5k+23WVx8iUfRkbfiKmOYClv2VB3O2q3B
         ymJtIOvIOXned4OM1hhJvaRtkK0SxA0p/9+SzFqmQ0kGE6HDlslsFy1/o0G0JYDGQJf2
         +WJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RWhsZukF3wxR9G9dqgPdfhoRJe3o6eJlTweOM5Ck3ks=;
        b=BAfi7D8DuHAnrRFeCHBaoKtpZzQZG7YPMxG1/IB1dGtpCx3Haw5Fkpp/Z1RCVlZYIH
         UDDAiDrAI+sPc+UO/nobwChjuuqHwXKfDBfSr25tkwLLnOrQ6do9ZDCRseknaqsMbFa6
         sNOotfB4LJ1MDjPmYS9h2iFMeFOLQUHvUcVZYPos8M6kYzEGj/Stid0R4gLif0Gy4oAU
         FKDL43ev1jjrFTRPOmFkZh70JebMylpqLHrCSqYSUgusHxyt2YqPKLkzmq42Ag3EzJhX
         58HsOXw6I/HdMgDzcgcZ7/cJxVZ0WMV9oPpMPHUg4DnOKNT+qvkYl4eed3SocQYjH8ln
         mG1g==
X-Gm-Message-State: AOAM531YYp0K0hVMggUtL3rtN5hVT2sPWLcHe7vI8gXIJN8pAX5zugRo
        kU+4P0AQ6i9kzTcWF6LGnD2WJnRpazQLSuYQ
X-Google-Smtp-Source: ABdhPJxpdoaP5v7K9p4mvDG6aBPWxjput0LuYRxmWTUq0yTN7sB0dVaamf8vQ9dnjjoiytZ/pJy3kw==
X-Received: by 2002:a62:75c6:0:b029:18a:d510:ff60 with SMTP id q189-20020a6275c60000b029018ad510ff60mr385547pfc.35.1604546418841;
        Wed, 04 Nov 2020 19:20:18 -0800 (PST)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v126sm300083pfb.137.2020.11.04.19.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 19:20:18 -0800 (PST)
Date:   Thu, 5 Nov 2020 11:20:08 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/2] selftest/bpf: add missed ip6ip6 test back
Message-ID: <20201105032008.GS2531@dhcp-12-153.nay.redhat.com>
References: <20201103042908.2825734-1-liuhangbin@gmail.com>
 <20201103042908.2825734-2-liuhangbin@gmail.com>
 <20201104184034.c2fse6kj2nwer3kv@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104184034.c2fse6kj2nwer3kv@kafai-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 10:40:34AM -0800, Martin KaFai Lau wrote:
> > +	check $TYPE
> > +	config_device
> > +	add_ipip6tnl_tunnel
> > +	ip link set dev veth1 mtu 1500
> > +	attach_bpf $DEV ipip6_set_tunnel ipip6_get_tunnel
> From looking at the ipip6_set_tunnel in test_tunnel_kern.c.
> I don't think they are testing an ip6ip6 packet.
> If the intention is to test ip6ip6, why the existing
> ip6ip6_set_tunnel does not need to be exercised?

Hi Martin,

Maybe I missed something. But I saw both ipip6_set_tunnel and
ip6ip6_set_tunnel in test_tunnel_kern.c. only set remote IPv6 address.
They didn't do anything else. The only difference between
ipip6 and ip6ip6 are in overlay network, using IPv4 or IPv6.


Thanks
Hangbin
