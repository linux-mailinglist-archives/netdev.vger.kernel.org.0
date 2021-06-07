Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6888F39DBAE
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 13:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhFGLqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 07:46:20 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.169]:25901 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbhFGLqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 07:46:19 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1623066258; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=o25I3NXYEF6msRfv+uU2SQlrVkm9JpJCOBnwVJe931m2RZPOS06A+g1jWNTlQIP5Br
    J2OftZZenzHid4pTNDBc5WPcwkFeWRT4H0FZO004GtBkuLGnTt8BDNL1EP800g5YHPM1
    9feJWAhNgptm9vayuCc+rL9hDKliCBRxHuxLQNOxTqIwT3X8UAbvMcJMRbB6nON5Yjak
    Sa0IRqfoqdRFgfFEHaP2/6efWwZ3w3Dei9wAlHU3LZrTZ7crbXkEoP3Yx8DKj/E06tqa
    ZnPxYsQpgaft3NWNJW5ys/oVfYPA3lnw9HjA+ODuirb7PwYA2OiwitYKI12xCFUn3Aq6
    aFMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1623066258;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=Vdy9tEfiBAFvvsoNtMx1ub8MckqnBpdQT6Woicrtes8=;
    b=Px2QJZ3A/g45ep6XfZx3rGaqslunXAUWL74cE1FVeZWJQSiahLxsC8zlfp6rRqs3u8
    eklYaTKvIuHze1hOjNSpHdcsp5Qy0apG+P5pyIQ4bRy8Rap2IhjZBTHWuA8zL+xJS71r
    vd664ImeVS4qjXo0w+aNCFpA4Ojkqzy2/vMCY7U/aOjLs5UE9p53LG1oUcHWXaWmIYJR
    g3jIDau5bJ6yir+xFB6rqfLrEuhy9BnosqK6r8YQTI+GWkqwEg3kKJhWacIk5Io+Br7C
    /f4IMQTeZwBKrk40gleCDlQZ3Do8IbkfzbmIUwLitstwJCucZWdCieGxTZEEVPkDHbYj
    mPlA==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1623066258;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=Vdy9tEfiBAFvvsoNtMx1ub8MckqnBpdQT6Woicrtes8=;
    b=KxR+fQdIYS1BYJ21qEH1QYmHXREyNsbNPxB8TLFXr+ll70Bv//k+/hjMSJIyJZpYUC
    vqUmxGyGutsR3xOnQzWvW+6XXIhffbMyWz7HGBVC++RU3PHXSMlwD6F+5G1jD+2I3wMK
    rRBhzwz0hJE9hD4w2n7gGlsvU33hxhsqlN5K1VKmR6XUX5Gj+SRDDirY+Q7riPd69+xe
    ZwgzrpjF9WHODckqsZEmby48kSMx0vj5bW66cuUBnDBaV8oTNVDB+6QigIIpLOMHmfpd
    sW++lXwQGXJQmYFwA3GIkmi2fi/+loNS1lla4ynPpFK87DFnpxTUedVpAseVZ3trUVQY
    HZEQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u26zEodhPgRDZ8j7Ic/BBg=="
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.27.2 DYNA|AUTH)
    with ESMTPSA id y01375x57BiHUEO
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 7 Jun 2021 13:44:17 +0200 (CEST)
Date:   Mon, 7 Jun 2021 13:44:08 +0200
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Network Development <netdev@vger.kernel.org>,
        linux-remoteproc@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [RFC] Integrate RPMSG/SMD into WWAN subsystem
Message-ID: <YL4GiEEcOQC2XrjP@gerhold.net>
References: <YLfL9Q+4860uqS8f@gerhold.net>
 <CAMZdPi9tcye-4P4i0uXZcECJ-Big5T11JdvdXW6k2mEEi9XwyA@mail.gmail.com>
 <YLtDB2Cz5ttewsFu@gerhold.net>
 <CAMZdPi_-Qa=JnThHs_h-144dAfSAjF5s+QdBawdXZ3kk8Mx8ng@mail.gmail.com>
 <YL364+xK3mE2FU8a@gerhold.net>
 <87sg1tvryx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87sg1tvryx.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 01:23:18PM +0200, Toke Høiland-Jørgensen wrote:
> Stephan Gerhold <stephan@gerhold.net> writes:
> > On Mon, Jun 07, 2021 at 11:27:07AM +0200, Loic Poulain wrote:
> >> On Sat, 5 Jun 2021 at 11:25, Stephan Gerhold <stephan@gerhold.net> wrote:
> >> > On Fri, Jun 04, 2021 at 11:11:45PM +0200, Loic Poulain wrote:
> >> > > On Wed, 2 Jun 2021 at 20:20, Stephan Gerhold <stephan@gerhold.net> wrote:
> >> > > > I've been thinking about creating some sort of "RPMSG" driver for the
> >> > > > new WWAN subsystem; this would be used as a QMI/AT channel to the
> >> > > > integrated modem on some older Qualcomm SoCs such as MSM8916 and MSM8974.
> >> > > >
> >> > > > It's easy to confuse all the different approaches that Qualcomm has to
> >> > > > talk to their modems, so I will first try to briefly give an overview
> >> > > > about those that I'm familiar with:
> >> > > >
> >> > > > ---
> >> > > > There is USB and MHI that are mainly used to talk to "external" modems.
> >> > > >
> >> > > > For the integrated modems in many Qualcomm SoCs there is typically
> >> > > > a separate control and data path. They are not really related to each
> >> > > > other (e.g. currently no common parent device in sysfs).
> >> > > >
> >> > > > For the data path (network interface) there is "IPA" (drivers/net/ipa)
> >> > > > on newer SoCs or "BAM-DMUX" on some older SoCs (e.g. MSM8916/MSM8974).
> >> > > > I have a driver for BAM-DMUX that I hope to finish up and submit soon.
> >> > > >
> >> > > > The connection is set up via QMI. The messages are either sent via
> >> > > > a shared RPMSG channel (net/qrtr sockets in Linux) or via standalone
> >> > > > SMD/RPMSG channels (e.g. "DATA5_CNTL" for QMI and "DATA1" for AT).
> >> > > >
> >> > > > This gives a lot of possible combinations like BAM-DMUX+RPMSG
> >> > > > (MSM8916, MSM8974), or IPA+QRTR (SDM845) but also other funny
> >> > > > combinations like IPA+RPMSG (MSM8994) or BAM-DMUX+QRTR (MSM8937).
> >> > > >
> >> > > > Simply put, supporting all these in userspace like ModemManager
> >> > > > is a mess (Aleksander can probably confirm).
> >> > > > It would be nice if this could be simplified through the WWAN subsystem.
> >> > > >
> >> > > > It's not clear to me if or how well QRTR sockets can be mapped to a char
> >> > > > device for the WWAN subsystem, so for now I'm trying to focus on the
> >> > > > standalone RPMSG approach (for MSM8916, MSM8974, ...).
> >> > > > ---
> >> > > >
> >> > > > Currently ModemManager uses the RPMSG channels via the rpmsg-chardev
> >> > > > (drivers/rpmsg/rpmsg_char.c). It wasn't my idea to use it like this,
> >> > > > I just took that over from someone else. Realistically speaking, the
> >> > > > current approach isn't too different from the UCI "backdoor interface"
> >> > > > approach that was rejected for MHI...
> >> > > >
> >> > > > I kind of expected that I can just trivially copy some code from
> >> > > > rpmsg_char.c into a WWAN driver since they both end up as a simple char
> >> > > > device. But it looks like the abstractions in wwan_core are kind of
> >> > > > getting in the way here... As far as I can tell, they don't really fit
> >> > > > together with the RPMSG interface.
> >> > > >
> >> > > > For example there is rpmsg_send(...) (blocking) and rpmsg_trysend(...)
> >> > > > (non-blocking) and even a rpmsg_poll(...) [1] but I don't see a way to
> >> > > > get notified when the TX queue is full or no longer full so I can call
> >> > > > wwan_port_txon/off().
> >> > > >
> >> > > > Any suggestions or other thoughts?
> >> > >
> >> > > It would be indeed nice to get this in the WWAN framework.
> >> > > I don't know much about rpmsg but I think it is straightforward for
> >> > > the RX path, the ept_cb can simply forward the buffers to
> >> > > wwan_port_rx.
> >> >
> >> > Right, that part should be straightforward.
> >> >
> >> > > For tx, simply call rpmsg_trysend() in the wwan tx
> >> > > callback and don't use the txon/off helpers. In short, keep it simple
> >> > > and check if you observe any issues.
> >> > >
> >> >
> >> > I'm not sure that's a good idea. This sounds like exactly the kind of
> >> > thing that might explode later just because I don't manage to get the
> >> > TX queue full in my tests. In that case, writing to the WWAN char dev
> >> > would not block, even if O_NONBLOCK is not set.
> >> 
> >> Right, if you think it could be a problem, you can always implement a
> >> more complex solution like calling rpmsg_send from a
> >> workqueue/kthread, and only re-enable tx once rpmsg_send returns.
> >> 
> >
> > I did run into trouble when I tried to stream lots of data into the WWAN
> > char device (e.g. using dd). However, in practice (with ModemManager) 
> > I did not manage to cause such issues yet. Personally, I think it's
> > something we should get right, just to avoid trouble later
> > (like "modem suddenly stops working").
> >
> > Right now I extended the WWAN port ops a bit so I tells me if the write
> > should be non-blocking or blocking and so I can call rpmsg_poll(...).
> >
> > But having some sort of workqueue also sounds like it could work quite
> > well, thanks for the suggestion! Will think about it some more, or
> > I might post what I have right now so you can take a look.
> 
> How big are those hardware TXQs? Just pushing packets to the hardware
> until it overflows sounds like a recipe for absolutely terrible
> bufferbloat... That would be bad!
> 

For reference, we're not really talking about "hardware" TXQs here.
As far as I understand, the RPMSG channels on Qualcomm devices are
mostly just a firmware convention for communicating between different
CPUs/DSPs via shared memory.

The packets are copied into some kind of shared FIFO/ring buffer
per channel, with varying sizes. On my test device, the firmware
allcates 1024 bytes for the QMI channel and 8192 bytes
for the AT channel.

I'm not sure how this would cause any kind of overflow/bufferbloat.
The remote side (e.g. modem DSP) is notified separately for every packet
that is sent. If we're really writing more quickly than the remote side
will read, rpmsg_send() will block and therefore the client will
block as well (since tx was disabled before calling rpmsg_send()).

Thanks,
Stephan
