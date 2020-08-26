Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11E425316A
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 16:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgHZOfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 10:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728084AbgHZOfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 10:35:33 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21231C061757
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 07:35:33 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id k18so1079142pfp.7
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 07:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zlWD4mMfzCVB2jdZZ6ZoIGAn0SqU5tPfKJ8HMMwtC/g=;
        b=J16/TGeiI0kuaBTxosIhsvsOU7S5wOF7AE+HMf6Ufqbh2CJcnS8jnicPOOMLp2KeFy
         nsToaRLAKH2fBakI7eQcPBmkiIEqzx8XuXZYnkhOaYutkMJ4TgLE5DGv6qfqII3+1O2U
         gGewV5HKl9r4mr+ujKWHTlKk76wICsv4PLCFmrJeMKolXi2rheY0VBSYpjQ9IEXI80kA
         ZW3+GnTsO3uAzFEaK/8QVoRVo2/r9zwrPhqAS2VYhyHYQtdKM6kMDBr9utvKmPpEUZGT
         rO78EwNr9/kahavSRcNQsgtfM9e/W6t75FQegHGMzmJ1X/zFp+dv9AOLa/3biDI64FPf
         FrsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zlWD4mMfzCVB2jdZZ6ZoIGAn0SqU5tPfKJ8HMMwtC/g=;
        b=S2HMIWIdws1cUp1hXRsIIEwsXi6N5WWTwdaO7Ltn+L2XUjkd8yQNig4y2SHMat65E5
         azPwDP0r6E5l27quXgMGQS7hAwFr7Qd6TNJjP046LToEgnXq3uMc4PGkh1rC9nEulibT
         jLmpBfepDy9JrIKAqJgAKaPgiM2CXNOyI7URRzxIrcQEyu0LbnNb5nkFLqe/DIbh2RKU
         jc1GIo2TNm3/CIYINXQ1RFfaftau9kx4OW7kbKNGQuw1Ghs0fK6lmRmJm3P2LAsNf169
         XWEkKiaG7G/Hq9sHrZtI6Duqih8rHGxN+7gfDh968OvhAnNtwX5Ss69RNYDehLAsT8qQ
         8Ycw==
X-Gm-Message-State: AOAM5323VvcS+UB2oWCMki18vOqYKqsUPBQs+Db3UmLT0+4NpZwff98O
        w0K1iCam9Z935TPuJ7kItw==
X-Google-Smtp-Source: ABdhPJzgvMHElSpdIXxkByse7xXog0LgeemvL5/O4JmtMXwxnMgi+0tFs2Lo79AQGYl7L2Uv7sGrNg==
X-Received: by 2002:a65:614a:: with SMTP id o10mr10697032pgv.411.1598452532616;
        Wed, 26 Aug 2020 07:35:32 -0700 (PDT)
Received: from madhuparna-HP-Notebook ([2402:3a80:cfa:a9b5:1951:3e81:92cc:b4c1])
        by smtp.gmail.com with ESMTPSA id n26sm3410243pfq.124.2020.08.26.07.35.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Aug 2020 07:35:31 -0700 (PDT)
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Google-Original-From: Madhuparna Bhowmik <change_this_user_name@gmail.com>
Date:   Wed, 26 Aug 2020 20:05:26 +0530
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        andrianov <andrianov@ispras.ru>, netdev <netdev@vger.kernel.org>
Subject: Re: Regarding possible bug in net/wan/x25_asy.c
Message-ID: <20200826143526.GA7985@madhuparna-HP-Notebook>
References: <CAD=jOEY=8T3-USi63hy47BZKfTYcsUw-s-jAc3xi9ksk-je+XA@mail.gmail.com>
 <CAJht_EPrOuk3uweCNy06s0UQTBwkwCzjoS9fMfP8DMRAt8UV8w@mail.gmail.com>
 <20200824141315.GA21579@madhuparna-HP-Notebook>
 <CAJht_ENNhvOO=V+bABBC3nL6G7Gkw6H-UVQPWxO4_vyYXcVNhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJht_ENNhvOO=V+bABBC3nL6G7Gkw6H-UVQPWxO4_vyYXcVNhA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 01:49:04PM -0700, Xie He wrote:
> On Mon, Aug 24, 2020 at 7:13 AM Madhuparna Bhowmik
> <madhuparnabhowmik10@gmail.com> wrote:
> >
> > Sure, I had a look at it and since you are already working on fixing
> > this driver, don't think there is a need for a patch to fix the
> > particular race condition bug. This bug was found by the Linux driver
> > verification project and my work was to report it to the maintainers.
> 
> OK. Thank you for reporting!
> 
> I think the Linux driver verification project works very well because
> it can help to find data races.
>
Yes, indeed!

> This driver might take a long time to fix because it has many issues,
> and developers who are interested in it and are able to review patches
> to it are rare.
>
Alright, hope it is fixed soon!

Thanks,
Madhuparna

> Xie He
