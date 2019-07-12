Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C837F66C06
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 14:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfGLMGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 08:06:20 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36393 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbfGLMGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 08:06:20 -0400
Received: from cpe-2606-a000-111b-405a-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:405a::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hluJJ-0008WG-BO; Fri, 12 Jul 2019 08:06:01 -0400
Date:   Fri, 12 Jul 2019 08:05:29 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        jiri@mellanox.com, mlxsw@mellanox.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andy@greyhouse.net, pablo@netfilter.org,
        jakub.kicinski@netronome.com, pieter.jansenvanvuuren@netronome.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 00/11] Add drop monitor for offloaded data paths
Message-ID: <20190712120529.GA13696@hmswarspite.think-freely.org>
References: <20190707075828.3315-1-idosch@idosch.org>
 <20190707.124541.451040901050013496.davem@davemloft.net>
 <20190711123909.GA10978@splinter>
 <20190711235354.GA30396@hmswarspite.think-freely.org>
 <69d0917f-895f-6239-4044-76944432e8ca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69d0917f-895f-6239-4044-76944432e8ca@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 08:40:34PM -0700, Florian Fainelli wrote:
> 
> 
> On 7/11/2019 4:53 PM, Neil Horman wrote:
> >> I would like to emphasize that the configuration of whether these
> >> dropped packets are even sent to the CPU from the device still needs to
> >> reside in devlink given this is the go-to tool for device-specific
> >> configuration. In addition, these drop traps are a small subset of the
> >> entire packet traps devices support and all have similar needs such as
> >> HW policer configuration and statistics.
> >>
> >> In the future we might also want to report events that indicate the
> >> formation of possible problems. For example, in case packets are queued
> >> above a certain threshold or for long periods of time. I hope we could
> >> re-use drop_monitor for this as well, thereby making it the go-to
> >> channel for diagnosing current and to-be problems in the data path.
> >>
> > Thats an interesting idea, but dropwatch certainly isn't currently setup for
> > that kind of messaging.  It may be worth creating a v2 of the netlink protocol
> > and really thinking out what you want to communicate.
> 
> Is not what you describe more or less what Ido has been doing here with
> this patch series?
possibly, I was only CCed on this thread halfway throught the conversation, and
only on the cover letter, I've not had a chance to look at the entire series

Neil

> -- 
> Florian
> 
