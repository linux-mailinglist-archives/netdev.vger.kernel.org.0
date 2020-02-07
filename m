Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99ADF1560F6
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 23:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgBGWAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 17:00:32 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:43757 "EHLO
        caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727031AbgBGWAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 17:00:32 -0500
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Feb 2020 17:00:31 EST
Received: by caffeine.csclub.uwaterloo.ca (Postfix, from userid 20367)
        id 5838C4613B2; Fri,  7 Feb 2020 16:51:09 -0500 (EST)
Date:   Fri, 7 Feb 2020 16:51:09 -0500
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        e1000-devel@lists.sourceforge.net
Subject: Re: [Intel-wired-lan] i40e X722 RSS problem with NAT-Traversal IPsec
 packets
Message-ID: <20200207215109.ym6evogglt5atbnk@csclub.uwaterloo.ca>
References: <CAKgT0Ucd0s_0F5_nwqXknRngwROyuecUt+4bYzWvp1-2cNSg7g@mail.gmail.com>
 <20190517172317.amopafirjfizlgej@csclub.uwaterloo.ca>
 <CAKgT0UdM28pSTCsaT=TWqmQwCO44NswS0PqFLAzgs9pmn41VeQ@mail.gmail.com>
 <20190521151537.xga4aiq3gjtiif4j@csclub.uwaterloo.ca>
 <CAKgT0UfpZ-ve3Hx26gDkb+YTDHvN3=MJ7NZd2NE7ewF5g=kHHw@mail.gmail.com>
 <20190521175456.zlkiiov5hry2l4q2@csclub.uwaterloo.ca>
 <CAKgT0UcR3q1maBmJz7xj_i+_oux_6FQxua9DOjXQSZzyq6FhkQ@mail.gmail.com>
 <20190522143956.quskqh33ko2wuf47@csclub.uwaterloo.ca>
 <20190607143906.wgi344jcc77qvh24@csclub.uwaterloo.ca>
 <CAKgT0Ue1M8_30PVPmoJy_EGo2mjM26ecz32Myx-hpnuq_6wdjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Ue1M8_30PVPmoJy_EGo2mjM26ecz32Myx-hpnuq_6wdjw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
From:   lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 07, 2019 at 12:32:51PM -0700, Alexander Duyck wrote:
> I had reached out to some folks over in the networking division hoping
> that they can get a reproduction as I don't have the hardware that you
> are seeing the issue on so I have no way to reproduce it.
> 
> Maybe someone from that group can reply and tell us where they are on that?

Well I still never heard anything from anyone.  Just installed 4.10
firmware in case that security fix (the only change to happen in over
12 months) did something, but no.

So all UDP encapsulated IPsec packets still always have RSS value of 0.

I am tempted to write a test to see if all UDP encapsulated IP packets
that are not of one of the explicitly handled types have this problem
since I have a suspicion they do.

-- 
Len Sorensen
