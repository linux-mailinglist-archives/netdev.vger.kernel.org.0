Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6870BD4557
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 18:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbfJKQZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 12:25:35 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54278 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfJKQZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 12:25:35 -0400
Received: by mail-wm1-f67.google.com with SMTP id p7so11043456wmp.4;
        Fri, 11 Oct 2019 09:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rq4Bvzgr7Q2qdHdWDtpYy7lX5F55pYx2dXwqOv2z3as=;
        b=AhKo2b4tR0TUNbN554APWR+q+NDR0HovLX8J/nCdZkoeQgYXHMpBRFXoECEo3Mq0cB
         E4p0ZaxUnagdvpEr0Vh4t0d2R77E69K879jEBmywDCriX2mycMrrPTIjTRXyX8BMP3kw
         XIwy3hAI3rypasg38xBP5NbLfmytV2S95P08PY47zDFkTjNze2dnFJE9xuD54kOq8kwh
         hAbHIszKrKnF+wiYHTqnDRhaRDOaT3msbkt8LBRcyRObN7w0OSRG3maCHkbBxVMjXhdy
         4kxUVuhYj7JwB1xTZ7hG21ItehW4VXIeh128axwoObqnjbP51RxhNFR3KQ3Qtc5iSaPr
         /CQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rq4Bvzgr7Q2qdHdWDtpYy7lX5F55pYx2dXwqOv2z3as=;
        b=b0HYv9XNkLbbiPZ8GS0HOQFPNmq7VYvrzZdGVoQwHgNEfWKp0Ko3SFNHXG329OQ2OX
         tMVVKg3WBqrnC5JLgYyF1yH/1KgLqRqZ633RyXORhpPPJDs2bS/RqZiZXzIX5zH3dCde
         cxY8NXe4KamBnAr2qWqnEHw1KGfN6G+SuzClopsWJ4Uyj0t7XEMKP6mDDZNq4n78HdXv
         BNkZzS4LakTO0yFxVs3qXN0exenzuq5a9wafA6wQH/avBffV/n3exa/HiDWKeCqGEzTp
         Tmfg55Se+C5n4Pdgml9bkSiXjA2J8dbKaXYAkD9NMlkVuYZ6Nm9eJSBghYhXuHhMsyjq
         4PRA==
X-Gm-Message-State: APjAAAUWVBvOV26Am4YVmqXh0Riqvq0S5anxEUUe5Jjg865AU/fS4dEP
        5zJ6n+b0frneV2Vb8IWpnk3jgvTHCOnQ0DWptPw=
X-Google-Smtp-Source: APXvYqzcmvlwDY+TPD8LZtSJZceLDE+4GO8IF+UGlFKhvr3i1gwzLdLrSnhK+dib3Cz1Tyf1nGBbU91i28FjL0dUryg=
X-Received: by 2002:a7b:c3cf:: with SMTP id t15mr3797714wmj.85.1570811131423;
 Fri, 11 Oct 2019 09:25:31 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570533716.git.lucien.xin@gmail.com> <066605f2269d5d92bc3fefebf33c6943579d8764.1570533716.git.lucien.xin@gmail.com>
 <60a7f76bd5f743dd8d057b32a4456ebd@AcuMS.aculab.com> <CADvbK_cFCuHAwxGAdY0BevrrAd6pQRP2tW_ej9mM3G4Aog3qpg@mail.gmail.com>
 <20191009161508.GB25555@hmswarspite.think-freely.org> <CADvbK_eJh0ghjrrqcx7mygEY94QsxxbV=om8BqWPEcXxUHFmHw@mail.gmail.com>
 <20191010124045.GA29895@hmswarspite.think-freely.org> <CADvbK_d-djw00DBTmu7XCpxrfNvCF-xksWT9gV_VP_-zLv=NkA@mail.gmail.com>
In-Reply-To: <CADvbK_d-djw00DBTmu7XCpxrfNvCF-xksWT9gV_VP_-zLv=NkA@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 12 Oct 2019 00:25:27 +0800
Message-ID: <CADvbK_eZcNd8Xy-q5SWS2CzD1SdMqzU05_mGkmh5-iLtOdRCCw@mail.gmail.com>
Subject: Re: [PATCHv2 net-next 3/5] sctp: add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE
 sockopt
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     David Laight <David.Laight@aculab.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 11:57 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Thu, Oct 10, 2019 at 8:40 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> >
> > On Thu, Oct 10, 2019 at 05:28:34PM +0800, Xin Long wrote:
> > > On Thu, Oct 10, 2019 at 12:18 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> > > >
> > > > On Tue, Oct 08, 2019 at 11:28:32PM +0800, Xin Long wrote:
> > > > > On Tue, Oct 8, 2019 at 9:02 PM David Laight <David.Laight@aculab.com> wrote:
> > > > > >
> > > > > > From: Xin Long
> > > > > > > Sent: 08 October 2019 12:25
> > > > > > >
> > > > > > > This is a sockopt defined in section 7.3 of rfc7829: "Exposing
> > > > > > > the Potentially Failed Path State", by which users can change
> > > > > > > pf_expose per sock and asoc.
> > > > > >
> > > > > > If I read these patches correctly the default for this sockopt in 'enabled'.
> > > > > > Doesn't this mean that old application binaries will receive notifications
> > > > > > that they aren't expecting?
> > > > > >
> > > > > > I'd have thought that applications would be required to enable it.
> > > > > If we do that, sctp_getsockopt_peer_addr_info() in patch 2/5 breaks.
> > > > >
> > > > I don't think we can safely do either of these things.  Older
> > > > applications still need to behave as they did prior to the introduction
> > > > of this notification, and we shouldn't allow unexpected notifications to
> > > > be sent.
> > > >
> > > > What if you added a check in get_peer_addr_info to only return -EACCESS
> > > > if pf_expose is 0 and the application isn't subscribed to the PF event?
> > > We can't subscribe to PF event only, but all the SCTP_PEER_ADDR_CHANGE
> > > events.
> > >
> > > Now I'm thinking both PF event and "return -EACCES" in get_peer_addr_info
> > > are new, we should give 'expose' a default value that would disable both.
> > > How do think if we set 'pf_expose = -1' by default. We send the pf event
> > > only if (asoc->pf_expose > 0) in sctp_assoc_control_transport().
> > >
> > And if pf_expose = 0, we send the event, and return -EACCESS if we call
> > the socket option and find a PF assoc?  If so, yes, I think that makes
> > sense.
> pf_expose:
> -1: compatible with old application (by default)
> 0: not expose PF to user
> 1: expose PF to user
>
> So it should be:
> if pf_expose == -1:  not send event, not return -EACCESS
> if pf_expose == 0: not send event, return -EACCESS
> if pf_expose > 0: sent event, not return -EACCESS
>
> makes sense?
Oh, sorry, pf_expose is 1 bit only now in asoc/ep.
Maybe we should use 2 bits, and values could be:
2: compatible with old application (by default)
0: not expose PF to user
1: expose PF to user

>
> >
> > Neil
> >
> > > >
> > > > Neil
> > > >
> > > > > >
> > > > > >         David
> > > > > >
> > > > > > -
> > > > > > Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> > > > > > Registration No: 1397386 (Wales)
> > > > > >
> > > > >
> > >
