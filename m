Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3712D6B00
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393983AbgLJWbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 17:31:17 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59536 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405106AbgLJWWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 17:22:55 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id BD0564D259C39;
        Thu, 10 Dec 2020 14:21:39 -0800 (PST)
Date:   Thu, 10 Dec 2020 14:21:34 -0800 (PST)
Message-Id: <20201210.142134.777780809639324675.davem@davemloft.net>
To:     tparkin@katalix.com
Cc:     gnault@redhat.com, netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH v4 net-next 0/2] add ppp_generic ioctl(s) to bridge
 channels
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201210171645.GB4413@katalix.com>
References: <20201210155058.14518-1-tparkin@katalix.com>
        <20201210171309.GC15778@linux.home>
        <20201210171645.GB4413@katalix.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 10 Dec 2020 14:21:39 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Parkin <tparkin@katalix.com>
Date: Thu, 10 Dec 2020 17:16:45 +0000

> On  Thu, Dec 10, 2020 at 18:13:09 +0100, Guillaume Nault wrote:
>> On Thu, Dec 10, 2020 at 03:50:56PM +0000, Tom Parkin wrote:
>> > Following on from my previous RFC[1], this series adds two ioctl calls
>> > to the ppp code to implement "channel bridging".
>> > 
>> > When two ppp channels are bridged, frames presented to ppp_input() on
>> > one channel are passed to the other channel's ->start_xmit function for
>> > transmission.
>> > 
>> > The primary use-case for this functionality is in an L2TP Access
>> > Concentrator where PPP frames are typically presented in a PPPoE session
>> > (e.g. from a home broadband user) and are forwarded to the ISP network in
>> > a PPPoL2TP session.
>> 
>> Looks good to me now. Thanks Tom!
>> 
>> Reviewed-by: Guillaume Nault <gnault@redhat.com>
>> 
> 
> Thanks again for your review and help with the series :-)

Series applied.
