Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8FC336CB5
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 08:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbhCKHFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 02:05:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:50954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231435AbhCKHFH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 02:05:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1C3264E46;
        Thu, 11 Mar 2021 07:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615446307;
        bh=ewpzD0GQIMAbpMTcb1x74h642nAL/984E8lDWQwFJ3I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OXR1jwoEtHLe7kJN4XsquRnCqiH40lalOc+R7nXD5xqUXqPEdb7nMrW9ilLYCf0n5
         8zhAdQCLZWaJoMjNsV/5etrqC77TyoZTXJxjSW+xqPkSn34dGt2qTWnUDIfuFs6RqB
         Qd/JHJ3bq7AKyRPQDtTmcNvtfrBMiw8HthHmMUFE=
Date:   Thu, 11 Mar 2021 08:05:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        jiri@resnulli.us, ruxandra.radulescu@nxp.com,
        netdev@vger.kernel.org, ioana.ciornei@nxp.com
Subject: Re: [PATCH net-next 00/15] dpaa2-switch: CPU terminated traffic and
 move out of staging
Message-ID: <YEnBINkt+CSP8BCe@kroah.com>
References: <YEi/PlZLus2Ul63I@kroah.com>
 <20210310134744.cjong4pnrfxld4hf@skbuf>
 <YEjT6WL9jp3HCf+w@kroah.com>
 <20210310.151310.2000090857363909897.davem@davemloft.net>
 <20210311065437.wke2a7vhebdxx2bi@skbuf>
 <YEnA/fSHjDS2p19U@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEnA/fSHjDS2p19U@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 08:04:29AM +0100, Greg KH wrote:
> On Thu, Mar 11, 2021 at 08:54:37AM +0200, Ioana Ciornei wrote:
> > On Wed, Mar 10, 2021 at 03:13:10PM -0800, David Miller wrote:
> > > From: Greg KH <gregkh@linuxfoundation.org>
> > > Date: Wed, 10 Mar 2021 15:12:57 +0100
> > > 
> > > > Yes, either I can provide a stable tag to pull from for the netdev
> > > > maintainers, or they can just add the whole driver to the "proper" place
> > > > in the network tree and I can drop the one in staging entirely.  Or
> > > > people can wait until 5.13-rc1 when this all shows up in Linus's tree,
> > > > whatever works best for the networking maintainers, after reviewing it.
> > > 
> > > I've added this whole series to my tree as I think that makes things easiest
> > > for everyone.
> > > 
> > > Thanks!
> > 
> > Sorry for bothering you again.. but it seems that Greg has also added
> > the first 14 patches to staging-next. I just want to make sure that the
> > linux-next will be happy with these patches being in 2 trees.
> 
> It should, git is nice :)
> 
> I can also just drop them from my staging tree as well, that's trivial.

Ah, just saw your "these are broken" email, I'll go drop these.

thanks,

greg k-h
