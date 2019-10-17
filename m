Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70147DA4DE
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 06:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392431AbfJQE4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 00:56:37 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:51546 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728755AbfJQE4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 00:56:37 -0400
Received: by mail-wm1-f53.google.com with SMTP id 7so1026985wme.1;
        Wed, 16 Oct 2019 21:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WnTzL28wtsAQdjx0j65OJpA8iYPMyh5LuJ+Wzc9XBog=;
        b=kA0/57buRdB8D8u2b2T29CksvUPa8A2CkAd8E5uCkraBO1YkS0u6losrhnp4r+vlqp
         qmwSkjozQigeqkG3QwADKQP5RMy/5CxwBrBD/wIDa0nBN/GlCBUM/3mr3t8FDpKi96aj
         jC8OaiNKCLd5AaFP2xl59loCU/kNqLDyapGMViaqW9M3mcGHE7JtwP09QoxK+GDt/App
         SQsCWDROz3c8io+qhLTR6Y97Cz11OT+CLmNKnPjUA635QsXAOkZQm5c8xE1dNkF84cj3
         eHtEEP1ivQhAh7s92XyzUG9MM/ciGD5EL8LeCunXWH9DqA3juAMn5ldXUwJq42TIAk0N
         kcCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WnTzL28wtsAQdjx0j65OJpA8iYPMyh5LuJ+Wzc9XBog=;
        b=YGmpOEH+6dUt89/YHcvoPOqJDByFfX7pSz4d7NPvxxuGvGPJKQhIy2SsBgt+XS5Sd7
         JronMh6HARwtv59inTIYieAISDRKU/qK45Ll90mLU9KLqGPBMFNucGi/r/90LeRw6UZU
         bcEyzE5J7WReeqXChNlq37w/qnxU+CINbI9Y6wtu3gkez0pWPHeLdhXb+lFeY1Nyqr5S
         yxmHKmZY40vSpdDO9wkL6g4j+ZPHvQI9hvFiUWi7UYQnFr3jX8RF1WvveOBujGCKorfK
         UidDT3xTK+mWaa4qan8EMjAhuBeDelU26C19o3kDuTRci1splSDNSUGcmK/Nyqwq9GcJ
         PDWg==
X-Gm-Message-State: APjAAAX6cq6bBFcAUY3h39vIJ2VYaxmJfcMMKHGFCRNwczhU8/fAyOaw
        r/trmrUdC6uvhPz2vXYXqetyWjsNDj8EGafIjKg=
X-Google-Smtp-Source: APXvYqxzxzi50yuRhRFw3az2dmpPmGDxB69NefTBrtQztX+1MgSpe1CVR0E2Qb0PZqk9yDzBLb87RyI5k7zM5qSxXTA=
X-Received: by 2002:a1c:6308:: with SMTP id x8mr1028838wmb.140.1571288194643;
 Wed, 16 Oct 2019 21:56:34 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1571033544.git.lucien.xin@gmail.com> <20191015.175639.347136446069377956.davem@davemloft.net>
 <1f6cf86fce074a9cbf7f8c2496cc7c84@AcuMS.aculab.com>
In-Reply-To: <1f6cf86fce074a9cbf7f8c2496cc7c84@AcuMS.aculab.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 17 Oct 2019 12:56:52 +0800
Message-ID: <CADvbK_cBaydDVnmcKvUWwsbf+u_GgAumoq7wW7FQtFg_TZNiiw@mail.gmail.com>
Subject: Re: [PATCHv3 net-next 0/5] sctp: update from rfc7829
To:     David Laight <David.Laight@aculab.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>,
        "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 6:42 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: David Miller
> > Sent: 16 October 2019 01:57
> > From: Xin Long <lucien.xin@gmail.com>
> > Date: Mon, 14 Oct 2019 14:14:43 +0800
> >
> > > SCTP-PF was implemented based on a Internet-Draft in 2012:
> > >
> > >   https://tools.ietf.org/html/draft-nishida-tsvwg-sctp-failover-05
> > >
> > > It's been updated quite a few by rfc7829 in 2016.
> > >
> > > This patchset adds the following features:
> > >
> > >   1. add SCTP_ADDR_POTENTIALLY_FAILED notification
> > >   2. add pf_expose per netns/sock/asoc
> > >   3. add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
> > >   4. add ps_retrans per netns/sock/asoc/transport
> > >      (Primary Path Switchover)
> > >   5. add spt_pathcpthld for SCTP_PEER_ADDR_THLDS sockopt
> >
> > I would like to see some SCTP expert ACKs here.
>
> I'm only an SCTP user, but I think some of the API changes aren't right.
Hi, David L.

I think you must know quite a few user cases.

Before I repost, can you pls give the exact places where the API
changes may not be right as you've already done in v1 and v2, so
that I can correct them.

Thanks.

> I'm not going to try to grok the sctp code - it makes my brain hurt.
> (Even though I've written plenty of protocol stack code.)
>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
>
