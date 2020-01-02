Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45AEB12E47D
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 10:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgABJi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 04:38:59 -0500
Received: from mail-yw1-f43.google.com ([209.85.161.43]:44599 "EHLO
        mail-yw1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727924AbgABJi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 04:38:59 -0500
Received: by mail-yw1-f43.google.com with SMTP id t141so17001740ywc.11
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 01:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Qgmw8Kqn8yIv6Odwfi6gr+AMOkWZuAH5N6bnIcc04I=;
        b=VqkEfxj4avpr5IFEYocYAt2JLSgCY1L2xx2epsYf2uch2pQQbEYKEPYnhNzt0zw1C3
         sfuyf5thbu37RKuYh/Intl5fRTyaX73hwlilCKARI4yUmJO8m74ZR9PcFuKoCUO/6a0e
         q0EDrXM6yRIVLEyYA9o9OxXaIq7sFl0fCm3gi1yqasj/oEj/zLQTl+GC0wUTHvP15llr
         O+mzBKIYLxj7M1ipPTtKbb8HoBnb8UOL099umHx8jcbHAxYVfhI1RF7JHHfFMzBWLjct
         qVJDbkAalFIfMUImEM3T5MGrRgqvFqpaTU1V4TLtNUuvCpzYTeA6ZYX+73dPvMotE+NX
         GQGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Qgmw8Kqn8yIv6Odwfi6gr+AMOkWZuAH5N6bnIcc04I=;
        b=LcF4KtVYyR1M1KUHMqy+VfdqKaO+Qh0D+SjC3fTWNgWSs4FOgsyN9HKPcoCofXwaOO
         9EiqkyiBfd0+0mNfYd1d3HVTXIipQY6ZQ/lEPvP5ev637W3awjOneEdnBAlZGpxLBV7R
         YvvXbPzHhDTjpAkSwtQx4UyGshuKsgx0jrjuUFHtvNahVdPbVHUDPp05tY+TLat2Fp41
         WrJq7Yp3S5UzpW8g+qfGMaZYjnXDDDdtCKz7FxRnw+/zHvNxkRk6rAyZkI3/NFRAlQgv
         DGggZKBsEmQCldPOZoNZePsZQjT0EqtidbyNN9A8QPsvtgmdVo6szIO2VteGC6kQK7cH
         MzrA==
X-Gm-Message-State: APjAAAWBeZJIbTz5cNF0v96+iydCRstrNYEeZeIiRRJEki5SuHdFb1pS
        bl8JzUNlDCo+InDSNLMH5TQ5rm19bHbdDyj4I5k=
X-Google-Smtp-Source: APXvYqwUOP70VIMQDQ/6ilOuSekdBNT99n4FNkIVCVcy2lzMc2sjR9xoX7B43Bz+eH2w3zOoGT2bnknvNrnXcASAeiA=
X-Received: by 2002:a0d:e8ce:: with SMTP id r197mr60914206ywe.500.1577957938171;
 Thu, 02 Jan 2020 01:38:58 -0800 (PST)
MIME-Version: 1.0
References: <CAMDZJNVLEEzAwCHZG_8D+CdWQRDRiTeL1N2zj1wQ0jh3vS67rA@mail.gmail.com>
 <CAJ3xEMiqf9-EP0CCAEhhnU3PnvdWpqSR8VbJa=2JFPiHAQwVcw@mail.gmail.com>
 <CAMDZJNXWG6jkNwub_nenx9FpKJB8PK7VTFj9wiUn+xM7-CfK3w@mail.gmail.com>
 <CAJ3xEMgXvxkmxNcfK-hFDWEu1qW7o7+FBhyGf3YGgr5dPK=Ddg@mail.gmail.com> <CAMDZJNVN8SuumcwOZZsgGDP-_-BX9K4sGC7-sbC3jypstrMXpQ@mail.gmail.com>
In-Reply-To: <CAMDZJNVN8SuumcwOZZsgGDP-_-BX9K4sGC7-sbC3jypstrMXpQ@mail.gmail.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Thu, 2 Jan 2020 11:38:47 +0200
Message-ID: <CAJ3xEMid-R-3rFtuTEpwf8=AYgon2yNEvctAupucUE58qNMRWA@mail.gmail.com>
Subject: Re: mlx5e question about PF fwd packets to PF
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Saeed Mahameed <saeedm@dev.mellanox.co.il>,
        Roi Dayan <roid@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 2, 2020 at 11:32 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> On Thu, Jan 2, 2020 at 3:50 PM Or Gerlitz <gerlitz.or@gmail.com> wrote:
> > On Thu, Jan 2, 2020 at 5:04 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> >> On Wed, Jan 1, 2020 at 4:40 AM Or Gerlitz <gerlitz.or@gmail.com> wrote:
> >> > On Tue, Dec 31, 2019 at 10:39 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:

> I add "skip_sw" option in tc command, and update the tc version to
> upstream, it run successfully:
> # tc filter add dev $PF0 protocol all parent ffff: prio 1 handle 1
> flower skip_sw action mirred egress redirect dev $PF1
> # tc -d -s filter show dev $PF0 ingress
> filter protocol all pref 1 flower chain 0
> filter protocol all pref 1 flower chain 0 handle 0x1
>   skip_sw
>   in_hw in_hw_count 1

As I said, in_hw seems like a bug

> action order 1: mirred (Egress Redirect to device enp130s0f1) stolen
>   index 1 ref 1 bind 1 installed 42 sec used 0 sec
>   Action statistics:
> Sent 408954 bytes 4173 pkt (dropped 0, overlimits 0 requeues 0)
> Sent software 0 bytes 0 pkt
> Sent hardware 408954 bytes 4173 pkt
> backlog 0b 0p requeues 0

> > I don't think so, what is the need? something wrong with N+2 rules as I suggested?

> N+2 works fine.

good!

> I do some research about ovs offload with mellanox nic.

cool

> I add the uplink of PF0 and PF1 to ovs. and it can offload the
> rule(PF0 to PF1, I reproduce with tc commands) to hardware but the nic
> can't send the packet out.

we don't offload that and should return error on the tc command
