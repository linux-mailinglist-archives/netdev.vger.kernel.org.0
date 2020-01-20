Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF760142268
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 05:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbgATEpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 23:45:08 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:32871 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729043AbgATEpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 23:45:08 -0500
Received: by mail-lf1-f65.google.com with SMTP id n25so22942381lfl.0;
        Sun, 19 Jan 2020 20:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v4gNUzx14wi5Q2LGqxGckShRs7K+FGBFyHDqioJzbu8=;
        b=kgvrbGR1TUzou0oyefZ/ZcSEKByOLic6u1/cL11Fsc+t6eVsyHyfzVSgRk1Jtw9xTF
         41gdc+Q8Eug+UpY9hY4Yi9NO8qIDT5yFWFk7YwsaC3g5KWV9tdF+1ZGYl4lFzsch7C6r
         zItDsoDiVguX+nRP23Bvjsr3xwLhGf6yDjea1pgGoarfLA0xLeyU3APZMSb8OzdADhQ1
         p2k+Q6b7FJ4+OaMTwz8gq8rzDauLSafXUDgn87jXwVLZbEgbm7dLTKchwIyiSw7PsXQl
         2ERieycrccayKPn6RFTAEGK81HPdotwjDXFVNTVjVzetRZFe/ndJ1HfQvVidbU+YCnLf
         MKXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v4gNUzx14wi5Q2LGqxGckShRs7K+FGBFyHDqioJzbu8=;
        b=gmJYAdoNMlfW38ROR7arodwGHjwvK3rTaQtavbb1zUCvuPEDdAfiybIh+RfHZqWzCX
         Q95MpHegapVj6bq9EGSPsCesEquHFCoPlJvmc1NcVHlIeI2jg8rak0kErebhiq1k4XYZ
         6fLzDDb2G2JoygxZnEd1J5ypdBDcQS/rAYLzz4bxaIyRMhe3Gc1uC33kW73Qd5XQDbJl
         g1KmyZp5ARsxdEOId28BaH9yb4DHr1y4dnsy7sjIotm/iMnlJKq/ysmdBZkqDu/jg+Af
         kEgr+/NravCU3aGzoESIg3tSJ/J4mKnnN65Tc9n1HLC7FJvbhoZK9ZUgQakegNi+9kdl
         GkNA==
X-Gm-Message-State: APjAAAUC+hyuV2RV1+LeRFN8aGoe72OX0VQ4fgM22p8QgFAK/F3NcVOj
        rjyanawnFRFRMSVon2qvGSeToQoTlSQYD2ohfBGJDF7q
X-Google-Smtp-Source: APXvYqw2yRksWZ+WJFnHMGInLgk7eBdsHBiSS9/DcGZk4AWnUQgqGdvhA8tOYHcJPcS/cFwuMq4OsOg4bWLsZ+qY6E8=
X-Received: by 2002:a19:6d13:: with SMTP id i19mr12034062lfc.6.1579495505859;
 Sun, 19 Jan 2020 20:45:05 -0800 (PST)
MIME-Version: 1.0
References: <20200120032639.2963-1-xiaofeng.yan2012@gmail.com>
In-Reply-To: <20200120032639.2963-1-xiaofeng.yan2012@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Mon, 20 Jan 2020 13:44:56 +0900
Message-ID: <CAMArcTW6YXKjDnxq4bgqQM6aL=ZZ2u+SNVs+NXoA-HSLxaq16g@mail.gmail.com>
Subject: Re: [PATCH] hsr: Fix a compilation error
To:     "xiaofeng.yan" <xiaofeng.yan2012@gmail.com>
Cc:     arvid.brodin@alten.se, David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, yanxiaofeng7@jd.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Jan 2020 at 12:26, xiaofeng.yan <xiaofeng.yan2012@gmail.com> wrote:
>
> From: "xiaofeng.yan" <yanxiaofeng7@jd.com>
>

Hi Xiaofeng,

> A compliation error happen when building branch 5.5-rc7
>
> In file included from net/hsr/hsr_main.c:12:0:
> net/hsr/hsr_main.h:194:20: error: two or more data types in declaration specifiers
>  static inline void void hsr_debugfs_rename(struct net_device *dev)
>
> So Removed one void.
>
> Signed-off-by: xiaofeng.yan <yanxiaofeng7@jd.com>

Acked-by: Taehee Yoo <ap420073@gmail.com>

I think the Fixes tag is needed.
You might have to send a v2 patch, which includes this Fixes tag.
Fixes: 4c2d5e33dcd3 ("hsr: rename debugfs file when interface name is changed")

Thank you!
Taehee Yoo
