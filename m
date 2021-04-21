Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90151366917
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 12:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239282AbhDUKVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 06:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238390AbhDUKVk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 06:21:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11DD76143B;
        Wed, 21 Apr 2021 10:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619000464;
        bh=hbFr6G44bKelkLXCtpk/IXprzfwUZE84xJEsflGAtYY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nvAOjbszJ3K45fjsOOfopGIN1qHSC4Nadp7pai56Priet0waSyonqaBB2LuBSIZEs
         hfzdDdOw1HTzwovrQ6KTnKxzu5x2VPtpzWLz547zt0bDsAs6/S4FZ8FOQRHgMDSFrB
         PoExlTS25uQUa/gztV0sGFTjX10xJAvifWa4/d0c=
Date:   Wed, 21 Apr 2021 12:21:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Aditya Pakki <pakki001@umn.edu>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dave Wysochanski <dwysocha@redhat.com>,
        linux-nfs@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Message-ID: <YH/8jcoC1ffuksrf@kroah.com>
References: <20210407001658.2208535-1-pakki001@umn.edu>
 <YH5/i7OvsjSmqADv@kroah.com>
 <20210420171008.GB4017@fieldses.org>
 <YH+zwQgBBGUJdiVK@unreal>
 <YH+7ZydHv4+Y1hlx@kroah.com>
 <CADVatmNgU7t-Co84tSS6VW=3NcPu=17qyVyEEtVMVR_g51Ma6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmNgU7t-Co84tSS6VW=3NcPu=17qyVyEEtVMVR_g51Ma6Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 11:07:11AM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Wed, Apr 21, 2021 at 6:44 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Apr 21, 2021 at 08:10:25AM +0300, Leon Romanovsky wrote:
> > > On Tue, Apr 20, 2021 at 01:10:08PM -0400, J. Bruce Fields wrote:
> > > > On Tue, Apr 20, 2021 at 09:15:23AM +0200, Greg KH wrote:
> > > > > If you look at the code, this is impossible to have happen.
> > > > >
> 
> <snip>
> 
> > > They introduce kernel bugs on purpose. Yesterday, I took a look on 4
> > > accepted patches from Aditya and 3 of them added various severity security
> > > "holes".
> >
> > All contributions by this group of people need to be reverted, if they
> > have not been done so already, as what they are doing is intentional
> > malicious behavior and is not acceptable and totally unethical.  I'll
> > look at it after lunch unless someone else wants to do it...
> 
> A lot of these have already reached the stable trees. I can send you
> revert patches for stable by the end of today (if your scripts have
> not already done it).

Yes, if you have a list of these that are already in the stable trees,
that would be great to have revert patches, it would save me the extra
effort these mess is causing us to have to do...

thanks,

greg k-h
