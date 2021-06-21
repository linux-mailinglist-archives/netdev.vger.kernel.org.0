Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703553AF9CC
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 01:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbhFUXzH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Jun 2021 19:55:07 -0400
Received: from mail-lf1-f45.google.com ([209.85.167.45]:45778 "EHLO
        mail-lf1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231975AbhFUXzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 19:55:06 -0400
Received: by mail-lf1-f45.google.com with SMTP id h15so14403589lfv.12;
        Mon, 21 Jun 2021 16:52:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gM1NbWrrOsqRjUDgYgaF83U/I/mSj3Z9D72CMu8OqMg=;
        b=De9ehrrTf4PqBCAyaREYd83aKzNsoVZ8ptnlZOu2me+/HQYrVxSJRK+oedNM48TfVk
         z/ocolNkLUy5/ZNaW4HYi6ThjbtTdrrQkC4BFLR6Bdtx2CkpXWIrOHe3WIMPl+3Hw0P4
         PtFku29q6zOhlavkDs5SFAPpwszT0K2Rvyf5RKwJYxx9encw4gG1iNPf2UbM+HOLVBiJ
         usQ/tOW4HlWn/7KKrLH75pMJh9Fzzx1dPFcYfDatLMg6NopPmtBbojy/qu7Nix1mt9VJ
         3xKp8eEievehZzm2gGi9RY6hmkYQGd2/9SQkfWjnaTB+Xb4Z4k34H7ESlx5/ptfoWvHD
         zvrg==
X-Gm-Message-State: AOAM532pDUyAy5J6DUq0FIu7AZ7Cn/0vlSdVTUZbXuUbTw1bAi/tdtY6
        rbxuf2jbjzF8xJV6Zq/xo1LVl6ce1dQIlumrjs4=
X-Google-Smtp-Source: ABdhPJyY9IaX5smHbLkInGa5Y1jq0LaYdjkSOHXVOXYe4GI/+cfpLvNVUvUGJqzWAzV5RCDU/Ww5aEnjdDwT+lraXhM=
X-Received: by 2002:a05:6512:4c3:: with SMTP id w3mr608746lfq.594.1624319568990;
 Mon, 21 Jun 2021 16:52:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210603151550.140727-1-mailhol.vincent@wanadoo.fr>
 <20210603151550.140727-3-mailhol.vincent@wanadoo.fr> <20210618093424.xohvsqaaq5qf2bjn@pengutronix.de>
 <CAMZ6RqJn5z-9PfkcJdiS6aG+qCPnifXDwH26ZEwo8-=id=TXbw@mail.gmail.com>
 <CAMZ6RqKrPQkPy-dAiQjAB4aKnqeaNx+L-cro8F_mc2VPgOD4Jw@mail.gmail.com>
 <20210618124447.47cy7hyqp53d4tjh@pengutronix.de> <CAMZ6RqJCZB6Q79JYfxD7PGboPwMndDQRKsuUEk5Q34fj2vOcYg@mail.gmail.com>
 <e90cbad2467e2ef42db1e4a14ecdfd8c512965ea.camel@esd.eu> <CAMZ6RqJphchOBFudyuVcN+imnCgCBu7P6yAaNhjzJypGKCQFpA@mail.gmail.com>
 <094d8a2eab2177e5a5143f96cf745b26897e1793.camel@esd.eu>
In-Reply-To: <094d8a2eab2177e5a5143f96cf745b26897e1793.camel@esd.eu>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 22 Jun 2021 08:52:42 +0900
Message-ID: <CAMZ6RqKt-GVeD4ERmrqaoPZf8Zi7haeji_Br7s2MLSpJo+pDhw@mail.gmail.com>
Subject: Re: CAN-FD Transmitter Delay Compensation (TDC) on mcp2518fd
To:     =?UTF-8?Q?Stefan_M=C3=A4tje?= <Stefan.Maetje@esd.eu>
Cc:     "thomas.kopp@microchip.com" <thomas.kopp@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le mar. 22 juin 2021 à 03:42, Stefan Mätje <Stefan.Maetje@esd.eu> a écrit :
>
> Am Samstag, den 19.06.2021, 21:34 +0900 schrieb Vincent MAILHOL:
> > On Sat. 19 Jun 2021 à 00:55, Stefan Mätje <Stefan.Maetje@esd.eu> wrote:
> > > Am Freitag, den 18.06.2021, 23:27 +0900 schrieb Vincent MAILHOL:
> > > > On Fri. 18 Jun 2021 at 21:44, Marc Kleine-Budde <mkl@pengutronix.de>
> > > > wrote:
> > > > > On 18.06.2021 20:17:51, Vincent MAILHOL wrote:
> > > > > > > > I just noticed in the mcp2518fd data sheet:
> > > > > > > >
> > > > > > > > > bit 14-8 TDCO[6:0]: Transmitter Delay Compensation Offset bits;
> > > > > > > > > Secondary Sample Point (SSP) Two’s complement; offset can be
> > > > > > > > > positive,
> > > > > > > > > zero, or negative.
> > > > > > > > >
> > > > > > > > > 011 1111 = 63 x TSYSCLK
> > > > > > > > > ...
> > > > > > > > > 000 0000 = 0 x TSYSCLK
> > > > > > > > > ...
> > > > > > > > > 111 1111 = –64 x TSYSCLK
> > > > > > > >
> > > > > > > > Have you takes this into account?
> > > > > > >
> > > > > > > I have not. And I fail to understand what would be the physical
> > > > > > > meaning if TDCO is zero or negative.
> > > > >
> > > > > The mcp25xxfd family data sheet says:
> > > > >
> > > > > > SSP = TDCV + TDCO
> > > > > > > TDCV indicates the position of the bit start on the RX pin.
> > > > >
> > > > > If I understand correctly in automatic mode TDCV is measured by the CAN
> > > > > controller and reflects the transceiver delay.
> > > >
> > > > Yes. I phrased it poorly but this is what I wanted to say. It is
> > > > the delay to propagate from the TX pin to the RX pin.
> > > >
> > > > If TDCO = 0 then SSP = TDCV + 0 = TDCV thus the measurement
> > > > occurs at the bit start on the RX pin.
> > > >
> > > > > I don't know why you want
> > > > > to subtract a time from that....
> > > > >
> > > > > The rest of the relevant registers:
> > > > >
> > > > > > TDCMOD[1:0]: Transmitter Delay Compensation Mode bits; Secondary
> > > > > > Sample
> > > > > > Point (SSP)
> > > > > > 10-11 = Auto; measure delay and add TDCO.
> > > > > > 01 = Manual; Do not measure, use TDCV + TDCO from register
> > > > > > 00 = TDC Disabled
> > > > > >
> > > > > > TDCO[6:0]: Transmitter Delay Compensation Offset bits; Secondary
> > > > > > Sample
> > > > > > Point (SSP)
> > > > > > Two’s complement; offset can be positive, zero, or negative.
> > > > > > 011 1111 = 63 x TSYSCLK
> > > > > > ...
> > > > > > 000 0000 = 0 x TSYSCLK
> > > > > > ...
> > > > > > 111 1111 = –64 x TSYSCLK
> > > > > >
> > > > > > TDCV[5:0]: Transmitter Delay Compensation Value bits; Secondary Sample
> > > > > > Point (SSP)
> > > > > > 11 1111 = 63 x TSYSCLK
> > > > > > ...
> > > > > > 00 0000 = 0 x TSYSCLK
> > > >
> > > > Aside from the negative TDCO, the rest is standard stuff. We can
> > > > note the absence of the TDCF but that's not a blocker.
> > > >
> > > > > > > If TDCO is zero, the measurement occurs on the bit start when all
> > > > > > > the ringing occurs. That is a really bad choice to do the
> > > > > > > measurement. If it is negative, it means that you are measuring the
> > > > > > > previous bit o_O !?
> > > > >
> > > > > I don't know...
> > > > >
> > > > > > > Maybe I am missing something but I just do not get it.
> > > > > > >
> > > > > > > I believe you started to implement the mcp2518fd.
> > > > >
> > > > > No I've just looked into the register description.
> > > >
> > > > OK. For your information, the ETAS ES58x FD devices do not allow
> > > > the use of manual mode for TDCV. The microcontroller from
> > > > Microchip supports it but ETAS firmware only exposes the
> > > > automatic TDCV mode. So it can not be used to test what would
> > > > occur if SSP = 0.
> > > >
> > > > I will prepare a patch to allow zero value for both TDCV and
> > > > TDCO (I am a bit sad because I prefer the current design, but if
> > > > ISO allows it, I feel like I have no choice).  However, I refuse
> > > > to allow the negative TDCO value unless someone is able to
> > > > explain the rationale.
> > >
> > > Hi,
> > >
> > > perhaps I can shed some light on the idea why it is a good idea to allow
> > > negative TDC offset values. Therefore I would describe the TDC register
> > > interface of the ESDACC CAN-FD controller of our company (see
> > > https://esd.eu/en/products/esdacc).
> >
> > Thanks for joining the conversation. I am happy to receive help
> > from more experts!
> >
> > > Register description of TDC-CAN-FD register (reserved bits not shown):
> > >
> > > bits [5..0], RO: TDC Measured (TDCmeas)
> > >         Currently measured TDC value, needs baudrate to be set and CAN
> > > traffic
> > >
> > > bits [21..16], R/W: TDC offset (TDCoffs)
> > >         Depending on the selected mode (see TDC mode)
> > >         - Auto TDC, automatic mode (default)
> > >                 signed offset onto measured TDC (TDCeff = TDCmeas +
> > > TDCoffs),
> > >                 interpreted as 6-bit two's complement value
> > >         - Manual TDC
> > >                 absolute unsigned offset (TDCeff = TDCoffs),
> > >                 interpreted as 6-bit unsigned value
> > >         - Other modes
> > >                 ignored
> > >         In either case TDC offset is a number of CAN clock cycles.
> > >
> > > bits [31..30], R/W: TDC mode
> > >         00 = Auto TDC
> > >         01 = Manual TDC
> > >         10 = reserved
> > >         11 = TDC off
> >
> > First remark is that you use different naming than what I
> > witnessed so far in other datasheets. Let me try to give the
> > equivalences between your device and the struct can_tdc which I
> > proposed in my patches.
> >
> > The Left members are ESDACC CAN-FD registers, the right members
> > are variables from Socket CAN.
> >
> > ** Auto TDC **
> > TDCoffs = struct can_tdc::tdco
> >
> > ** Manual TDC **
> > TDCoffs = struct can_tdc::tdcv + struct can_tdc::tdco
> >
> > In both cases, TDCeff corresponds to the SSP position.
>
> TDCeff is not the SSP position in our implementation. see below.
>
> >
> > > So in automatic mode the goal is to be able to move the real sample point
> > > forward and(!) backward from the measured transmitter delay. Therefore the
> > > TDCoffs is interpreted as 6-bit two's complement value to make negative
> > > offsets
> > > possible and to decrease the effective (used) TDCeff below the measured
> > > value
> > > TDCmeas.
> > >
> > > As far as I have understood our FPGA guy the TDCmeas value is the number of
> > > clock cycles counted from the start of transmitting a dominant bit until the
> > > dominant state reaches the RX pin.
> >
> > Your definition of TDCmeas is consistent with the definition of
> > TDCV in socket CAN.
> >
> > What I miss to understand is what does it mean to subtract from
> > that TDCmeas/TDCV value. If you subtract from it, it means that
> > TDCeff/SSP is sampled before the signal reaches the RX
> > pin. Correct?
> >
> > > During the data phase the sample point is controlled by the tseg values set
> > > for
> > > the data phase but is moved additionally by the number of clocks specified
> > > by
> > > TDCeff (or SSP in the mcp2518fd case).
> >
> > Here I do not follow you. The SSP, as specified in ISO 11898-1
> > is "specified by its distance from the start of the bit
> > time". Either you do not use TDC and the measurement is done on
> > the SP according to the tseg values, either you do use TDC and
> > the measurement is done on the SSP according to the TDC
> > values. There is no mention of mixing the tseg and tdc values.
> >
> > P.S.: don't hesitate to invite your FPGA guy to this thread!
>
> I would like to do but he left off for holidays this weekend. So what I tell
> here should be taken with a grain of salt.
>
> I've had a look at the ISO specificaton and the chapter on Transmitter delay
> compensation. It was not aware of the exact definition of SSP in the ISO spec.
> But I can explain our implementation and the relation to the ISO spec.
>
> In our implementation during transmit our RX-state machine runs skewed later by
> TDCeff timequanta than the TX-state machine. This leads to the timing effects
> described below.
>
> For this discussion I would define SPO (Sample Point Offset) as sum of time
> quanta of Sync Segment, Prop_Segment and Phase1 segment set for the data phase,
> i. e. the time quanta till Sample Point in the data phase.

FYI, the sample point is already available in Socket CAN but it
is expressed in tenth of percent. You can simply convert it back
to time quanta doing:
|        u32 sample_point_in_tq = can_bit_time(dbt) * dbt->sample_point / 1000;

(which is a formula I already used to calculate TDCO:
https://elixir.bootlin.com/linux/v5.13-rc6/source/drivers/net/can/dev/bittiming.c#L194)

> Bittiming for a single bit in the data phase
>
>
>   |<-------- SPO ---------->|
>   |                                   |
> --+-----------------------------------+-- TX-Bit
>    \                        ^
>     \
>      \
>       \
>        \
>         \
>          \
>   |<---->| TDCmeas
>           \
>            \
>             \
>          |<->| TDCoffs
>              |
>   |<-------->| TDCeff
>              |<-------- SPO ---------->|
>              |                                   |
>            --+-----------------------------------+-- RX-Bit
>                                        ^
>   |<------------ SSP ----------------->|
>
>
> The sketch should show the timing relations between transmitted and received
> bits. You see in our implementation the SSP is calculated as the sum of TDCeff
> and SPO where in turn TDCeff is the sum of TDCmeas and TDCoffs:
>
> SSP = TDCeff + SPO      and TDCeff = TDCmeas + TDCoffs ==>
>
> SSP = TDCmeas + TDCoffs + SPO
>
> Where (all in time quanta)
> TDCmeas = measured TDC delay like TDCV from Microchip data sheet
> TDCoffs = our ESDACC register value for the TDC offset
> SPO     = offset to data phase sample point as defined before
>
> In comparision to the ISO spec the SSP offset "SSPO" from figure 24 would then
> be for our implementation:
>
> SSPO = TDCoffs + SPO
>
> And from your description your are thinking to implement the SSPO to be struct
> can_tdc::tdco.
>
> If you take "our" formula for SSPO into account you can see that a negative
> TDCoffs can be of use because it is always offsetted by SPO. And you're right
> that a SSPO less than zero would sample the line before the bit has arrived.
>
> I think the reason for this kind of implementation was that if you enable
> automatic mode and set TDCoffs to zero it does basically "the right thing". That
> is TDCoffs is independent from the settings done for segments in the data phase
> because the resulting sample point offset (SPO) is cared for automatically.

Thank you. What you are saying makes sense. To me, there is only
one thing that is a bit strange in your sketch: the TDCmeas/TDCV
does not indicate the beginning of the RX-bit.

I tried to modify your sketch with my vision.

  |<-------- SPO ---------->|
  |                                   |
--+-----------------------------------+-- TX-Bit
   \                        ^
    \
     \
      \
       \
        \
         \
          \
           \
            \
|<---------->| TDCmeas (by definition, TDCmeas/TDCV is the measured delay,
             |          i.e. it indicates the beginning of the RX-bit)
             |
             |<-------- SPO ---------->|
             |                         |<->| TDCoffs (might be negative)
             |<--------------------------->| TDCeff = SPO + TDCoffs
             |                                   |
           --+-----------------------------------+-- RX-Bit
                                           ^
|<---------------- SSP ------------------->|

The above is still consistent with your formulas for ESDACC CAN-FD:

SSP = TDCmeas + TDCeff
    = TDCmeas + SPO + TDCoffs

And this is how to use Socket CAN variables to calculates yours:

SPO = can_bit_time(&priv->data_bittiming) *
      priv->data_bittiming.sample_point / 1000;

TDCoffs = priv->tdc.tdco - SPO

So here, Socket CAN's TDCO is indeed an absolute value because it
is an offset on TDCmeas/TDCV whereas in your implementation,
TDCoffs is a relative value because it is an offset on
TDCmeas/TDCV + TDCeff.

> To understand the TDC configuration opportunities of the MPC2518FD more
> thoroughly I've looked at its reference manual
>
>
> https://ww1.microchip.com/downloads/en/DeviceDoc/MCP25XXFD-CAN-FD-Controller-Module-Family-Reference-Manual-DS20005678E.pdf
>
> and also had a look at some example bittiming calculations done with
>
> https://ww1.microchip.com/downloads/en/DeviceDoc/MCP2517FD%20Bit%20Time%20Calculations%20-%20UG.xlsx
>
> These documents are linked here:
> https://www.microchip.com/wwwproducts/en/MCP2518FD
>
> In the Excel calculation sheet the TDCO is calculated as
> TDCO = (DPRSEG + DPH1SEG) * DBRP
> which makes it  also dependend from the data phase prescaler. This means that
> the recommended initial TDCO (which really seems to be SSPO in their
> implementation) depends on (DPRSEG + DPH1SEG) which is basically the SPO as
> defined for our implementation.
>
> But this also means for a user that when setting TDCO via struct can_tdc::tdco
> the full configuration of the data bitrate must be known. Additionally changing
> the data bitrate sample point will make the TDC settings unsuitable for the the
> new data bitrate setting.
>
> What this means on how to implement a nice user interface to these parameters I
> don't know at the moment.

This should not be an issue. In the interface I am writing, I am
forcing the user to provide both the data bitrate and the TDC
settings at the same time.

Long story short, I now understand that negative TDCO thing (and
thanks again for your long write-up). It is just that the
calculation is done differently. I am thinking of continuing to
use an unsigned TDCO in the socket CAN implementation and maybe
provide an helper function: can_tdc_get_relative_tdco() that will
return the signed TDCO needed for the ESDACC and the
MPC2518FD (and probably other controllers as well).


Yours sincerely,
Vincent
