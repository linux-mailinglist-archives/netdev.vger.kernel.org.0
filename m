Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770F735CAEC
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243255AbhDLQSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:18:44 -0400
Received: from mout.gmx.net ([212.227.15.18]:53729 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237798AbhDLQSm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:18:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1618244250;
        bh=23L7C4c2Fun/n1dWfwKI/BlS0wULMrCt+0lVJbOuZz8=;
        h=X-UI-Sender-Class:Date:In-Reply-To:References:Subject:Reply-to:To:
         CC:From;
        b=XeiZUOEANURDUnqwLj9B9Dqa51UMQFDj9Mg72HevrYG+PT/JotfmkBF4GxS/nEgzu
         l6UeXU7lEa2V08Qy2GPRqlNtEh1B/GChh27J4glaH/VgsyKXbFLf6gXzODO4q0FEqJ
         YfrwlWenAlAfOWA6vhbpXblCbi2rhUtXADoyr2XA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from frank-s9 ([80.245.76.232]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mq2j2-1lscQa0TPm-00nDjv; Mon, 12
 Apr 2021 18:17:30 +0200
Date:   Mon, 12 Apr 2021 18:17:23 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <20210412153058.929833-1-dqfext@gmail.com>
References: <20210410133454.4768-1-ansuelsmth@gmail.com> <20210410133454.4768-2-ansuelsmth@gmail.com> <20210412033525.2472820-1-dqfext@gmail.com> <YHPPlnXbElN4qJ/r@Ansuel-xps.localdomain> <20210412153058.929833-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH RFC net-next 1/3] net: dsa: allow for multiple CPU ports
Reply-to: frank-w@public-files.de
To:     DENG Qingfang <dqfext@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
CC:     netdev@vger.kernel.org,
        =?ISO-8859-1?Q?Marek_Beh=FAn?= <marek.behun@nic.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
From:   Frank Wunderlich <frank-w@public-files.de>
Message-ID: <FC33D997-21FA-4528-BC04-A4DFFCFF8847@public-files.de>
X-Provags-ID: V03:K1:dbzBiYsqH4KKKgpvQbCWzaoK3jiqG5FH4wT+Kfv5hq6bbv/5wqT
 DoK/Djhy2p6XDDSsj6NrJ0tP1Y4dqfJrBW5m7zJsQfNsmHnPrs9HlIgxP3CYoJ4zY3/lpO1
 U0+Du/GbuLbGxRcBmwPifGyZf6UzXz7B+lB4tHimssY/SRuE1mEys2EjKw1A/YWdmyveMkh
 cTTnzYRLMWzTlLkGvpowQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:W65El3gWUuQ=:7o01fDUksN1KmrHTW5zm/J
 z0yXoeLzeW4eYvj8cdySgbNVuSOcKFVI9IJrbih0PdNIc0wIQmMOkImS+xPRE8QttZSvTpOyf
 Z6109WVOhof2iQisnyTPLvzebMZD6ieBqhDzvS30cJH5H4VEfgSPdY7gmfZn5RcZo1mEV4sIU
 0jqC52FW4o0tALeO+3xAFuvtWYUe21xd28Z6BfMUE6UQQhdQjhFbvwlDLVHu+gYRgRVQK2C+f
 gQDlPpzTpblk+R4mOopLg9QMvTd8OX7D4OAxOU/7JEsSYMKNK6V4KhG034UNHdmAjAy2vE+6E
 Ff5bqqG++XD9EyG4AFLkmM3m8wtmMHYSPavMlFUA7u3yxb89PYkNmMjLV/IZHc+dec1Fj5YCV
 /hoJnEqL/2RCwQCECLYXZAMVJ8DhjM9iSb1bbcBp8CL36AJBWsS/R6prYib2DIinFAwKBOyhz
 s/fFwjhKtWcyJny+D/6Zzsf+Y+WMDRmVhCewpuGUU4fYhP8WvBzOHDI/aOHZFmkZ0A6Y7eBGM
 5D6vrsprLajYgmbyYYwUIMtvDnT3smisMnGTWfiilkYlfwsLDzvWm53m7yS/08QrdwNIAZ0RC
 uc5JTFU5/IyfDnhBdXVdr8RciIvN91pnlmnnljaBa9KVS7s08wOzwRVyRZ+eci2xYtk6UpRGg
 T2nBGyvMoazUvrSxwR5gejRzna/xoiL87clerGvD/TjPiAw0cZrEswzvt5N/J//jSHjTB5ePm
 almz88j6Iujo+DO9+ijBJkwXx2Vs1q+GELbufVgbL02a8RuLA6NBi1+7gF43FO9miut6vAZPf
 J3BM5kMiWIaYRu9f24agYxjyrrzycz57ufLm0Np5+21Vt8MAdSRAwvt3AYpK5hexx7b4p8QX3
 cyVI4ZnSftDQSBX6U8BKjrZsJmkvRfJ0JjRvwre3yKqp+Z5cFshCqxe0Y4KfCfMgJEZQ1iyl4
 NkuJ4slk94p4Q6gU3eH8ODWB46KoTK8dpuf9QwrTS36YWzgniLWdsSqug6xmgd/StTDDOipK+
 E3cbUGcizts5Q0UG2MrZ/gD1iGcA/EpzrUXvA8688/YU8ARLjF8KXRrTh++n3/w+pAZ5iZ7+s
 iQXrWC+IC6FWob37IboGPEpwGc4JuXQbguRslnpRbCpKGBfQhGQdqWyOeTAo0HmqOh5QbWwMK
 +CdiPHAqmZoe71rwnyT0Q2DIr2TTEQE/Nu812n5qOvlF7fFvki8ftVOb/t3jfWKxXa4/T+heG
 pvW4p6vK83kBZPhO0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 12=2E April 2021 17:30:58 MESZ schrieb DENG Qingfang <dqfext@gmail=2Ecom=
>:

>So we somehow configured default CPU port in dts (by port name)=2E In
>my opinion we can just add a default CPU property in dts to specify
>it (like Frank Wunderlich did earlier), and fall back to round-robin
>if the property is not present, while still allow users to change it
>in userspace=2E

My series was an up ported version of Patches (linux 4=2E9) afair from Fel=
ix=2E The dts-version was 1 reason why it was rejected, because DT describe=
s hardware and not software preferences=2E


regards Frank
