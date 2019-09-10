Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0985AF002
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 18:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436864AbfIJQ4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 12:56:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60284 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436786AbfIJQ4Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 12:56:16 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 74DCC3082E03;
        Tue, 10 Sep 2019 16:56:15 +0000 (UTC)
Received: from ovpn-116-172.ams2.redhat.com (ovpn-116-172.ams2.redhat.com [10.36.116.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CC445C207;
        Tue, 10 Sep 2019 16:56:12 +0000 (UTC)
Message-ID: <e364d94b2d2a2342f192d6e80fec4798578a5d07.camel@redhat.com>
Subject: Re: Is bug 200755 in anyone's queue??
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Steve Zabele <zabele@comcast.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mark KEATON <mark.keaton@raytheon.com>,
        Network Development <netdev@vger.kernel.org>,
        "shum@canndrew.org" <shum@canndrew.org>,
        "vladimir116@gmail.com" <vladimir116@gmail.com>,
        "saifi.khan@strikr.in" <saifi.khan@strikr.in>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "on2k16nm@gmail.com" <on2k16nm@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Craig Gallek <kraig@google.com>
Date:   Tue, 10 Sep 2019 18:56:11 +0200
In-Reply-To: <CA+FuTSfRP09aJNYRt04SS6qj22ViiOEWaWmLAwX0psk8-PGNxw@mail.gmail.com>
References: <010601d53bdc$79c86dc0$6d594940$@net>
         <20190716070246.0745ee6f@hermes.lan> <01db01d559e5$64d71de0$2e8559a0$@net>
         <CA+FuTSdu5inPWp_jkUcFnb-Fs-rdk0AMiieCYtjLE7Qs5oFWZQ@mail.gmail.com>
         <8f4bda24-5bd4-3f12-4c98-5e1097dde84a@gmail.com>
         <CA+FuTSf4iLXh-+ADfBNxqcsw=u_vGm7Wsx7vchgwgwvGFYOA6w@mail.gmail.com>
         <CA+FuTSdi=tw=N4X2f+paFNM7KHqBgNkV_se-ykZ0+WoA7q0AhQ@mail.gmail.com>
         <00aa01d5630b$7e062660$7a127320$@net>
         <4242994D-E2CF-499A-848A-7B14CE536E33@raytheon.com>
         <c3b83305-82a5-f3c8-2602-1aed2e9b51ca@gmail.com>
         <F119F197-FD88-4F9B-B064-F23B2E5025A3@comcast.net>
         <CA+FuTSf24VrjOxS9Kg3+DFEYn7ihe6vMj5o7rggOz_6KH_rNpQ@mail.gmail.com>
         <CA+FuTSfRP09aJNYRt04SS6qj22ViiOEWaWmLAwX0psk8-PGNxw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 10 Sep 2019 16:56:15 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On Tue, 2019-09-10 at 11:52 -0400, Willem de Bruijn wrote:
> This clearly has some loose ends and is no shorter or simpler. So
> unless anyone has comments or a different solution, I'll finish
> up the first variant.

I'm sorry for the late feedback.

I was wondering if we could use a new UDP-specific setsockopt to remove
the connected socket from the reuseport group at connect() time?

That would not have any behavioral change for existing application
leveraging the current reuseport implementation and requires possibly a
simpler implementation, but would need application changes for UDP
servers doing reuse/connect().

WDYT?

Cheers,

Paolo

