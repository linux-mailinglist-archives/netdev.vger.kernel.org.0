Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511F1407627
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 12:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235680AbhIKKwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 06:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhIKKwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Sep 2021 06:52:22 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750D0C061574;
        Sat, 11 Sep 2021 03:51:10 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id j2so2783006pll.1;
        Sat, 11 Sep 2021 03:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=UFYHQK723urgnyZK8cryzPqMETiG1GMvGdqJPFY18rA=;
        b=A01dX2KpNI50iBNYmQtpOWRHyf1K4Wtbh4xi8aDyHDob/58AIZGJNitOTigpLb2XkD
         +6627sStMks0doTNi/apF95nMP4YylfHQy4Rl+nPWmcf7fKMNuyJKyye/hbkjFB/KU7q
         k0y+3DtWUAOcKMVemTYk34H1362/OCdBPCwuy/x3QDRpV81BRWNBN+whDMd3ctxutL5+
         JEtsK7QlM1yj/JSiaUQpQHy1rYGohZkjVJ+BqLpvxYLHrhddzXDavvsZBOq9tT+p9cRX
         uKxOVILWmH/eTs9cQz0hHQx9AgNSj9xXcxzFE4tkcZcPQ2ArESAbtc8Gs7oyxrQXNKot
         +Mxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=UFYHQK723urgnyZK8cryzPqMETiG1GMvGdqJPFY18rA=;
        b=gsgc1h+I88qkiH2dZ02lk/LvyS/fHLDhfHANjpCOJXvIIVfKgO7M83vTWTwzMNbGqF
         Lpoqi7mYtcCiSKLuoKEGFu3TUF/EGP7+zqfHsKDEVKU0DrG+UwTfGqnYPepJAZu/WVmL
         X0TCuVJuS2l4pjOqylzWTKkcH64qBslS7vVpPtXDVLljX+bwnj/W48sV+J0FVWTxlOdV
         L9XNEVxZjy8nzLvoGGQjhuPPT2/JtCWeoEdrfbjMqIsgxRW3/utEzlWm1C7Ykxx2tqEg
         e3cjcS2YitxWeldcQ5gVAqDpZIq4kuOXYUR7i8BblS54lYgQt6CTVQ/XFtOPFbFxmDAC
         cO7Q==
X-Gm-Message-State: AOAM533Br150lscEqnXgdfSdi0glJ2AgPhOqRU2kLkLRZY1l2Z0RW40S
        2b89FyqSBBReuL2nyw+UoJA=
X-Google-Smtp-Source: ABdhPJwg3uudJj+5d1rEd1MHlKEqwDqrFritvcimiB3i/p7NIQANC/vRIrM6UMh7TKOGFdz29261UQ==
X-Received: by 2002:a17:902:c406:b0:13b:7b40:9c51 with SMTP id k6-20020a170902c40600b0013b7b409c51mr1727663plk.89.1631357470001;
        Sat, 11 Sep 2021 03:51:10 -0700 (PDT)
Received: from ubuntu ([223.106.51.51])
        by smtp.googlemail.com with ESMTPSA id n11sm1449900pjh.23.2021.09.11.03.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 03:51:09 -0700 (PDT)
Date:   Sat, 11 Sep 2021 03:50:57 -0700
From:   Zhongya Yan <yan2228598786@gmail.com>
To:     edumazet@google.com, rostedt@goodmis.org, brendan.d.gregg@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, hengqi.chen@gmail.com,
        yhs@fb.com, 2228598786@qq.com
Subject: Re: [PATCH] net: tcp_drop adds `reason` and SNMP parameters for
 tracing v4
Message-ID: <20210911105057.GA4754@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 11 Sep 2021 03:50:12 -0700
Steven Rostedt <rostedt@goodmis.org> wrote:

> Just curious. Is "Tcp" the normal way to write "TCP" in the kernel? I see
> it in snmp_seq_show_tcp_udp() in net/ipv4/proc.c, but no where else
> (besides doing CamelCase words). Should these be written using "TCP"
> instead of "Tcp". It just looks awkward to me.
>
> But hey, I'm not one of the networking folks, so what do I know?
>
> -- Steve

I will do it. I guess any other suggestions? I feel like my description may not be accurate.
Thanks.
    --Zhongya Yan
