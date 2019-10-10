Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9D7FD2650
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 11:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387421AbfJJJ2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 05:28:47 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39102 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbfJJJ2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 05:28:47 -0400
Received: by mail-wr1-f66.google.com with SMTP id r3so6966568wrj.6;
        Thu, 10 Oct 2019 02:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zdzMalG66NsofXJPkTYtHVy1N+UqRoHC8Uo/Wn3GaE4=;
        b=mqxaxi7rzsYeAnApFshT9C3/sRGHrOkgsSeaCkJsq4uv0rqyS6DqPXlS4BYePkI/+S
         xmq18wX3A3oq5JL1t13FsZoSjrsadlutD5LtM/cSHrG5AHzQOieLaKN/+fs6+wxYv+m+
         F7R4CeeCggWgi/7zFscNZTsU4ILTNilr3RFwd6FWxMJV4oWr3gngFErlXIQfvGStqORv
         zRZYw6Afm5mVqEmY1p8oR3SaVXJLaDPD296CMpE1eWRSRvF4jJrfSLaxQAp4rxsXYWID
         /vatPsQ4teqjYA0ga19GRa3xuIFVL7SoL/lPv/4VAzxjoqxyQiU8ChCvKRrjQ56hbCdo
         dwIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zdzMalG66NsofXJPkTYtHVy1N+UqRoHC8Uo/Wn3GaE4=;
        b=E4E59zMpVkPB0YjN4d5jfiwE9VEBe/wLg+y2elSfIXfpbUwqCiAeRUHQiPgHF+dMWn
         LaktI4F0MTbr7KDCFkpC/zAs/VpLzw0EWswgbKRxSqq1dNVa5GGZ+aWZbRB5HYIWuN12
         0a9RMF+xFUWFkU3SjC5aS3OHFsZIi09D5zXk4xGW+pXH3kY6pQGaPnR6Pkp+kvvBudpY
         9jXgwPJDYfyv4ojtLlNnefNMog0w/mJl8JuWY6zpYV4aH9SijfZsDPU7Pjngp/LdYOJN
         UGofsx63kitRJ64tQHBM9wBlR7C9IXeKRQ4kTSL6pIIiLyt2LPYEaDEmUcx6vwi/viow
         sdlw==
X-Gm-Message-State: APjAAAWez4jUVwYMnxWi9BpP01T3K6C8TSy3BXJ/aZv8YeZZ/GpcT9F4
        5KWXCo0lKZxBamZEN6SYhvBf34QyO3C3WXNWNAU=
X-Google-Smtp-Source: APXvYqyAUZ5J/iGMXsE7KiEs21akOvQrjYRCDg3+KBiWCIgfST47JgnOt+GmPTlZDxtgEtu+tWI+je4xcO5QpasFd1E=
X-Received: by 2002:a05:6000:1242:: with SMTP id j2mr7719467wrx.361.1570699723557;
 Thu, 10 Oct 2019 02:28:43 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570533716.git.lucien.xin@gmail.com> <066605f2269d5d92bc3fefebf33c6943579d8764.1570533716.git.lucien.xin@gmail.com>
 <60a7f76bd5f743dd8d057b32a4456ebd@AcuMS.aculab.com> <CADvbK_cFCuHAwxGAdY0BevrrAd6pQRP2tW_ej9mM3G4Aog3qpg@mail.gmail.com>
 <20191009161508.GB25555@hmswarspite.think-freely.org>
In-Reply-To: <20191009161508.GB25555@hmswarspite.think-freely.org>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 10 Oct 2019 17:28:34 +0800
Message-ID: <CADvbK_eJh0ghjrrqcx7mygEY94QsxxbV=om8BqWPEcXxUHFmHw@mail.gmail.com>
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

On Thu, Oct 10, 2019 at 12:18 AM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Tue, Oct 08, 2019 at 11:28:32PM +0800, Xin Long wrote:
> > On Tue, Oct 8, 2019 at 9:02 PM David Laight <David.Laight@aculab.com> wrote:
> > >
> > > From: Xin Long
> > > > Sent: 08 October 2019 12:25
> > > >
> > > > This is a sockopt defined in section 7.3 of rfc7829: "Exposing
> > > > the Potentially Failed Path State", by which users can change
> > > > pf_expose per sock and asoc.
> > >
> > > If I read these patches correctly the default for this sockopt in 'enabled'.
> > > Doesn't this mean that old application binaries will receive notifications
> > > that they aren't expecting?
> > >
> > > I'd have thought that applications would be required to enable it.
> > If we do that, sctp_getsockopt_peer_addr_info() in patch 2/5 breaks.
> >
> I don't think we can safely do either of these things.  Older
> applications still need to behave as they did prior to the introduction
> of this notification, and we shouldn't allow unexpected notifications to
> be sent.
>
> What if you added a check in get_peer_addr_info to only return -EACCESS
> if pf_expose is 0 and the application isn't subscribed to the PF event?
We can't subscribe to PF event only, but all the SCTP_PEER_ADDR_CHANGE
events.

Now I'm thinking both PF event and "return -EACCES" in get_peer_addr_info
are new, we should give 'expose' a default value that would disable both.
How do think if we set 'pf_expose = -1' by default. We send the pf event
only if (asoc->pf_expose > 0) in sctp_assoc_control_transport().

>
> Neil
>
> > >
> > >         David
> > >
> > > -
> > > Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> > > Registration No: 1397386 (Wales)
> > >
> >
