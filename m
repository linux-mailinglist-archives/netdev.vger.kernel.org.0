Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD4F37810C
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 21:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfG1TY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 15:24:27 -0400
Received: from mail-lf1-f52.google.com ([209.85.167.52]:40533 "EHLO
        mail-lf1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbfG1TY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 15:24:27 -0400
Received: by mail-lf1-f52.google.com with SMTP id b17so40528685lff.7;
        Sun, 28 Jul 2019 12:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m1bkao4L2HOCuabkoSA/X13Y3hjpAfMVV+naV5LffF4=;
        b=hx9jfQ9tM4cYnm1aIPDcrP2APz/emt/55jeszuJPdT/X0kPcaARRTWHB9ppUOlTpxs
         hNLJCB9fk/nNXni/kM65Jm5dZv3zYIOexiw2u7X1eVIkQ75m8bPdlGKRLi5viMZZqIJ0
         vtgLcYmUnv7/rLNevKast1AP29CqKzeK0vrb3kDNSv9xzgI7EcUKYnkuuqiC3m7srMdk
         uNpUwqNfA8u11nMzp0OWIGywKBOuo/cqmgB5idPlv1plYXtpehntTGSWiiswCTTTpxuH
         BIKn+T3OOFRLTZADaxRNZBR2hXsAe3iVoJUSPKzAZPRccES7iRWPexlg5Woy9Sh4gH+g
         0dfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m1bkao4L2HOCuabkoSA/X13Y3hjpAfMVV+naV5LffF4=;
        b=A1F6Yw2muSOXIIRoukMqu0/3P/fAlNQFjeF0qNqfC0ZKJbZhFcIbrKD4oDOepaIv/J
         wHtswae8lXgRQpn1IFojA0vKnL7x1sm2oKCGidGS6U+6xZpjXMQvXNFPLX3gsUaoaHmZ
         1nlcBbEcivCLZDDgxHSJ0dEyuGWEp/jrmGQZIDmkowgQ2jC/MzASrynpHaKujHGmMWIK
         n186s4jD1tevKnb2LvJx61WYpitOt7YiA49Vqm0STsu5gbukag2lQYjWnit7mxn0INOa
         tLp6OdNfedUoAnmsy26X2Y21XB67Zl3OJYuYABDlgzI0Hm4kGsD/im9wGdirLSxbK+Ic
         uxcw==
X-Gm-Message-State: APjAAAVsLA47Fbfj4MluNRy4C6T0TmDZmvHwyM6dRrwcpBWoDw2ng7RV
        nrpJQLpbc9RX9akW8K03ozDeIJ1ypTtR0H5E1nU=
X-Google-Smtp-Source: APXvYqwHSJGB6dXPgpl27UZrPHyZ7vIJtR4DxjPwhPr1lUpR3kClZ12N0XpBJpWTiosLdhMtjUn4AZxPu7op7veybBM=
X-Received: by 2002:ac2:5337:: with SMTP id f23mr50595546lfh.15.1564341865219;
 Sun, 28 Jul 2019 12:24:25 -0700 (PDT)
MIME-Version: 1.0
References: <2e9f33c9-b772-396e-1e70-2e2d5027cac5@iogearbox.net>
 <5f1e881b-7094-a6d9-5d7c-f391d128780d@iogearbox.net> <CAADnVQJ0ATngyqo8xjXdDsyFuuov3KRtbHMR1LcV8VnEDUK8Fg@mail.gmail.com>
In-Reply-To: <CAADnVQJ0ATngyqo8xjXdDsyFuuov3KRtbHMR1LcV8VnEDUK8Fg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 28 Jul 2019 12:24:13 -0700
Message-ID: <CAADnVQKsvEaQhJBZ7mjds+8092=bhtK52LyYt7cE0WmQjp7qNw@mail.gmail.com>
Subject: Linux Plumbers BPF micro-conference CFP (reminder)
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Folks,

August 2nd deadline to submit a proposal for BPF uconf
is quickly approaching.
If you're attending LPC in Lisbon and interested
in awesome BPF uconf you need to submit a proposal.

Some of you already submitted them to lpc-bpf@vger
per instructions that were sent back on July 12.
Some proposals were sent via website.
We'd like all proposals to be seen in the website.
Could you please re-enter your proposal there?
Please go to:
https://www.linuxplumbersconf.org/event/4/abstracts/
click on 'submit new proposal'
and copy-paste what you've already sent to lpc-bpf@vger.
Much appreciate it and sorry for confusion.

There is still room for few new proposals,
but space is getting very limited.
Please don't delay.

Thanks!

> ---------- Forwarded message ---------
> From: Daniel Borkmann <daniel@iogearbox.net>
> Date: Fri, Jul 12, 2019 at 7:26 AM
> Subject: Linux Plumbers BPF micro-conference CFP (reminder)
> To: <bpf@vger.kernel.org>
> Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
> <xdp-newbies@vger.kernel.org>, <iovisor-dev@lists.iovisor.org>,
> <lpc-bpf@vger.kernel.org>, <alexei.starovoitov@gmail.com>
>
>
> This is a call for proposals for the BPF micro-conference at this
> years' Linux Plumbers Conference (LPC) 2019 which will be held in
> Lisbon, Portugal for September 9-11.
>
> The goal of the BPF micro-conference is to bring BPF developers
> together to discuss topics around Linux kernel work related to
> the BPF core infrastructure as well as its many subsystems under
> tracing, networking, security, and BPF user space tooling (LLVM,
> libbpf, bpftool and many others).
>
> The format of the micro-conference has a main focus on discussion,
> therefore each accepted topic will provide a short 1-2 slide
> introduction with subsequent discussion for the rest of the given
> time slot.
>
> The BPF micro-conference is a community-driven event and open to
> all LPC attendees, there is no additional registration required.
>
> Please submit your discussion proposals to the LPC BPF micro-conference
> organizers at:
>
>         lpc-bpf@vger.kernel.org
>
> Proposals must be submitted until August 2nd, and submitters will
> be notified of acceptance at latest by August 9. (Please note that
> proposals must not be sent as html mail as they are otherwise dropped
> by vger.)
>
> The format of the submission and many other details can be found at:
>
>         http://vger.kernel.org/lpc-bpf.html
>
> Looking forward to seeing you all in Lisbon in September!
