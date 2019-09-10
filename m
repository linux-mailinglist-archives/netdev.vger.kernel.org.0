Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF84CAE72B
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 11:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390302AbfIJJkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 05:40:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58260 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727803AbfIJJke (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 05:40:34 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B69F39B286;
        Tue, 10 Sep 2019 09:40:34 +0000 (UTC)
Received: from dhcp-12-139.nay.redhat.com (dhcp-12-139.nay.redhat.com [10.66.12.139])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 394B75D9D6;
        Tue, 10 Sep 2019 09:40:28 +0000 (UTC)
Date:   Tue, 10 Sep 2019 17:40:25 +0800
From:   Hangbin Liu <haliu@redhat.com>
To:     Greg KH <greg@kroah.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        netdev@vger.kernel.org, Jan Stancek <jstancek@redhat.com>,
        Xiumei Mu <xmu@redhat.com>,
        David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.2
Message-ID: <20190910094025.GM22496@dhcp-12-139.nay.redhat.com>
References: <cki.77A5953448.UY7ROQ6BKT@redhat.com>
 <20190910081956.GG22496@dhcp-12-139.nay.redhat.com>
 <20190910085810.GA3593@kroah.com>
 <20190910093021.GK22496@dhcp-12-139.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190910093021.GK22496@dhcp-12-139.nay.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Tue, 10 Sep 2019 09:40:34 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 05:30:21PM +0800, Hangbin Liu wrote:
> Xiumei Mu also forwarded me a mail. It looks Sasha has fixed something.
> But I don't know the details.

Oh, I checked that thread. It's the same issue. So Sasha should has fixed it. I
just wonder the commit id now.

Thanks
Hangbin
> 
> ----- Forwarded Message -----
> > From: "Sasha Levin" <sashal@kernel.org>
> > To: "Greg KH" <greg@kroah.com>
> > Cc: "Major Hayden" <major@mhtx.net>, "CKI Project" <cki-project@redhat.com>, "Linux Stable maillist"
> > <stable@vger.kernel.org>, "Yi Zhang" <yi.zhang@redhat.com>, "Xiumei Mu" <xmu@redhat.com>, "Hangbin Liu"
> > <haliu@redhat.com>, "Ying Xu" <yinxu@redhat.com>
> > Sent: Wednesday, August 28, 2019 2:25:36 AM
> > Subject: Re: ❌ FAIL: Test report for kernel 5.2.11-rc1-9f63171.cki (stable)
> >
> > On Tue, Aug 27, 2019 at 07:05:18PM +0200, Greg KH wrote:
> > >On Tue, Aug 27, 2019 at 09:35:30AM -0500, Major Hayden wrote:
> > >> On 8/27/19 7:31 AM, CKI Project wrote:
> > >> >   x86_64:
> > >> >       Host 2:
> > >> >          ❌ Networking socket: fuzz [9]
> > >> >          ❌ Networking sctp-auth: sockopts test [10]
> > >>
> > >> It looks like there was an oops when these tests ran on 5.2.11-rc1 and the
> > >> last set of patches in stable-queue:
> > >
> > >Can you bisect?
> >
> > I think I've fixed it, let's see what happens next run.
> >
> > --
> > Thanks,
> > Sasha
