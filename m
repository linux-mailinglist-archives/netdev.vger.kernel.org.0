Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 497F5B755B
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 10:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731572AbfISImy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 04:42:54 -0400
Received: from mail-ed1-f41.google.com ([209.85.208.41]:34762 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731499AbfISImy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 04:42:54 -0400
Received: by mail-ed1-f41.google.com with SMTP id p10so2455885edq.1
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 01:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OSHWLgbheDlCjHoVSKm4svWfI9bBPQFVWr5prjfMRig=;
        b=Zg8ECe5R2uRmExYUXgSu6NkhOM3cxSZGcq6CwUHLxj1R6k4NxyC7roTY5DimjGqwog
         2lel/NpRFsxSzmxYxJe2nj26tcfU/9Qf7HvNLJciVxvD8ZJfcKFOI6P1UWG+b4TxHOqu
         zvX2VVghL35dmcoCEIGxzCepFN29yjnor5p6A4xwaWFpZJgigO67/KCvZ7tpoC4W8s1Q
         7k0dNHG3HGzZ+jctuQYidyL2MPya7xgHOHfUi/mbhcHCWltmiL/WO/Wurd047o5n47Ve
         sG1tQA2UHOUtceLx35Px71O7Ccpy9MjPKootPENqpwtZpPly22R/+e02Y4vHqgfibc5l
         /YrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OSHWLgbheDlCjHoVSKm4svWfI9bBPQFVWr5prjfMRig=;
        b=EEHZOmXsvwqNSxMiGU2Oy3+UHGem3HcjD0/H0cDkrrP6ddt9SW6DGQeEpBUGglOH88
         Po26fhU2UVBRv4C3qVymk2l68jJ9XfH3xBAfU8pwRCcJSvp9UTO/EhHO55Wi3D6dFajw
         Gkhz2BRUUaYZG9ZKuEd77BDmldgwsOgDY65bKp0oCRQ1j+YBj1nYihqOH5LZZ0kgmYIK
         LklCFbTqynXQczwtBkNiRWDE6ezUdetfoNMW6r5zSmhCLK07BL3K+TGqwwBXJNGudtux
         s/YK5F5ul7rSPMzx17kHVaDv8OFb1gOOdYfWeAXI4ZmAQY5fkskYtgQFfx0cSF3Zmtr7
         pB5w==
X-Gm-Message-State: APjAAAUwkBgO5NcI49zGPfnNSmFTDTit3rLY/NMpiua/YXJeNqCgU46O
        g/XMC4rfV2Wa+eEsGYm/hFyfkGY/HrBniu2Pdig=
X-Google-Smtp-Source: APXvYqzNXOW/p63mOaPwb90H4wPKPkfK3m/DxwZAndDDPCzawHUaxMZ4VvhlJBigEo+nS6yyU3qVaxmbnZWpuiIvBAA=
X-Received: by 2002:a05:6402:35b:: with SMTP id r27mr13539859edw.140.1568882572649;
 Thu, 19 Sep 2019 01:42:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190918140225.imqchybuf3cnknob@pengutronix.de>
 <CA+h21hpG52R6ScGpGX86Q7MuRHCgGNY-TxzaQGu2wZR8EtPtbA@mail.gmail.com>
 <20190919080051.mr3cszpyypwqjwu4@pengutronix.de> <20190919083638.wgxrrgtqxwpjcsu3@pengutronix.de>
In-Reply-To: <20190919083638.wgxrrgtqxwpjcsu3@pengutronix.de>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 19 Sep 2019 11:42:41 +0300
Message-ID: <CA+h21hrca8dhtr4CD2KaXRgAY5TVco_ijUx_+5Z=EM5DgYrTBQ@mail.gmail.com>
Subject: Re: dsa traffic priorization
To:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Florian Fainelli <f.fainelli@gmail.com>, kernel@pengutronix.de,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Uwe,

On Thu, 19 Sep 2019 at 11:36, Uwe Kleine-K=C3=B6nig
<u.kleine-koenig@pengutronix.de> wrote:
>
> On Thu, Sep 19, 2019 at 10:00:51AM +0200, Sascha Hauer wrote:
> > Hi Vladimir,
> >
> > On Wed, Sep 18, 2019 at 05:36:08PM +0300, Vladimir Oltean wrote:
> > > Hi Sascha,
> > >
> > > On Wed, 18 Sep 2019 at 17:03, Sascha Hauer <s.hauer@pengutronix.de> w=
rote:
> > > >
> > > > Hi All,
> > > >
> > > > We have a customer using a Marvell 88e6240 switch with Ethercat on =
one port and
> > > > regular network traffic on another port. The customer wants to conf=
igure two things
> > > > on the switch: First Ethercat traffic shall be priorized over other=
 network traffic
> > > > (effectively prioritizing traffic based on port). Second the ethern=
et controller
> > > > in the CPU is not able to handle full bandwidth traffic, so the tra=
ffic to the CPU
> > > > port shall be rate limited.
> > > >
> > >
> > > You probably already know this, but egress shaping will not drop
> > > frames, just let them accumulate in the egress queue until something
> > > else happens (e.g. queue occupancy threshold triggers pause frames, o=
r
> > > tail dropping is enabled, etc). Is this what you want?
> >
> > If I understand correctly then the switch has multiple output queues pe=
r
> > port. The Ethercat traffic will go to a higher priority queue and on
> > congestion on other queues, frames designated for that queue will be
> > dropped. I just talked to our customer and he verified that their
> > Ethercat traffic still goes through even when the ports with the genera=
l
> > traffic are jammed with packets. So yes, I think this is what I want.
>
> Moreover egressing the cpu port has the advantage that network
> participants on other ports that might be able to process packet quicker
> are not limited.
>

Yes, that is true if you apply port-based policers (matchall), but not
necessarily so if your switch is able to do ingress classification (a
common key for switches being the {DMAC, VLAN} pair). Again, there is
a model for configuring even that, if the hardware is capable. Just
not for egress shaping on the CPU port.


> Best regards
> Uwe
>
> --
> Pengutronix e.K.                           | Uwe Kleine-K=C3=B6nig       =
     |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  =
|
