Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631032EB151
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 18:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729919AbhAERYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 12:24:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:49760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726132AbhAERYm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 12:24:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0572622D3E;
        Tue,  5 Jan 2021 17:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609867441;
        bh=K5IX6ZpFt2wGZmnpKc5zDLDYcbauGoJDvRm7OkFRFDU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2UL+Fo3EwXwWF7cddCCefdvtZkFAoSzlTztUiBZiembsHEZRvFSiSeLrl9MhlUOmA
         w+VW+OwevAV6IiH5JxIHLvXbLIf/rq5jwTWOduWfkrNVYm9gYqt5g3ATn1hMcEQFuc
         9Z+Kc0QnRpKAHKJp6AliKRn3MW4w21bcvDdtUcdY=
Date:   Tue, 5 Jan 2021 18:25:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jeffrey Townsend <jeffrey.townsend@bigswitch.com>,
        "David S . Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] ethernet: igb: e1000_phy: Check for
 ops.force_speed_duplex existence
Message-ID: <X/ShBVXp32Y+Jeds@kroah.com>
References: <20201102231307.13021-1-pmenzel@molgen.mpg.de>
 <20201102231307.13021-3-pmenzel@molgen.mpg.de>
 <20201102161943.343586b1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <36ce1f2e-843c-4995-8bb2-2c2676f01b9d@molgen.mpg.de>
 <20201103103940.2ed27fa2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <c1ad26c6-a4a6-d161-1b18-476b380f4e58@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c1ad26c6-a4a6-d161-1b18-476b380f4e58@molgen.mpg.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 06:16:59PM +0100, Paul Menzel wrote:
> Dear Jakub, dear Greg,
> 
> 
> Am 03.11.20 um 19:39 schrieb Jakub Kicinski:
> > On Tue, 3 Nov 2020 08:35:09 +0100 Paul Menzel wrote:
> > > According to *Developer's Certificate of Origin 1.1* [3], it’s my
> > > understanding, that it is *not* required. The items (a), (b), and (c)
> > > are connected by an *or*.
> > > 
> > > >          (b) The contribution is based upon previous work that, to the best
> > > >              of my knowledge, is covered under an appropriate open source
> > > >              license and I have the right under that license to submit that
> > > >              work with modifications, whether created in whole or in part
> > > >              by me, under the same open source license (unless I am
> > > >              permitted to submit under a different license), as indicated
> > > >              in the file; or
> > 
> > Ack, but then you need to put yourself as the author, because it's
> > you certifying that the code falls under (b).
> > 
> > At least that's my understanding.
> 
> Greg, can you please clarify, if it’s fine, if I upstream a patch authored
> by somebody else and distributed under the GPLv2? I put them as the author
> and signed it off.

You can't add someone else's signed-off-by, but you can add your own and
keep them as the author, has happened lots of time in the past.

Or, you can make the From: line be from you if the original author
doesn't want their name/email in the changelog, we've done that as well,
both are fine.

thanks,

greg k-h
