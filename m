Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D523336CB3
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 08:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhCKHEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 02:04:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231614AbhCKHEe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 02:04:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DF1764E46;
        Thu, 11 Mar 2021 07:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615446274;
        bh=lxADtNQEL1VKWUmvIf6Pn2Yb/41WFzvwWA4D8XBJmfQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I1+3PCHTt2iB2QF2K0MC4jGmpmvvi9vlSOLxMLNQWA2WNBQf3cvvUqEZn+zPAX8TS
         G1WjT7LRZsDdJLVBZTjpf0D7L9L031r3zTkl1g/32VUHThOAdLN1k5TZ7QcrjzyBoo
         NYgqloSpAWdDwlLjwK0k50Eamne1ogWMh3DPEmPQ=
Date:   Thu, 11 Mar 2021 08:04:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        jiri@resnulli.us, ruxandra.radulescu@nxp.com,
        netdev@vger.kernel.org, ioana.ciornei@nxp.com
Subject: Re: [PATCH net-next 00/15] dpaa2-switch: CPU terminated traffic and
 move out of staging
Message-ID: <YEnA/fSHjDS2p19U@kroah.com>
References: <YEi/PlZLus2Ul63I@kroah.com>
 <20210310134744.cjong4pnrfxld4hf@skbuf>
 <YEjT6WL9jp3HCf+w@kroah.com>
 <20210310.151310.2000090857363909897.davem@davemloft.net>
 <20210311065437.wke2a7vhebdxx2bi@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311065437.wke2a7vhebdxx2bi@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 08:54:37AM +0200, Ioana Ciornei wrote:
> On Wed, Mar 10, 2021 at 03:13:10PM -0800, David Miller wrote:
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Date: Wed, 10 Mar 2021 15:12:57 +0100
> > 
> > > Yes, either I can provide a stable tag to pull from for the netdev
> > > maintainers, or they can just add the whole driver to the "proper" place
> > > in the network tree and I can drop the one in staging entirely.  Or
> > > people can wait until 5.13-rc1 when this all shows up in Linus's tree,
> > > whatever works best for the networking maintainers, after reviewing it.
> > 
> > I've added this whole series to my tree as I think that makes things easiest
> > for everyone.
> > 
> > Thanks!
> 
> Sorry for bothering you again.. but it seems that Greg has also added
> the first 14 patches to staging-next. I just want to make sure that the
> linux-next will be happy with these patches being in 2 trees.

It should, git is nice :)

I can also just drop them from my staging tree as well, that's trivial.

thanks,

greg k-h
