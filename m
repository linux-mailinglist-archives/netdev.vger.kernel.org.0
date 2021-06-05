Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B5A39C710
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 11:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhFEJ13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 05:27:29 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:30018 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhFEJ12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 05:27:28 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1622885133; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=moOMLLHmGAgJXsDkIEal4LJp8gZwsPk1cVKUc6MusVXojHm1HGfQisy/tkTQIrQXWI
    +PdNQ2wMwyF+w9GyO19LYPO95W3cehou/upL3Fz43xZoDrdkA80rrfiGRMIhYQyg1bM/
    UWSnXwkeh5uCVpI700Xh+i1CN79DiMD1eD7/qAmGU880p5Cw1EOqHXUtzEk5kAyCcrrr
    AYgop131mAZmnmtCDgAsFuDzRxXRF3H6F2uNdZgtyrq+aUEDqFhSSp76T2qKtqi3ZLrK
    8y7Ta+sePUVQC4ctKRoZfqPMVKl3wtSA8PNWAKWDwfuFyfhLKr+c2NQEeLnZcdzS40hs
    bOEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1622885133;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=GabYozNASBnE7dtIOF+VMV7TS49Lpb4nqqO+LYrYhU0=;
    b=rQ2s6Gwk6uTpFnsnkpASP3YKURr+RMelTiUHyox0YeApl6QSk3zsizPOF2tiApFGpv
    +nkgD6D+4R0f3N8M/0P8QrKprvRuFRknRvvujgOxCUpHXONrtOHDEvHa3L4CtDRGLdvm
    ffSuzZHWtwlV0A2u6JYQZGG64uxCj1Zn25V5Fxj2KoKvndcR0wDiEkD/Ja83Y/CRdG6H
    0n2opVZIWu4rIq6XYpgMStQcJTSCmTxWUl2dTf8YUOVcTtqBaB8HWD243XrNmVOhe9ew
    +Ogmn+UhHrtCBfqOaRyswSNaZP4TPSlL+dAHJn2R7qFTptMC8AlGVuhJ2hwthZRNlmSJ
    5TdA==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1622885133;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=GabYozNASBnE7dtIOF+VMV7TS49Lpb4nqqO+LYrYhU0=;
    b=V25tR7AkIWt+W+o55qf3zVB7pQ54LUt27B8w7OMfGeZxE/22BCp44QJDV1CIxwb+tE
    4ga/7VQL6r3bzDL+kQKmatQRzIlWhsOdy6/C6e1ANXrl/2d12SUAEW24/d7ys5e+FyDf
    WNpUJybSQOF4fIPocAwC/VnSPvmwOpfgAp2aZR5A11aBhwXewkriCowyuakHIXW2WWiG
    kxr9/UYUhp+NBtASkpCB9THc/fpRy1cMcs4lL9bt5zJmfWEbw1JUmgTQRLvII3A+DM41
    weCOjgdqgt0xrZ8uWtJ5Fw9sCZ+GPM54W9NC8WC5BydB+cDDuFI0SO9IjLzZhOSB/eT7
    FtcA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u26zEodhPgRDZ8j6IcjHBg=="
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.27.2 DYNA|AUTH)
    with ESMTPSA id y01375x559PWIwr
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sat, 5 Jun 2021 11:25:32 +0200 (CEST)
Date:   Sat, 5 Jun 2021 11:25:27 +0200
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Network Development <netdev@vger.kernel.org>,
        linux-remoteproc@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [RFC] Integrate RPMSG/SMD into WWAN subsystem
Message-ID: <YLtDB2Cz5ttewsFu@gerhold.net>
References: <YLfL9Q+4860uqS8f@gerhold.net>
 <CAMZdPi9tcye-4P4i0uXZcECJ-Big5T11JdvdXW6k2mEEi9XwyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZdPi9tcye-4P4i0uXZcECJ-Big5T11JdvdXW6k2mEEi9XwyA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Loic,

On Fri, Jun 04, 2021 at 11:11:45PM +0200, Loic Poulain wrote:
> On Wed, 2 Jun 2021 at 20:20, Stephan Gerhold <stephan@gerhold.net> wrote:
> > I've been thinking about creating some sort of "RPMSG" driver for the
> > new WWAN subsystem; this would be used as a QMI/AT channel to the
> > integrated modem on some older Qualcomm SoCs such as MSM8916 and MSM8974.
> >
> > It's easy to confuse all the different approaches that Qualcomm has to
> > talk to their modems, so I will first try to briefly give an overview
> > about those that I'm familiar with:
> >
> > ---
> > There is USB and MHI that are mainly used to talk to "external" modems.
> >
> > For the integrated modems in many Qualcomm SoCs there is typically
> > a separate control and data path. They are not really related to each
> > other (e.g. currently no common parent device in sysfs).
> >
> > For the data path (network interface) there is "IPA" (drivers/net/ipa)
> > on newer SoCs or "BAM-DMUX" on some older SoCs (e.g. MSM8916/MSM8974).
> > I have a driver for BAM-DMUX that I hope to finish up and submit soon.
> >
> > The connection is set up via QMI. The messages are either sent via
> > a shared RPMSG channel (net/qrtr sockets in Linux) or via standalone
> > SMD/RPMSG channels (e.g. "DATA5_CNTL" for QMI and "DATA1" for AT).
> >
> > This gives a lot of possible combinations like BAM-DMUX+RPMSG
> > (MSM8916, MSM8974), or IPA+QRTR (SDM845) but also other funny
> > combinations like IPA+RPMSG (MSM8994) or BAM-DMUX+QRTR (MSM8937).
> >
> > Simply put, supporting all these in userspace like ModemManager
> > is a mess (Aleksander can probably confirm).
> > It would be nice if this could be simplified through the WWAN subsystem.
> >
> > It's not clear to me if or how well QRTR sockets can be mapped to a char
> > device for the WWAN subsystem, so for now I'm trying to focus on the
> > standalone RPMSG approach (for MSM8916, MSM8974, ...).
> > ---
> >
> > Currently ModemManager uses the RPMSG channels via the rpmsg-chardev
> > (drivers/rpmsg/rpmsg_char.c). It wasn't my idea to use it like this,
> > I just took that over from someone else. Realistically speaking, the
> > current approach isn't too different from the UCI "backdoor interface"
> > approach that was rejected for MHI...
> >
> > I kind of expected that I can just trivially copy some code from
> > rpmsg_char.c into a WWAN driver since they both end up as a simple char
> > device. But it looks like the abstractions in wwan_core are kind of
> > getting in the way here... As far as I can tell, they don't really fit
> > together with the RPMSG interface.
> >
> > For example there is rpmsg_send(...) (blocking) and rpmsg_trysend(...)
> > (non-blocking) and even a rpmsg_poll(...) [1] but I don't see a way to
> > get notified when the TX queue is full or no longer full so I can call
> > wwan_port_txon/off().
> >
> > Any suggestions or other thoughts?
> 
> It would be indeed nice to get this in the WWAN framework.
> I don't know much about rpmsg but I think it is straightforward for
> the RX path, the ept_cb can simply forward the buffers to
> wwan_port_rx.

Right, that part should be straightforward.

> For tx, simply call rpmsg_trysend() in the wwan tx
> callback and don't use the txon/off helpers. In short, keep it simple
> and check if you observe any issues.
> 

I'm not sure that's a good idea. This sounds like exactly the kind of
thing that might explode later just because I don't manage to get the
TX queue full in my tests. In that case, writing to the WWAN char dev
would not block, even if O_NONBLOCK is not set.

But I think you're right that it's probably easiest if I start with
that, see if I can get anything working at all ...

> And for sure you can propose changes in the WWAN framework if you
> think something is missing to support your specific case.
> 

... and then we can discuss that further on a RFC PATCH or something
like that. Does that sound good to you?

Thanks!
Stephan
