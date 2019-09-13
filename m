Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F327B1DBD
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 14:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729830AbfIMMcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 08:32:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54480 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726771AbfIMMcR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 08:32:17 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 641D81DA4;
        Fri, 13 Sep 2019 12:32:17 +0000 (UTC)
Received: from carbon (ovpn-200-36.brq.redhat.com [10.40.200.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 803DB19C78;
        Fri, 13 Sep 2019 12:32:13 +0000 (UTC)
Date:   Fri, 13 Sep 2019 14:32:12 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, brouer@redhat.com
Subject: Re: [v2 2/3] samples: pktgen: add helper functions for IP(v4/v6)
 CIDR parsing
Message-ID: <20190913143212.0ae78582@carbon>
In-Reply-To: <CAEKGpzhz2jDdO2W7kaZxKQ-3Dkpvu5=DB=JumfcfxM-Hr7Fp0w@mail.gmail.com>
References: <20190911184807.21770-1-danieltimlee@gmail.com>
        <20190911184807.21770-2-danieltimlee@gmail.com>
        <20190912175921.02bcd3b6@carbon>
        <CAEKGpzhz2jDdO2W7kaZxKQ-3Dkpvu5=DB=JumfcfxM-Hr7Fp0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Fri, 13 Sep 2019 12:32:17 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 13 Sep 2019 02:53:26 +0900
"Daniel T. Lee" <danieltimlee@gmail.com> wrote:

> On Fri, Sep 13, 2019 at 12:59 AM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
> >
> > On Thu, 12 Sep 2019 03:48:06 +0900
> > "Daniel T. Lee" <danieltimlee@gmail.com> wrote:
> >  
> > > This commit adds CIDR parsing and IP validate helper function to parse
> > > single IP or range of IP with CIDR. (e.g. 198.18.0.0/15)  
> >
> > One question: You do know that this expansion of the CIDR will also
> > include the CIDR network broadcast IP and "network-address", is that
> > intentional?
> >  
> 
> Correct.
> 
> What I was trying to do with this script is,
> I want to test RSS/RPS and it does not
> really matters whether it is broadcast or network address,
> since the n-tuple hashing doesn't matter whether which kind of it.

Okay, sounds valid to me.

Some more feedback on the shell code... in another reply.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
