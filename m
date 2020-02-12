Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 645A015A6D8
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 11:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgBLKqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 05:46:06 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42839 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727891AbgBLKqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 05:46:06 -0500
Received: by mail-ed1-f66.google.com with SMTP id e10so1856671edv.9
        for <netdev@vger.kernel.org>; Wed, 12 Feb 2020 02:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R+FL0xcMviUrfJkWr/louXOk7u76CVOpQ53eJ8RPXrU=;
        b=TBY3mc7upVmVxYsv5uOmeNQz7jsgib4rMM4/sY75S3iOu9oIBQRplhpio2AX8iMDKw
         ADnu9da15qW9FAgUBhmQ7vvCkcf0v6c/nGjeX9s3w8JZDIUVDcIr1iIF+GOl1HQA+SEB
         FxKSTvcWeApYOptp4+F71tZOqiwGlXb4GGydaqInPfTG6uRuVqNNKnqSse+o4ewH0RbD
         HVWURsR9ubRo/TD4EV7BhqtOxmj5qbAnqBncF/i1Ms6Umcvs71mE5Lmfpz04Ir7A30Py
         BVreUx89SbLPuNbwndGCdu/Vh1piFdlyCrD2YbyWPQOQe9HFuhcTVPF0syXYlId/xSZU
         NcNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R+FL0xcMviUrfJkWr/louXOk7u76CVOpQ53eJ8RPXrU=;
        b=hyFRh2X1ftHtkglah+Q+yGO4neZN2/Pf3pgzJJjAGCdj97MrW8O6s3gUXGgQR0/XBi
         QG4tpspVDpZl2ak0sIM8F0AV5D/0F29NpKJPzHi3ZJt0KH5YiSijzxVaw4HCQ2mnFaro
         NQ/DKhQ+4O/mPLSDTbxyYGyYO2tAL2gueX+QjodlSo2Y4FNpk1E0n3cMifiZVePvG/9z
         +Zzw1mQijJvvtJhtieRQqzk+QmqsAG1BbgvO5C6TZCKLr3Dz9L7C4n0Nht73KCa2J7nx
         v+/cI0yj3uq7chFArfurUMcw1EzhrQh6Qah6zVOSgvumOKNzOJ2KN9g2gTUqzkmyce4w
         r3Gg==
X-Gm-Message-State: APjAAAU6QXamnBGyoeNUD5luxZx5a5mvobMkDxi0i43V3UThkGQ6w4aX
        +ZEoFdNCalzmkuhwlTlcD8YW6I1W4yVoGJRsgO8=
X-Google-Smtp-Source: APXvYqx62duwTsubAcYaJ1dex9c25RHSokFXEfrbsyqT8/aRVgcFUNpLK84JYAaaD5UUOHZFvL2vPRCYY0n06vcolas=
X-Received: by 2002:a05:6402:19b2:: with SMTP id o18mr10208992edz.368.1581504364603;
 Wed, 12 Feb 2020 02:46:04 -0800 (PST)
MIME-Version: 1.0
References: <20200211045053.8088-1-yangbo.lu@nxp.com> <20200211.170635.1835700541257020515.davem@davemloft.net>
 <AM7PR04MB68852520F30921405A717B6CF81B0@AM7PR04MB6885.eurprd04.prod.outlook.com>
 <CA+h21hr+dE1owiF-e81psj3uKgCRdeS+C_LbFdd_ta91TS+CUA@mail.gmail.com> <AM7PR04MB688559DED451E057CBFE46E5F81B0@AM7PR04MB6885.eurprd04.prod.outlook.com>
In-Reply-To: <AM7PR04MB688559DED451E057CBFE46E5F81B0@AM7PR04MB6885.eurprd04.prod.outlook.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 12 Feb 2020 12:45:53 +0200
Message-ID: <CA+h21hpfAhFFJUwhguRbgF8KK0cSYicSn6fW+ocZZgoPycvE0A@mail.gmail.com>
Subject: Re: [PATCH] ptp_qoriq: add initialization message
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yangbo,

On Wed, 12 Feb 2020 at 12:39, Y.b. Lu <yangbo.lu@nxp.com> wrote:
>
> > -----Original Message-----
> > From: Vladimir Oltean <olteanv@gmail.com>
> > Sent: Wednesday, February 12, 2020 6:34 PM
> > To: Y.b. Lu <yangbo.lu@nxp.com>
> > Cc: David Miller <davem@davemloft.net>; netdev@vger.kernel.org;
> > richardcochran@gmail.com
> > Subject: Re: [PATCH] ptp_qoriq: add initialization message
> >
> > Hi Yangbo,
> >
> > On Wed, 12 Feb 2020 at 12:25, Y.b. Lu <yangbo.lu@nxp.com> wrote:
> > >
> > > > -----Original Message-----
> > > > From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> > > > Behalf Of David Miller
> > > > Sent: Wednesday, February 12, 2020 9:07 AM
> > > > To: Y.b. Lu <yangbo.lu@nxp.com>
> > > > Cc: netdev@vger.kernel.org; richardcochran@gmail.com
> > > > Subject: Re: [PATCH] ptp_qoriq: add initialization message
> > > >
> > > > From: Yangbo Lu <yangbo.lu@nxp.com>
> > > > Date: Tue, 11 Feb 2020 12:50:53 +0800
> > > >
> > > > > It is necessary to print the initialization result.
> > > >
> > > > No, it is not.
> > >
> > > Sorry, I should have added my reasons into commit message.
> > > I sent out v2. Do you think if it makes sense?
> > >
> > > " Current ptp_qoriq driver prints only warning or error messages.
> > > It may be loaded successfully without any messages.
> > > Although this is fine, it would be convenient to have an oneline
> > > initialization log showing success and PTP clock index.
> > > The goods are,
> > > - The ptp_qoriq driver users may know whether this driver is loaded
> > >   successfully, or not, or not loaded from the booting log.
> > > - The ptp_qoriq driver users don't have to install an ethtool to
> > >   check the PTP clock index for using. Or don't have to check which
> > >   /sys/class/ptp/ptpX is PTP QorIQ clock."
> > >
> > > Thanks.
> >
> > How about this message which is already there?
> > [    2.603163] pps pps0: new PPS source ptp0
>
> This message is from pps subsystem. We don't know what PTP clock is registered as ptp0.
> And if the PTP clock doesn't support pps capability, even this log won't be showed.
>
> Thanks.
>
> >
> > Thanks,
> > -Vladimir

Yes but this is ptp_qoriq, which specifically _does_ support PPS, so
the message will be printed. Am I missing something?

Regards,
-Vladimir
