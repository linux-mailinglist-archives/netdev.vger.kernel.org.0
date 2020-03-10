Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 526B31803AB
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 17:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgCJQiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 12:38:10 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:45900 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbgCJQiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 12:38:09 -0400
Received: by mail-ot1-f68.google.com with SMTP id f21so13740246otp.12
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 09:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=bkwvCTuYlWO7DbnAg1CGZnwoFyjZgNNFD+F6y6C7oyM=;
        b=vFjE8hj9kP586XIWp0xqcRe4G6q9oCaSYW3l8JfgKnYSEAZmJ+F34SR+RPt+Zq8In4
         KiDgnzAbUyMAAvgHl6lksgf8XhZfNLKiQ/dHb8FeUYJKDH1Zux9Wts/OIK7tjVwCZo4a
         mpXkqML4vdTaih3Q5aCRX7YYEngO9AaWh2q0i9MWVwSgLne6u2qtiubqlB2YPNWGshAd
         QszwMW4UZ2DYsiOWWC/th1gTQee7M83ca7omICzbJeq7WpWzZ4+bbQ/ayOT7nUEesrqY
         fkyUJIxDROah9+rs0lpXoIGAxHKPFNv8oVYa0YTU4mG74w/uctC2+cOdZZ0iDeqhqLV0
         kApA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=bkwvCTuYlWO7DbnAg1CGZnwoFyjZgNNFD+F6y6C7oyM=;
        b=ZkvwsylEapxU7/ef42TdXJVXx0MfWVHHeo/NbQbLPBAuNL1pvBsl/Pc7/y8AbWIObH
         937ACWgXZIbRH7RLnK5geuhaDDZbB8FRdKMZPEIEmt6/Et6cHHzvUEAXtyin7Sm8+139
         tQUi9Sbf39iHD6TczCoSw/PiBxE7uo+mD4hc/iFtBaXPTSrKSx+d2yc8eVkIzotWKAfY
         s6DVvgGixi2vmK16ydsLgbiNS90jJrEaFDpCSqfAA7qlllxxAMup0DrLCwuCnhaydBN0
         5Ks+4AvwsyPVUER9a+kDX6nKkTXLUaXfo5dfrhZV7MkvAkUaaBiOZq1G3mowHmT5Os82
         CNZA==
X-Gm-Message-State: ANhLgQ0Dusy/ECwWAPrfHIjAYfJboax3FkXPw9eZd//ub1VsKsmC1UZB
        Yv2jAqhI/w8TRQp0ora7EiDxFw5XY+n/v67RmUpGqLaa
X-Google-Smtp-Source: ADFU+vtpfsI6ZNIvo0MJRY3+NRjCGoKXiCtEhe1A9Ma22GmZMLmDmKSPkRokXOPVSKr9kFnB49webDY8MKk49lZE6bM=
X-Received: by 2002:a05:6830:c5:: with SMTP id x5mr4375416oto.302.1583858288426;
 Tue, 10 Mar 2020 09:38:08 -0700 (PDT)
MIME-Version: 1.0
References: <3748be15d31f71c6534f344b0c78f48fc4e3db21.camel@infradead.org>
 <abe4f3a8-956a-6024-80f5-349c640fa48d@gmail.com> <CADVnQyme9ydhetPZTKj-9-Cuig4CrEzuxWampv6+0tdm2Z-n9Q@mail.gmail.com>
In-Reply-To: <CADVnQyme9ydhetPZTKj-9-Cuig4CrEzuxWampv6+0tdm2Z-n9Q@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Tue, 10 Mar 2020 12:37:51 -0400
Message-ID: <CADVnQy=1z2BeO64qd-1oa5prfaoSfBwL_NwO9Qr2=T-oVVFmnA@mail.gmail.com>
Subject: Fwd: TCP receive failure
To:     Netdev <netdev@vger.kernel.org>,
        Martin Pohlack <mpohlack@amazon.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 12:19 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 3/10/20 2:40 AM, David Woodhouse wrote:
> > I'm chasing a problem which was reported to me as an OpenConnect packet
> > loss, with downloads stalling until curl times out and aborts.
> >
> > I can't see a transport problem though; I think I see TCP on the
> > receive side misbehaving. This is an Ubuntu 5.3.x client kernel
> > (5.3.0-40-generic #32~18.04.1-Ubuntu) which I think is 5.3.18?
> >
> > The test is just downloading a large file full of zeroes. The problem
> > starts with a bit of packet loss and a 40ms time warp:

David, would you be able to post a binary tcpdump pcap file (including
SYN/SYNACK, to get the wscale option) at a public HTTP/S URL
somewhere? A time/sequence plot may shed some light on this, but the
tools that generate those generally want a pcap file as input.

I also like Eric's idea to reproduce and take periodic ss/nstat dumps.
That might be extremely informative.

thanks,
neal
