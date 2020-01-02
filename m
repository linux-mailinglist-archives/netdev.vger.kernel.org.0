Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF2612F19D
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 00:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgABXFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 18:05:47 -0500
Received: from egyptian.birch.relay.mailchannels.net ([23.83.209.56]:1964 "EHLO
        egyptian.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725890AbgABXFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 18:05:47 -0500
X-Sender-Id: dreamhost|x-authsender|stevie@qrpff.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 5CF175E1C9E;
        Thu,  2 Jan 2020 23:05:45 +0000 (UTC)
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (100-96-86-164.trex.outbound.svc.cluster.local [100.96.86.164])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id BDA6A5E1854;
        Thu,  2 Jan 2020 23:05:44 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|stevie@qrpff.net
Received: from pdx1-sub0-mail-a6.g.dreamhost.com ([TEMPUNAVAIL].
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.18.5);
        Thu, 02 Jan 2020 23:05:45 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|stevie@qrpff.net
X-MailChannels-Auth-Id: dreamhost
X-Daffy-Spicy: 070e7e9b61f0b289_1578006345195_399340049
X-MC-Loop-Signature: 1578006345195:71854839
X-MC-Ingress-Time: 1578006345194
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a6.g.dreamhost.com (Postfix) with ESMTP id 7843B7F37E;
        Thu,  2 Jan 2020 15:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=qrpff.net; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=qrpff.net; bh=rJVu1oJ5OXoPfH59J1rx+8VLjrI=; b=k
        OH8+yfsAgBUg4q/tg+qsxE2UWzZtyuSZkapGQY5A8X8QLC1qpI0/lA1e7VZMRQBD
        c2UeJ9GDly2OWzY6v2+YtwkZaXOd3CDcZ422lClcG09RqAUBkqNlhsnJB+YYChQC
        rNhRnnCBhS5bn0WEsI+C8KIeAgNz1RWCugFYANGczE=
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: stevie@qrpff.net)
        by pdx1-sub0-mail-a6.g.dreamhost.com (Postfix) with ESMTPSA id 0B9427F380;
        Thu,  2 Jan 2020 15:05:38 -0800 (PST)
Received: by mail-lj1-f172.google.com with SMTP id y6so34212048lji.0;
        Thu, 02 Jan 2020 15:05:38 -0800 (PST)
X-Gm-Message-State: APjAAAXjggjtOlDoZ/sRyXJR4M6m89xaGgGLKDoGilVEC7RPpMn2bgUM
        CkwcV/VHidJ7LzlTO4v6uDPYHaQ4FzyLHZe/qOY=
X-Google-Smtp-Source: APXvYqyX88202Y94oL3z3iKty2TRFCRwIZICQA3PUCWFaRomHJocbdmqtWdzdWlwGQOBuUF1kmWTCVC8bsuqINoezCE=
X-Received: by 2002:a2e:8016:: with SMTP id j22mr51293445ljg.24.1578006332987;
 Thu, 02 Jan 2020 15:05:32 -0800 (PST)
MIME-Version: 1.0
References: <CAD_xR9eDL+9jzjYxPXJjS7U58ypCPWHYzrk0C3_vt-w26FZeAQ@mail.gmail.com>
 <1762437703fd150bb535ee488c78c830f107a531.camel@sipsolutions.net>
In-Reply-To: <1762437703fd150bb535ee488c78c830f107a531.camel@sipsolutions.net>
X-DH-BACKEND: pdx1-sub0-mail-a6
From:   Stephen Oberholtzer <stevie@qrpff.net>
Date:   Thu, 2 Jan 2020 18:05:21 -0500
X-Gmail-Original-Message-ID: <CAD_xR9eh=CAYeQZ3Vp9Yj9h3ifMu2exy0ihaXyE+736tJrPVLA@mail.gmail.com>
Message-ID: <CAD_xR9eh=CAYeQZ3Vp9Yj9h3ifMu2exy0ihaXyE+736tJrPVLA@mail.gmail.com>
Subject: Re: PROBLEM: Wireless networking goes down on Acer C720P Chromebook (bisected)
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     toke@redhat.com, "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: -100
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrvdegvddgtddvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepgghfjgfhfffkuffvtgesthdtredttddtjeenucfhrhhomhepufhtvghphhgvnhcuqfgsvghrhhholhhtiigvrhcuoehsthgvvhhivgesqhhrphhffhdrnhgvtheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepvddtledrkeehrddvtdekrddujedvnecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehmrghilhdqlhhjuddqfhdujedvrdhgohhoghhlvgdrtghomhdpihhnvghtpedvtdelrdekhedrvddtkedrudejvddprhgvthhurhhnqdhprghthhepufhtvghphhgvnhcuqfgsvghrhhholhhtiigvrhcuoehsthgvvhhivgesqhhrphhffhdrnhgvtheqpdhmrghilhhfrhhomhepshhtvghvihgvsehqrhhpfhhfrdhnvghtpdhnrhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 2, 2020 at 8:28 AM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Tue, 2019-12-31 at 19:49 -0500, Stephen Oberholtzer wrote:
> > Wireless networking goes down on Acer C720P Chromebook (bisected)
> >
> > Culprit: 7a89233a ("mac80211: Use Airtime-based Queue Limits (AQL) on
> > packet dequeue")
> >

<snip>

> I think I found at least one hole in this, but IIRC (it was before my
> vacation, sorry) it was pretty unlikely to actually happen. Perhaps
> there are more though.
>
> https://lore.kernel.org/r/b14519e81b6d2335bd0cb7dcf074f0d1a4eec707.camel@sipsolutions.net

<snippety-snip>

> Do you get any output at all? Like a WARN_ON() for an underflow, or
> something?
>
> johannes
>

Johannes,

To answer your immediate question, no, I don't get any dmesg output at
all. Nothing about underruns.
However, while pursuing other avenues -- specifically, enabling
mac80211 debugfs and log messages -- I realized that my 'master' was
out-of-date from linux-stable and did a git pull.  Imagine my surprise
when the resulting kernel did not exhibit the problem!

Apparently, I had been a bit too pessimistic; since the problem
existed in 5.5-rc1 release, I'd assumed that the problem wouldn't get
rectified before 5.5.

However, I decided to bisect the fix, and ended up with: 911bde0f
("mac80211: Turn AQL into an NL80211_EXT_FEATURE"), which appears to
have "solved" the problem by just disabling the feature (this is
ath9k, by the way.)

This AQL stuff sounds pretty nifty, and I'd love to try my hand at
making it work for ath9k (also, since I put so much effort into an
automated build-and-test framework, it'd be a shame to just abandon
it.)  However, the ath9k code is rather lacking for comments, so I
don't even know where I should start, except for (I suspect) a call to
`wiphy_ext_feature_set(whatever, NL80211_EXT_FEATURE_AQL);` from
inside ath9k_set_hw_capab()?

In the meantime, I went back to e548f749b096 -- the commit prior to
the one making AQL support opt-in -- and cranked up the debugging.

I'm not sure how to interpret any of this, but  here's what I got:

dmesg output:

Last relevant mention is "moving STA <my AP's MAC> to state 4" which
happened during startup, before everything shut down.

/sys/kernel/debug/ieee80211/phy0

airtime_flags = 7

stations/<my AP's MAC>/airtime =

RX: 6583578 us
TX: 32719 us
Weight: 256
Deficit: VO: -1128 us VI: 11 us BE: -5098636 us BK: 256 us
Q depth: VO: 3868 us VI: 3636 us BE: 12284 us BK: 0 us
Q limit[low/high]: VO: 5000/12000 VI: 5000/12000 BE: 5000/12000 BK: 5000/12000

(I have no idea how to interpret this, but that '32719 us' seems odd,
I thought the airtime usage was in 4us units?)


Doing an 'echo 3 | tee airtime_flags' to clear the (old) AQL-enabled
bit seemed to *immediately* restore network connectivity.

I ran a ping, and saw this:

- pings coming back in <5ms
- re-enable AQL (echo 7 | tee airtime_flags)
- pings stop coming back immediately
- some seconds later, disable AQL again (echo 3 | tee airtime_flags)
- immediate *flood* of ping replies registered, with times 16000ms,
15000ms, 14000ms, .. down to 1000ms, 15ms, then stabilizing sub-5ms
- According to the icmp_seq values, all 28 requests were replied to,
and their replies were delivered in-order

This certainly looks like a missing TX queue restart to me?


-- 
-- Stevie-O
Real programmers use COPY CON PROGRAM.EXE
