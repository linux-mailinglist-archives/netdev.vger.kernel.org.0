Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66BE3DB610
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390539AbfJQSZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:25:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51164 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728492AbfJQSZZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 14:25:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NzDPVs1BOLZ/9v1I/jx6wbo7cilX1Fk11KMmOCph3h8=; b=jXr3BphEGakjeTyjFBpCWWwPC4
        WIq5J7LW+vcv1COSR7pPUOKnTQ7O5v60mNt1v51TBSvUenxJ3b4EnuQgJbMeFoVu1/ZTcElwV/+jw
        lIPd4gAf89BfpZDaNKCKIcXtr/kh1gyq7a5WCoHlqdYPHfFoaczrFqRCvuGtDTXcA0zU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iLASf-0005v4-8D; Thu, 17 Oct 2019 20:25:21 +0200
Date:   Thu, 17 Oct 2019 20:25:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stefan Wahren <wahrenst@gmx.net>
Cc:     Daniel Wagner <dwagner@suse.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: lan78xx and phy_state_machine
Message-ID: <20191017182521.GU17013@lunn.ch>
References: <20191014140604.iddhmg5ckqhzlbkw@beryllium.lan>
 <20191015005327.GJ19861@lunn.ch>
 <20191015171653.ejgfegw3hkef3mbo@beryllium.lan>
 <20191016142501.2c76q7kkfmfcnqns@beryllium.lan>
 <20191016155107.GH17013@lunn.ch>
 <20191017065230.krcrrlmedzi6tj3r@beryllium.lan>
 <6f445327-a2bc-fa75-a70a-c117f2205ecd@gmx.net>
 <20191017174133.e4uhsp77zod5vbef@beryllium.lan>
 <388beb72-c7e6-745a-ad39-cfbde201f373@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <388beb72-c7e6-745a-ad39-cfbde201f373@gmx.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 07:52:32PM +0200, Stefan Wahren wrote:
> Hi Daniel,
> 
> Am 17.10.19 um 19:41 schrieb Daniel Wagner:
> > Hi Stefan,
> >
> > On Thu, Oct 17, 2019 at 07:05:32PM +0200, Stefan Wahren wrote:
> >> Am 17.10.19 um 08:52 schrieb Daniel Wagner:
> >>> On Wed, Oct 16, 2019 at 05:51:07PM +0200, Andrew Lunn wrote:
> >>>> Please could you give this a go. It is totally untested, not even
> >>>> compile tested...
> >>> Sure. The system boots but ther is one splat:
> >>>
> >> this is a known issues since 4.20 [1], [2]. So not related to the crash.
> > Oh, I see.
> >
> >> Unfortunately, you didn't wrote which kernel version works for you
> >> (except of this splat). Only 5.3 or 5.4-rc3 too?
> > With v5.2.20 I was able to boot the system. But after this discussion
> > I would say that was just luck. The race seems to exist for longer and
> > only with my 'special' config I am able to reproduce it.
> okay, let me rephrase my question. You said that 5.4-rc3 didn't even
> boot in your setup. After applying Andrew's patch, does it boot or is it
> a different issue?

Hi Stefan

I would say i fixed a real issue with my patch. I will submit it to
David for stable. The problem has come to light because Danial is
using the kernel ipconfig and NFS root. That makes the race condition
hit every time. But the issue could happen under other conditions as
well.

    Andrew
