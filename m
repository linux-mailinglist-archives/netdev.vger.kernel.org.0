Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0866D2AB
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 19:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbfGRRVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 13:21:49 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:43286 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727767AbfGRRVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 13:21:49 -0400
Received: by mail-oi1-f193.google.com with SMTP id w79so22135288oif.10;
        Thu, 18 Jul 2019 10:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L4xEEafUuGBe6hx3t7d821dwtUG1l9ImyXUv9qYk2Ss=;
        b=ZsfsfHCSf3i+mwhVBEmzhrcQJTiitHSv+MKimXAYflGNGUTxt3jAo9tZucMW8UofUq
         Tcxrf+GMpEoXb7eDZGKpSPjihT4/IfVl1Ws8PKPnBJ/7StcR71EK/Q8s6ZgvUAAoT5aY
         INX4bfqtthOpRRQNgiR2N41UVcJRArsTGa9l9reCniJ7Ssig5hxv7wCoHcfZximuHzVa
         wAruWHuvQdCYFEi5UF6SWUKCjUCdsPiga024ubiAkas8MLrO8u006TvxMrcxf58ecT6K
         +xQiLcpqTZ+VUg3hSXfK9+rFctSGMmqmdjYl1ZXsIL5m4qWa1X2eY0cffuJODNKv5F7A
         9f7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L4xEEafUuGBe6hx3t7d821dwtUG1l9ImyXUv9qYk2Ss=;
        b=JXyz+OtGhk11UWNi6wjpKr09nFtpUhbe7eBsqxyNaIZDHb/IwMcAwJwOXwIopIgqR5
         rejUACOwfsYRrEkPv0aqbczcTTbNE4fgyFwbIsYitb1LssUIzVUvq+j465aI8LC6qlJi
         1s0AS04PN/WCv+Ik3NszO0rYLZ/xf+haIdTZM7QPp43H2ds4fhymqLXNSCkkg1mP4dyQ
         yMQGk7ijQmnlDkO29+fN06VH2J0d93tQP3Zh7TZVGmmVqYZbRhW/puBTwGKCn1aksUcW
         SuGSL5l9YHpV33uPnGLuonb9WVBvSXbRI9B/0ugsbmLE3SmNKhsGR4cPm1Hxwc3HB5+Y
         4rBQ==
X-Gm-Message-State: APjAAAXuCPfmzxOjed5kaD70ORbOJcqd+8FpMpjVpMNg4mNaSv8YBrt0
        MC3uOr1IdtXpDNsvxZ2+xK5wUmsXguExFk+4yB4=
X-Google-Smtp-Source: APXvYqx8yHNmd34Tn8Qfltgd4N1CQDo//l3fFsuwKMic15rbi2JgmGvI7rPQg+0ZftCBtdf8n0R/0uySK48/KlcCtug=
X-Received: by 2002:aca:e106:: with SMTP id y6mr23447043oig.77.1563470507901;
 Thu, 18 Jul 2019 10:21:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190718143428.2392-1-TheSven73@gmail.com> <1563468471.2676.36.camel@pengutronix.de>
 <CAOMZO5A_BuWMr1n_fFv4veyaXdcfjxO+9nFAgGfCrmAhNmzV5g@mail.gmail.com>
In-Reply-To: <CAOMZO5A_BuWMr1n_fFv4veyaXdcfjxO+9nFAgGfCrmAhNmzV5g@mail.gmail.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Thu, 18 Jul 2019 13:21:36 -0400
Message-ID: <CAGngYiULAjXwwxmUyHxEXhv1WzSeE_wE3idOLSnD5eEaZg3xDw@mail.gmail.com>
Subject: Re: [PATCH] net: fec: generate warning when using deprecated phy reset
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lucas, Fabio,

On Thu, Jul 18, 2019 at 12:52 PM Fabio Estevam <festevam@gmail.com> wrote:
>
> > Not really a fan of this. This will cause existing DTs, which are
> > provided by the firmware in an ideal world and may not change at the
> > same rate as the kernel, to generate a warning with new kernels. Not
> > really helpful from the user experience point of view.
>
> I agree. I don't think this warning is useful.

Few users watch the dmesg log, But I totally see your point.

The problem I'm trying to address here is this: when I want to
reset the fec phy, I go look at existing devicetrees. Nearly
all of them use phy-reset-gpios, so that's what I'll use. But,
when I try to upstream the patch, the maintainer will tell me:
"no, that is deprecated, use this other method".

Is there a good solution you can think of which would point
the unwary developer to the correct phy reset method?

See my previous thread here:
https://lkml.org/lkml/2019/7/15/1764
