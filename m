Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82A9C12ABFD
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 12:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfLZLoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 06:44:54 -0500
Received: from mail-ed1-f50.google.com ([209.85.208.50]:42391 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfLZLoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 06:44:54 -0500
Received: by mail-ed1-f50.google.com with SMTP id e10so22389334edv.9
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 03:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZJO/PGFiGEeZ/TNfLFE2YR12l5jbTSzN+yS8xy2BS0c=;
        b=tyHUQGP/h1qM/t+u3jCh5oD7J4o+NKtkoB8yZQRLaHWPZCBgcfvAnokG9czTzW49Bz
         SWZ1OkprTUBs3u85rymjqfs6SBHOm62FIg/J2EXaaI7m1II77lK/8fo6P4MgJF1PpcWN
         Lc6Gz3pmA9VChGDtGWn9eMUQo+JwdodQvyrET5rQdQ8Tr2Ro5OMNk7NWUB7IGp0/2/Nr
         sqNFFkQ5Wq/9nNJhRJElxelDSzYWvKObMEGJFXuuhV9iZdgfQ7XNbc82ZGx661wlkrMt
         W3UHzentVkDLh1Vd75H2lqjRjgsbp7IzJfmmBrM9xlZP35weHTABTf1ogSbmTRiSYGTT
         9d6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZJO/PGFiGEeZ/TNfLFE2YR12l5jbTSzN+yS8xy2BS0c=;
        b=WOAQGGWeskba93+0+0VRv/n8eFX2sL2DUOxIHsfctfFPi7XyQVVaIITCzMt6gjE09/
         53u8E5CEFyXWN1UI9wLd+EywADOxxlZAJSkMJfIVz5Nrnxhv03NOo4KQIhS44zDlCsF5
         e2Ki6A6RTKkYEurkxMMxYJQtP47I1M9ilDKwVqLBH24lpeWQkXtKy5T1LSj8RpgO8D0z
         TJX8OXwJADGWTtQ9+aeNYbTBqSjdub9Tfz63/nSqmt/wxXCSgRVnYkJ4o+MfeCDWQfGe
         /11BtJGi56fHadJLU09tGRimVIr0MXNQ+3cz1D+KIs5ftzEbWnHH7X0+t/3jRvkjvsFF
         EQsg==
X-Gm-Message-State: APjAAAUQ9sac7YrhOSZh+Os5qJGDPRd3RLoXXqk8rfdk+nMF/PvHNmsd
        nA7FrQflW2pbisNiCrfeYOaYsRrHn5RgSzkOxI4=
X-Google-Smtp-Source: APXvYqyhAXd4j2VwCxhhbMZqPXWe3RydIlG0ZDfti2gyDOfWTt2rwdb3xBprfKejdog+ccMryPP8cWGDLnypPM3JrIg=
X-Received: by 2002:a50:f704:: with SMTP id g4mr49010265edn.123.1577360692738;
 Thu, 26 Dec 2019 03:44:52 -0800 (PST)
MIME-Version: 1.0
References: <20191226095851.24325-1-yangbo.lu@nxp.com> <CA+h21hojJ=UU2i1kucYoD4G9VQgpz1XytSOp_MT9pjRYFnkc4A@mail.gmail.com>
 <AM7PR04MB68858970C5BA46FE33C01F48F82B0@AM7PR04MB6885.eurprd04.prod.outlook.com>
In-Reply-To: <AM7PR04MB68858970C5BA46FE33C01F48F82B0@AM7PR04MB6885.eurprd04.prod.outlook.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 26 Dec 2019 13:44:41 +0200
Message-ID: <CA+h21hp_3gAqehP6mPdF-bWN9kDoXLdMEAVhidCrmPAPTpR2eg@mail.gmail.com>
Subject: Re: [PATCH] net: mscc: ocelot: support PPS signal generation
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Dec 2019 at 13:17, Y.b. Lu <yangbo.lu@nxp.com> wrote:
> > Also, I think what you have implemented here is periodic output
> > (PTP_CLK_REQ_PEROUT) not PPS [input] (PTP_CLK_REQ_PPS). I have found
> > the PTP documentation to be rather confusing on what PTP_CLK_REQ_PPS
> > means, so I'm adding Richard in the hope that he may clarify (also
> > what's different between PTP_CLK_REQ_PPS and PTP_CLK_REQ_PPS).
>
> My understand is PTP_CLK_REQ_PEROUT is for periodical output, and PTP_CLK_REQ_PPS is for PPS event handling.
> This patch is to initialize PPS signal. You may check reference manual for how to generate PPS.
>
> "For the CLOCK action, the sync option makes the pin generate a single pulse, <WAFEFORM_LOW>
> nanoseconds after the time of day has increased the seconds. The pulse will get a width of
> <WAVEFORM_HIGH> nanoseconds. "
>
> If the sync option is not used, it is for periodical clock generation that you mentioned.
>

So basically this hardware emits a periodic signal with the frequency
f equal to:
- NSEC_PER_SEC / (WAFEFORM_LOW + WAFEFORM_HIGH) if PTP_PIN_SYNC is not set
- 1 Hz if PTP_PIN_SYNC is set

So the hardware hardcodes the frequency, basically, and makes
WAFEFORM_LOW be the phase adjustment. So all in all, it's still
PTP_CLK_REQ_PEROUT that needs to be treated for this. Maybe you have
to special-case the value of rq->perout.period.sec and
rq->perout.period.nsec.

What is the phase adjustment (pin start time) if the PTP_PIN_SYNC
option is not set?

Anyway, it's good that you figured it out, but it's not really ok to
hardcode it like this. On some boards there may be electrical issues
if the PTP pins just emit pulses by default.

> EXTTS is for capturing timestamps for external trigger pin which is input signal.

And isn't PTP_CLK_REQ_PPS the same, just that the input signal is
expected to have a particular waveform?
Some drivers, like ptp_qoriq, seem like they misinterpret the PPS
request as meaning "generate PPS output". I find this strange because
it's exactly Richard who added the code for it.

Thanks,
-Vladimir
