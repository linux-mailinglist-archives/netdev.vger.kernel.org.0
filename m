Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F085B23A858
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 16:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgHCOZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 10:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbgHCOZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 10:25:03 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A506C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 07:25:03 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id b30so20555444lfj.12
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 07:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MX4viYZ/xKq9Ghudfj7kZZkIQ8770iwEU2sLuiQmkPw=;
        b=koHh/I9DCNEHtONo1J5uW0wMj02taHdVeP1W0K3H4rp2DNLATEFUNo9Vdup31gA9QL
         /ibA7d4V1asZyBgbkjmfOdMu/Yi+VtA0NPCR4bxRjhALKhEkWhbv4bJHWjNFcYDzkIhj
         shZJf0ZVbv7M40CXuM9F8UlQb9f+dnMpm3Q8oQIKMBleHybwAAHF1l6CfPlyfcA/GUIY
         HzR3p3tTYDShTZRmzvRQj/vGh9wRSghzGAojR0USQIkAMxkoicNvfT69uYU+FsSRmgZP
         /ClLT465Asko0Ua/3uM+frCQXxemtMYzzD6BUUWt06zfo7eAKaVgoGWNaxKL+DpmuIHw
         glbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MX4viYZ/xKq9Ghudfj7kZZkIQ8770iwEU2sLuiQmkPw=;
        b=SGV6wMpP1FeBDJVJFP3ji+T8nWybJFEOxVTLiLrlQyo74/XJBVOVCg1PuFEWT/pFDS
         GmmaIjnuCWrLy3bKoVgF/XLHhtv7eMWYd+cwwyXrk095KqRnazzNe8dslJeYCRFCcbYr
         ni03zSRoxG4KZZS7e17juH0mIk804/7dzCI6qnr36j20D8ew/irOCGOxWbW90PHkHKWK
         CFLFZnntFNPWvzS2FoFf99Z8HwW4ZQXhJdIxdAO5qoxtSnDe0NdhMrZANqo9lXGps98U
         KNl3ix1ueAx/dTKHHy/yCJuLJ8GTC/cbQJznNu5kx3sTVPqzWEHPgW/B1s65B20Jwcp9
         Cggg==
X-Gm-Message-State: AOAM532AWykWYUSTsNoXJDlyUBxfyQXtexyhHTb1gMizr9/0kFwNlX8+
        QkPtWsDikqFUuAbzcPSJjFsNDyd4DsD+bh6qvKW8lg==
X-Google-Smtp-Source: ABdhPJzg7+MYyjoQqb7QIxMRDAfM5K/C8NXsHxaRM8h5Wu17ieAlqntyZSjGMeM1zJCXnVIwaIpx2kjtF3SrEsItGSE=
X-Received: by 2002:ac2:488a:: with SMTP id x10mr8757933lfc.85.1596464701778;
 Mon, 03 Aug 2020 07:25:01 -0700 (PDT)
MIME-Version: 1.0
References: <CANXY5y+iuzMg+4UdkPJW_Efun30KAPL1+h2S7HeSPp4zOrVC7g@mail.gmail.com>
 <c508eeba-c62d-e4d9-98e2-333c76c90161@gmail.com>
In-Reply-To: <c508eeba-c62d-e4d9-98e2-333c76c90161@gmail.com>
From:   mastertheknife <mastertheknife@gmail.com>
Date:   Mon, 3 Aug 2020 17:24:50 +0300
Message-ID: <CANXY5y+gfZuGvv+pjzDOLS8Jp8ZUFpAmNw7k53O6cDuyB1PCnw@mail.gmail.com>
Subject: Re: PMTUD broken inside network namespace with multipath routing
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

In this case, both paths are in the same layer2 network, there is no
symmetric multi-path routing.
If original message takes path 1, ICMP response will come from path 1
If original message takes path 2, ICMP response will come from path 2
Also, It works fine outside of LXC.


Thank you,
Kfir

On Mon, Aug 3, 2020 at 4:32 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 8/3/20 5:14 AM, mastertheknife wrote:
> > What seems to be happening, is that when multipath routing is used
> > inside LXC (or any network namespace), the kernel doesn't generate a
> > routing exception to force the lower MTU.
> > I believe this is a bug inside the kernel.
> >
>
> Known problem. Original message can take path 1 and ICMP message can
> path 2. The exception is then created on the wrong path.
