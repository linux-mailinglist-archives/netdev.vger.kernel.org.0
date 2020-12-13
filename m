Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33492D8E3C
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 16:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405887AbgLMPRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 10:17:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:56466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730018AbgLMPR3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Dec 2020 10:17:29 -0500
Date:   Sun, 13 Dec 2020 16:16:45 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607872608;
        bh=pEiuqB9pAZbrN292hjKDbjBh1bbQUpVOf/f5lPhZzEQ=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=papV6FLD96BXoyZOlsI0R1TlvUIoPV0HQeU0lnGtnjJk8+YRXUXA+niGSE1bP6Xvy
         TTAiaNjzJZW0WZBiihNbrUyKExm0BwxfruvL820O0gxSl4TX9g93CjevSQCGbnFlnQ
         RvWwI52nWFjn3nBMyuzoK7ZpoMtaqMtoTL/6Bg1g=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Shuah Khan <shuah@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        wireguard@lists.zx2c4.com
Subject: Re: [PATCH v3] Compiler Attributes: remove CONFIG_ENABLE_MUST_CHECK
Message-ID: <X9YwXZvjSWANm4wR@kroah.com>
References: <20201128193335.219395-1-masahiroy@kernel.org>
 <20201212161831.GA28098@roeck-us.net>
 <CANiq72=e9Csgpcu3MdLGB77dL_QBn6PpqoG215YUHZLNCUGP0w@mail.gmail.com>
 <8f645b94-80e5-529c-7b6a-d9b8d8c9685e@roeck-us.net>
 <CANiq72kML=UmMLyKcorYwOhp2oqjfz7_+JN=EmPp05AapHbFSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiq72kML=UmMLyKcorYwOhp2oqjfz7_+JN=EmPp05AapHbFSg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 13, 2020 at 03:58:20PM +0100, Miguel Ojeda wrote:
> > The key here is "if nobody complains". I would argue that it is _your_
> > responsibility to do those builds, and not the reponsibility of others
> > to do it for you.
> 
> Testing allmodconfig for a popular architecture, agreed, it is due
> diligence to avoid messing -next that day.
> 
> Testing a matrix of configs * arches * gcc/clang * compiler versions?
> No, sorry, that is what CI/-next/-rcs are for and that is where the
> "if nobody complains" comes from.
> 
> If you think building a set of code for a given arch/config/etc. is
> particularly important, then it is _your_ responsibility to build it
> once in a while in -next (as you have done). If it is not that
> important, somebody will speak up in one -rc. If not, is anyone
> actually building that code at all?
> 
> Otherwise, changing core/shared code would be impossible. Please don't
> blame the author for making a sensible change that will improve code
> quality for everyone.
> 
> > But, sure, your call. Please feel free to ignore my report.
> 
> I'm not ignoring the report, quite the opposite. I am trying to
> understand why you think reverting is needed for something that has
> been more than a week in -next without any major breakage and still
> has a long road to v5.11.

Because if you get a report of something breaking for your change, you
need to work to resolve it, not argue about it.  Otherwise it needs to
be dropped/reverted.

Please fix.

thanks,

greg k-h
