Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE6DEE40A
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 15:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbfD2Nz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 09:55:58 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:37433 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbfD2Nz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 09:55:58 -0400
Received: from [192.168.1.110] ([77.9.18.117]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MwPjf-1gT9H42mKz-00sLKc; Mon, 29 Apr 2019 15:54:35 +0200
Subject: Re: [PATCH v10 0/7] Add Fieldbus subsystem + support HMS Profinet
 card
To:     Sven Van Asbroeck <thesven73@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, mark.rutland@arm.com,
        treding@nvidia.com, David Lechner <david@lechnology.com>,
        noralf@tronnes.org, johan@kernel.org,
        Michal Simek <monstr@monstr.eu>, michal.vokac@ysoft.com,
        Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@linuxfoundation.org>, john.garry@huawei.com,
        geert+renesas@glider.be, robin.murphy@arm.com,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        sebastien.bourdelin@savoirfairelinux.com, icenowy@aosc.io,
        Stuart Yoder <stuyoder@gmail.com>,
        "J. Kiszka" <jan.kiszka@siemens.com>, maxime.ripard@bootlin.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <20190409144250.7237-1-TheSven73@gmail.com>
 <982e69c6-4e68-6f62-8bed-cd5a1802272b@metux.net>
 <CAGngYiUTHZFFY=H7xXHzZnN4pS0jAqWBTrcw04hjf5S-ykxC9w@mail.gmail.com>
 <c1831703-a476-8870-0a5f-9060bda0f669@metux.net>
 <CAGngYiXx2eKR7DnHm9sNWVC+B1F2N6uUNXqZAq4rey2yjU1RyA@mail.gmail.com>
 <23a25601-ed98-5348-9bac-bf8fc2baea5e@metux.net>
 <CAGngYiVJwRh_ESLfSYWak4RU60T2D1HW0-3Hg1CZbRjWhaSN5Q@mail.gmail.com>
 <7ceaeb70-f937-bd84-95e5-d7a6baeb5d87@metux.net>
 <CAGngYiUPZ+g4eXJKvgA9GSJXgOFAAf6Q3qqAheiqNSnJ+Dbx+w@mail.gmail.com>
 <e07f7575-2617-a11a-fd78-d068b10a8171@metux.net>
 <06024a8a-ad00-8062-215b-01b2f95a6e24@hartkopp.net>
 <c1b783b0-9773-17f5-d043-35e28f7797f0@suse.de>
 <d54b294e-d641-bb14-84ed-39d9a9079dc7@hartkopp.net>
 <CAGngYiX_xxDWEAbxQ=XeZPYAA+zgQ32U0Ov=CG86yE=6=qTfpg@mail.gmail.com>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Organization: metux IT consult
Message-ID: <2bed794d-4960-df09-df16-e063cc41eaae@metux.net>
Date:   Mon, 29 Apr 2019 15:54:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAGngYiX_xxDWEAbxQ=XeZPYAA+zgQ32U0Ov=CG86yE=6=qTfpg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:XKZ+U9p2e+DR5HEHnRD3a5YgCyikZoBUmNnTjxGi9hDiE/mOW05
 MWW8x9pjhr0I3vtT2M9L+ZdxFYT2ydXVisV1SSZ4hu9gz4ovnbPz1NTvo5JQXim7xMcH7tP
 6Od4jzmaMi36swtR+Wdrmha4aSlss0Dfv9o+1HZuyWDeK9Fz9UhWkTft5ncMplULHCuAgla
 lrqMyJPjIzrg+38RmVIfA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:YGZf1uj3/6I=:uILxPV5x+bGgNNEKC7e4j3
 ZRnzQN+YTtXwsHoDQMyaNWvu6Jm7U6Qcha21dg/ejOZ71z2RNiORCtPH1g+emerxdEwWlWC4v
 NJUVRdpmXdaLcpHejA/Z9q0bjPLg0EGzJXtPjCkgGdQd7ZUp3i7s6OcI+QCZ2IjXVzsFSi4cE
 TmEIqfQagpIzOJ7bf2j7RimRZXupWLauRVEoTaEx7TgoUI8iskH3gf93pfdDVbJBTRs5bZhci
 ch31pjCpbIcoHExjCYiqFoQJ78lPhME0GbbKsfurukisZqmem9FdEC15H8Et68fC1yYuwLjms
 L7tRPSfDyMBZcOnig8r1HdMyoMVz66tBunZi/cWtCNc7WO5l/NyCLVugUVXxUyVAG6n0jc2Cz
 Y2k1p3aHTRiABAPzLC/yL4uZHDTRDE2FD75HqlklkPSk279L2bISEYkMRGHSug7NJd/yQ2fDs
 2dKUHCjIZrGbtQnAujSvjQ3pRvstKFZ3Y6t5To45/MvG3RwhK0zfdSzISNVZnFJ63PnV+8im5
 sEfUC21/QW4Pg/y1lyKCQ3micL1i4PTJJz8OkBFcmMdzzuf6AiR3Jc8QkFIxuBT64PrzEC0ZP
 /KbTFQOI7ZuUa1GmQZvQN4UUitAS7JxFwcudbo2NV2LSBoQu9hy3Z3WWuNJwD3Ki3OFoe6zeI
 Xm/xlbRLcs8VhaKrrGsDeD+kVcjSyKZAmFR04lBir4zLsbSATgJmeL6LPOiMWPJL9Vmo+LiYW
 WnIOZoTymEHcEagvuhA2+r973IIV3lfRv9SZZ8h1cqtsiZ/0XtHRbM3onu8=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.04.19 17:10, Sven Van Asbroeck wrote:

> The subsystem is called fieldbus_dev "fieldbus device" because it> abstracts Linux fieldbus clients that want to expose themselves as>
e.g. an actuator, motor, console light, switch, ...
Sounds a bit confusing. With that description, I'd expect highlevel
interfaces similar to LED, input, IIO, etc ... but you're actually
implementing an distributed process memory system. This in turn is
just a subset of the fieldbus world.

> During one of the eleven review cycles, drivers/fieldbus_dev got> truncated to drivers/fieldbus because the reviewers felt that> _dev
was redundant, given the lack of other fieldbus> subsystems.
There is at least one: CAN. Sometimes CAN is used in the IEC61158-way,
but also completely different, even both in combination.

> These cards are not controllers, but slaves on the bus.

Do they really implement the process memory part or just the lower
layer communications ?

> I'm by no means a fieldbus expert. It seems that the term> 'fieldbus' is much broader than these process-memory based> standards?

Yes, indeed.

> I am open to any _concrete_ naming suggestion
> that can get consensus.
Maybe IEC61158 ?

> I'm a bit confused by Wikipedia's entry for fieldbus.
> It suggests that IEC 61158 and Fieldbus are
> interchangeable?
> https://en.wikipedia.org/wiki/Fieldbus

That's wrong.

> <quote>
> Fieldbus is the name of a family of industrial computer
> network protocols used for real-time distributed control,
> standardized as IEC 61158.
> </quote>

IEC 61158 only standardizes one particular approach: the distributed
process memory.

> Given that CAN/EtherCAT are not process memory based
> (that I know of), the fieldbus_dev subsystem is probably
> not a good fit.

ACK. Neither are MVB+friends.


--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
