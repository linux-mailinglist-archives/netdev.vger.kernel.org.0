Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6BAA4888DB
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 12:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbiAIL3h convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 9 Jan 2022 06:29:37 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:54221 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbiAIL3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 06:29:36 -0500
Received: from mail-wr1-f50.google.com ([209.85.221.50]) by
 mrelayeu.kundenserver.de (mreue012 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1N5lvf-1mHV8X2gUV-017GcI for <netdev@vger.kernel.org>; Sun, 09 Jan 2022
 12:29:34 +0100
Received: by mail-wr1-f50.google.com with SMTP id o3so21182377wrh.10
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 03:29:34 -0800 (PST)
X-Gm-Message-State: AOAM532fWdAInDFpz844rlYHLGbZe0ez6jbNpqFx+y/zyCVRukVdomw2
        srSKWszyv3GXZZS+KKBjmpWkVYrFJvw4LSpINnY=
X-Google-Smtp-Source: ABdhPJw3XoQkxp7FpwvbomrmH7uMmgx/GEpqq4V3MpQtq2tANmkIT2ijqQ+3rNtdacgAG92PhzgXu89LMPlpm8mBwd0=
X-Received: by 2002:a5d:694e:: with SMTP id r14mr9634766wrw.192.1641727774245;
 Sun, 09 Jan 2022 03:29:34 -0800 (PST)
MIME-Version: 1.0
References: <20190426195849.4111040-1-arnd@arndb.de> <20190426195849.4111040-6-arnd@arndb.de>
 <20211108094845.cytlyen5nptv4elu@intra2net.com> <CAK8P3a0=+w-CR_3uUr3Vi8E7v1z1O40K81pZU6y67u5ns8tCHA@mail.gmail.com>
 <977673e5-57ea-1977-65fe-963e88f5da7a@eversberg.eu>
In-Reply-To: <977673e5-57ea-1977-65fe-963e88f5da7a@eversberg.eu>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sun, 9 Jan 2022 12:29:17 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1Ox40896hSQWFm-u64yptn0H=3736SOZhyKZfhFC+nhw@mail.gmail.com>
Message-ID: <CAK8P3a1Ox40896hSQWFm-u64yptn0H=3736SOZhyKZfhFC+nhw@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] isdn: move capi drivers to staging
To:     Andreas Eversberg <andreas@eversberg.eu>
Cc:     Arnd Bergmann <arnd@arndb.de>, Networking <netdev@vger.kernel.org>,
        Karsten Keil <isdn@linux-pingi.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:Bn9Hqe8ffBmM9WO0xhh3LMlJbUVXV++nph/YYL7My0CYcm7xawl
 ubgIMre3MPjbbbiMZgzJWiiBPtGDTjzwbc3Fg1Apg/Z/SKxkWElqwV5+TRR985c/kUGiChr
 GD7Gyekt7Rs6VWu3ghTRr0m50nUuNYJesfNHQMw63hvYMpi2MSFFTGHZsvQuC6A1R+sfJnB
 Rf3nDO976Dlf/nEhRqedg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:j0BnypZV/8g=:HiIu0nVsmQX37FhYD8djm3
 kGZKIrMVTTtWxqLz3/onP7nnX5PfSz3Nsn6bKkS2RfNw5HVZ8uqofulo4NYcTCCnvpT5P30KK
 IvOxlLbouL8y7PpdL4hGAaUGAcXfuz8Vz66tOpq+yiyYG//iq8SUGFRgEtM+RoX7WbZeT9v/a
 2vTIw4AAYA66GPCtMb3IXNPo4HaFY24H62m0C/Md+e8DIWdjwucohZY6ek35ykX6r2rcb/dHN
 JZS1pEafJRqpdpB8eze7RP0y1wtd4/0WP3Q8WKxi6UcKSomKkZqMgHRVly3RSwRahhoQIE8ek
 s2Zk2Tl37iQCR0+Fhh2hTc4oEDfAna3kZaRuRjxP8kgxEVOmQL6Q4uBdskH++JMlD6L5+h06q
 m4UqTAePT+7UUeTnB661LbA1eb6G+1O4OtRt/ZxB76ks025wvuX97fW8GiZ6ONeUAsRteg/N7
 BSfBcL2eHIgRg8dvrHb0U9nsztjIgYy31pvDIWdF5PaALDx4+BMsVw/VCHG/ogvBiqekQUwro
 B/RrIdLfGmQxiO+iuroJVN4py/hMzQPLTXk9HBljSa2b9K2FCpfEjmEQvk12WcmA3q1C6IjpA
 s8Y5zDWRJPd4zJZadS+asDDBpVRZrV05rWQlqjXajrSmhMUBC1I1xLH7npB6qFTnKtxjH/krK
 NyCUbS8qbjWnsZRzxyARnTJyOT9PB1zoJbBAFe0tfjhP2RB9TY1qSzANfX1ags144izk=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 9, 2022 at 10:42 AM Andreas Eversberg <andreas@eversberg.eu> wrote:
>
> Hi Arnd,
>
> first of all I want to introduce myself:
>
> I developed some drivers for the mISDN stack, like HFC-4S/8S/E1 cards and audio processing. I wrote LCR to make use of the mISDN stack and process ISDN voice calls. Later I worked on several GSM related Osmocom projects. My current effort is to preserve classic telecommunication technology[1].
>
> In my opinion, mISDN should stay in kernel. Connecting existing hardware PBX and terminal equipment (phones) requires BRI/PRI interfaces, which are provided by mISDN. Also telcos offer analog or BRI ports on their integrated access devices. LCR is not in development anymore, because the architecture is based on classic telephony, so that VoIP (SIP) supports basic speech calls with many limitations only. I actually don't like LCR it anymore. As a replacement for LCR, I wrote two gateway applications[2] that can interconnect SIP and mISDN endpoints without having something like a PBX. I know of some people still using mISDN/LCR (or the new gateway applications) to connect their equipment to a SIP provider. So there is still a use case.
>
> I have not been working on / compiling mISDN kernel drivers for a long time. If there is work to be done, let me know and I will look at it.

Hi Andreas,

There is of course no problem keeping it in the tree longer if it
still has users, but your
description above does not answer the two main questions:

- how likely are the remaining mISDN users to upgrade to a future
kernel using the
  provided mISDN stack, rather than remaining on the latest currently
working kernel
  or one of the out-of-tree copies of the driver [1][2].

- As Karsten Keil is no longer actively providing patches for mISDN
(his last mainline
  commit is from 2015, the last commit to [1] was in April 2020), is
there any other
  person who can take over as maintainer and actively work on ensuring that the
  drivers continue to work?

          Arnd

[1] https://github.com/ISDN4Linux/mISDN
[2] https://github.com/bbaranoff/mISDN
