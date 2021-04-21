Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB8236657A
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 08:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235823AbhDUGfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 02:35:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:55250 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229536AbhDUGfl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 02:35:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1618986907; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fDQ7emmRJXtP1ofpDwCVif6iy+cZGLJnS5pOEzgyEIE=;
        b=ZvK/RC4pu63ZvJEwKjIt9sLxwHggqQoBSXC7DNEDktW4LOr4gBruarnt62dgpxaLS3FtIr
        Ww7mm0wltC2K5nhoPQHen8N2JRXLykdPUg4zRpffZTc/o2I3z+Zh3gUP94ErcjFt1O/wQF
        R6GpcWLn/wzNomrHhpmgwvY5+i8HMAc=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 31CD2B0D7;
        Wed, 21 Apr 2021 06:35:07 +0000 (UTC)
Date:   Wed, 21 Apr 2021 08:35:06 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Mike Rapoport <rppt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Rapoport <rppt@linux.ibm.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] docs: proc.rst: meminfo: briefly describe gaps in
 memory accounting
Message-ID: <YH/HmtmZfBhtBlFK@dhcp22.suse.cz>
References: <20210420121354.1160437-1-rppt@kernel.org>
 <20210420132430.GB3596236@casper.infradead.org>
 <YH7ds1YOAOQt8Mpf@dhcp22.suse.cz>
 <YH8WYJU2Jk6S9YIJ@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YH8WYJU2Jk6S9YIJ@localhost.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 20-04-21 20:58:56, Alexey Dobriyan wrote:
> On Tue, Apr 20, 2021 at 03:57:07PM +0200, Michal Hocko wrote:
> > On Tue 20-04-21 14:24:30, Matthew Wilcox wrote:
> > > On Tue, Apr 20, 2021 at 03:13:54PM +0300, Mike Rapoport wrote:
> > > > Add a paragraph that explains that it may happen that the counters in
> > > > /proc/meminfo do not add up to the overall memory usage.
> > > 
> > > ... that is, the sum may be lower because memory is allocated for other
> > > purposes that is not reported here, right?
> > 
> > yes. Many direct page allocator users are not accounted in any of the
> > existing counters.
> 
> Does virtio_balloon dereserve special mention?

Yes

> From inside VM memory borrowing looks like one giant memory leak resulting
> in support tickets (not that people who file them read internal kernel
> documentation...)

Even if people do not read that documentation it is really good to have
a reference you can send when you are dealing with bug reports.

Thanks!

-- 
Michal Hocko
SUSE Labs
