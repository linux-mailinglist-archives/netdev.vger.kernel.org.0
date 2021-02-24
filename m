Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9AD324190
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 17:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbhBXQBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 11:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233115AbhBXPhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 10:37:01 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19A0C06174A
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 07:36:17 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id o16so2225593wmh.0
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 07:36:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=jBvixhRMQ+Vys3CnbicMV7CAEtVmPH+y0/5IHOF/LrE=;
        b=rlsOC54iFqCnOQpTS758zfD0k2x5//z9VMD0Nx5A03U0EVoo7WMUnIHyl4XOAWdJQw
         ezLySO3GM4IAUzVZjhxffHzC/Dqvc/sAIDByVcH2CQoCl21a1qzZ3v1NNWMBY1hHngSs
         zE/c3o7iwICH1T2G5gkVzX6C8OY/wbzgnjhxL36JOEdG+nX+ChnOJB4HiUhv0t89FWqc
         2EojzdaazYcHY62JBM51OXcRr1zR4PerEbrxuhYPlW0gXyllAyQGqoWWYrstedNBgH+a
         bhRIhTdskoCPFnzC7ESXwgqLb4JJ8/hJVx2HqhK9NR2iIymvC7USVUQ3mz/bvww1pEpa
         wVjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=jBvixhRMQ+Vys3CnbicMV7CAEtVmPH+y0/5IHOF/LrE=;
        b=ZK+hOeF0r98+z0DfTbQRGxr/PSp0LdVvCLXxGs7oGWR7bwiVvQRruFUXdgovkxs4as
         AnfU5W8OOotc/u1kcG5SEUveHPSGMpTPwFaF9kzVwqq+BY97jgIEh+0aQHzprQdN6cIV
         AgJpoO6RL6MNqTkVJl4+VEfPMNPyKYRoRKxRTC7FKxwauQDKXM6CZGmwy3fp7cyd2LqB
         YM9LwZczyx7719yC0RUJfqGWl0LlkMEGgQ6UnrlKywolsy0U5YDpnt7kbWA7tmN951ht
         w123u1biXwrvmffsdXq468TzV2gGNCCiIX0HJs5M5+9/h1ztESP1h9SlUXxfZucMPawr
         roBA==
X-Gm-Message-State: AOAM5312BQJQIJD66ODBtuWE4auIL9zAGCDzLVcA/IDaTTTmhI7B5vL/
        +CmdY4aYL8onHlptlTCL7+8=
X-Google-Smtp-Source: ABdhPJwjU7SKmd1SxlPeoOYn3QDQxpDel3R6sbXL6m1vtgV2queqfCb/sueIpQAQQZzAIRAIkMqyOQ==
X-Received: by 2002:a1c:20c7:: with SMTP id g190mr4253149wmg.156.1614180976597;
        Wed, 24 Feb 2021 07:36:16 -0800 (PST)
Received: from silmaril.home ([188.120.85.11])
        by smtp.gmail.com with ESMTPSA id g15sm4281691wrx.1.2021.02.24.07.36.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Feb 2021 07:36:15 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: TCP stall issue
From:   Gil Pedersen <kanongil@gmail.com>
In-Reply-To: <CADVnQynP40vvvTV3VY0fvYwEcSGQ=Y=F53FU8sEc-Bc=mzij5g@mail.gmail.com>
Date:   Wed, 24 Feb 2021 16:36:14 +0100
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <93A31D2F-1CDE-4042-9D00-A7E1E49A99A9@gmail.com>
References: <35A4DDAA-7E8D-43CB-A1F5-D1E46A4ED42E@gmail.com>
 <CADVnQy=G=GU1USyEcGA_faJg5L-wLO6jS4EUocrVsjqkaGbvYw@mail.gmail.com>
 <C5332AE4-DFAF-4127-91D1-A9108877507A@gmail.com>
 <CADVnQynP40vvvTV3VY0fvYwEcSGQ=Y=F53FU8sEc-Bc=mzij5g@mail.gmail.com>
To:     Neal Cardwell <ncardwell@google.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 24 Feb 2021, at 15.55, Neal Cardwell <ncardwell@google.com> wrote:
>=20
> On Wed, Feb 24, 2021 at 5:03 AM Gil Pedersen <kanongil@gmail.com> =
wrote:
>> Sure, I attached a trace from the server that should illustrate the =
issue.
>>=20
>> The trace is cut from a longer flow with the server at 188.120.85.11 =
and a client window scaling factor of 256.
>>=20
>> Packet 78 is a TLP, followed by a delayed DUPACK with a SACK from the =
client.
>> The SACK triggers a single segment fast re-transmit with an ignored?? =
D-SACK in packet 81.
>> The first RTO happens at packet 82.
>=20
> Thanks for the trace! That is very helpful. I have attached a plot and
> my notes on the trace, for discussion.
>=20
> AFAICT the client appears to be badly misbehaving, and misrepresenting
> what has happened.  At each point where the client sends a DSACK,
> there is an apparent contradiction. Either the client has received
> that data before, or it hasn't. If the client *has* already received
> that data, then it should have already cumulatively ACKed it. If the
> client has *not* already received that data, then it shouldn't send a
> DSACK for it.
>=20
> Given that, from the server's perspective, the client is
> misbehaving/lying, it's not clear what inferences the server can
> safely make. Though I agree it's probably possible to do much better
> than the current server behavior.
>=20
> A few questions.
>=20
> (a) is there a middlebox (firewall, NAT, etc) in the path?
>=20
> (b) is it possible to capture a client-side trace, to help
> disambiguate whether there is a client-side Linux bug or a middlebox
> bug?

Yes, this sounds like a sound analysis, and matches my observation. The =
client is confused about whether it has the data or not.

Unfortunately I only have that (un-rooted) device available, so I can't =
do traces on it. The connection path is Client -> Wi-Fi -> NAT -> NAT -> =
Internet -> Server (which has a basic UFW firewall).
I will try to do a trace on the first NAT router.

My first priority is to make the server behave better in this case, but =
I understand that you would like to investigate the client / connection =
issue as well? =46rom the server POV, this is clearly an edge case, but =
a fast re-transmit does seem more appropriate.

Btw. the "client SACKs TLP retransmit" note is not correct. This is an =
old ACK, which can be seen from the ecr value.

/Gil=
