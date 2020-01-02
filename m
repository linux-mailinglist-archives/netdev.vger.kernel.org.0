Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1512812E9B5
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 19:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgABSG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 13:06:57 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46546 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727952AbgABSG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 13:06:57 -0500
Received: by mail-qt1-f195.google.com with SMTP id g1so28302050qtr.13
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 10:06:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kKodLo/bwDXK8D0TLbyN4sF1my9cqh3pcja+/KKW6A8=;
        b=Jal5LxvL4znSnvCGWhZHX1UxzRTC1NMg5N3vzxMVApWblzPxKXc84C/b0BegS9MkZr
         fQTVzk0QJjEM+WtlXsH2FmriNHoOPCIlY1pQICUS9nyFpeWzHmd9TdsoDNRd0httOUbg
         AcyC2is5KwCtI+7WQek6hoo2E40I5goBb81hp6/wlvkz/gIT5GXNFLtVuDf07uKUBlCJ
         kzP+7Kgn6K1iENfcHPoNPRke8JvZJtMdWFLif20U6ZpgKrvH4jNkwrDjT5bvw32Ncvmi
         5BD9Z5yY2kyNkLPQOBG7fDmYuhskV61HDaNWodCoBETKeIi//8ShhGwpqy+R38/U5iIw
         eMWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kKodLo/bwDXK8D0TLbyN4sF1my9cqh3pcja+/KKW6A8=;
        b=nvoqmLw+ATFSFJNnIN67IGaY9mDKa+dcXa/qQJ4ZpWNL3GZ4LoR+xjHE5OVFF7bqnt
         rkFIbZbW8LrXcTfbnnPVViGIgM4gLRkayOqNykaNLqLJVjuIve7iTnmVTOxD3UclixsT
         313NdJtQvwiJgcKXZ/fQiMTKDWGFwgaY8eZCTwRjVmuQnz5E4OnSea4dRNyN6V1u9BY4
         LisIUjlkQDJ7qbNvNR5oOYjGnymf6uTwvdUZS9t9ef/ETXGEFaE0Q9ldRClY1uQh86Qb
         g9rin6Kvj23MEzf/pGWo1VFERX6mxrpizAWOfOhAtYO3wTzdowR/KBq95YmdevO3yGuF
         I8Fw==
X-Gm-Message-State: APjAAAWqyiF36dQOfBIzt72XMZl2EZFvBWW+wjSnz7dVuRH5oF7VokfH
        ZztouVaRKhmpxUBIfhzHgkMiHQ==
X-Google-Smtp-Source: APXvYqxglEhq9d4CAJnBtJBjaPLfDCM65z+Q3Qr+0mNjpmBu3AjCflRpQWW8Zznps5r6KVFhxWfaug==
X-Received: by 2002:ac8:5257:: with SMTP id y23mr60734501qtn.88.1577988416092;
        Thu, 02 Jan 2020 10:06:56 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id u15sm15303346qku.67.2020.01.02.10.06.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 02 Jan 2020 10:06:55 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1in4s2-0002mo-Os; Thu, 02 Jan 2020 14:06:54 -0400
Date:   Thu, 2 Jan 2020 14:06:54 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>
Subject: Re: [PATCH v3 19/20] RDMA: Add irdma Kconfig/Makefile and remove
 i40iw
Message-ID: <20200102180654.GB9282@ziepe.ca>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-20-jeffrey.t.kirsher@intel.com>
 <20191211200200.GA13279@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7B6B9343F@fmsmsx124.amr.corp.intel.com>
 <20191217210406.GC17227@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7C1DEF259@fmsmsx123.amr.corp.intel.com>
 <20200102170426.GA9282@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7C1DEF79B@fmsmsx123.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7C1DEF79B@fmsmsx123.amr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 02, 2020 at 05:50:45PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [PATCH v3 19/20] RDMA: Add irdma Kconfig/Makefile and remove
> > i40iw
> > 
> > On Thu, Jan 02, 2020 at 04:00:37PM +0000, Saleem, Shiraz wrote:
> > > > Subject: Re: [PATCH v3 19/20] RDMA: Add irdma Kconfig/Makefile and
> > > > remove i40iw
> > > >
> > > >
> > > > > >  - The whole cqp_compl_thread thing looks really weird
> > > > > What is the concern?
> > > >
> > > > It looks like an open coded work queue
> > > >
> > >
> > > The cqp_compl_thread is not a work queue in the sense that no work is
> > > queued to it. It is a thread that is signaled to check for and handle
> > > CQP completion events if present.
> > 
> > How is that not a work queue? The work is the signal to handle CQP completion
> > events.
> > 
> 
> Yes we could use the work as a signal. But this would mean,
> we allocate a work item, initialize it to an 'identical' value,
> queue it up and then free it.

You don't have to allocate a work item every time.

> Why is this better than using a single kthread that just
> wake ups to handle the CQP completion?

We'd have endless kthreads if people did this everytime they needed a
bit of async work.

Jason
