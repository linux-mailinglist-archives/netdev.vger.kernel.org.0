Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2E66191A67
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 21:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbgCXT7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 15:59:06 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:32778 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgCXT7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 15:59:06 -0400
Received: by mail-pl1-f196.google.com with SMTP id g18so7876605plq.0
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 12:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gcQRcAtEQg4rjglKJRL2d98Lwfwnni+3VOu5y4qk85w=;
        b=qYdy9ZyBm+V84vQRBdlRTTvNTWSlZa5gYHUIUgd4O4BL5QBdn6VF9+ymfZWyvKzL/2
         /FOM9/+eBM3zVmgxj6CLruwd+vCZ5F8v6fKWp+ANxQUv9ZKTrG9WXB6KVw+xf15tRh/M
         bEZpa2mn4ETx1ELJqqGcVJ56DtgBO8mwIYIbKSpeB8ThQwmMHDppJVerNjKNcjMNfIdn
         4mwR48QTj83kunUhPaEhiY4GG8YIcPxsA/2jWrps7vuIhcEX84DwnB9kQ+DijcW6QF2d
         HPMyPCpZURVGe/yMfvl4PiIqZnOO4Ujrk2RxJrGbIuD4IctdsbBG3/lOTk27h7IopctE
         5VdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gcQRcAtEQg4rjglKJRL2d98Lwfwnni+3VOu5y4qk85w=;
        b=fgPQvipYuO9xeHHlzX1SLwG4rWVyArIc+YCY5OsR9nDRL6JlVALzhxiFmsjlbdqdCY
         UIJW0QElSkz+tSqb9YPYP77KbxwNwfAUqefNnoaO7EMfo9+BinHS7shKX6hgC/RNz391
         XVCZmMb81DR74hV459U3ZemOPHYvRJmb12TNfKstG7ZT58oI4QRf6axqRcwGsuqV+3hq
         monGeyewpG6Il8Aha1VmC4rbgpPfPVEqPCPiDJKObrtqTLtfJCzoMn6u4Cj6Hzt2McA4
         MD7IN1v6OKkXCPZBBFYkbujSUhnzRREHOzXImayHBbVVv60b8TfdcMm6y5/q6TsNNBgl
         Ry+Q==
X-Gm-Message-State: ANhLgQ1DFpARmsQV0zZNeZ8/Lm8dww62bc0KXdK8Z0CbEOTvwp+6GOWU
        3GtiSLnElpquVzYuIQyWmCiPb+KKQ49ce/DSr+6aaA==
X-Google-Smtp-Source: ADFU+vuilu4nK+FQYgpHdIaviKzEUBXNJjUU1ornx3/tJ+r2le+vN0Nlu7KwhPe37OGsZLY9Z8pKyFJL8kFUhNhEyA8=
X-Received: by 2002:a17:902:6bc8:: with SMTP id m8mr21730233plt.223.1585079945020;
 Tue, 24 Mar 2020 12:59:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200324161539.7538-1-masahiroy@kernel.org> <20200324161539.7538-3-masahiroy@kernel.org>
 <CAKwvOdkjiyyt8Ju2j2O4cm1sB34rb_FTgjCRzEiXM6KL4muO_w@mail.gmail.com>
In-Reply-To: <CAKwvOdkjiyyt8Ju2j2O4cm1sB34rb_FTgjCRzEiXM6KL4muO_w@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 24 Mar 2020 12:58:54 -0700
Message-ID: <CAKwvOdmWqAUhL5DRg9oQPXzFtogK-0Q-VZ=FWf=Cjm-RJgR4sw@mail.gmail.com>
Subject: Re: [PATCH 3/3] kbuild: remove AS variable
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 12:38 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
> consistent in this regard (and not using the compiler as the driver),

Ah, the preprocessor; we need to preprocess the .S files, .s files are
fine (though we have .lds.S files that are not `-x
assembler-with-cpp`)

-- 
Thanks,
~Nick Desaulniers
