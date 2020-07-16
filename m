Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378252225A0
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 16:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbgGPOcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 10:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbgGPOcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 10:32:03 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442B0C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 07:32:03 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id c25so4336018otf.7
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 07:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y33iJ0++P8x3ZKlzoIa+XlhHf3rBpyq5v+nJxcOKCDc=;
        b=CUxZgNmVXABmfG3PQKPwE4UK3UFPC1Pczm2Xdg1z90uw6rKiqit8VhHScDfCW95fP5
         HvFlNrFxg0TEmUSPZzwUJOJk4ZZdPQtix7Tpb8LNrPCXlFwn2YWtNrizFilmveUdkwgF
         YCYxdk3GH9gT2NLoHZl4Hpn2QEZWR6zV5lemWsl+mScoTy5fpETiiU7/IajXzbMcf7Fr
         8sdfhFWqPRs+MBIeB5KUQp2oFY+Hfx1HbqqAkSMfxTvjPs0YsORCAhk+NWh3vMwT/RN1
         4NrmOR/HcliQtOAZbxyphzu4XE9/tkhoUFCih2jXuD5oQUiC173eqSfS+dqT78bbqE9w
         iwig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y33iJ0++P8x3ZKlzoIa+XlhHf3rBpyq5v+nJxcOKCDc=;
        b=XrIVXEi6+oSRCGBOde2/WuuCp6xqOAn8uWormvBtTP/RzZViVIWe3bWKJ5YrQ72daD
         oC3buq+iF93CME2Cj+NknV14PBNR3yKwnkz92vGqz6uB4naRkoo4KUBDcVfE3QKMz7T5
         /DHgYLYythNbWdRt1Q3/34kihS37kEamAu+e5eMh/34KqXXZq63fs57j5/f3naxvy+wk
         anxMCw7oPCU5bQM4Q6ZJ7/oaEh6seBrLnwQPCmAL2vxmdCTO6Z2pLj5O6+dN2mcUOmFr
         FEYnwJFt+VQ+y5MWOqGrzXhi8MOxRaBsa1RqTvpOvsnJS3qFnjp/55LRrUKgQx+Oi7wp
         oOuQ==
X-Gm-Message-State: AOAM531aP0MR8Us2b/zsfKkOqyaR+jWYEKuSQkWkD8K/Lkaz5zgQofUB
        nTl1sSsJeaGYVczVhwz5bFTQv8PF1sz7i2pSUG/OxFuL
X-Google-Smtp-Source: ABdhPJy/1Di6Psz7KSU0bgmHl/1G8gQCXnKAG8PPi0QCXiGWpVdFi/0PQ/6wpU4u1S+5+s+jILkNmgh39IEYQFkIUCQ=
X-Received: by 2002:a9d:4e82:: with SMTP id v2mr4795786otk.278.1594909922617;
 Thu, 16 Jul 2020 07:32:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAD=hENefWXPsvPSLsnRyM5bbjYpYkfg2JMQegxia90P_JN7f5A@mail.gmail.com>
 <398-5f102a00-7b-4ccf8d80@121109257>
In-Reply-To: <398-5f102a00-7b-4ccf8d80@121109257>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Thu, 16 Jul 2020 22:31:51 +0800
Message-ID: <CAD=hENdPR8Xi1SYaaA+24aLX9sUq7VK7Fbsb=5E9RSKgChk8HQ@mail.gmail.com>
Subject: Re: Bonding driver unexpected behaviour
To:     Riccardo Paolo Bestetti <pbl@bestov.io>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 6:20 PM Riccardo Paolo Bestetti <pbl@bestov.io> wrote:
>
> Hello Zhu Yanjun,
>
> On Thursday, July 16, 2020 11:45 CEST, Zhu Yanjun <zyjzyj2000@gmail.com> wrote:
>
> > On Thu, Jul 16, 2020 at 4:08 PM Riccardo Paolo Bestetti <pbl@bestov.io> wrote:
> > >
> > >
> > >
> > > On Thursday, July 16, 2020 09:45 CEST, Zhu Yanjun <zyjzyj2000@gmail.com> wrote:
> > > > You can use team to make tests.
> > > I'm not sure I understand what you mean. Could you point me to relevant documentation?
> >
> > https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/networking_guide/sec-comparison_of_network_teaming_to_bonding
> >
> > Use team instead of bonding to make tests.
> That seems like a Red Hat-specific feature. Unfortunately, I do not know Red Hat.

Just a test.
Team driver does not belong to Red Hat.
I am also not Redhat employee.

You can make tests with team driver to find the root cause, then fix it.

IMHO, you can build bonding driver and gretap driver, make tests with
them, then find out where the packets are dropped, finally find out
the root cause.
This is a direct method.

It is up to you about how to find out the root cause.

Zhu Yanjun
> Nor I would have the possibility of using Red Hat in production even if I could get teaming to work instead of bonding.
>
> Riccardo P. Bestetti
>
