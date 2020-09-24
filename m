Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE19277315
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 15:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgIXNu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 09:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728032AbgIXNu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 09:50:26 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E56CC0613CE;
        Thu, 24 Sep 2020 06:50:26 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id 26so3718691ois.5;
        Thu, 24 Sep 2020 06:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc;
        bh=wL0LIGpBgsROOKg0cQ18bWeg7cLHfTfL2bP6kCHNnGk=;
        b=jPfURQzn1/RwPgOLLUMsEbewe78lussA/XIB/WjGJqwgPTKy65BHc7Hjm6CqQP2NDp
         Bi/ZQiwCLq5SKnMB7UaJEPHn/yyd7tlrP923UOqzaDAjsA0/XQvXqQrDfoR6o6nn/wOp
         32HKty/cRkYkOSqRGMqF/tTtFauAEI6Yzxc1n7iLrfEOAzeF2EPQyFRrMnIdf8Orr98p
         8KQm7JkI5ywS69gKBmMAfuhMoLdEwVixmX/ZpZM9/Bu1qUbd6OMS2AvtJo7Gn6X8pdz0
         5C/PGHPpkGO67Lz3TOJcRh9nWqrXShOdmhM5S5L8TKLGR8kpcxE5TNA+t1bLAOr5Fhmq
         B6+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:cc;
        bh=wL0LIGpBgsROOKg0cQ18bWeg7cLHfTfL2bP6kCHNnGk=;
        b=KDThqy5rhObPgNZKcwgcouXA+oZFM2kCbzfv+/azliVOeQaK6zUxzwMfzhtcFpcF2A
         7I+l8+SqPNwNN4uZ+D6Hol4kPX5HJe1E9c4MXXra50Mr8URoEUSCWBOgQ3wtwL0Rlqq6
         9g7Xfo772T9hy51QINyzeuttHm6prSghXj8lcw63DLGvzhC+MaoYBEXN78PO/GM7nW/Z
         83/JFIXwCayBUEqMGWwdw78mLAH1Tzbq0QeAZLKekJb0GqdVy9piNwBf2uITpPR7P6v9
         WaN1JvemECl6q6fK2BD9w0usFOlWAl7Edf0H9GHcIzXKh894wmdU7c+SDAnwIenWgTKE
         R3/Q==
X-Gm-Message-State: AOAM5323VdXG6vWMWbh8V14ImlE9SZs1E9xu40JiI43Fl7NlCTMTsURc
        mY0x3z8CB1dl38oOZAIs/FEQnIMZh924R01f+H4=
X-Google-Smtp-Source: ABdhPJxWSx3js4JIJytEMhCdDZZXBKrFuQsJLM+aEKuvpYqfcZ4NT/WistOQLrEJryBzw+V83sj1e5z5ORCTAyBidB0=
X-Received: by 2002:aca:d409:: with SMTP id l9mr2379815oig.70.1600955425693;
 Thu, 24 Sep 2020 06:50:25 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 24 Sep 2020 15:50:14 +0200
Message-ID: <CA+icZUX+AX4GAG0z2PAnvJSEmKozYLa7oHjxGkjv2_9Rcs0J7A@mail.gmail.com>
Subject: [PATCH] kbuild: explicitly specify the build id style
To:     Bill Wendling <morbo@google.com>
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Andy Lutomirski <luto@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Will Deacon <will@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Please CC me I am not subscribed to all MLs ]
[ CC Sami ]

Hi Bill,

I have tested your patch on top of Sami's latest clang-cfi Git branch.

Feel free to add...

Tested-by: Sedat Dilek <sedat.dilek@gmail.com> # LLVM toolchain
version 11.0.0-rc3 on x86-64

Thanks for the patch.

Regards,
- Sedat -
