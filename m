Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D858D34C3F4
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 08:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhC2Gl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 02:41:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229706AbhC2Glj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 02:41:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D28D61968;
        Mon, 29 Mar 2021 06:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617000099;
        bh=KxNcYSl0nrCa2SH/GVXM8tEadgh7cMT6fd+SoIzsIC0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v2MDT53Dp/isiKR41HWoKzD+0lO44jjFh5Dcf8jL/c897WSmq5RclJLFyOvRdaCKn
         KfsvlYEndo+RMItumzrV2D4DjDIzqOqkFO+KRJcbxuFo3+Kmm2+jkY8M647kWXddYN
         JYw1sHE5zw0hVYsGdBPQlIiD+AlbZYdpSmPSG/pg=
Date:   Mon, 29 Mar 2021 08:41:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Du Cheng <ducheng2@gmail.com>
Subject: Re: [PATCH net-next] qrtr: move to staging
Message-ID: <YGF2mwCExlyvTn0f@kroah.com>
References: <20210328122621.2614283-1-gregkh@linuxfoundation.org>
 <YGFi0uIfavNsXhfs@unreal>
 <YGFl4IcdLfbsyO51@kroah.com>
 <YGF0AfLmdAr1q1+i@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGF0AfLmdAr1q1+i@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 09:30:25AM +0300, Leon Romanovsky wrote:
> On Mon, Mar 29, 2021 at 07:30:08AM +0200, Greg Kroah-Hartman wrote:
> > On Mon, Mar 29, 2021 at 08:17:06AM +0300, Leon Romanovsky wrote:
> > > On Sun, Mar 28, 2021 at 02:26:21PM +0200, Greg Kroah-Hartman wrote:
> > > > There does not seem to be any developers willing to maintain the
> > > > net/qrtr/ code, so move it to drivers/staging/ so that it can be removed
> > > > from the kernel tree entirely in a few kernel releases if no one steps
> > > > up to maintain it.
> > > > 
> > > > Reported-by: Matthew Wilcox <willy@infradead.org>
> > > > Cc: Du Cheng <ducheng2@gmail.com>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > ---
> > > 
> > > Greg,
> > > 
> > > Why don't you simply delete it like other code that is not maintained?
> > 
> > "normally" we have been giving code a chance by having it live in
> > drivers/staging/ for a bit before removing it to allow anyone that
> > actually cares about the codebase to notice it before removing it.
> 
> I don't know about netdev view on this, but for the RDMA code, the code
> in staging means _not_exist_. We took this decision after/during Lustre
> fiasco. 

That's fine, each subsystem can set it's own rules for staging code.
For networking stuff, the flow-out-through-staging has been happening
for some time now.

Lustre was a different beast, that was an attempt to get code into the
kernel, not out.

thanks,

greg k-h
