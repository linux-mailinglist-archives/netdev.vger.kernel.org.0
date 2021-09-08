Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A14403C6E
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 17:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351840AbhIHPZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 11:25:03 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:37486 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbhIHPZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 11:25:02 -0400
Received: by mail-wr1-f42.google.com with SMTP id v10so3898866wrd.4;
        Wed, 08 Sep 2021 08:23:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1t5LYToXMKzmQGZhhdsl+wcVGB4mGa+92qwlh2R7WK8=;
        b=fokVFnFlZTnk+C8IcO5UcufX3C0IssE6sFF2S9CBMAQE1CAWiUWorclsLi/NDW5I59
         xSW+ALYgg+/Uj5x7Rl+dsj/2xzkQKFMAvsD7CWIyv4RXBPnoQQM3G3QOvzEdgV8ap/8n
         49cbFnDgx8CcI6dYc2b8hVg2Qa+eI5eA34DFsfjErCqJFa6uYJkOQeymY81ypSJXhWQX
         es3mkebSiCmgec1srXpMKa/9jvdUGDbBgd6ZjaccQs4VqtmvJaDfrJrwD4D7TwbFhP25
         VRYNCtwJtYUfNguhKK1DMUGpxQ3RWNUTdwGQC9lSoZhEyC6Sqw8spaDX2Z2uNR4KFens
         hdMg==
X-Gm-Message-State: AOAM531uDev/QXBAufE+NeL/mdNk6wUgTU+gX3wGBYY9iF4Qp7oItO8Y
        34xUQKc+Vv8swtzAI8pZu0Q=
X-Google-Smtp-Source: ABdhPJwtCnniMnv2FH4hW32bnl4MIBdEAEuQG84WcjPSOttEQvakqMUDFeH6Cxa9SmN1PRBTYeInfw==
X-Received: by 2002:adf:9e4d:: with SMTP id v13mr4758076wre.26.1631114633660;
        Wed, 08 Sep 2021 08:23:53 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id j17sm2367696wrh.67.2021.09.08.08.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 08:23:53 -0700 (PDT)
Date:   Wed, 8 Sep 2021 15:23:51 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Wei Liu' <wei.liu@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Ariel Elior <aelior@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger
 than 1024 bytes [-Werror=frame-larger-than=]
Message-ID: <20210908152351.asln63jxk43xffib@liuwe-devbox-debian-v2>
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
 <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
 <20210908100304.oknxj4v436sbg3nb@liuwe-devbox-debian-v2>
 <46be667d057f413aac7871ebe784e274@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46be667d057f413aac7871ebe784e274@AcuMS.aculab.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 08, 2021 at 02:51:21PM +0000, David Laight wrote:
> From: Wei Liu
> > Sent: 08 September 2021 11:03
> ...
> > However calling into the allocator from that IPI path seems very heavy
> > weight. I will discuss with fellow engineers on how to fix it properly.
> 
> Isn't the IPI code something that is likely to get called
> when a lot of stack has already been used?
> 
> So you really shouldn't be using much stack at all??

I don't follow your questions. I don't dispute there is a problem. I
just think calling into the allocator is not a good idea in that
particular piece of code we need to fix.

Hopefully we can come up with a solution to remove need for a cpumask in
that code -- discussion is on-going.

Wei.

> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
