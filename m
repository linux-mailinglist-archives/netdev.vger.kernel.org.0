Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DC42C7C48
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 02:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgK3BFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 20:05:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgK3BFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 20:05:11 -0500
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A68C0613CF;
        Sun, 29 Nov 2020 17:04:25 -0800 (PST)
Received: by mail-qv1-xf44.google.com with SMTP id ek7so4890498qvb.6;
        Sun, 29 Nov 2020 17:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9w+jIogOsKRBrpA0BOG2mGKZgZW7G/tIHqRWbeWWJW4=;
        b=WU2glR0TsgL7F4/RiVfuwal0YDkOeqqQo1eMszLAWLO0V78Iff5/n64/V+Tel6qT40
         0VZPZwJwnsbjpw844pzMgW2hYIqwz9mbmNNEs6O9eqV7TWRrdnQvvljYsI+oAgmSfU9d
         JIxDowmXVsOG4M50gjV44mXjYipYLj/9fbmyh2K14okhPO2JuJkIbpuUnR81GPub6sfc
         rlIoxazGL6HuV4KMjGROkoGEtAMmm7Vc+Pc82fuAAMqnezRvuWTfJB0nD/O/ozmK1le2
         0iQc4nSTPnFUJ+egMZNoYLZ/ZHipkw5XcHC1btQ4QFt9SCnPc6sbU8WpdjVCohjcBAA6
         sP4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9w+jIogOsKRBrpA0BOG2mGKZgZW7G/tIHqRWbeWWJW4=;
        b=uBg+pLLcCaWLE0ZI5H6R84hlEEMKyD8wSPYQJju2zAQ5f4VO7CMaB9pgY9VLs87+6d
         B4Axb0U8vFJ9yic/cG24srxEZfdMOLf0q0Asqgam2qVReSu0Jspe3+YHyQf8A1xCKvwQ
         GcI88b0vEPBESsVbFfvlUnqtxQ5bfs78F0oENj9gCs1BibkB68lLqe6RUE4RTvm+BWd2
         XYIbm9x2DLnHlvphaEzqtX+pdm1Gm9D4P0sHRvhffT7iBWkBCEnlENRiRWr6a4OoPt83
         mUh7NHbOdoLLuwPrqVMGlMrZICayRKtVV2LVubJvr/z1b0mrQJ3iRGnZe+OwoRrDhOhA
         3nrQ==
X-Gm-Message-State: AOAM530zkGSD/jJNA7PQPrE+S2pbKxO1mE3N/giTnbtK0nfqshI4boSQ
        GIFHR4pSLr3VfC114sEtFYk=
X-Google-Smtp-Source: ABdhPJxNBQJpDe6Q+07RcfAa9BO9KXU9uK23WXodIbLjKY85NBzOpU1EHUFfTEHywAlwGfo76xkVUw==
X-Received: by 2002:a0c:fe04:: with SMTP id x4mr17013047qvr.61.1606698264424;
        Sun, 29 Nov 2020 17:04:24 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id e19sm14025778qtp.83.2020.11.29.17.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 17:04:23 -0800 (PST)
Date:   Sun, 29 Nov 2020 18:04:22 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Shuah Khan <shuah@kernel.org>,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        wireguard@lists.zx2c4.com
Subject: Re: [PATCH v3] Compiler Attributes: remove CONFIG_ENABLE_MUST_CHECK
Message-ID: <20201130010422.GA1956616@ubuntu-m3-large-x86>
References: <20201128193335.219395-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201128193335.219395-1-masahiroy@kernel.org>
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

Acked-by: Nathan Chancellor <natechancellor@gmail.com>
