Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEDA2D24F3
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 08:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbgLHHwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 02:52:14 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:33995 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbgLHHwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 02:52:14 -0500
Received: from [192.168.1.155] ([95.117.39.192]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1N3K9E-1k4AHh0uGY-010MJG; Tue, 08 Dec 2020 08:49:07 +0100
Subject: Re: [PATCH 2/7] net: batman-adv: remove unneeded MODULE_VERSION()
 usage
To:     Sven Eckelmann <sven@narfation.org>, linux-kernel@vger.kernel.org,
        "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     davem@davemloft.net, kuba@kernel.org, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, marcel@holtmann.org,
        johan.hedberg@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        jmaloy@redhat.com, ying.xue@windriver.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-hyperv@vger.kernel.org, bpf@vger.kernel.org,
        Matthias Schiffer <mschiffer@universe-factory.net>
References: <20201202124959.29209-1-info@metux.net>
 <20201202124959.29209-2-info@metux.net> <4581108.GXAFRqVoOG@sven-edge>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Message-ID: <ca5c17a1-dea5-83eb-f9c5-a027b4135fec@metux.net>
Date:   Tue, 8 Dec 2020 08:48:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <4581108.GXAFRqVoOG@sven-edge>
Content-Type: text/plain; charset=windows-1252
Content-Language: tl
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:h8bNmxElVyI3h1+Nyku7bHTBtAaOLvHvVsdC9bGyQSsOED5F3Cj
 Dc5QkiVs/ZBk+NcKthsQ230rBqEUcOorknjtkvuApOrZrlTzCKFWSUnpYoTvRnBQ4n7m5EX
 chK0eoerQcDZwBWU+W3OKlYH/Ri950fzERNDDw6FyrvGorgAuRfxsVw3N3sEWxfmiqmiDwO
 RvekdPs8+NG/Ta/hS2v8w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:kef8D6LPYu0=:cmiNBIxEZx0KDmv/6+ogX9
 rlkms8HLbna+KOViXb6Yx5vDMQXZye2NsFlbGfczMFgZK4Q+8QhID395GyHrIrVMCr+8r3IxK
 WPdLiaL/wx4J5jLXC7H6Luj2Gp3xbNHwOBMDcfPiQaFrdG07bSg3xoBEFvxVYwJVNMy0seo4H
 f9FydN4pNU1mPzg/UK/ZmGZKNtZI6REeZkESqQTZ2u4eSgyTCZoAkZ4z7uTX5u5hJb1OELyl5
 1udFyf0bbAfy9jHRP+IjVpL7gyOg3xaS/oz3t4q+ItyJc2fukz2VjQJ4wUviRURaa1kDTy6La
 ulk0bOzva4qTrIn3ZYQCqu1HKgrOdWUfQB+CKg2eakKglOJKRwtKBMyLF2dJDLUrisYb5btjo
 gWtJ6npcQCS4tVy9gmvwiKjIBEDunzK/1UIPOw6FgipIT1X8OHlBuAKH5FTIX
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.12.20 08:06, Sven Eckelmann wrote:

Hi,

> Is there some explanation besides an opinion? Some kind goal which you want to 
> achieve with it maybe?

Just a cleanup. I've been under the impression that this version is just
an relic from oot times.

> At least for us it was an easy way to query the release cycle information via 
> batctl. Which made it easier for us to roughly figure out what an reporter/
> inquirer was using - independent of whether he is using the in-kernel version 
> or a backported version.

Is the OOT scenario still valid ?

> Loosing this source of information and breaking parts of batctl and other 
> tools (respondd, ...) is not the end of the world. But I would at least know 
> why this is now necessary.

Okay, if this particular information indeed has a practical value, we
should keep it. Taking it as a NAK.

Perhaps we should add a comment what it's used for and make sure, the
version number is properly maintained.

The problem I see w/ those version fields is that we have lots of
changes in the kernel tree, w/o the version number being increased -
making this information at least doubtful.


--mtx

-- 
---
Hinweis: unverschlüsselte E-Mails können leicht abgehört und manipuliert
werden ! Für eine vertrauliche Kommunikation senden Sie bitte ihren
GPG/PGP-Schlüssel zu.
---
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
