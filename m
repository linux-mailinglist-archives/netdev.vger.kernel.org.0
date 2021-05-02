Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83988370B3D
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 13:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhEBLKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 07:10:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229676AbhEBLKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 May 2021 07:10:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60D5A613AD;
        Sun,  2 May 2021 11:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619953751;
        bh=9b+Zymr+Mz1pLOb4u87Mw5cXg2R71td3YNJJky3rs/8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XJcA7qFWI2RH44jI9Pl5HkBc+pepLyvm/NpsvBTSSXq7mlqnyhgsMXNG6YyVD8EHw
         BcJiJY+S9Amzd4S83PZ+XBtJH66H1Fj+fBQqwUCL9iqJI5byRS7ghoPLj3Nc+ndkWE
         7mCjxV+iwUKTfxLm/nJA/TWHRXWUnvZ2Blh4IMv0=
Date:   Sun, 2 May 2021 13:09:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jonathon Reinhart <jonathon.reinhart@gmail.com>
Cc:     stable@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Backport: "net: Make tcp_allowed_congestion_control readonly in
 non-init netns"
Message-ID: <YI6IVcl7I091C/jB@kroah.com>
References: <1618749928154136@kroah.com>
 <CAPFHKzdKcVDDERr8pmd=65Tf=tWNh_bKar9OLQd0oS2YBVu80Q@mail.gmail.com>
 <YH1xw5s0Uu5i/cRT@kroah.com>
 <CAPFHKzdnmb=rXcAfKZYgAOz1M_5r=Cu6p1g+o0fi8VmncL1dbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPFHKzdnmb=rXcAfKZYgAOz1M_5r=Cu6p1g+o0fi8VmncL1dbg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 30, 2021 at 11:45:51PM -0400, Jonathon Reinhart wrote:
> Hello,
> 
> Please apply upstream git commit 2671fa4dc010 ("netfilter: conntrack:
> Make global sysctls readonly in non-init netns") to the stable trees.
> 
> BTW netdev-FAQ.txt said not to send networking patches to stable, but
> Greg suggested I do it this way :-)
> 
> On Mon, Apr 19, 2021 at 8:04 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > For something like this, how about just waiting until it hits Linus's
> > tree and then email stable@vger.kernel.org saying, "please apply git
> > commit <SHA1> to the stable trees." and we can do so then.
> 
> If there's a better way I should go about this, please let me know!

That's all that's needed, now queued up, thanks!

greg k-h
