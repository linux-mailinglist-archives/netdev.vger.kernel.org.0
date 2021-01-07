Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36122EE8E2
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 23:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbhAGWjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 17:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbhAGWjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 17:39:21 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CA2C0612F4;
        Thu,  7 Jan 2021 14:38:40 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id q1so8337856ilt.6;
        Thu, 07 Jan 2021 14:38:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g76BqINnxfL5FktF2QZPjibz0wQRs+oejPYTd9O0uKI=;
        b=oCDs9QSR09VDsaZxasV5ZQi3feqOMiay04zU8pdNYdCFf9UQ3bXtae5goNoXq+H79S
         9GX4wP0lzIV3a81xA5ahyspC8OfQBvO/o3BOTjbGYo7EURoxuWP+HPEbRv5k73A8Hwls
         boPONDhhfYiUKxkbXZg9xWkxt8cdzzutJue3mRcXPkdjF0Cs0fpRw1gzohQi4JPanUnL
         euOZRWKUkQtdllxLom0yLdW8agEQyv10EfdFWxxPPVhkV1VaYoC/NjwmXjFI18nEeQU4
         9cCECb8UZDYhNeM3PKS7mZnz2xmUXjCuo5+Q3qufBUAYoSS0dO2b3/+7qDXPOJpX9q6j
         54YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g76BqINnxfL5FktF2QZPjibz0wQRs+oejPYTd9O0uKI=;
        b=ne3S/20a2ov5E8ltAX5JEinf0Yu8m6AYE9x3ydY5shQ5+XpdX+HzVt5LLDss/ngSs8
         QZEs41aeJmSAELja+NDctpdbYj7zjwIF/xT8oaBvtmZzH9HTY+YQ5Dcm9Byxx/w1ltEI
         XioZ3KSIcMGa3exrrClzGJSKARGtwBvOwIbdyyet1daW9mWkpv+ZSccDYNre6tnzfhLG
         iPTJrbmdDcqVYoyOIlwQJUa9S9o3Y2KCIeo5KAH232RXlOiDAFVSRqI1G2ALsI4e2CNF
         wsU1qVyi1H2qihaksE9YRAajJzjulv5MojiHzOd9YKN+YVdJE+QCB8WaCCjqgaEwAy4T
         1SHA==
X-Gm-Message-State: AOAM5307FbUY0ojQfmBHGUJLVb8igbwZHFZoEgdGbpL2BUyFrYRQvi8R
        OrEqCMF4E8FfVodaNXMJp+sDKaWMPtlUalEGMcs=
X-Google-Smtp-Source: ABdhPJz0cRe54eom0Jm6xNfSZA5zFZAyntyHcTcizOiimzwsJKHfdTZsaPDfqiTdjQJaKIaGWjdkMae4vy9yadvIs7k=
X-Received: by 2002:a92:8419:: with SMTP id l25mr1046154ild.100.1610059119870;
 Thu, 07 Jan 2021 14:38:39 -0800 (PST)
MIME-Version: 1.0
References: <20201228094507.32141-1-bongsu.jeon@samsung.com>
 <20201228131657.562606a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACwDmQCVkxa6u0ZuS4Zn=9JvOXoOE8-v1ZSESO-TaS9yHc7A8A@mail.gmail.com>
 <20210104114842.2eccef83@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACwDmQCTj1T+25XBx8=3z=NmCtBSeHxHbUykA6r9_MwNJmJOQQ@mail.gmail.com> <20210106090112.04ebf38f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210106090112.04ebf38f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
Date:   Fri, 8 Jan 2021 07:38:29 +0900
Message-ID: <CACwDmQAKky89hBzmOR0FOy=B0HQ8-APj0MEKBFwUHtnTSWXh_w@mail.gmail.com>
Subject: Re: [PATCH net-next] nfc: Add a virtual nci device driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 7, 2021 at 2:01 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 6 Jan 2021 08:16:47 +0900 Bongsu Jeon wrote:
> > On Tue, Jan 5, 2021 at 4:48 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > thank you for your answer.
> > > > I think that neard(NFC deamon) is necessary to test the NCI subsystem
> > > > meaningfully.
> > > > The NCI virtual device in user space can communicate with neard
> > > > through this driver.
> > > > Is it enough to make NCI virtual device at tools/nfc for some test?
> > >
> > > I'm not sure if I understand. Are you asking if it's okay for the test
> > > or have a dependency on neard?
> >
> > Sorry for confusing you.
> > There is no dependency between neard and a NCI virtual device.
> > But, To test the NCI module, it is necessary to make an application like neard.
> > Is it okay to just make a NCI virtual device as a tool at tools/nfc
> > without the application?
>
> Meaning the device will be created but there will be no test cases in
> the tree?

yes.

>
> What we'd like to see is some form of a test which would exercise the
> NFC-related kernel code on such a device and can signal success /
> failure. It doesn't have to be very complex.
>
> You can build a more complex user space applications and tests
> separately.

okay. I understand it. I will try to make it.
