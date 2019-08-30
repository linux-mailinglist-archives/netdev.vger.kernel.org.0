Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0154A2B87
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfH3Akf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:40:35 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:39682 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfH3Akf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:40:35 -0400
Received: by mail-pg1-f182.google.com with SMTP id u17so2534142pgi.6;
        Thu, 29 Aug 2019 17:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=dEzzK3ej0D2DdcrKMnr5GiDP31mC/4AEuzvK1xuDxvQ=;
        b=q932OvW839kqnCTD+/UUQ5bHkpzRVLV8CY6Vu9mdp+4ItpgKcVBip46mW9SKWoDq7b
         0QZm4Jw+aP8678Rei13/TiDivwFJktsM7Gpfv3MGjtz9vKkRCsbeEXximE1KWaPxXGJB
         Y1Sq9BUGmxSKi3sLxldJwAuqNonn68LWir6uyJunvOngmG4Ivd1hEXGzxmweDNwd3yDl
         3KUZn3z0iqi5oZFYkkK6J4Z4TojUZV38BcCMetY5iALx2KjTk4x6t7jQOBNehexc6sSu
         D5y6BiUAXbsjE062f+KT20tbaTBHmTfzN35Vdhg8VVIVnKAft6bLFDTLXp3t8vN/aVAq
         EZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=dEzzK3ej0D2DdcrKMnr5GiDP31mC/4AEuzvK1xuDxvQ=;
        b=hv9vRShcisqxuAGkhJL0+OkJHZtqqfpxW9hQzzgatZDWh8OzwIfguftbzoGAMs7Cmk
         61nXNhXDDJ2anQahli1+AVE6F3OfNUFDIZo43xPtQgdwFG/+HdSlO3qA3pcnHRmR6T/I
         2K9tzdjiGv3CYHp6c7WbF6cTMjr/bw5JCpgF5EOOb+r7MNtU34vi/nbWmE4CqNIdZ1Xj
         JlIdZNoAW+4K0rCEsVAuIfZJVq42hIV29P+ZpwODOQNOxuFoYDszrkhkUJqBb7I6tgCT
         Eyf81tcr6Y7pQX+b5SXZiejRqD1adga/Nu5YTZwuV0fCUtdpFZgudPV2pDMUV2loSJaz
         vbUg==
X-Gm-Message-State: APjAAAWLU6n0wyhI914hyFoPYBJ4Bga14xUkvdyxZqtNoSpw54u22Vu1
        0Su6qn9IWskt4I7Klr+NEiU=
X-Google-Smtp-Source: APXvYqx2ufivqU/tZ7EaorHY4lT0vU8Du8aagsdvqLhRMb1BuJhFLb/D0CtfAOei+SqgWf1QCCzaHg==
X-Received: by 2002:a17:90a:256d:: with SMTP id j100mr12764872pje.126.1567125634017;
        Thu, 29 Aug 2019 17:40:34 -0700 (PDT)
Received: from ?IPv6:2600:380:7030:d773:cdf3:ae60:8f6c:db60? ([2600:380:7030:d773:cdf3:ae60:8f6c:db60])
        by smtp.gmail.com with ESMTPSA id t15sm4229652pfc.47.2019.08.29.17.40.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 17:40:33 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: ANNOUNCE: rpld an another RPL implementation for Linux
From:   Reuben Hawkins <reubenhwk@gmail.com>
X-Mailer: iPhone Mail (16G77)
In-Reply-To: <CAB_54W7h9ca0UJAZtk=ApPX-2ZCvzu4774BTFTaB5mtkobWCtw@mail.gmail.com>
Date:   Thu, 29 Aug 2019 17:40:30 -0700
Cc:     "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Richardson <mcr@sandelman.ca>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Robert Kaiser <robert.kaiser@hs-rm.de>,
        Martin Gergeleit <martin.gergeleit@hs-rm.de>,
        Kai Beckmann <kai.beckmann@hs-rm.de>, koen@bergzand.net,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        BlueZ development <linux-bluetooth@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        sebastian.meiling@haw-hamburg.de,
        Marcel Holtmann <marcel@holtmann.org>,
        Werner Almesberger <werner@almesberger.net>,
        Jukka Rissanen <jukka.rissanen@linux.intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F9994340-5074-4CAB-9FCF-7CC5DAF48257@gmail.com>
References: <CAB_54W7h9ca0UJAZtk=ApPX-2ZCvzu4774BTFTaB5mtkobWCtw@mail.gmail.com>
To:     Alexander Aring <alex.aring@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a COPYRIGHT file in radvd which I just read for the first time toda=
y. It=E2=80=99s been there for 19+ years. Sounds very BSD to me. I=E2=80=99v=
e been maintainer for 9 years. As far as I=E2=80=99m concerned, you can do w=
ith the code whatever you like.  Good luck. =F0=9F=91=8D=20

Sent from my iPhone

> On Aug 29, 2019, at 2:57 PM, Alexander Aring <alex.aring@gmail.com> wrote:=

>=20
> Hi,
>=20
> I had some free time, I wanted to know how RPL [0] works so I did a
> implementation. It's _very_ basic as it only gives you a "routable"
> (is that a word?) thing afterwards in a very constrained setup of RPL
> messages.
>=20
> Took ~1 month to implement it and I reused some great code from radvd
> [1]. I released it under the same license (BSD?). Anyway, I know there
> exists a lot of memory leaks and the parameters are just crazy as not
> practical in a real environment BUT it works.
>=20
> I changed a little bit the dependencies from radvd (because fancy new thin=
gs):
>=20
> - lua for config handling
> - libev for event loop handling
> - libmnl for netlink handling
>=20
> The code is available at:
>=20
> https://github.com/linux-wpan/rpld
>=20
> With a recent kernel (I think 4.19 and above) and necessary user space
> dependencies, just build it and run the start script. It will create
> some virtual IEEE 802.15.4 6LoWPAN interfaces and you can run
> traceroute from namespace ns0 (which is the RPL DODAG root) to any
> other node e.g. namespace ns5. With more knowledge of the scripts you
> can change the underlying topology, everybody is welcome to improve
> them.
>=20
> I will work more on it when I have time... to have at least something
> running means the real fun can begin (but it was already fun before).
>=20
> The big thing what everybody wants is source routing, which requires
> some control plane for RPL into the kernel to say how and when to put
> source routing headers in IPv6. I think somehow I know what's
> necessary now... but I didn't implemented it, this simple
> implementation just filling up routing tables as RPL supports storing
> (routing table) or non-storing (source routing) modes. People tells me
> to lookup frrouting to look how they do source routing, I will if I
> get the chance.
>=20
> It doesn't run on Bluetooth yet, I know there exists a lack of UAPI to
> figure out the linklayer which is used by 6LoWPAN. I need somehow a
> SLAVE_INFO attribute in netlink to figure this out and tell me some
> 6LoWPAN specific attributes. I am sorry Bluetooth people, but I think
> you are also more interested in source routing because I heard
> somebody saying it's the more common approach outside (but I never saw
> any other RPL implementation than unstrung running).
>=20
> Also I did something in my masters thesis to make a better parent
> selection, if this implementation becomes stable I can look to get
> this migrated.
>=20
> Please, radvd maintainer let me know if everything is okay from your
> side. As I said I reused some code from radvd. I also operate on
> ICMPv6 sockets. The same to Michael Richardson unstrung [2]. If there
> is anything to talk or you have complains, I can change it.
>=20
> Thanks, I really only wanted to get more knowledge about routing
> protocols and how to implement such. Besides all known issues, I still
> think it's a good starting point.
>=20
> - Alex
>=20
> [0] https://tools.ietf.org/html/rfc6550
> [1] https://github.com/reubenhwk/radvd
> [2] https://github.com/AnimaGUS-minerva/unstrung
