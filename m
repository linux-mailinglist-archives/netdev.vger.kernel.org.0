Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90B739A355
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 16:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbhFCOg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 10:36:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43318 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231659AbhFCOg1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 10:36:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=YaS8z6uRPRbrqr5oaG8kgrxcuj2FKRWwtg6xBCV1NXY=; b=yU
        XgX5gSJy4VhV+JfqgwJiaC53Vpy4yXFwJpwPHNpL0PvGQ9IALyNhXVOW6NQQy9ahEx4tORxC6OKLK
        f8bPbeGj3JoVTpWJIi9VHBYVHnxKOPLFjv4IBAwuwBRLb4mPIKMSiDJ6y3s0a6vw+B/PUlu3xXRSH
        1QAQY31eXmUDTdk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1looQi-007dOk-SE; Thu, 03 Jun 2021 16:34:40 +0200
Date:   Thu, 3 Jun 2021 16:34:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: /sys/class/net/eth0/name_assign_type -> EINVAL
Message-ID: <YLjogBwSY9QBoCwX@lunn.ch>
References: <1b61b068cd72677cf5f0c80b82092dcb1684fa9d.camel@infinera.com>
 <5922a590219f3940a7ce94901b8d916daee31d3a.camel@infinera.com>
 <YLjkMw/TUYmuckzv@lunn.ch>
 <92a72e7b3f54d694a69b9286fadedf1e375640df.camel@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <92a72e7b3f54d694a69b9286fadedf1e375640df.camel@infinera.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 02:29:38PM +0000, Joakim Tjernlund wrote:
> On Thu, 2021-06-03 at 16:16 +0200, Andrew Lunn wrote:
> > On Thu, Jun 03, 2021 at 01:12:16PM +0000, Joakim Tjernlund wrote:
> > > Seems like old eth interface names cannot read name_assign_type:
> > > cat /sys/class/net/eth0/name_assign_type
> > > cat: /sys/class/net/eth0/name_assign_type: Invalid argument
> > 
> > Have you done a git bisect to figure out which change broke it?
> > 
> > The 5.10 kernel on my Debian desktop has this issue. So it is older
> > than that.
> > 
> >      Andrew
> 
> No, I have not used systemd before, also on 5.10.latest, I am setting up a new FW @home and decided to try out systemd.

Debian systemd does not seem to mind not being able to read
/sys/class/net/eth0/name_assign_type. At least my Ethernet interface
is working O.K.

   Andrew
