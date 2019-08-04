Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F094680C2F
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 21:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfHDT0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 15:26:45 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46507 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbfHDT0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 15:26:45 -0400
Received: from cpe-2606-a000-111b-6140-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:6140::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1huM9P-0006RD-NH; Sun, 04 Aug 2019 15:26:41 -0400
Date:   Sun, 4 Aug 2019 15:26:12 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     David Miller <davem@davemloft.net>
Cc:     joe@perches.com, vyasevich@gmail.com, marcelo.leitner@gmail.com,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sctp: Rename fallthrough label to unhandled
Message-ID: <20190804192612.GA17184@hmswarspite.think-freely.org>
References: <eac3fe457d553a2b366e1c1898d47ae8c048087c.camel@perches.com>
 <20190731121646.GD9823@hmswarspite.think-freely.org>
 <a03a23728d3b468942a20b55f70babceaec587ee.camel@perches.com>
 <20190802.161932.1776993765494484851.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802.161932.1776993765494484851.davem@davemloft.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 02, 2019 at 04:19:32PM -0700, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Fri, 02 Aug 2019 10:47:34 -0700
> 
> > On Wed, 2019-07-31 at 08:16 -0400, Neil Horman wrote:
> >> On Wed, Jul 31, 2019 at 04:32:43AM -0700, Joe Perches wrote:
> >> > On Wed, 2019-07-31 at 07:19 -0400, Neil Horman wrote:
> >> > > On Tue, Jul 30, 2019 at 10:04:37PM -0700, Joe Perches wrote:
> >> > > > fallthrough may become a pseudo reserved keyword so this only use of
> >> > > > fallthrough is better renamed to allow it.
> > 
> > Can you or any other maintainer apply this patch
> > or ack it so David Miller can apply it?
> 
> I, like others, don't like the lack of __ in the keyword.  It's kind of
> rediculous the problems it creates to pollute the global namespace like
> that and yes also inconsistent with other shorthands for builtins.
> 
FWIW, I acked the sctp patch, because the use of the word fallthrough as a
label, isn't that important to me, unhendled is just as good, so I'm ok with
that change.

But, as I stated in the other thread, I agree, making a macro out of fallthrough
without clearly naming it using a macro convention like __ is not something I'm
ok with
Neil

