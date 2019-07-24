Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79E31736FC
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 20:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbfGXSxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 14:53:08 -0400
Received: from mail-yw1-f52.google.com ([209.85.161.52]:35499 "EHLO
        mail-yw1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfGXSxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 14:53:07 -0400
Received: by mail-yw1-f52.google.com with SMTP id g19so17815083ywe.2
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 11:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=QkGoST7w43m8q/Esj90wYrBwrvB8U4NUXNoDEdC9zkw=;
        b=DfXOAxLjSWi0qh+6acmkUVxhHaotyiTVOkhsQbMCVCLbFTlR2U1M0ODKowJTZJO6bi
         AY4cPMEmUVjHi/lcQq9q37dCvu2bxLSVO/2Cj8MQSNmWh284hoz1A9kJu5T/rqAxWcA2
         jq1E8odfVy4B94g+1ICGV53JhdfxUUprY27NbVBtrvAexfQf3KrE8GYJRv90j+EI/68F
         Nt3i/MnH39+tuaOwo08OPFbdY9meH5zycXj1mSdL06kJEGcaFb6OBltS1Q3K1ZM+3TgE
         t7kmiIPAvExMNewu7rKRPP8E2uZYbTCErawj37va4v6NHlCBcpqh2cLAXrJiNfJHXoo3
         cZ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=QkGoST7w43m8q/Esj90wYrBwrvB8U4NUXNoDEdC9zkw=;
        b=bAzqCVGGcrpV5Q9cCBY4dXjrakXGbXvGr+/fMxItJ8AKz/xJr5FkzrrwY5NKc0z3Oh
         5uLz7C1osxQ+AiZD5KYM+tp5jSK/eMW6posy0oaQZRCeSAU+5h32OLPAYElq8bOhnsN5
         vr6pEn/pphiDzdu/gBYNFsPA1wt6plFoDw+5TaIMx/7u8/73pZdWrYv5fGuY6pjZ/BBe
         1eVL8cgsQecQcRBA0qJfcF5bYzOfYnU/yQTPpXA0mOel3jUzqpZ6NrzjvIJWO2wX8wzb
         gfn1kZSInDoHHuNKb0Ez9MYA3SabDywplSMYVyARb3hNjX9q1pUE6jenVyhoqswpYSWk
         UgvQ==
X-Gm-Message-State: APjAAAUzoBy+mMUgvpiqRi1XNsWLeBFpkb0CBJO53fTx/h2Nkf6pE+2c
        nbHuaLvUmVG2l9If19AJt0nzx8meBC+miD8bp77QLw==
X-Google-Smtp-Source: APXvYqx/tMXLvZEiqYfzJYCs7OOzSaxnEEKNMHX5g5zE3SSvQ73RpFpciwz3aMrVNiSRZv8HDB0OwcO0qWyK+HgZCIU=
X-Received: by 2002:a0d:dfc4:: with SMTP id i187mr48556986ywe.146.1563994386315;
 Wed, 24 Jul 2019 11:53:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190724013813.GB643@sol.localdomain> <63f12327-dd4b-5210-4de2-705af6bc4ba4@gmail.com>
 <20190724163014.GC673@sol.localdomain> <20190724.111225.2257475150626507655.davem@davemloft.net>
 <20190724183710.GF213255@gmail.com>
In-Reply-To: <20190724183710.GF213255@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 24 Jul 2019 20:52:54 +0200
Message-ID: <CANn89iKZcdk-YfqZ-F1toHDLW3Etf5oPR78bXOq0FbjwWyiSMQ@mail.gmail.com>
Subject: Re: Reminder: 99 open syzbot bugs in net subsystem
To:     David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        netdev <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>,
        i.maximets@samsung.com, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 8:37 PM Eric Biggers <ebiggers@kernel.org> wrote:

> A huge number of valid open bugs are not being fixed, which is a fact.  We can
> argue about what words to use to describe this situation, but it doesn't change
> the situation itself.
>
> What is your proposed solution?

syzbot sends emails, plenty  of them, with many wrong bisection
results, increasing the noise.

If nobody is interested, I am not sure sending copies of them
repeatedly will be of any help.

Maybe a simple monthly reminder with one URL to go to the list of bugs
would be less intrusive.
