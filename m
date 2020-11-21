Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194A32BC219
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 21:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728505AbgKUUpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 15:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728402AbgKUUpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 15:45:54 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C342EC0613CF;
        Sat, 21 Nov 2020 12:45:53 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id x17so12091339ybr.8;
        Sat, 21 Nov 2020 12:45:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jfob3+FnyGrRXkhnjH+zGr8/PgDK3twBANc/QMxzgFE=;
        b=J7K+/UQ7F1lLvhDUkN5iLO0MvjX7Kj2Yl4f0hrn4pIZzSXMIv+YjKJExTuyxkjxvAu
         tDTtUy+dCTzZRxCvYI08Es+Rl6Pj4vkoYp3+zBz2zdG0p9fgwIMi+vmfdbPi610owxXt
         HOsCV5UlDZ/TzHhOGjCMucJtSwOjTbXxfnlkYxe26eUyRp3YcXM2A6BvMEfXCTOfG4rb
         GkMhSphirNkrqej5d9RzyRYhiPWYz5JSPLgq0rDX45LXAPGSGzEXPnsDkttCidhrAUWp
         S66B6SiAvXTGG4744mRaXXAnxUh+5r4Bm+LuMzu1qgXtDVzh1v87M2X6pqtuJNTp/D1Z
         b31g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jfob3+FnyGrRXkhnjH+zGr8/PgDK3twBANc/QMxzgFE=;
        b=KPeqFj69oBMvfNd/Zg6LI6Y7u2grdddKUDs9x0b1JiKgDrepfUMoI22/xGuDXcZQM0
         wwNj8MCfJ9lGmRqWP/+WKsU5C4zvupDFWpntYbs5pU62JhsnBOnTmfGlGjIVVGpjUSR5
         qWkE6NztSsgq0gKyEPdvJuNKGDA5ai0XisU8GONyQ+jqS73xBUi34rk2bWirIsohE14E
         1Je1QVzJaCVM6LSFz/OXgzRfbVq8VuqB2lNKGJs2BMKZBCjqwWuNJp1piqq9/S8fdqm3
         HvUEDE5lcxNSLem9nByXDcq2Q0xgECVmR4rFK0x+Eluwq557qzmXJpBmKTJCCc/7Alqa
         ovvA==
X-Gm-Message-State: AOAM530dk4JvO+j4nTcCLWt/NaWdrTD+g+gMrnIVSney42l9Axehg6ZP
        DI9Dhc6dSMExH8ga/BWrL9PON0FqZEUJav3aLkE=
X-Google-Smtp-Source: ABdhPJw29eh3xaiHlSU2WpXqs9VkBeKzCzHJyDlT0wlOE00mduy9vnpv6HjM6io7IBtMYamga//5r9fCirI/O4wN5Ko=
X-Received: by 2002:a25:2e0d:: with SMTP id u13mr28744857ybu.247.1605991552718;
 Sat, 21 Nov 2020 12:45:52 -0800 (PST)
MIME-Version: 1.0
References: <20201121194339.52290-1-masahiroy@kernel.org>
In-Reply-To: <20201121194339.52290-1-masahiroy@kernel.org>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Sat, 21 Nov 2020 21:45:41 +0100
Message-ID: <CANiq72nL7yxGj-Q6aOxG68967g_fB6=hDED0mTBrZ_SjC=U-Pg@mail.gmail.com>
Subject: Re: [PATCH] compiler_attribute: remove CONFIG_ENABLE_MUST_CHECK
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Shuah Khan <shuah@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        wireguard@lists.zx2c4.com,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 21, 2020 at 8:44 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> Our goal is to always enable __must_check where appreciate, so this
> CONFIG option is no longer needed.

This would be great. It also implies we can then move it to
`compiler_attributes.h` since it does not depend on config options
anymore.

We should also rename it to `__nodiscard`, since that is the
standardized name (coming soon to C2x and in C++ for years).

Cc'ing the Clang folks too to make them aware.

Cheers,
Miguel
