Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D2E39DA4A
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 12:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhFGK4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 06:56:33 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:26085 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhFGK4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 06:56:32 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1623063273; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=U2IUTV4H2dq/GOzdZ1PFhSHiW/DFDHabhUWoHotRiSopxeSxdD3CknsWYjXK/iyJ5d
    g0tUFLDAtEGdsJJih0mKnMqOOITAnt+2tMmWNyLtULLvgcgG3qrcgrO+JZvmWNKeVeZR
    Zw3p5j4QzPSOSec9y/6V91ZVYvtE5HV+k17dI1uWo7TfN4nU/EBgcbsLzU/i+imgpssX
    IHMpB2hqqfPKV7DDOZFAi/WcoEW5RoGsxiLuDUzgnCoKmjFoxGWanGm0cpKFaHfCP2O5
    vOLFBEMzff7Z/ZfbdOMvnNBbMY6F0e+RkTz1UDJYN+FiiyoNsGnW0pnafcMkJdPtqUOD
    MUFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1623063273;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=hdm4hBggGM17oX9y9jwL4+IJ8JgrHVXkX3Pxwr0GLLs=;
    b=llKxed79twSurxjLYd+XhpLK+3gwVXUr2LjUEkXsRT6QxVLFha+kC1ayfyEdCKzaP5
    XkSmH9ZEOln+9CucDNWkJZgwraYOWpc4BjwpAbnSdRDcqS40NaceH0PghFATNcq7E3oZ
    dAByynKkLSDY0+LBo2L8wamPavUxmmNxM0sRVwlOw2W/oee9MBLB37WfEp7GToypxByC
    b0MpNVUeUnJPvYOcX979gI04zqrC8iI0tqQt0c2S/bTHq6USlN3aA+5xPdd2WVUkLOph
    r7Yqcy6tTIZ2XS19uJBeeQqwt/1n5nxZDvnYPraABv5WcJdvCIehBapcH+6nh06Xyfg1
    HSLg==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1623063273;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=hdm4hBggGM17oX9y9jwL4+IJ8JgrHVXkX3Pxwr0GLLs=;
    b=K1Wv6NVTRhrYMo3X9PrgJkrYiuG5gNRC3xJwxdeb4qRSmV+7FHgMS4E+3k/FnMvtFQ
    naha4v4dJ9qZkH5wZx1Sgju9/NG9QxVv5qLoNumhtPP4Fo2JcKF9cJPFj7dWPD/fX8oB
    cjo0FApUYcHA/ZLoZBFbmu8Dkz1Pod16mHJI50LNKTfHewTVTVCp39p90CXK+ucWx29+
    K5IMSYBSgtDHXSR8L9GYdHv3vuJm/TqI3tOE7vVtmrbx7uHL6vt/sXr0qEV5wsauvMdQ
    DVPlD7YouK6AubTlwK/J5vuRx1/56A03C30q2psP5A3yik2Vzl9dLTjkqkY4+8EgWhLz
    m88g==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u26zEodhPgRDZ8j7Ic/BBg=="
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.27.2 DYNA|AUTH)
    with ESMTPSA id y01375x57AsWTsN
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 7 Jun 2021 12:54:32 +0200 (CEST)
Date:   Mon, 7 Jun 2021 12:54:27 +0200
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
Message-ID: <YL364+xK3mE2FU8a@gerhold.net>
References: <YLfL9Q+4860uqS8f@gerhold.net>
 <CAMZdPi9tcye-4P4i0uXZcECJ-Big5T11JdvdXW6k2mEEi9XwyA@mail.gmail.com>
 <YLtDB2Cz5ttewsFu@gerhold.net>
 <CAMZdPi_-Qa=JnThHs_h-144dAfSAjF5s+QdBawdXZ3kk8Mx8ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZdPi_-Qa=JnThHs_h-144dAfSAjF5s+QdBawdXZ3kk8Mx8ng@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Loic,

On Mon, Jun 07, 2021 at 11:27:07AM +0200, Loic Poulain wrote:
> On Sat, 5 Jun 2021 at 11:25, Stephan Gerhold <stephan@gerhold.net> wrote:
> > On Fri, Jun 04, 2021 at 11:11:45PM +0200, Loic Poulain wrote:
> > > On Wed, 2 Jun 2021 at 20:20, Stephan Gerhold <stephan@gerhold.net> wrote:
> > > > I've been thinking about creating some sort of "RPMSG" driver for the
> > > > new WWAN subsystem; this would be used as a QMI/AT channel to the
> > > > integrated modem on some older Qualcomm SoCs such as MSM8916 and MSM8974.
> > > >
> > > > It's easy to confuse all the different approaches that Qualcomm has to
> > > > talk to their modems, so I will first try to briefly give an overview
> > > > about those that I'm familiar with:
> > > >
> > > > ---
> > > > There is USB and MHI that are mainly used to talk to "external" modems.
> > > >
> > > > For the integrated modems in many Qualcomm SoCs there is typically
> > > > a separate control and data path. They are not really related to each
> > > > other (e.g. currently no common parent device in sysfs).
> > > >
> > > > For the data path (network interface) there is "IPA" (drivers/net/ipa)
> > > > on newer SoCs or "BAM-DMUX" on some older SoCs (e.g. MSM8916/MSM8974).
> > > > I have a driver for BAM-DMUX that I hope to finish up and submit soon.
> > > >
> > > > The connection is set up via QMI. The messages are either sent via
> > > > a shared RPMSG channel (net/qrtr sockets in Linux) or via standalone
> > > > SMD/RPMSG channels (e.g. "DATA5_CNTL" for QMI and "DATA1" for AT).
> > > >
> > > > This gives a lot of possible combinations like BAM-DMUX+RPMSG
> > > > (MSM8916, MSM8974), or IPA+QRTR (SDM845) but also other funny
> > > > combinations like IPA+RPMSG (MSM8994) or BAM-DMUX+QRTR (MSM8937).
> > > >
> > > > Simply put, supporting all these in userspace like ModemManager
> > > > is a mess (Aleksander can probably confirm).
> > > > It would be nice if this could be simplified through the WWAN subsystem.
> > > >
> > > > It's not clear to me if or how well QRTR sockets can be mapped to a char
> > > > device for the WWAN subsystem, so for now I'm trying to focus on the
> > > > standalone RPMSG approach (for MSM8916, MSM8974, ...).
> > > > ---
> > > >
> > > > Currently ModemManager uses the RPMSG channels via the rpmsg-chardev
> > > > (drivers/rpmsg/rpmsg_char.c). It wasn't my idea to use it like this,
> > > > I just took that over from someone else. Realistically speaking, the
> > > > current approach isn't too different from the UCI "backdoor interface"
> > > > approach that was rejected for MHI...
> > > >
> > > > I kind of expected that I can just trivially copy some code from
> > > > rpmsg_char.c into a WWAN driver since they both end up as a simple char
> > > > device. But it looks like the abstractions in wwan_core are kind of
> > > > getting in the way here... As far as I can tell, they don't really fit
> > > > together with the RPMSG interface.
> > > >
> > > > For example there is rpmsg_send(...) (blocking) and rpmsg_trysend(...)
> > > > (non-blocking) and even a rpmsg_poll(...) [1] but I don't see a way to
> > > > get notified when the TX queue is full or no longer full so I can call
> > > > wwan_port_txon/off().
> > > >
> > > > Any suggestions or other thoughts?
> > >
> > > It would be indeed nice to get this in the WWAN framework.
> > > I don't know much about rpmsg but I think it is straightforward for
> > > the RX path, the ept_cb can simply forward the buffers to
> > > wwan_port_rx.
> >
> > Right, that part should be straightforward.
> >
> > > For tx, simply call rpmsg_trysend() in the wwan tx
> > > callback and don't use the txon/off helpers. In short, keep it simple
> > > and check if you observe any issues.
> > >
> >
> > I'm not sure that's a good idea. This sounds like exactly the kind of
> > thing that might explode later just because I don't manage to get the
> > TX queue full in my tests. In that case, writing to the WWAN char dev
> > would not block, even if O_NONBLOCK is not set.
> 
> Right, if you think it could be a problem, you can always implement a
> more complex solution like calling rpmsg_send from a
> workqueue/kthread, and only re-enable tx once rpmsg_send returns.
> 

I did run into trouble when I tried to stream lots of data into the WWAN
char device (e.g. using dd). However, in practice (with ModemManager) 
I did not manage to cause such issues yet. Personally, I think it's
something we should get right, just to avoid trouble later
(like "modem suddenly stops working").

Right now I extended the WWAN port ops a bit so I tells me if the write
should be non-blocking or blocking and so I can call rpmsg_poll(...).

But having some sort of workqueue also sounds like it could work quite
well, thanks for the suggestion! Will think about it some more, or
I might post what I have right now so you can take a look.

> >
> > But I think you're right that it's probably easiest if I start with
> > that, see if I can get anything working at all ...
> >
> > > And for sure you can propose changes in the WWAN framework if you
> > > think something is missing to support your specific case.
> > >
> >
> > ... and then we can discuss that further on a RFC PATCH or something
> > like that. Does that sound good to you?
> 
> Yes, you can submit the series, no need to be RFC IMHO, this thread is
> already your RFC.
> 

I kind of see "RFC" like a "I'm not sure if the approach taken here is
really a good idea" and my current patch set currently still fits that
criteria. But at the end it's just a strange prefix for the mail subject
so it shouldn't matter too much. :)

Thanks!
Stephan
