Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA28712E1D1
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 04:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbgABDE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jan 2020 22:04:26 -0500
Received: from mail-lj1-f172.google.com ([209.85.208.172]:39455 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727525AbgABDE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jan 2020 22:04:26 -0500
Received: by mail-lj1-f172.google.com with SMTP id l2so39418675lja.6
        for <netdev@vger.kernel.org>; Wed, 01 Jan 2020 19:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=No0w7DnojZ/t4DhNe0vKJFQzQ30+UJs07dkzQKDkybQ=;
        b=EEeuXNe79O7ejaTfiY8xERjRANOmPIjEyY5G9dy7B3OtUUsqBZsc8ZJIHL5mJCD6CK
         a0ICqdOFL89WDFONVMAj4hHK7Nl1ySKd6d3l3NfvVso+ZbAVJaI3UTHUEvDzBiBAF8MN
         pVTB3uh7/NfRIglVjSWsS+JZ92AhVBElb3GbHBU60iLFA85ATC2QqESxchz+998ur4mo
         14/K+nCg/mUpVMQaAiZyxQeJdVxT2WQmBGq4CyYx/0UelO2VtX744JXbzOMCBsDsZaKn
         aixOHJGcuy20sTULyFfwQpcsehDahMEmA35KWUCig0pb+aKxU8qzK5afi+Fp0BNlqGJp
         tpAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=No0w7DnojZ/t4DhNe0vKJFQzQ30+UJs07dkzQKDkybQ=;
        b=iDoQ1mZlQ1T9KN45TmzHMqLQLWdToU2Stcx6bu86EAuqxYwtlF/2eznajj/U0dNE1G
         OBWfY0Ht8jDzxtVDUxrTlNtgV0ZcfrnDyUsz+rz6dAVGAqfhtTv9P+rsAqLEsACrXns/
         emc5k+/eKtXBp7NrJySc5rv3VP35VC9GmQMD+MyZqJWB0lurcvcD6aO9yqLNmjr0teFu
         8v/Pc8LRT7Aehtan9Gih2IrCznJnhbtwSEgU0qDoc5pa3XWuiFmya6BtKAoPWtgfNokA
         p5GDwfZIwtH85FwBdMWG8AWjleJcYmlOHHYNXlrADEsT0MS/pKpLycTviSNRTB1W/a2G
         w46g==
X-Gm-Message-State: APjAAAVah3KcuL0HMUJphYA2H/BOtK9n3AJ28xxdu6Sx1ae4LHJslDIx
        nTJgR66124fldGBRJu7x+rUeJCFghPVNxW+5zu8=
X-Google-Smtp-Source: APXvYqznFRwlirVxmrOTHGfWvF2ByO70G0zOWeoRIE493mkU5AMFAj5KCTbZ7sOQZnFPe/ooIQMfjfSAnLvAsWVcswY=
X-Received: by 2002:a2e:7c08:: with SMTP id x8mr40419904ljc.185.1577934264269;
 Wed, 01 Jan 2020 19:04:24 -0800 (PST)
MIME-Version: 1.0
References: <CAMDZJNVLEEzAwCHZG_8D+CdWQRDRiTeL1N2zj1wQ0jh3vS67rA@mail.gmail.com>
 <CAJ3xEMiqf9-EP0CCAEhhnU3PnvdWpqSR8VbJa=2JFPiHAQwVcw@mail.gmail.com>
In-Reply-To: <CAJ3xEMiqf9-EP0CCAEhhnU3PnvdWpqSR8VbJa=2JFPiHAQwVcw@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Thu, 2 Jan 2020 11:03:47 +0800
Message-ID: <CAMDZJNXWG6jkNwub_nenx9FpKJB8PK7VTFj9wiUn+xM7-CfK3w@mail.gmail.com>
Subject: Re: mlx5e question about PF fwd packets to PF
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Saeed Mahameed <saeedm@dev.mellanox.co.il>,
        Roi Dayan <roid@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 1, 2020 at 4:40 AM Or Gerlitz <gerlitz.or@gmail.com> wrote:
>
> On Tue, Dec 31, 2019 at 10:39 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> > In one case, we want forward the packets from one PF to otter PF in eswitchdev mode.
>
> Did you want to say from one uplink to the other uplink? -- this is
> not supported.
yes, I try to install one rule and hope that one uplink can forward
the packets to other uplink of PF.
But the rule can be installed successfully, and the counter of rule is
changed as show below:

# tc filter add dev $PF0 protocol all parent ffff: prio 1 handle 1
flower action mirred egress redirect dev $PF1

# tc -d -s filter show dev $PF0 ingress
filter protocol all pref 1 flower chain 0
filter protocol all pref 1 flower chain 0 handle 0x1
  in_hw
action order 1: mirred (Egress Redirect to device enp130s0f1) stolen
  index 1 ref 1 bind 1 installed 19 sec used 0 sec
  Action statistics:
Sent 3206840 bytes 32723 pkt (dropped 0, overlimits 0 requeues 0)
backlog 0b 0p requeues 0

The PF1 uplink don't sent the packets out(as you say, we don't support it now).
If we don't support it, should we return -NOSUPPORT when we install
the hairpin rule between
uplink of PF, because it makes me confuse.
> What we do support is the following (I think you do it by now):
>
> PF0.uplink --> esw --> PF0.VFx --> hairpin --> PF1.VFy --> esw --> PF1.uplink
Yes, I have tested it, and it work fine for us.
> Hairpin is an offload for SW gateway, SW gateway is an **application** that runs
> over two NIC ports -- we allow them to be virtual NIC ports  -- PF0.VFx/PF1.VFy
>
> since e-switch != (SW) gateway --> eswitch offload != (SW) gateway offload
>
> note that steering rules ## (wise)
>
> PF0.uplink --> T1 --> PF0.VFx --> T2 --> PF1.VFy --> T3 --> PF1.uplink
>
> since you use instantiate eswitch on the system, T(ype)1 and T(ype)3 rules
> are ones that differentiate packets that belong to this GW. But, T(ype)2 rules,
> can be just "fwd everything" -- TC wise, you can even mask out the ethertype,
> just a tc/flower rules that fwd everything from ingress PF0.VFx vNIC
> to egress  PF1.VFy vNIC.
>
> Further, you can also you this match-all (but with flower..) rule for
> the PF1.VFy --> PF1.uplink
> part of the chain since you know that everything that originates in
> this VF should go to the uplink.
>
> Hence the claim here is that if PF0.uplink --> hairpin --> PF1.uplink
> would have been
> supported
Did we have plan to support that function.
> and the system had N steering rules, with what is currently
> supported you
> need N+2 rules -- N rules + one T2 rule and one T3 rul
