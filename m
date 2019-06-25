Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAAA0521E0
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 06:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfFYERr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 00:17:47 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34157 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfFYERr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 00:17:47 -0400
Received: by mail-wm1-f67.google.com with SMTP id w9so1311558wmd.1
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 21:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TZxWWWpC1bRmfm9NiiyZtA8z4+2NRrShD++slVFi/uY=;
        b=ZiJf2LURFQj8t3X+ZiK/eAzEQPb+98/LrSWQderUsc4fUhD6uH/eY3+fD62iBiE1h4
         zzQqHZ0o0cCHTUaYd/RrXGHhyI8mEbXKZQmNw9dCXmX5fgshkr/VeVsR//xtHrS308pA
         TbiKBlGqFs5kfl4pPBdPjsLiw9q5p645edtReHzZKkQKELRY3mTV4eZeCCZKF1gEiGvj
         vKPXZaRsWnWVRmySsOpE579qib1NO/1Sk3u1Fe+bLQXz53HwRhqEwajmRz6JKGJTpB4O
         cfEjd/j7ixN+JIG2yURzXsP8zsqqcpsIjxBCWpYPW1rCzBezprEBtO0nzKxsprr1pNIx
         ZJ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TZxWWWpC1bRmfm9NiiyZtA8z4+2NRrShD++slVFi/uY=;
        b=OI1BA92ydIboVY9OrCsbZ/yNF+a/oyzJpX+W1cV4cGz3Q2gp0FEPlucN6GAkkMDOue
         FbAVrup+b9qHHqlibHa7TliG7vqZ+gUoJiT/uiGeyZNKGESdtjkpYdRkgN90pX8UG2v3
         YmOAjPqpRqp48PXwuCy9ftOVJ5GpXXt1+CUaPb1jjh6n1EBcBl1bvZNaoLI4KxAQFKSe
         nO2aFy8eHNpdrlBmdyLNi+7yfyRp0VNYkwmYynUEoISN9/gnPNivoudARpajaYc9JkPO
         btjYtMwkNkChtktLpdD/UHnyXhpTLTmj/QcNbS7oG0poNPKPh2fURZzbU/8IoWyYh/2E
         VebA==
X-Gm-Message-State: APjAAAUd8Ev22tgNbN7APLRQE5FV1J1KQ0wxQLPtUfkaSmM0QVFcs85x
        41ZHjRrWngBbQgPB00DPtF/QBWo3QtLxmfC7oMILHQ==
X-Google-Smtp-Source: APXvYqzWl1CM/L2VKvPQdihmR3JA6PxNFcv7x6hy9Z0+zy1kbX0JrHZ2ZNWZxwN4/Md3pAE4eeUDvT4bqjTmzeZP+rA=
X-Received: by 2002:a1c:d107:: with SMTP id i7mr18417120wmg.92.1561436264754;
 Mon, 24 Jun 2019 21:17:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190622004519.89335-1-maheshb@google.com> <CACKFLinDN+cOEBfm9wnoXU-iDDtZZpCu+NPMHs9aCQ1RjJcNBw@mail.gmail.com>
In-Reply-To: <CACKFLinDN+cOEBfm9wnoXU-iDDtZZpCu+NPMHs9aCQ1RjJcNBw@mail.gmail.com>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Mon, 24 Jun 2019 21:17:27 -0700
Message-ID: <CAF2d9jgBSdGh0C2PLpigzVv90EqF+swod0pReQhgvt9Jw8VsTA@mail.gmail.com>
Subject: Re: [PATCH next 0/3] blackhole device to invalidate dst
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Daniel Axtens <dja@axtens.net>,
        Mahesh Bandewar <mahesh@bandewar.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 9:00 PM Michael Chan <michael.chan@broadcom.com> wrote:
>
> On Fri, Jun 21, 2019 at 5:45 PM Mahesh Bandewar <maheshb@google.com> wrote:
>
> > Well, I'm not a TCP expert and though we have experienced
> > these corner cases in our environment, I could not reproduce
> > this case reliably in my test setup to try this fix myself.
> > However, Michael Chan <michael.chan@broadcom.com> had a setup
> > where these fixes helped him mitigate the issue and not cause
> > the crash.
> >
>
> I will ask the lab to test these patches tomorrow.  Thanks.
Thank you Michael.
