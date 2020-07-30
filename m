Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30F723304D
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 12:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbgG3KY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 06:24:27 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:56595 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgG3KY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 06:24:26 -0400
Received: from mail-qk1-f179.google.com ([209.85.222.179]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MgwBv-1ki5v20u33-00hKLZ for <netdev@vger.kernel.org>; Thu, 30 Jul 2020
 12:24:25 +0200
Received: by mail-qk1-f179.google.com with SMTP id h7so25051233qkk.7
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 03:24:24 -0700 (PDT)
X-Gm-Message-State: AOAM531b4maDAzJHIc/XFPQdw6eTRjYlU/9vqaSp0dhL7cTi7tBiP54q
        rhDerir/u1yRkJDEPRCCa8sqPJ4IOsv0liN7IwY=
X-Google-Smtp-Source: ABdhPJwMBHOO0wGxSWIXQQfZTPVK1KUznk5I3GjhMa/5xHDIa88DzjjBZLP4L2//26g0QTkgWKyWIACLSgYYr9b4nOI=
X-Received: by 2002:a37:9004:: with SMTP id s4mr36804611qkd.286.1596104663212;
 Thu, 30 Jul 2020 03:24:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200730080048.32553-1-kurt@linutronix.de> <20200730080048.32553-6-kurt@linutronix.de>
 <9e18a305-fbb9-f4da-cf73-65a16bdceb12@ti.com> <87ime5ny3e.fsf@kurt>
In-Reply-To: <87ime5ny3e.fsf@kurt>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 30 Jul 2020 12:24:07 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2G7YJqzwrLDnDDO3ZUtNvyBSyun=6NjY3M2KS0Wr1ubg@mail.gmail.com>
Message-ID: <CAK8P3a2G7YJqzwrLDnDDO3ZUtNvyBSyun=6NjY3M2KS0Wr1ubg@mail.gmail.com>
Subject: Re: [PATCH v3 5/9] ethernet: ti: am65-cpts: Use generic helper function
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>,
        Networking <netdev@vger.kernel.org>,
        Petr Machata <petrm@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:Nu/tRjJl+FsuOdStm1+7v3duIp5c7XM+UOKetiC0452gQbV2NoW
 2zhO8jzjiRlX7JOvanJdhYJimb4AVwehv1mRS+0kv4htPEj1/0wBlzakNK+wGzIqot7efoY
 nsaiqJklkvc5RKVHZXvZR1KfClVhmdGd18aZDTxv189A3XngmWBo1wiVLlMBbVPopyhUM5B
 pb58427kHsdn17UfoF/Hg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:rbNXKeTh3hc=:9WZOGrPo4O3Ai2uIxjx0xJ
 lUkdR08HPVVjqnwAlX09crKCEd2WL7lxxHjvyfALOdXLXHPcK9ehfZKoL/0AqnqkScNAwXrw9
 KLZaeBA09nAdP5rCK5b8rcAwtYmdoyAfWasC8wzalGEPnkX5yb4KKTSPJRCQKgR/+XQIBDIxT
 iM36ytEDqyPnN3hndtzKoN9T9zz4WTxo19lrXQ5LSyL+tZ3wS9g1oCzkiMRSJtP70Rss0GpDi
 w9tDc/+dElGGOzGIkADU2dnykbEagy01J0jVLOb3Q5c+jgKiRajws/YAwTOo8y3XyjuYFA6N/
 wsK8FglwU7IBsaLaBDqNO6Ejg16zWadz8NumNhjoh+fOBoZXLJUWNzPuB70MPxt4PgJPKTPn6
 zlfL13mA0lRTSpv0GDZ2ZO7W2G2duBv1qCk/Yoryr0nBHhcBUzYygbRfz9roqV28estrew09w
 Yi+1KSZGNXQ2wybZcKQGxCyBqvo4zDrbITSVqUe4JrPwtjHkF8wErFrAFLqqpT1wKOqdaleWs
 HJ2zpO2woEnQR1RYe3I2RzPJudbhKXjsw9Ba/mKjCi4rQ/B9KMyMvGLQvHMvr2kCoIBvLDqVq
 SzyJBYok23kUaUs6FqU1HG68Htk1XhHYPyUo7qt/ooB/o35DNXYSNP5V5LmhrRarq2ss/S6le
 +TzKjeTWro8vT06K2/mFqn6fSAB/1D5yEiANw1Dn/WC0VrxXr04nXrSv8xbhIpW17o4VCHmAi
 IFKcaHWhaXxizhwxRzZzOxJOOdnsyB4GjCCKdQXuc3PX5Z8lzCmUju5Wo2hZnj6kR6dFT7Q5B
 MJ2XYEzRoZfOU0qXDB1cWNDz30+SDOIVj1zjY4zcIexqU5HfL5ypn5gteUgEQjDBRlkT+LIZL
 VOvxq8j40bkrRMkcG2X/Iif/n5RgwmagZIGyaibFnHtrZueKqp21hAHwyXSJiEvyG68NVm8Bk
 4kCYiVaIdWA3AvGJ7TooZUjCUOdNWj6cbz840qcZ5QBT+M3YUM9dc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 11:41 AM Kurt Kanzenbach <kurt@linutronix.de> wrote:
> On Thu Jul 30 2020, Grygorii Strashko wrote:
> > On 30/07/2020 11:00, Kurt Kanzenbach wrote:
> >> +    msgtype = ptp_get_msgtype(hdr, ptp_class);
> >> +    seqid   = be16_to_cpu(hdr->sequence_id);
> >
> > Is there any reason to not use "ntohs()"?
>
> This is just my personal preference, because I think it's more
> readable. Internally ntohs() uses be16_to_cpu(). There's no technical
> reason for it.

I think for traditional reasons, code in net/* tends to use ntohs()
while code in drivers/*  tends to use be16_to_cpu().

In drivers/net/* the two are used roughly the same, though I guess
one could make the argument that be16_to_cpu() would be
more appropriate for data structures exchanged with hardware
while ntohs() makes sense on data structures sent over the
network.

     Arnd
