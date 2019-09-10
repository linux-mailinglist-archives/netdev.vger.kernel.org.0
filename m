Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4E22AE94E
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 13:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731145AbfIJLjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 07:39:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34512 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730304AbfIJLjr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 07:39:47 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E6AB330BA092;
        Tue, 10 Sep 2019 11:39:46 +0000 (UTC)
Received: from dhcp-12-139.nay.redhat.com (dhcp-12-139.nay.redhat.com [10.66.12.139])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D3C8219C78;
        Tue, 10 Sep 2019 11:39:44 +0000 (UTC)
Date:   Tue, 10 Sep 2019 19:39:41 +0800
From:   Hangbin Liu <haliu@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg KH <greg@kroah.com>, netdev@vger.kernel.org,
        Jan Stancek <jstancek@redhat.com>, Xiumei Mu <xmu@redhat.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.2
Message-ID: <20190910113941.GO22496@dhcp-12-139.nay.redhat.com>
References: <cki.77A5953448.UY7ROQ6BKT@redhat.com>
 <20190910081956.GG22496@dhcp-12-139.nay.redhat.com>
 <20190910085810.GA3593@kroah.com>
 <20190910093021.GK22496@dhcp-12-139.nay.redhat.com>
 <20190910094025.GM22496@dhcp-12-139.nay.redhat.com>
 <20190910105223.GG2012@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190910105223.GG2012@sasha-vm>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 10 Sep 2019 11:39:47 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 06:52:23AM -0400, Sasha Levin wrote:
> On Tue, Sep 10, 2019 at 05:40:25PM +0800, Hangbin Liu wrote:
> > On Tue, Sep 10, 2019 at 05:30:21PM +0800, Hangbin Liu wrote:
> > > Xiumei Mu also forwarded me a mail. It looks Sasha has fixed something.
> > > But I don't know the details.
> > 
> > Oh, I checked that thread. It's the same issue. So Sasha should has fixed it. I
> > just wonder the commit id now.
> 
> That was fixed by upstream commit
> b00df840fb4004b7087940ac5f68801562d0d2de.

Got it, thanks for this info.
