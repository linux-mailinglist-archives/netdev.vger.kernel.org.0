Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569972D87E5
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 17:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405775AbgLLQT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 11:19:26 -0500
Received: from gproxy10-pub.mail.unifiedlayer.com ([69.89.20.226]:60042 "EHLO
        gproxy10-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729002AbgLLQTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 11:19:17 -0500
Received: from cmgw14.unifiedlayer.com (unknown [10.9.0.14])
        by gproxy10.mail.unifiedlayer.com (Postfix) with ESMTP id 15A67140410
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 09:18:33 -0700 (MST)
Received: from bh-25.webhostbox.net ([208.91.199.152])
        by cmsmtp with ESMTP
        id o7bMkzLCFwNNlo7bMk9opQ; Sat, 12 Dec 2020 09:18:33 -0700
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.3 cv=C+zHNzH+ c=1 sm=1 tr=0
 a=QNED+QcLUkoL9qulTODnwA==:117 a=2cfIYNtKkjgZNaOwnGXpGw==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=kj9zAlcOel0A:10:nop_charset_1
 a=zTNgK-yGK50A:10:nop_rcvd_month_year
 a=evQFzbml-YQA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=UGG5zPGqAAAA:8 a=pGLkceISAAAA:8 a=1XWaLZrsAAAA:8 a=ekWyMdHfF5DymNlJAZQA:9
 a=CjuIK1q_8ugA:10:nop_charset_2 a=AjGcO6oz07-iQ99wixmX:22
 a=17ibUXfGiVyGqR_YBevW:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ohfb6PS6heT9rthxIVaAwHdwPtLaCOLcj0Or4Jj88tE=; b=zw+Zgzt8RzKBBLj43KwMbx3GSF
        7W09c62qztGcN8PW7XnvsMJPOPHpVMhlP7IQ0W9WBQ8WRL7t4C6Q4jpxdXCuEF/aMV9zQ+MBPabBX
        IUjJPfF5e44uT/bOhGqnmdyZiROYr1KXJwaUgidBNT/uI+Fooct0SNGO2CUXCI4fXeuo1v04g/wXc
        nJG8EU8XmIHVWE01wKUBW4ly+UsKOtJ1HuqIXD72Ut3+R2onCxRilQwDrsMYyIwSUQCuxRe+aZMGB
        PyF8aS7xxgrcWPos5rpt4ttVNo14eRoYiDdQl7Zu5CGLaeFJLerP0zBU65EsIM8tzF+5gClYz7BoW
        qTjWHUmA==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:50122 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <linux@roeck-us.net>)
        id 1ko7bL-002w99-Rs; Sat, 12 Dec 2020 16:18:32 +0000
Date:   Sat, 12 Dec 2020 08:18:31 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Shuah Khan <shuah@kernel.org>,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        wireguard@lists.zx2c4.com
Subject: Re: [PATCH v3] Compiler Attributes: remove CONFIG_ENABLE_MUST_CHECK
Message-ID: <20201212161831.GA28098@roeck-us.net>
References: <20201128193335.219395-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201128193335.219395-1-masahiroy@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1ko7bL-002w99-Rs
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:50122
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 27
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 29, 2020 at 04:33:35AM +0900, Masahiro Yamada wrote:
> Revert commit cebc04ba9aeb ("add CONFIG_ENABLE_MUST_CHECK").
> 
> A lot of warn_unused_result warnings existed in 2006, but until now
> they have been fixed thanks to people doing allmodconfig tests.
> 
> Our goal is to always enable __must_check where appropriate, so this
> CONFIG option is no longer needed.
> 
> I see a lot of defconfig (arch/*/configs/*_defconfig) files having:
> 
>     # CONFIG_ENABLE_MUST_CHECK is not set
> 
> I did not touch them for now since it would be a big churn. If arch
> maintainers want to clean them up, please go ahead.
> 
> While I was here, I also moved __must_check to compiler_attributes.h
> from compiler_types.h
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Acked-by: Nathan Chancellor <natechancellor@gmail.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

This patch results in:

arch/sh/kernel/cpu/sh4a/smp-shx3.c: In function 'shx3_prepare_cpus':
arch/sh/kernel/cpu/sh4a/smp-shx3.c:76:3: error: ignoring return value of 'request_irq' declared with attribute 'warn_unused_result'

when building sh:defconfig. Checking for calls to request_irq()
suggests that there will be other similar errors in various builds.
Reverting the patch fixes the problem.

Guenter
