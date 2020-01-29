Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8D1514C3D3
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 01:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgA2AJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 19:09:45 -0500
Received: from mail-lj1-f179.google.com ([209.85.208.179]:33629 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgA2AJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 19:09:45 -0500
Received: by mail-lj1-f179.google.com with SMTP id y6so16635399lji.0
        for <netdev@vger.kernel.org>; Tue, 28 Jan 2020 16:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QduTAavzxiCRJ3QIrVZTV+4VX4RWH7qT0xGsTNvmhOM=;
        b=MyJxWp5i/mvvugkr2t/2O1kBCqxCjKJf55Bh7Ms1DfgVlHegYxAFbvwASxZeNaGCG0
         6Soyn6YDYMUTXaVYZ+WGdlgyh7Do3v1dXFNLHaM+aQtb/HFCMKjYUbs0eomPNz7wMGFu
         7xK7/MiRyzKPclywKYT8cIr/OVWye3i61r9EM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QduTAavzxiCRJ3QIrVZTV+4VX4RWH7qT0xGsTNvmhOM=;
        b=BlUF/UVT+giSa4ImunxSRT5T/pbbJwPRcFDpMg5WCvYk61Ws/j4XTiSFpwlIKoyDqb
         yU0yAq5l7yRQ6Tk/8ZqNOQHKH+ju/DzMrsGu8+Xu+FTCpWrP3KD9Uwq5vaB6HIBiwyq7
         U4Kth+ZT38IfJZJltRp33Lr4/zsWm9y2qLmDGUAV5PHNiJE0Zp/5YegZMrrNrN2u8YO0
         VENkp51aoj3zdjwuS71aV3auMT4dx62W+FQNXGwWBpbkWi57QcUhjBEyOkAymzitAN/5
         Cw8+3Kd3Y0nOFsb4pS7pqm4mIeB9ya5XBj99JHrWFSK2jYYh4O42vv004sZO99B8NtSm
         58HA==
X-Gm-Message-State: APjAAAUy32DCLiydmJFiO4WnP+x6rjydCXr2w1Ma1MlETdus7MupuIKR
        JPL8F35qjoiurFegCmD9vFtiVQdzk3s=
X-Google-Smtp-Source: APXvYqwOq+FNpZfger09FrzLOwN3UBhddWu6y/Zvu+UzWYVzGpWZp0WACGGPlU+6Bk14pSakBxC3Bw==
X-Received: by 2002:a05:651c:1032:: with SMTP id w18mr14445051ljm.61.1580256583016;
        Tue, 28 Jan 2020 16:09:43 -0800 (PST)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id t1sm47575lji.98.2020.01.28.16.09.41
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2020 16:09:42 -0800 (PST)
Received: by mail-lj1-f177.google.com with SMTP id f25so3697256ljg.12
        for <netdev@vger.kernel.org>; Tue, 28 Jan 2020 16:09:41 -0800 (PST)
X-Received: by 2002:a2e:88c5:: with SMTP id a5mr14969687ljk.201.1580256581346;
 Tue, 28 Jan 2020 16:09:41 -0800 (PST)
MIME-Version: 1.0
References: <20200128.172544.1405211638887784147.davem@davemloft.net>
In-Reply-To: <20200128.172544.1405211638887784147.davem@davemloft.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 28 Jan 2020 16:09:25 -0800
X-Gmail-Original-Message-ID: <CAHk-=whKJ2Zae4xqk3op9aoB_PVEfwTKQ1iAxnoEY2K6C0SPcQ@mail.gmail.com>
Message-ID: <CAHk-=whKJ2Zae4xqk3op9aoB_PVEfwTKQ1iAxnoEY2K6C0SPcQ@mail.gmail.com>
Subject: Re: [GIT] Networking
To:     David Miller <davem@davemloft.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 28, 2020 at 8:26 AM David Miller <davem@davemloft.net> wrote:
>
> 1) Add WireGuard

W00t!

             Linus
