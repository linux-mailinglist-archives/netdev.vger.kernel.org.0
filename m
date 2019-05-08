Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B49EB17B28
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 15:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfEHN7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 09:59:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:41874 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727054AbfEHN7B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 09:59:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5669EAC0C;
        Wed,  8 May 2019 13:58:59 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 8D157E014E; Wed,  8 May 2019 15:58:58 +0200 (CEST)
Date:   Wed, 8 May 2019 15:58:58 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jiri Benc <jbenc@redhat.com>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Patrick McHardy <kaber@trash.net>,
        stefan.sorensen@spectralink.com
Subject: Re: [PATCH net-next] macvlan: pass get_ts_info and SIOC[SG]HWTSTAMP
 ioctl to real device
Message-ID: <20190508135858.GA8780@unicorn.suse.cz>
References: <20190418033157.irs25halxnemh65y@localhost>
 <20190418080509.GD5984@localhost>
 <20190423041817.GE18865@dhcp-12-139.nay.redhat.com>
 <20190423083141.GA5188@localhost>
 <20190423091543.GF18865@dhcp-12-139.nay.redhat.com>
 <20190423093213.GA7246@localhost>
 <20190425134006.GG18865@dhcp-12-139.nay.redhat.com>
 <20190506140123.k2kw7apaubvljsa5@localhost>
 <20190507083559.GD13858@localhost>
 <20190508014159.GM18865@dhcp-12-139.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508014159.GM18865@dhcp-12-139.nay.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 08, 2019 at 09:41:59AM +0800, Hangbin Liu wrote:
> On Tue, May 07, 2019 at 10:35:59AM +0200, Miroslav Lichvar wrote:
> > On Mon, May 06, 2019 at 07:01:23AM -0700, Richard Cochran wrote:
> > > On Thu, Apr 25, 2019 at 09:40:06PM +0800, Hangbin Liu wrote:
> > > > Would you please help have a look at it and see which way we should use?
> > > > Drop SIOCSHWTSTAMP in container or add a filter on macvlan(maybe only in
> > > > container)?
> > > 
> > > I vote for dropping SIOCSHWTSTAMP altogether.  Why?  Because the
> > > filter idea means that the ioctl will magically succeed or fail, based
> > > on the unknowable state of the container's host.
> > 
> > That's a good point. I agree that SIOCSHWTSTAMP always failing would
> > be a less surprising behavior than failing only with some specific
> > configurations.
> 
> Thanks for the reply. As net-next is closed now. I will post the fix
> to net branch after merging finished.

net-next has been already merged into master and net so if it's a fix,
you don't have to wait (and you shouldn't).

Michal Kubecek
