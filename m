Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F061D0F65
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 12:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732830AbgEMKKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 06:10:41 -0400
Received: from verein.lst.de ([213.95.11.211]:45527 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbgEMKKk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 06:10:40 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id EA85568C65; Wed, 13 May 2020 12:10:37 +0200 (CEST)
Date:   Wed, 13 May 2020 12:10:37 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net/scm: cleanup scm_detach_fds
Message-ID: <20200513101037.GA1143@lst.de>
References: <20200511115913.1420836-1-hch@lst.de> <20200511115913.1420836-3-hch@lst.de> <20200513092918.GA596863@splinter> <20200513094908.GA31756@lst.de> <20200513095811.GA598161@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513095811.GA598161@splinter>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 12:58:11PM +0300, Ido Schimmel wrote:
> On Wed, May 13, 2020 at 11:49:08AM +0200, Christoph Hellwig wrote:
> > On Wed, May 13, 2020 at 12:29:18PM +0300, Ido Schimmel wrote:
> > > On Mon, May 11, 2020 at 01:59:12PM +0200, Christoph Hellwig wrote:
> > > > Factor out two helpes to keep the code tidy.
> > > > 
> > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > 
> > > Christoph,
> > > 
> > > After installing net-next (fb9f2e92864f) on a Fedora 32 machine I cannot
> > > ssh to it. Bisected it to this commit [1].
> > > 
> > > When trying to connect I see these error messages in journal:
> > > 
> > > sshd[1029]: error: mm_receive_fd: no message header
> > > sshd[1029]: fatal: mm_pty_allocate: receive fds failed
> > > sshd[1029]: fatal: mm_request_receive_expect: buffer error: incomplete message
> > > sshd[1018]: fatal: mm_request_receive: read: Connection reset by peer
> > > 
> > > Please let me know if more info is required. I can easily test a patch
> > > if you need me to try something.
> > 
> > To start we can try reverting just this commit, which requires a
> > little manual work.  Patch below:
> 
> Thanks for the quick reply. With the below patch ssh is working again.

Ok.  I'll see what went wrong for real and will hopefully have a
different patch for you in a bit.
