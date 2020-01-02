Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7587312E373
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 08:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgABHxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 02:53:40 -0500
Received: from mail-yw1-f54.google.com ([209.85.161.54]:43169 "EHLO
        mail-yw1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbgABHxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 02:53:39 -0500
Received: by mail-yw1-f54.google.com with SMTP id v126so16929289ywc.10
        for <netdev@vger.kernel.org>; Wed, 01 Jan 2020 23:53:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sa1eTCii+IrC8uZVOeJ+HY4hJ5ZDbDbfl8jfzAJ9Y5E=;
        b=XeBPTLAJzZWOxbzvXL+8zb3r4cO5903yO4GL4MyFXzYraEEqbtGYhktHKqb9R4f5ry
         og+AJ7FxUW445ngAnOmf0jy2wy7fcRWK+4rB+ZzLZ09SMVOeJx+HMyt9cRCAmmY4dvMi
         ShD6Vm0cX+UoWI2H84E1zGAdzyar8ojWBc3Q2ratrzl8JnBBE7iTIZzshaOzcaayqZap
         78tiDAcLSAMKEUrxuAMowgbN5ewoZGF39HlX1Frgpv/lve6kpzsUNNBFHM02Nh+T4+Uv
         muXzRrf95TKkwpBW8dAc4B8FzJnKJsFK2dv3zYRoqQShpca3q0dwDvGiHbrgUWPxejK6
         +RaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sa1eTCii+IrC8uZVOeJ+HY4hJ5ZDbDbfl8jfzAJ9Y5E=;
        b=daOIT2dREW4kuFD4HKWmmIKsqo1MeJ9sF52Ohs0AGhh0Bwd3P6RzdVYUR/2/WDHYIj
         2ubiJf/DTs95ydDYN4kJOGQj+/ib3evjnEQ1gi1u9VFLRYj5AbfoDaAz/kqyKHv5GUpx
         06Vy45KPydD9iaFetghed7aH6oCzh1orS9k5rCTNA7wDQp+hE3lqwDIRw7EZXqmwJice
         2NWPuNYYrJZ9eTQXVdbLORIbOf1OZQ2Xf39T02JwFZzIkRJCzjX3LmHj1w2OfyyVjD5k
         3ztyxmXenzHhcFM2y8S14vfHm+M6hdS2KYQ3hpOdvFfyZFoadURCTZRtwm0TsGNB3nAn
         Ndqw==
X-Gm-Message-State: APjAAAVxjCFet0+B8gRtkqMVVHTiUCjZeNk4Hcw7znGnKrE4O/SArpQN
        EQFAKLGradrytNEaMdXnnrG87fTUT7dHfuQNxzk=
X-Google-Smtp-Source: APXvYqygMbg+ZXuASSLgTWaoMOMzEUh0BtHu4fPzIlcpHOzfkwv5RSMPEOu+IZWdASvmKy/gqr6oluKNrLOCN8aTuIo=
X-Received: by 2002:a81:498c:: with SMTP id w134mr62666448ywa.391.1577951618585;
 Wed, 01 Jan 2020 23:53:38 -0800 (PST)
MIME-Version: 1.0
References: <CAMDZJNVLEEzAwCHZG_8D+CdWQRDRiTeL1N2zj1wQ0jh3vS67rA@mail.gmail.com>
 <CAJ3xEMiqf9-EP0CCAEhhnU3PnvdWpqSR8VbJa=2JFPiHAQwVcw@mail.gmail.com> <CAMDZJNXWG6jkNwub_nenx9FpKJB8PK7VTFj9wiUn+xM7-CfK3w@mail.gmail.com>
In-Reply-To: <CAMDZJNXWG6jkNwub_nenx9FpKJB8PK7VTFj9wiUn+xM7-CfK3w@mail.gmail.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Thu, 2 Jan 2020 09:53:27 +0200
Message-ID: <CAJ3xEMhVZUt-8fOCPBa8mre_=rtj_SN=_B4-7NqH2-NJGQj2LQ@mail.gmail.com>
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

On Thu, Jan 2, 2020 at 5:04 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Wed, Jan 1, 2020 at 4:40 AM Or Gerlitz <gerlitz.or@gmail.com> wrote:
> > On Tue, Dec 31, 2019 at 10:39 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > In one case, we want forward the packets from one PF to otter PF in eswitchdev mode.


>
> > Did you want to say from one uplink to the other uplink? -- this is not supported.
> yes, I try to install one rule and hope that one uplink can forward
> the packets to other uplink of PF.
> But the rule can be installed successfully, and the counter of rule is
> changed as show below:
>
> # tc filter add dev $PF0 protocol all parent ffff: prio 1 handle 1
> flower action mirred egress redirect dev $PF1
>

you didn't ask for skip_sw, if you install a rule with "none" and adding to hw
fails, still the rule is fine in the SW data-path

>
> # tc -d -s filter show dev $PF0 ingress
> filter protocol all pref 1 flower chain 0
> filter protocol all pref 1 flower chain 0 handle 0x1
>   in_hw


this (in_hw) seems to be a bug, we don't support it AFAIK

> action order 1: mirred (Egress Redirect to device enp130s0f1) stolen
>   index 1 ref 1 bind 1 installed 19 sec used 0 sec
>   Action statistics:
> Sent 3206840 bytes 32723 pkt (dropped 0, overlimits 0 requeues 0)
> backlog 0b 0p requeues 0


I think newish (for about a year now or maybe more)  kernels and iproute have
per data-path (SW/HW) rule traffic counters - this would help you
realize what is
going on down there

>
> The PF1 uplink don't sent the packets out(as you say, we don't support it now).
> If we don't support it, should we return -NOSUPPORT when we install
> the hairpin rule between
> uplink of PF, because it makes me confuse.


indeed, but only if you use skip_sw

still the in_hw indication suggests there a driver bug


>
> > What we do support is the following (I think you do it by now):
> > PF0.uplink --> esw --> PF0.VFx --> hairpin --> PF1.VFy --> esw --> PF1.uplink


>
> Yes, I have tested it, and it work fine for us.


cool, so production can keep using these rules..


>
> > Hence the claim here is that if PF0.uplink --> hairpin --> PF1.uplink
> > would have been supported


>
> Did we have plan to support that function.


I don't think so, what is the need? something wrong with N+2 rules as
I suggested?
