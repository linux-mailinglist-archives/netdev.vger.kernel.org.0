Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C779112F4E6
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 08:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgACHWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 02:22:09 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:33852 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgACHWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 02:22:09 -0500
Received: by mail-ot1-f65.google.com with SMTP id a15so60048820otf.1;
        Thu, 02 Jan 2020 23:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o43WK0aGQfxtR36Yk2dMmC8IKe8HC2vf043dM8fz/J0=;
        b=kBHjrs1XnSyfWoGPfctBX/UaQV+2CNFQiPTPd/Y01UbdDbmQau1AHdLldzBtIEVBxW
         Xlq+HQwZ3DkZRiYhm2WL8NVNftcQZMTsUBedt/BGOihOWTIHtGA8Jtd7MZ6IJrFlDyvY
         Ieyrbn61qQoi8zCilr+LU+ZkmSDPahF/zMKxK2i0GTxL7RYJho2P7GD8I5ffiuRJP/rK
         o03DXNJc8n0gZGxx/WExyayA3Ih4rfBgPRnBSBP2JQQtjp+g6NYLdee2A+tHY293TrdH
         sSinmfuC25QZLd4Gjs3HmMSVVZlt2k0RN5IiV/CwR4D3Rkqh9nlFp5nz1sMdYbOf10uf
         889Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o43WK0aGQfxtR36Yk2dMmC8IKe8HC2vf043dM8fz/J0=;
        b=TBjhYPsYTpOGC6PlDgHbu0L7QoT7YwvlDexAS9h7mBy4U/v+eVKownSQ6OMBMqN5Oh
         9Rq95O4rfbFslv+oahH0un2MLsKN2dJqUjP22n1v2O0ETs/ys3q7Kj3SUixqY+XE/mlr
         YEvuGKhv1BJCG6A8S8MKrxR4N9t/ZDQC0BKolRXXpaFez/LmdnNQzo67jHboLSUbeOkb
         DQc+vIA0NHFH+7CqHg5YIkOFH8S1UD4n45jWaZs1a7zz8S5/ZNa022eR4ALTuMWrC13k
         aB6yTvaFmFmY9AGukeV4ihJjNC/Wap/U76D4F8B1g/LAIsgnh7hUWONU07IqxI48swBz
         FAQA==
X-Gm-Message-State: APjAAAVxexPxMcyHDQh8Hr/22RYqy7V8Y/VMY9P9A2bWs1ZShdOZse35
        h+eKTuUIoUvc+jptdkc+eCM650LdoxKro8zBY9I=
X-Google-Smtp-Source: APXvYqySDXOnLw7kJKhe72eMXvoQUtPXGwbXBK+RARSAlJHRXKujxFmp2PP49cECDcsrEE9JZ9Zu4JvoRjkzEU78Fns=
X-Received: by 2002:a05:6830:2141:: with SMTP id r1mr97473012otd.39.1578036128160;
 Thu, 02 Jan 2020 23:22:08 -0800 (PST)
MIME-Version: 1.0
References: <CAD_xR9eDL+9jzjYxPXJjS7U58ypCPWHYzrk0C3_vt-w26FZeAQ@mail.gmail.com>
 <1762437703fd150bb535ee488c78c830f107a531.camel@sipsolutions.net> <CAD_xR9eh=CAYeQZ3Vp9Yj9h3ifMu2exy0ihaXyE+736tJrPVLA@mail.gmail.com>
In-Reply-To: <CAD_xR9eh=CAYeQZ3Vp9Yj9h3ifMu2exy0ihaXyE+736tJrPVLA@mail.gmail.com>
From:   Justin Capella <justincapella@gmail.com>
Date:   Thu, 2 Jan 2020 23:21:56 -0800
Message-ID: <CAMrEMU-QF8HCTMFhzHd0w2f132iA4GLUXHmBPGnuetPqkz=U7A@mail.gmail.com>
Subject: Re: PROBLEM: Wireless networking goes down on Acer C720P Chromebook (bisected)
To:     Stephen Oberholtzer <stevie@qrpff.net>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rather large negative deficit stands out to me. See this patch,
https://patchwork.kernel.org/patch/11246363/ specifically the comments
by Kan Yan

On Thu, Jan 2, 2020, 3:14 PM Stephen Oberholtzer <stevie@qrpff.net> wrote:
>
>
> /sys/kernel/debug/ieee80211/phy0
>
> airtime_flags = 7
>
> stations/<my AP's MAC>/airtime =
>
> RX: 6583578 us
> TX: 32719 us
> Weight: 256
> Deficit: VO: -1128 us VI: 11 us BE: -5098636 us BK: 256 us
> Q depth: VO: 3868 us VI: 3636 us BE: 12284 us BK: 0 us
> Q limit[low/high]: VO: 5000/12000 VI: 5000/12000 BE: 5000/12000 BK: 5000/1200

On Thu, Jan 2, 2020 at 3:14 PM Stephen Oberholtzer <stevie@qrpff.net> wrote:
>
> On Thu, Jan 2, 2020 at 8:28 AM Johannes Berg <johannes@sipsolutions.net> wrote:
> >
> > On Tue, 2019-12-31 at 19:49 -0500, Stephen Oberholtzer wrote:
> > > Wireless networking goes down on Acer C720P Chromebook (bisected)
> > >
> > > Culprit: 7a89233a ("mac80211: Use Airtime-based Queue Limits (AQL) on
> > > packet dequeue")
> > >
>
> <snip>
>
> > I think I found at least one hole in this, but IIRC (it was before my
> > vacation, sorry) it was pretty unlikely to actually happen. Perhaps
> > there are more though.
> >
> > https://lore.kernel.org/r/b14519e81b6d2335bd0cb7dcf074f0d1a4eec707.camel@sipsolutions.net
>
> <snippety-snip>
>
> > Do you get any output at all? Like a WARN_ON() for an underflow, or
> > something?
> >
> > johannes
> >
>
> Johannes,
>
> To answer your immediate question, no, I don't get any dmesg output at
> all. Nothing about underruns.
> However, while pursuing other avenues -- specifically, enabling
> mac80211 debugfs and log messages -- I realized that my 'master' was
> out-of-date from linux-stable and did a git pull.  Imagine my surprise
> when the resulting kernel did not exhibit the problem!
>
> Apparently, I had been a bit too pessimistic; since the problem
> existed in 5.5-rc1 release, I'd assumed that the problem wouldn't get
> rectified before 5.5.
>
> However, I decided to bisect the fix, and ended up with: 911bde0f
> ("mac80211: Turn AQL into an NL80211_EXT_FEATURE"), which appears to
> have "solved" the problem by just disabling the feature (this is
> ath9k, by the way.)
>
> This AQL stuff sounds pretty nifty, and I'd love to try my hand at
> making it work for ath9k (also, since I put so much effort into an
> automated build-and-test framework, it'd be a shame to just abandon
> it.)  However, the ath9k code is rather lacking for comments, so I
> don't even know where I should start, except for (I suspect) a call to
> `wiphy_ext_feature_set(whatever, NL80211_EXT_FEATURE_AQL);` from
> inside ath9k_set_hw_capab()?
>
> In the meantime, I went back to e548f749b096 -- the commit prior to
> the one making AQL support opt-in -- and cranked up the debugging.
>
> I'm not sure how to interpret any of this, but  here's what I got:
>
> dmesg output:
>
> Last relevant mention is "moving STA <my AP's MAC> to state 4" which
> happened during startup, before everything shut down.
>
> /sys/kernel/debug/ieee80211/phy0
>
> airtime_flags = 7
>
> stations/<my AP's MAC>/airtime =
>
> RX: 6583578 us
> TX: 32719 us
> Weight: 256
> Deficit: VO: -1128 us VI: 11 us BE: -5098636 us BK: 256 us
> Q depth: VO: 3868 us VI: 3636 us BE: 12284 us BK: 0 us
> Q limit[low/high]: VO: 5000/12000 VI: 5000/12000 BE: 5000/12000 BK: 5000/12000
>
> (I have no idea how to interpret this, but that '32719 us' seems odd,
> I thought the airtime usage was in 4us units?)
>
>
> Doing an 'echo 3 | tee airtime_flags' to clear the (old) AQL-enabled
> bit seemed to *immediately* restore network connectivity.
>
> I ran a ping, and saw this:
>
> - pings coming back in <5ms
> - re-enable AQL (echo 7 | tee airtime_flags)
> - pings stop coming back immediately
> - some seconds later, disable AQL again (echo 3 | tee airtime_flags)
> - immediate *flood* of ping replies registered, with times 16000ms,
> 15000ms, 14000ms, .. down to 1000ms, 15ms, then stabilizing sub-5ms
> - According to the icmp_seq values, all 28 requests were replied to,
> and their replies were delivered in-order
>
> This certainly looks like a missing TX queue restart to me?
>
>
> --
> -- Stevie-O
> Real programmers use COPY CON PROGRAM.EXE
