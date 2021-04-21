Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E0E3664F5
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 07:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235265AbhDUFno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 01:43:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230343AbhDUFnm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 01:43:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D749C613D5;
        Wed, 21 Apr 2021 05:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618983790;
        bh=46DEw1GkA/TFpTbQoIDwrXdc0q4tL1Go9e21SMUFhiU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XtclWBtAW1D8f3YXTpHWvChErFPCOD0RMLHu+Nb/wyayOuAGQgkG/mn8t+5lKHgPj
         OOG56/vsTA0sBAXi0+gx+gtZjtBYcB41VJDRTRF+WMss/cCaeWfLQFTDDllic+3Uo4
         tAmWX1dt5Rcd3HrYij1H7A25oqpYCGLM1+HsE7Ms=
Date:   Wed, 21 Apr 2021 07:43:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "J. Bruce Fields" <bfields@fieldses.org>,
        Aditya Pakki <pakki001@umn.edu>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dave Wysochanski <dwysocha@redhat.com>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Message-ID: <YH+7ZydHv4+Y1hlx@kroah.com>
References: <20210407001658.2208535-1-pakki001@umn.edu>
 <YH5/i7OvsjSmqADv@kroah.com>
 <20210420171008.GB4017@fieldses.org>
 <YH+zwQgBBGUJdiVK@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YH+zwQgBBGUJdiVK@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 08:10:25AM +0300, Leon Romanovsky wrote:
> On Tue, Apr 20, 2021 at 01:10:08PM -0400, J. Bruce Fields wrote:
> > On Tue, Apr 20, 2021 at 09:15:23AM +0200, Greg KH wrote:
> > > If you look at the code, this is impossible to have happen.
> > > 
> > > Please stop submitting known-invalid patches.  Your professor is playing
> > > around with the review process in order to achieve a paper in some
> > > strange and bizarre way.
> > > 
> > > This is not ok, it is wasting our time, and we will have to report this,
> > > AGAIN, to your university...
> > 
> > What's the story here?
> 
> Those commits are part of the following research:
> https://github.com/QiushiWu/QiushiWu.github.io/blob/main/papers/OpenSourceInsecurity.pdf
> 
> They introduce kernel bugs on purpose. Yesterday, I took a look on 4
> accepted patches from Aditya and 3 of them added various severity security
> "holes".

All contributions by this group of people need to be reverted, if they
have not been done so already, as what they are doing is intentional
malicious behavior and is not acceptable and totally unethical.  I'll
look at it after lunch unless someone else wants to do it...

greg k-h
