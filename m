Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34B223194C
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 08:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgG2GFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 02:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbgG2GFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 02:05:52 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D24AC061794;
        Tue, 28 Jul 2020 23:05:50 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id a26so7900844otf.1;
        Tue, 28 Jul 2020 23:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=155Y2WSS72tG/ncO6CfTu7AAxycSUP0sDEk7oKysRWQ=;
        b=EdIn9HGCHAadTqAOhR6DmfzgEOgv5+th+OM5D23I2fdbWeeE3Ek+QJHXB3tKAH1Plv
         6nFYEplWL/aI2Pnkunfo0Wlbl62Kd8jrz8lkNkiSuNhn4tJ/PxhjOBEwr0Ce3wngroL2
         tcSIxdUENeHrG5yLF52wYe3z3ZRX+hYhavCxEFC2dmGJn5BRlk/6Sik9C1/M1PfFqa6o
         I9/lChHR4mmMis6vkEhR0pLDOyF+OKFLU/8icd2CSxAEMAaFwJ1wnA3pyUCHxkpq6r+T
         0vb6hVJAYNLwDuoTGHVGn5tuV8qhRHV9KZlpOqScHmlX2xz3DRigMW27VMXuqIbcs8cs
         NHGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=155Y2WSS72tG/ncO6CfTu7AAxycSUP0sDEk7oKysRWQ=;
        b=drM5dAJ2eD1Yd7vlzSjoTcz7ON3ttPUOlRkMHHRJgEwq2IwxQizr5yewQgEMV24wS6
         M1AioaB887QrOQdD3sKToKypwJVFnSBhTNQlLgUl278WEMKBZfvlWMCcNbC6ontJdUtO
         f9l0F71yQXRvmzZWJp8I44eyuOlETqpQAfNTwvzQprEU/moS5YQvg+KJbdsej/6OHNFw
         GSX9B28rUOUvlxOlrz/1X6huTL5t/9yK8ho++lb4caWvl38wijzBRbPQoYocgfnEsjTu
         zxLwj2EKIWTs/FcoG4n97EW0D/gZByuWl2nJgoS/3aE4Y6HVozLpeKXOE/9sWtCezSrg
         stcw==
X-Gm-Message-State: AOAM533IO2Hw22Uqkg+D9oDb9/SPWL7+Mgdq7j0Sv5F6iBAKeMhWGBTk
        aV8UeBB9SSbwHVfJDXJyIWySH/VJP91INQr8LnoCjnBqGVxY0Q==
X-Google-Smtp-Source: ABdhPJwKvUWGvj+0PNmbhodUFbqPrt41n++j0abnttMdz1LMf2a7SvXkzEwmhcFFMZ1mfLu8i9eImZPLd0tybgkEbHc=
X-Received: by 2002:a05:6830:4c8:: with SMTP id s8mr26585768otd.368.1596002749683;
 Tue, 28 Jul 2020 23:05:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200728182610.2538-1-dhiraj.sharma0024@gmail.com>
 <CAPRy4h2Kzqj449PYPjPFmd7neKLR4TTZY8wq51AWqDrTFEFGJA@mail.gmail.com> <20200729054637.GA437093@kroah.com>
In-Reply-To: <20200729054637.GA437093@kroah.com>
From:   Dhiraj Sharma <dhiraj.sharma0024@gmail.com>
Date:   Wed, 29 Jul 2020 11:35:36 +0530
Message-ID: <CAPRy4h0KcCXJsg3kHurzvDKpL6mkkUAFCxFBsBaex36fOp7Low@mail.gmail.com>
Subject: Re: [PATCH] staging: qlge: qlge_dbg: removed comment repition
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     manishc@marvell.com, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> A: http://en.wikipedia.org/wiki/Top_post
> Q: Were do I find info about this thing called top-posting?
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing in e-mail?
>
> A: No.
> Q: Should I include quotations after my reply?
>
> http://daringfireball.net/2007/07/on_top
>


I will avoid such things and will do useful stuff.

>
> It has been less than 24 hours for a simple comment cleanup patch.
> Please give maintainers time, they deal with thousands of patches a
> week.
>
> Usually, if after 2 weeks, you have not gotten a response, you can
> resend it.
>
> >  I know that I should ask for reviews etc after a week but the change
> > is for my eudyptula task and until it doesn't get merged little
> > penguin will not pass the task for me so please look at it.
>
> If you knew that you should wait for at least a week, and yet you did
> not, that implies that you somehow feel this comment cleanup patch is
> more important than everyone else, which is a bit rude, don't you think?
>
> There are no such things as deadlines when it comes to upstream kernel
> development, sorry.
>

Alright, I will wait and hope it gets accepted before 1st August or
else I have patience.


Thank You
Dhiraj Sharma
