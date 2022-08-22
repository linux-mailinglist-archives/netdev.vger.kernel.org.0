Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA9859C3EC
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 18:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236387AbiHVQSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 12:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236341AbiHVQSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 12:18:37 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9751BEA8
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 09:18:32 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id p187so1243406iod.8
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 09:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=28liATqWCnenPmSSbmsfL1Qb8/cCcnlC13eU8jycOoY=;
        b=brSaED4ax4SJscfe+HTsieLi7/Mk77XKfVCSrTh3ORLHqjwNzyWIJQvtoTLzJNTl77
         jDSSXgytEhg2nWzkcQrVLS2nbFjSleoOA+GWELyUGlFT1YYG+/2tE/70Nz3GLIgjm7d0
         O5yUggh8qVq5I+6TV3xYGNCbUqTwZa9q/0S76cgldppLfIe0fN9cMz/RYiWzwRhyMNK6
         kc80PHvKA5GXOp8b1rHk/eYBNz1Spo6l7bgXtgSnUOskcaRMgKX7PXqigjAm9VJ8T6n7
         VZASR85i0P6Qj/ldZMZuWZsWa4Mf/pqAynvFl4vpaA22LLvWplwhSKXERP4qeidz4mrO
         pFSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=28liATqWCnenPmSSbmsfL1Qb8/cCcnlC13eU8jycOoY=;
        b=PsnJmONw+x7WVl7rXK+f9arckHlSZu8cB7e3T/jE2dkh8K4sdttkfouwwa0prn3rRC
         6+4BLqEYF/X8uK3uWOcyVNr1f4YTMXpegjYs41K2ZA3LvfLCEg/mgx2LQDhDAkw20IdS
         YADycPkycaE4rCoaH3hOyO+KsEfU77HqsyweG3jwqp+dRyBawQxEoSh/l7AjDqdAU2Uu
         FAJY/mNFILTLzedV7AIJXUPPT3pQyqTIqbNLhXH0A/L612nioY0VG1O2XNZ7vBnwDNvX
         7JmS84RfjYscOs7dHybOHRIATknlFDtxhHXwzTpkpQNb/CNUdWcvoRg1BaWV3LGQRV5/
         LKTA==
X-Gm-Message-State: ACgBeo0K86/qxDe3slyp012H6kKHd1g69HqqcqInZqztKMDaE8PXqQhp
        PjSmAtpmYzfl4/CRW/VIgEmO5Tp3AzXraAqg6VykGg==
X-Google-Smtp-Source: AA6agR7DaLdD5v8vkDX3umoS6oSedE+nyg/hFLRDB6jS5QtPV07mT06RicLD1fu7DxWjr63YxdENVP8+A/z/LYikUnw=
X-Received: by 2002:a02:5d42:0:b0:349:e1a7:f08d with SMTP id
 w63-20020a025d42000000b00349e1a7f08dmr1725304jaa.61.1661185111863; Mon, 22
 Aug 2022 09:18:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220819190558.477166-1-axelrasmussen@google.com> <20220819160752.777ef64b@kernel.org>
In-Reply-To: <20220819160752.777ef64b@kernel.org>
From:   Axel Rasmussen <axelrasmussen@google.com>
Date:   Mon, 22 Aug 2022 09:17:57 -0700
Message-ID: <CAJHvVcgfdkrQSsoenyanjtuav9OK4w9YKVqinUiMrkvdgtB4sg@mail.gmail.com>
Subject: Re: [PATCH] selftests: fix a couple missing .gitignore entries
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrei Vagin <avagin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jens Axboe <axboe@kernel.dk>,
        Kees Cook <keescook@chromium.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 4:07 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 19 Aug 2022 12:05:58 -0700 Axel Rasmussen wrote:
> > Some recent commits added new test binaries, but forgot to add those to
> > .gitignore. Now, after one does "make -C tools/testing/selftests", one
> > ends up with some untracked files in the kernel tree.
> >
> > Add the test binaries to .gitignore, to avoid this minor annoyance.
> >
> > Fixes: d8b6171bd58a ("selftests/io_uring: test zerocopy send")
> > Fixes: 6342140db660 ("selftests/timens: add a test for vfork+exit")
> > Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
> > ---
> >  tools/testing/selftests/net/.gitignore    | 3 ++-
> >  tools/testing/selftests/timens/.gitignore | 1 +
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
> > index 0e5751af6247..02abf8fdfd3a 100644
> > --- a/tools/testing/selftests/net/.gitignore
> > +++ b/tools/testing/selftests/net/.gitignore
> > @@ -39,4 +39,5 @@ toeplitz
> >  tun
> >  cmsg_sender
> >  unix_connect
> > -tap
> > \ No newline at end of file
> > +tap
> > +io_uring_zerocopy_tx
>
> Could you make the io_uring test the first in the file?
> That'd gets us closest to the alphabetical ordering (I know the file is
> not ordered now, but we should start moving that way).

It isn't that it's mostly ordered with a few exceptions, to me it
looks entirely random. I don't mind moving the one I'm adding but, I'm
not sure it gives much value given that.

Would folks object to just adding a second commit to this which sorts
the file? Since this file isn't changed frequently, I would say the
risk of annoying conflicts is pretty low.
