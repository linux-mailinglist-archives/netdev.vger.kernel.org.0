Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D94EDF4E3
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 20:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbfJUSKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 14:10:43 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46874 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbfJUSKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 14:10:43 -0400
Received: by mail-lj1-f193.google.com with SMTP id d1so14316949ljl.13
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 11:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nR2LxSHck9ZqQD2zhto73lESdyPHZ6hoSmYt89NXolo=;
        b=QR9U0/pZ+b93DioOVYgQhbOSswPd2nYpt1ud14bK1x3x4HXBGvG38UUzbfk2UAaONl
         OcSoig/0EWQsy6AwqZkUTug9fvxFqVQQVCcTwpkwnTIPEUi/72TE7avRZUlmrNBEUBhn
         qihPewuGVlehtph0uPM93LVCofFeHxrDWFdiFpTDmV22SRaEsdTDTb82lcWSkmDlH223
         RCR49wE/GfeaxzYM+xjFQ7j9YC5jK27mK135mRyKKJAcbtcauajkIpQpBeSHTQEbvnR0
         khMDYO2qyyugsPNRoZdabTIqcsqGYU4Diczwjop5g9342Ih85f84gIV+h1GySLuKzycQ
         X+cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nR2LxSHck9ZqQD2zhto73lESdyPHZ6hoSmYt89NXolo=;
        b=I9sE5qbMQ9Tc2bpDeESce1QSDnGLYU5d+4MmfRhli3tKFG5Y+dLUdD/toE8qUfSs3N
         cy4CTSO8w4sEfXJCpHev8uFnOAcEUux+fWfhHYuPnqgcyxbLZFoUYrV1m5gqYrOJwm2v
         0ckvzj9VntAlEQU7bPo9t05WuxmqUL/yLd8Ve53KREbGtpdsqrUwz2xbvLVw2OBkBRpt
         4jS581mNGWMrlRsT8BAqYIDfR6kSNm5Y0CjBd6dUUGp0hnKjaV9q3xhtG+5kxxwHn5ur
         DZuoiRhXQm7aeivI9xURdwcdu9G2m7NrT0VMlZS/1cBVthOh3W4fC0xh+FLPCj6ccizi
         wXIg==
X-Gm-Message-State: APjAAAW236bWAWanPsm7Dcz09K7WzOMnVPPqvHSKawxa/ZBr8dazSxWH
        32spO92FzV2LuJuQKEKN9PeYvecEaSYrQnW2S30=
X-Google-Smtp-Source: APXvYqxZTVGCz8VB9CCaeyPopiuIL7+X8FFY5AinVrWGN5jLhXqwY3k5bmFLe9zSk03VjAwB9lww6+zfM1jCcyVc+2o=
X-Received: by 2002:a2e:85c1:: with SMTP id h1mr16031802ljj.169.1571681439954;
 Mon, 21 Oct 2019 11:10:39 -0700 (PDT)
MIME-Version: 1.0
References: <68ad6fb82c0edfb788c7ce1a3bdc851b@codeaurora.org>
 <d09e2d5d-ccad-5add-59c5-a0d2058644e3@gmail.com> <8cbba50ce2e3ea12cd78277b3dc2d162@codeaurora.org>
In-Reply-To: <8cbba50ce2e3ea12cd78277b3dc2d162@codeaurora.org>
From:   Josh Hunt <joshhunt00@gmail.com>
Date:   Mon, 21 Oct 2019 11:10:28 -0700
Message-ID: <CAKA=qzaPA8+O5RBVgB9jcdeWfgDRe68JXmB37Wdi0+v5QCXv9w@mail.gmail.com>
Subject: Re: Crash when receiving FIN-ACK in TCP_FIN_WAIT1 state
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>, hcaldwel@akamai.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 10:42 AM Subash Abhinov Kasiviswanathan
<subashab@codeaurora.org> wrote:
>
> > Please give us a pointer to the exact git tree and sha1.
> >
> > I do not analyze TCP stack problems without an exact starting point,
> > or at least a crystal ball, which I do not have.
>
> Hi Eric
>
> We are at this commit - Merge 4.19.75 into android-4.19-q.
>
> https://android.googlesource.com/kernel/common/+/cfe571e421ab873403a8f75413e04ecf5bf7e393
>
> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> a Linux Foundation Collaborative Project

We were investigating a problem in this area a few months back (it
turned out to be something else), but were wondering if retrans_out,
lost_out, and sacked_out should be cleared in tcp_rtx_queue_purge()? I
meant to get back to it, but it got buried and this just thread jogged
my memory...

-- 
Josh
