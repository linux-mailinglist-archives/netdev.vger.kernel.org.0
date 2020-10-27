Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D47629AA83
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 12:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1749891AbgJ0L1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 07:27:52 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37572 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2899149AbgJ0L1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 07:27:51 -0400
Received: by mail-ed1-f68.google.com with SMTP id o18so1046638edq.4;
        Tue, 27 Oct 2020 04:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=AzH6ewxh7YtkyS5REKd77RP0oyXcwztZS/MSjNhBqhc=;
        b=d0/iKrfNuYrOuX9ZXj5DDeQoHaKlpEhiuWXRaHLikSn5LPPliNgYzNXD5760rDtDHN
         qcJXu1DQAkkg+lrWwkeH3ieIXpUkoJ5XZlvHU1aLU32AZWbLUX2YTAtMcmEY7hnICZAf
         FjIGw6w+H4VX3NvnnH2OvqvW+nnqThNuwZTehNCYnIywOy1IpJrfkAWjCIW5IXhMVi5g
         LdQ5+uLOTf9xrkK0e3/fFTpERHeFpQlbMW1Gmjo1NOiKHE/zbH4l6znYxnbPHZvS1v5K
         6Qvlq4G3GEvq1wZnlgE9+iNU7taR+P+T8AkvyDeLPby8o3h56anB9j4Qlx/k7sTH6lc2
         zQ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=AzH6ewxh7YtkyS5REKd77RP0oyXcwztZS/MSjNhBqhc=;
        b=pIeG1yHrRWEXslv4bHW+uUsKkRscUzmePh3syPnrBz9rZF4r0fWZimLmxInyD3ahPB
         b3K99wYf4/9nX+ThmuwuHD7TBWauNW9zXmglcn07Zq7CzHyMV99bGCiustqMeX/1PxsP
         pbbd4iedb0WjMoLYYH22rZ9qp/MMhuqjReK8GRTBJQ8S/w19vpLRsxSSZYhWXyBqiqeA
         XnAP69MpPi0XWLX2fc4OYOnZ7j6YxtS3X0MCurwTJ/K9YYUO2Ake1pHnA98sD998FjDo
         ONb5y6roTmS7ZMrZZOlJPNQJ3IR1IufYlLA0v1GXhPuwNg9ZUuw3O5TlEuF45k2cEUbr
         43NQ==
X-Gm-Message-State: AOAM53279F7L6HUKp2EpM2SDD41M4/SPveBZJzg7Y6fCx+wUvdvj7vUb
        QgUxLhhEdsWmY7aaxhuyFgVRlUrxjhrtJByjibA=
X-Google-Smtp-Source: ABdhPJx9MKnnqsSGBtVI84GKj94Vfcd2lUK8oq+3z24A53kbg+jBf7h+LEA9OWFF8GY1s8C+TMrrivN3Rf/Y+jYDqdk=
X-Received: by 2002:a05:6402:1004:: with SMTP id c4mr1698669edu.149.1603798068770;
 Tue, 27 Oct 2020 04:27:48 -0700 (PDT)
MIME-Version: 1.0
References: <20201022102946.18916-1-yegorslists@googlemail.com>
 <32bad1a4-4daf-8ebe-e469-175e0339b292@pengutronix.de> <20201022122453.GA31522@x1.vandijck-laurijssen.be>
In-Reply-To: <20201022122453.GA31522@x1.vandijck-laurijssen.be>
From:   Yegor Yefremov <yegorslists@googlemail.com>
Date:   Tue, 27 Oct 2020 12:27:37 +0100
Message-ID: <CAGm1_kuZkrbaLwATrbPkmDmQW7SAwDapy5jbT8EwOSmccGqV0A@mail.gmail.com>
Subject: Re: [PATCH] can: j1939: convert PGN structure to a table
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Yegor Yefremov <yegorslists@googlemail.com>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 2:25 PM Kurt Van Dijck
<dev.kurt@vandijck-laurijssen.be> wrote:
>
> On Thu, 22 Oct 2020 12:33:45 +0200, Marc Kleine-Budde wrote:
> > On 10/22/20 12:29 PM, yegorslists@googlemail.com wrote:
> > > From: Yegor Yefremov <yegorslists@googlemail.com>
> > >
> > > Use table markup to show the PGN structure.
> > >
> > > Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
> > > ---
> > >  Documentation/networking/j1939.rst | 12 ++++++++----
> > >  1 file changed, 8 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/Documentation/networking/j1939.rst b/Documentation/networking/j1939.rst
> > > index faf2eb5c5052..f3fb9d880910 100644
> > > --- a/Documentation/networking/j1939.rst
> > > +++ b/Documentation/networking/j1939.rst
> > > @@ -71,10 +71,14 @@ PGN
> > >
> > >  The PGN (Parameter Group Number) is a number to identify a packet. The PGN
> > >  is composed as follows:
> > > -1 bit  : Reserved Bit
> > > -1 bit  : Data Page
> > > -8 bits : PF (PDU Format)
> > > -8 bits : PS (PDU Specific)
> > > +
> > > +  ============  ==============  ===============  =================
> > > +  PGN
> > > +  ----------------------------------------------------------------
> > > +  25            24              23 ... 16        15 ... 8
> >
> > ICan you add a row description that indicated that these numbers are. They are
> > probably bit positions within the CAN-ID?
>
> This is true for up to 99.9%, depending on who you ask.
> this maps indeed to the bit positions in the CAN-ID, as in J1939-21.
> The trouble is that PGN's are also communicated as such in the payload,
> e.g. in the TP and ETP (see J1939-81 if i remember correctly).
> Since only PGN is written there, without SA, the bit position relative
> to the CAN-ID are ... making things look fuzzy.
>
> So I the best I can propose is to add a 2nd row :-)

I have sent v2. Should I also include the tables for PDU1 and PDU2
formats as well as the general table with ID and Data? See Wiki [1]

[1] https://de.wikipedia.org/wiki/SAE_J1939#/media/Datei:J1939_Aufsplittung_CAN-Identifier.png

Best regards,
Yegor

> >
> > > +  ============  ==============  ===============  =================
> > > +  R (Reserved)  DP (Data Page)  PF (PDU Format)  PS (PDU Specific)
> > > +  ============  ==============  ===============  =================
> > >
> > >  In J1939-21 distinction is made between PDU1 format (where PF < 240) and PDU2
> > >  format (where PF >= 240). Furthermore, when using the PDU2 format, the PS-field
> > >
> >
> > Marc
> >
> > --
> > Pengutronix e.K.                 | Marc Kleine-Budde           |
> > Embedded Linux                   | https://www.pengutronix.de  |
> > Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> > Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
> >
>
>
>
