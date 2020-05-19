Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC3C1DA13F
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 21:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgESTrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 15:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgESTrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 15:47:15 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2523C08C5C0;
        Tue, 19 May 2020 12:47:14 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id m64so666727qtd.4;
        Tue, 19 May 2020 12:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WiMWkU2MI6chQi1x2YV25YJqvNn+eocUFqEC99kaegE=;
        b=s7aymCDFGP9fWPptrcF+EDGocaJIpadYogh3WIepuQrGRUynks71rfTtAgT6b/iRp5
         dWMu09y9Ao8qDjwJkqlCaImmDHLjUTXUG4fD7mDTC40b4yUv5rQQelTdBAHuoxSv63c1
         fOI31JrkXd3W8Zzxk+HWdFALj2C/CR5kNhb4u9Xf5ZFnn6vSr3ggGO69k1ttayWXSEt7
         EPp5sa+TxTAJoAUwAMh1K6TbFgfxhNPuqw+FkZggm/9YTiYh3GvoDbCvcUqYIQtPihOk
         jYauVckYo4zZNRBId8T7Y9MwlBr9JzWVEpfBZC0MLJEvntAXEPHsk8R8TidshY1bWcN6
         Nmwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WiMWkU2MI6chQi1x2YV25YJqvNn+eocUFqEC99kaegE=;
        b=uHPtQz+T8BPylOuz0aAlCsNIzySk13KgJG48rXR2Yu/PTaUaXboV+ONZq6rhYOILYa
         NrOWXII0GKaT3iUe04LOHvuDom7su2xCv+jQUWNcOi3pfn6pNw/H3kDyJEz/CN3UtrD6
         iChCq/JOCJc3tSrKuKbkw33lei1S54/3BdC5QY8KK8EC6dWas18QFH1Ax5K5pJ7svJMZ
         +fTiwGwGuc/DjP1w7i2KR1rcyhghFDc/g0PypdaEf8uZvvj/Hxi2lFkcwaLIITad5RXF
         hw9RlW4l6ldFvRbtVY0w+XefcqRGqsEjb4xcWMweDgMpPrXnYG+W+HtPv2Qy3S+Ix+3k
         tKdA==
X-Gm-Message-State: AOAM530p6ST88cytvh2T8U7yFnLxGcFFmvCOkPSepXe3d288yprGV3gv
        rDYRWquTUH8KWyVhUjhxNco=
X-Google-Smtp-Source: ABdhPJySgYwKHqe0Yvl0Q1z0uW0HzgiuKI0Xb0SAhAQUWbRbH9qIFBLgqUtVHF3BB+59p2JtHdLSZQ==
X-Received: by 2002:ac8:2c38:: with SMTP id d53mr1645101qta.162.1589917634146;
        Tue, 19 May 2020 12:47:14 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:fa5d:572c:344c:b561:94e0])
        by smtp.gmail.com with ESMTPSA id h12sm611149qtb.19.2020.05.19.12.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 12:47:13 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id C53C4C08DA; Tue, 19 May 2020 16:47:10 -0300 (-03)
Date:   Tue, 19 May 2020 16:47:10 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: sctp doesn't honour net.ipv6.bindv6only
Message-ID: <20200519194710.GP2491@localhost.localdomain>
References: <62ff05456c5d4ab5953b85fff3934ba9@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62ff05456c5d4ab5953b85fff3934ba9@AcuMS.aculab.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 10:47:17AM +0000, David Laight wrote:
> The sctp code doesn't use sk->sk_ipv6only (which is initialised
> from net.ipv6.bindv6only) but instead uses its own flag

It actually does, via [__]ipv6_only_sock() calls since 7dab83de50c7
("sctp: Support ipv6only AF_INET6 sockets.").

> sp->v4mapped which always defaults to 1.
> 
> There may also be an expectation that
>   [gs]etsockopt(sctp_fd, IPPROTO_IPV6, IPV6_V6ONLY,...)
> will access the flag that sctp uses internally.
> (Matching TCP and UDP.)

My understanding is that these are slightly different.

v4mapped, if false, will allow the socket to deal with both address
types, without mapping. If true, it will map v4 into v6.
v6only, if false, it will do mapping for tcp/udp, but sctp won't use
it. If true, it will deny using v4, which is complementary to v4mapped
for sctp.

Did I miss anything?
 
  Marcelo
