Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756232FD9C5
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 20:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392617AbhATTfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 14:35:42 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50784 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392596AbhATTff (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 14:35:35 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l2JFj-001hDA-As; Wed, 20 Jan 2021 20:34:51 +0100
Date:   Wed, 20 Jan 2021 20:34:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     M Chetan Kumar <m.chetan.kumar@intel.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
        krishna.c.sudi@intel.com
Subject: Re: [PATCH 17/18] net: iosm: readme file
Message-ID: <YAiF2/lMGZ0mPUSK@lunn.ch>
References: <20210107170523.26531-1-m.chetan.kumar@intel.com>
 <20210107170523.26531-18-m.chetan.kumar@intel.com>
 <X/eJ/rl4U6edWr3i@lunn.ch>
 <87turftqxt.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87turftqxt.fsf@miraculix.mork.no>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 17, 2021 at 06:26:54PM +0100, Bjørn Mork wrote:
> I was young and stupid. Now I'm not that young anymore ;-)

We all make mistakes, when we don't have the knowledge there are other
ways. That is partially what code review is about.

> Never ever imagined that this would be replicated in another driver,
> though.  That doesn't really make much sense.  We have learned by now,
> haven't we?  This subject has been discussed a few times in the past,
> and Johannes summary is my understanding as well:
> "I don't think anyone likes that"

So there seems to be agreement there. But what is not clear, is
anybody willing to do the work to fix this, and is there enough ROI.

Do we expect more devices like this? Will 6G, 7G modems look very
different? Be real network devices and not need any of this odd stuff?
Or will they be just be incrementally better but mostly the same?

I went into the review thinking it was an Ethernet driver, and kept
having WTF moments. Now i know it is not an Ethernet driver, i can say
it is not my domain, i don't know the field well enough to say if all
these hacks are acceptable or not.

It probably needs David and Jakub to set the direction to be followed.

   Andrew
