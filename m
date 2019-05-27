Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0D62BB96
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 22:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfE0U4R convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 May 2019 16:56:17 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36532 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbfE0U4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 16:56:16 -0400
Received: by mail-ed1-f67.google.com with SMTP id a8so28375354edx.3
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 13:56:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=EuQ8b2S5R3YbI8mza3fhQsrNgy4ILRY0opGI5BO2xXM=;
        b=QGiVHgUzRZkvOapyOpY+LpJujRhB9zKOljfNC1pN/qt7uHNjgOv9EJ9vV7f78PvGHv
         FTZMmhuFPKxOnbExlmQwYQc03J1aINjJJ2Z2sktZ08g4yDUTy0hbqgDf58NAxjQWAg7t
         Ge0HdEA5wUH2qlr+O+rT4iXulXHpYi1/iyfAptmr6u+80a3C9qykQj7sq80HkhLq7VrM
         mjdT6zxqhDHczkbWfmt+0c7/HMtCWaO73Ur2cmiiuJ5fa9NGTeEsghB2F/tM4Xj6hoHW
         rKsZQFkO3QkP9rG3REiHMWCGqnlwudumZ3kXW2c0KkmvzroMiFbDh0y02XWAJMPkvXfU
         W5PA==
X-Gm-Message-State: APjAAAWFC5GoQy9snaJzLsyE3Gk1+OK9Zp7bYSqQpPwVVabXM2PFRSB3
        poVGk/ryIZrOEbvQJ790mEwcdPKGNfw=
X-Google-Smtp-Source: APXvYqzUnRBS7tZrJ2cj09aYaeiNZUBCeQ8sRcsTtIswnwaH37A7/PzY07Gr9EXsW/SVKaHUqMTSVg==
X-Received: by 2002:a50:b39a:: with SMTP id s26mr119636360edd.39.1558990574529;
        Mon, 27 May 2019 13:56:14 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id l18sm1906110ejs.44.2019.05.27.13.56.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 May 2019 13:56:13 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C739018031C; Mon, 27 May 2019 22:56:12 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Cc:     "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v5] net: sched: Introduce act_ctinfo action
In-Reply-To: <4F2278CE-5197-43FF-B3D5-AF443088D73F@darbyshire-bryant.me.uk>
References: <87h89kx74q.fsf@toke.dk> <20190527111716.94736-1-ldir@darbyshire-bryant.me.uk> <8736kzyk53.fsf@toke.dk> <4F2278CE-5197-43FF-B3D5-AF443088D73F@darbyshire-bryant.me.uk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 27 May 2019 22:56:12 +0200
Message-ID: <87lfyrwr9v.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk> writes:

> I have to call it a day. I have no idea why the patches are becoming
> corrupt and hence how to fix it, it’s probably something Apple has
> done to git, or maybe MS to my email server.

Or maybe it's just that your editor saves things with the wrong type of
line ending (if you're on a Mac)?

> Sadly I also think that the only way this patch/functionality will
> ever be acceptable is if someone else writes it, where they or their
> company can take the credit/blame.

Not sure why you would think so.

> I tried very hard to approach the process of upstream submission in a
> positive way, seeking advice & guidance in the form of RFC patches,
> many rounds later I feel they’re further away from acceptance than
> ever.

Not sure why you'd think that either; I thought you were rather close,
actually...

> Clearly it is not desired functionality/code otherwise it would have
> been written by now and I cannot face another 3 rounds of the same
> thing for act_ctinfo user space, the x_tables/nf_tables kernel helper
> to store the DSCP in the first place and the user space code to handle
> that.
>
> As a rank outsider, amateur coder I shall leave it that I’ve found the
> process completely discouraging. The professionals are of course paid
> to deal with this.

It's up to you if you want to continue, of course; but honestly, I'm not
actually sure what it is you are finding hard to "deal with"? No one has
told you "go away, this is junk"; you've gotten a few suggestions for
improvements, most of which you have already fixed. So what, exactly, is
the problem? :)

-Toke
