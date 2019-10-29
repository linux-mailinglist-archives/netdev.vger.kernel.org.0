Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 848B0E7F70
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 06:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbfJ2FJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 01:09:20 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34242 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfJ2FJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 01:09:20 -0400
Received: by mail-lf1-f66.google.com with SMTP id f5so9524396lfp.1;
        Mon, 28 Oct 2019 22:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fu23a2LiYeTVsc9FCtPm8Q6gbyK53FnRd2mwyu6MHEA=;
        b=p86UAwzTfWSV5qnbeDVwySXbkLwyZFQhpyCnw+CDA3b4IYxyZgIkkMgii79VmGBQ+L
         cg0XnHnLVD7AHbKWYp48dfJNtG3x8DcJqbWTt/uH4uKFqccJPRpYxCGXiIbqE1Qvdu9j
         xLyUC38Z0xMQ1Y9NG3zJzhSlLs9a9sq0vxgD03V4DKtut/LQK9wzwj2Wa2tBmFyKdugr
         IiyEJ0n2sPAL7K0MRR/W5fSc8Sg9dogdkAfdHBjBgpxkX9zFBnl86qmBIYoSh+rB5LMy
         MED1mbdV3FQzID66LwoPVLZMkkoebDAuqiOR4N9EJHBSlHV9Rn7w0JhxSnSYLw0LUyYT
         mvOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fu23a2LiYeTVsc9FCtPm8Q6gbyK53FnRd2mwyu6MHEA=;
        b=bDrStdp/75KHURBEHFJycSWBGI9DkybUjRw7sNeGA9niW6pLE+rGCBqFA8pxnQrAw8
         kxt4Rsvhu7dzDc/FmcEN/Rwmn6aTsQb7EsLwcRxBwQ/yTXBeIaLAzKMTfe5mb4Y8N+2m
         Cr6jPFQdUrrtfctaoU4gxvOV+SuluFw2ru30iQjCCNepwr4OdraXBnd0I554315fEGuU
         8FXKhg7t5IedoUU/QphSmvxtArSoG0Ji4s04GBFpLQoDJycYSdNjmN5sEjSIGjJooTy4
         zt78fOLiKzwzPNBJoXtPKO7PbIFtBegaE7WvZz5FzB/RZerxSso6iVPZFlXEJxd1aqtD
         LKNw==
X-Gm-Message-State: APjAAAXj/E4zSpz8xY/MHee9bPY4JnZHOeYGSMgNEL6hZkp1f/RXfdka
        RQwTXNbI4CYtiU5e+o3yvDirQRkrW80Wbp6S6LQ=
X-Google-Smtp-Source: APXvYqxKxrrM1VocolZa2pPapP0O3kvBAS6ElTmJAPv16Ov2Pd9v0w72m+FKAySdpT86pdN395XdxsAt36cBi0NJ4WE=
X-Received: by 2002:a05:6512:146:: with SMTP id m6mr827514lfo.98.1572325758469;
 Mon, 28 Oct 2019 22:09:18 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000044a7f0595fbaf2c@google.com> <000000000000929f990596024a82@google.com>
 <20191028.212449.1389218373993746531.davem@davemloft.net>
In-Reply-To: <20191028.212449.1389218373993746531.davem@davemloft.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Tue, 29 Oct 2019 14:09:07 +0900
Message-ID: <CAMArcTUMcWm4McPGTDK9+Cf5jUKbzSRaio4BA1vs1nhugfsQ1w@mail.gmail.com>
Subject: Re: INFO: trying to register non-static key in bond_3ad_update_ad_actor_settings
To:     David Miller <davem@davemloft.net>
Cc:     syzbot+8da67f407bcba2c72e6e@syzkaller.appspotmail.com,
        Andy Gospodarek <andy@greyhouse.net>, j.vosburgh@gmail.com,
        linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com, vfalico@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Oct 2019 at 13:24, David Miller <davem@davemloft.net> wrote:
>

Hi David,

> From: syzbot <syzbot+8da67f407bcba2c72e6e@syzkaller.appspotmail.com>
> Date: Mon, 28 Oct 2019 18:11:08 -0700
>
> > syzbot has found a reproducer for the following crash on:
> >
> > HEAD commit:    60c1769a Add linux-next specific files for 20191028
> > git tree:       linux-next
> > console output:
> > https://syzkaller.appspot.com/x/log.txt?x=154d4374e00000
> > kernel config:
> > https://syzkaller.appspot.com/x/.config?x=cb86688f30db053d
> > dashboard link:
> > https://syzkaller.appspot.com/bug?extid=8da67f407bcba2c72e6e
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro: https://syzkaller.appspot.com/x/repro.syz?x=14d43a04e00000
> > C reproducer: https://syzkaller.appspot.com/x/repro.c?x=16be3b9ce00000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the
> > commit:
> > Reported-by: syzbot+8da67f407bcba2c72e6e@syzkaller.appspotmail.com
>
> This might be because of the lockdep depth changes.
>
> Taehee, please take a look.
>

Thank you for forwarding this,
I will take a look at this issue.

Thank you
Taehee Yoo

> Thanks.
